# Connoisseur — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Connoisseur. For end-user documentation, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md).

## File Map

```
Consumable-Connoisseur/
├── Consumable-Connoisseur.toc          Load order; single TOC for Era + TBC Anniversary
├── Data/
│   ├── Data.lua                        Locale init, palette, ns.Config, conjure spell lists, constants
│   ├── Default-Settings.lua            ns.DATABASE_DEFAULTS (AceDB profile + global.minimap)
│   └── *.lua                           Static item data, one file per category (SQL-sourced)
├── Features/
│   ├── Core.lua                        Central event dispatcher, AceDB lifecycle, update throttle
│   ├── Utilities.lua                   ns.GetColor, API shims, ns.IsEra/IsTBC, small predicates
│   ├── Announcements.lua               ns.PrintMessage + once-per-session welcome
│   ├── Item-Cache.lua                  Derives/caches per-item data; ignore-list pruning
│   ├── Scanner-Character.lua           Skills, aura probes (Well Fed / scrolls / pet), early re-apply
│   ├── Scanner-Inventory.lua           Bag scan, RANKING_PRIORITY ladder, per-category winners
│   ├── Macros/
│   │   ├── Engine.lua                  Definition registry, body/state-key builders, 255-byte trim
│   │   ├── Runtime.lua                 ConnFire/ConnTip/ConnIf/ConnNoItem macro globals
│   │   ├── Tools-<Class>.lua           What each class KNOWS (resolvers, Feed Pet, Poisons)
│   │   ├── <Category>.lua              One RegisterMacroType definition per macro
│   │   └── Integration-Druid-Macro-Helper.lua  DMH powershift wrapping (HP/MP/HS)
│   ├── Action-Button-Text.lua          Macro-name visibility on default bars
│   ├── Restocker/                      Bag/bank/vendor restocking (/crs); vendored architecture
│   │   ├── Restocker.lua               Lifecycle, profiles, one-line saved format (v5), slash
│   │   ├── Bank.lua                    Coroutine restock loop, watchdogs, in-flight gate
│   │   ├── Bag.lua                     Container moves; split/merge; specialty-bag gating
│   │   ├── Merchant.lua                Purchase orders, reputation gate
│   │   ├── BuyIngredients.lua          Crafting reagent auto-buy (rogue poisons)
│   │   ├── MainFrame.lua / ListFrame.lua   The /crs window
│   │   ├── Specs/ · Tests/             Dev-only: headless API stubs + planner test (not in TOC)
│   │   └── ...                         Module/KvEnv/Events/Settings/Item/Cache/Inventory plumbing
│   ├── Diagnostics.lua                 Runtime-only probes/reports (never persisted)
│   └── Minimap-Button.lua              LDB object, tooltip, click handlers
├── Options/                            AceConfig panels (General, Profiles, Diagnostics)
├── Locales/                            AceLocale files; enUS.lua is source of truth
├── Includes/                           Vendored libraries — never edited by hand
└── tools/parity/                       Dev-only offline macro-parity harness (not in TOC)
```

Deprecated files that must stay gone: the pre-restructure `Features/Macro-*.lua` layout and `Features/Restocker/RestockerConf.lua` (deleted; superseded by `RestockerClass.lua` annotations).

## Architecture

### Event Loop

`Features/Core.lua` owns one frame and one dispatcher; feature files never register their own events — with one accepted exception, Restocker (below). The full event list is exported as `ns.EVENT_NAMES` so the dispatcher and Diagnostics' Event Registration check can never drift. Unit-filtered events (`UNIT_PET`, `UNIT_SPELLCAST_SUCCEEDED`) register via `RegisterUnitEvent`; `UNIT_AURA` registers only while a buff-tracking feature is active; `QUEST_LOG_UPDATE` registers for Hunters only; `GET_ITEM_INFO_RECEIVED` registers only while a scan is waiting on item data.

Rebuilds funnel through `ns.RequestUpdate()`: a two-flag throttle (`isUpdatePending` / `isTickScheduled`) arms a 0.5 s `OnUpdate` tick. The flags are separate so a pending update can never strand — any out-of-combat request re-arms a disarmed tick.

### Combat Lockdown

Macros cannot be written in combat. Every path defers: the dispatcher swallows most events under `InCombatLockdown()` (setting `isUpdatePending`), the throttle tick disarms itself, and `PLAYER_REGEN_ENABLED` replays the pending work. Three things still run mid-combat because they are read-only and matter there: init on `PLAYER_LOGIN`, `UI_ERROR_MESSAGE` (zone-restriction reporting, dead-pet detection), and `PLAYER_LEVEL_UP` cache refreshes.

### Scan → Compose → Write

1. **Scan** — `ns.ScanBags()` (`Scanner-Inventory.lua`) walks bags once, dispatches every usable item to each registered definition claiming its cached `itemType`, and ranks candidates through the single `RANKING_PRIORITY` ladder (buff food → percent → value → conjured → price → hybrid → count → itemID; the last step makes picks deterministic across reloads).
2. **Compose** — `Features/Macros/Engine.lua` builds each macro body from the definition's hooks (`conjure`, `buildUseLine`, `getStackIDs`, `buildModeOverride`, `appendBlock`, `stateExtras`); `Data/Data.lua`'s `ns.Config` supplies names and default icons.
3. **Write** — `WriteMacro` creates or edits the shared General-tab macro only when the state key changed. Creation respects `ns.MACRO_SLOT_CUSHION` and warns once per session when the book is full, then self-heals when a slot frees.

### Item Data Caching

`ns.CacheItemData` (`Features/Item-Cache.lua`) derives a canonical record per item into `ns.db.profile.itemCache`. A `GetItemInfo` cold-call nil marks the scan dirty; `ns.RegisterDataRetry` listens for `GET_ITEM_INFO_RECEIVED` plus a 2 s timer and rescans. Invalidation is two-layered: a version stamp (`itemCacheVersion ~= ns.Version`) wipes on release bumps, and a nil-test of the newest schema field catches same-version dev edits — when adding a cache field, extend that nil-test in `Scanner-Inventory.lua`.

### State Encoding

Every input that affects a macro body must appear in its state key, or the macro goes stale. Namespaces are disjoint by prefix so any mode transition forces a rewrite: standard keys are item-ID-led (`ITEMIDS(_C…)(_EX:mode)?(_SM|_SE)?`), Food's scroll mode uses `SCROLLS:`, and the Druid override uses `DMH:`. The Poisons and Feed Pet builders keep their own keys with the same lossless-key rule.

## Food Macro: Modes and Overrides

The Food definition (`Features/Macros/Food.lua`) is the busiest:

- **Plain/buff food** — buff food competes only while the scanner's live `ns.AllowBuffFood` is true (setting + party/raid mode + not Well Fed + not self-targeting + not in an arena).
- **Scroll-only mode** — with missing scroll buffs and no friendly-player target, the whole body becomes a scroll applier and flips back next update:

```
#showtooltip
/use [@player] item:4425
/use [@player] item:1180
```

- **Pet-buff override** — `modifyItem` swaps the food for Kibler's Bits / Sporeling Snacks and `buildUseLine` targets `[@pet]`.
- **Stealth Eating** — `appendBlock` adds `/cast [nostealth] Stealth` (Rogues) or Shadowmeld (other Night Elves) under the food line, flag `SE`. Water does the same for drinking (`SM`), Night Elves only, never Rogues.

## Multi-Use Macros and the 255-Byte Trim

Health Potion, Mana Potion, and Healthstone are `ranked` definitions: up to `ns.MULTI_USE_MAX_ITEMS` (3) `/use` lines, best first — safe because each category shares an item cooldown, so one press consumes one item and the extra lines are combat fallbacks. Optional Healthstone stacking appends the stone list under the potion lines. The client truncates macro bodies at 255 bytes; `BuildStandardBody` sheds stacked stone lines first, then fallback lines bottom-up — the rank-1 line never drops. Localized spell names make this real: a body that fits in enUS can overflow in ruRU or deDE.

## Era vs TBC: Warlock Rank Pinning (recurring bug)

Warlock Healthstones/Soulstones are distinctly-named spells on Era (cast bare; appending `(Rank N)` silently no-ops) but numeric ranks on TBC (must pin `(Rank N)`). The split is declared as data — `rankIsTBCOnly` on the `ns.ConjureSpells` lists — and applied only by `ns.GetSmartSpell`. Mage Conjure Food/Water are numeric-rank on both flavors. Read the RECURRING BUG note on `WarlockCreateHealthstone` in `Data/Data.lua` before touching any of it; fixtures 01/03 in the parity harness lock the behavior.

## Feed Pet (Hunter)

A custom-update definition in `Tools-Hunters.lua` with three knowledge tiers: print-only stub (any core pet spell missing), Mend-less cascade (10–11), full cascade (12+: ctrl-Dismiss, shift/dead-Revive, `[nopet]` Call-or-Revive, `[btn:2][combat]` Mend, default Feed + food line). Pet food selection prefers the lowest-level max-happiness food, skips active quest objectives, and falls back to above-level food. Dead-but-dismissed pets are detected via `UI_ERROR_MESSAGE` and flip `[nopet]` to Revive.

## Poisons (Rogue)

Also custom-update: left-click poisons the off hand (slot 17), right-click the main hand (slot 16), middle-click opens the crafting window. The body `/use`s the poison then the slot, `/click StaticPopup1Button1` to confirm replacement, and clears UI errors. Poison groups per hand come from the profile; group names resolve from the client's own item names, so they localize for free.

## Restocker

Vendored subsystem (accepted interim architecture) behind `/crs`: per-character shopping profiles stored in its own `ConnoisseurRestockerDB`, its own event frame, and `CrsModule`/`CRS_ADDON` globals. Key mechanics:

- **Bank restocking** is a coroutine stepped by a ping-paced `OnUpdate` timer. Every step re-scans reality (never optimistic bookkeeping), issues at most one move, and waits for item locks to settle. A no-progress watchdog stops with an honest report; an in-flight gate ignores scans taken while a move is mid-air; a bounced exact split escalates to a whole-stack pull whose overshoot is stashed back.
- **Hard invariant: never sell.** `C_Container.UseContainerItem` sells when a merchant window is open, so the bank loop refuses to run while `merchantIsOpen`.
- **Saved format v5** — each profile is keyed by itemID; items deflate to one comma-separated line per item at logout and inflate at login (`rsItemToString` / `rsItemFromString`).
- Chat/UI strings are localized (`RESTOCKER_*` keys); pacing lives in `Bank.lua`; the offline planner test covers the move logic.

## Diagnostics

Runtime-only (`ns.diagnostics`, never saved; everything defaults off each login). The panel builds reports on button press only: API/event probes driven by `ns.DIAGNOSTIC_API_CHECKS` and `ns.EVENT_NAMES`, an event log tapped in Core's dispatcher, saved-variable dumps of both tables, library versions, and the taintLog CVar buttons — the only thing it ever writes.

## Saved Variables

- **`ConnoisseurDB`** — the AceDB-3.0 table. `profiles.<name>` holds every user setting (toggles, modes, `enabledMacros`, `scrollTypes`, `petBuffTypes`, poison groups, `ignoreList`, plus the derived `itemCache`/`itemCacheVersion`); `global.minimap` is the LibDBIcon subtable, profile-independent so profile operations never move the button; `profileKeys` maps characters to profiles (shared "Default" out of the box via `AceDB:New(..., true)`).
- **`ConnoisseurRestockerDB`** — Restocker's account-wide table (accepted interim; an AceDB merge is planned): `profiles` (one-line item strings keyed by itemID), `profileKeys` ("Name-Realm" → active profile), `currentProfile`, `framePos`, `autoOpenAtBank`, `autoOpenAtMerchant`, `debugMessages`, `dataVersion`.

### Migration Chain

- `ConnoisseurCharDB` (legacy per-character) → AceDB profile; plus legacy root keys on `ConnoisseurDB` → profile/global — remove after 2026-10-06 (tagged in `Core.lua`, `Diagnostics.lua`, TOC).
- Standalone `RestockerDB` adoption and `RestockerSettings` per-character import → `ConnoisseurRestockerDB`; pre-v5 saved-line tolerances — remove after 2026-08-15 (tagged in `Restocker.lua`).

Defaults come from `ns.DATABASE_DEFAULTS` and are applied lazily by AceDB-3.0 via metatables — nothing is copied into the saved table, and explicit user values (including `false`) are never overridden.

There is no refill-on-empty list logic: Connoisseur ships no user-editable default item lists (the static tables in `Data/` are code, not saved data), and settings maps like `enabledMacros` deliberately survive being all-false. The derived `itemCache` is lazy-initialized outside the defaults table because Core owns its invalidation.

## Adding a New Consumable Category

1. Add the static data to a new `Data/<Category>.lua` under `ns.RawData.<Category>`, with the originating SQL query in a comment (or `-- TODO: Add SQL Query`).
2. List the file in the TOC's `# Data` block and add the defensive `ns.RawData.<Category> = ns.RawData.<Category> or {}` line in `Features/Item-Cache.lua`.
3. Extend `ns.CacheItemData` with a branch deriving the canonical record (`itemType`, values, requirements).
4. Create `Features/Macros/<Category>.lua` calling `ns.RegisterMacroType` (see the definition protocol in `Engine.lua`); add the TOC line among the definitions.
5. Add the macro to `ns.Config` in `Data/Data.lua` (macro name ≤ 16 characters), `enabledMacros` in `Data/Default-Settings.lua`, an Enable Macros toggle in `Options/Options-General.lua`, and `MACRO_*`/`LABEL_*` keys in `Locales/enUS.lua` only.
6. Mind the 255-character macro limit if the body stacks lines — German and Russian names are the canary. Add a parity fixture in `tools/parity/fixtures/` and refresh `baseline/`.

## Adding a New Registered Event

Add the name to `ns.EVENT_NAMES` in `Features/Core.lua` and a dispatcher branch — registration and the Diagnostics event/registration checks pick it up together. Use `DEFERRED_EVENTS` if it must register conditionally.

## Adding a New Scroll Type or Restocker Recipe

- Scrolls: add the type to `ns.ScrollData` in `Data/Scrolls.lua` (items best-first, `conflictSpells` with base amounts), `ns.SCROLL_CHECK_ORDER`, `scrollTypes` defaults, an options toggle, and enUS keys.
- Restocker crafted items: add the recipe in `Features/Restocker/BuyIngredients.lua` via `ClassicRecipe`/`TbcRecipe` with itemID + English reagent names.

## Localization

- **Structure** — locale files live in `Locales/<locale>.lua`, each registered through AceLocale-3.0's `NewLocale`. `enUS.lua` is the source of truth and the only file that passes the `true` default-fallback flag; every string originates there.
- **Keeping locales in sync** — every other locale carries a translation of the same key set; AceLocale falls back to English via `__index` for anything missing at runtime. Aligning the files is the Localization pass's job — don't hand-edit non-enUS locales during ordinary work; new keys go into `enUS.lua` only and fall back until that pass runs.
- **Placeholders** — `%s`/`%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime.
- **Spanish** — `esES`/`esMX` are two separate, self-contained files; identical strings in both is correct and expected.
- **Locale overflow** — German is the usual canary against the 255-character macro limit; the trims in `Engine.lua`, `Integration-Druid-Macro-Helper.lua`, and `Tools-Hunters.lua` exist because of it.
- Diagnostics strings are developer-facing plain English in `Features/Diagnostics.lua` — never localized.

## Common Pitfalls

- **Editing macros in combat**: silently blocked by the client. Always route through `ns.RequestUpdate()`; the pending flag replays on `PLAYER_REGEN_ENABLED`.
- **Appending `(Rank N)` to warlock stones on Era**: the `/cast` silently no-ops. The `rankIsTBCOnly` flag and `ns.GetSmartSpell` own this — don't "simplify" the spell families together.
- **A body input missing from the state key**: the macro silently goes stale. Lossless keys are the rule; mode overrides use disjoint prefixes so transitions always rewrite.
- **`GetItemInfo` cold nils**: a fresh login can't resolve uncached items. The scan flags `dataRetry` and re-runs on `GET_ITEM_INFO_RECEIVED` — never assume the first scan is complete.
- **255-byte macro bodies in multibyte locales**: always assemble-then-trim (see the three trim sites); `#body` measures bytes, which is what the client enforces.
- **`UseContainerItem` at a merchant sells the item**: the bank restock loop must never run with the merchant window open — guarded in `RunRestockLogic`.
- **`UIDropDownMenu_SetWidth` padding**: the dropdown's invisible frame is width + padding (620 px in the Restocker footer) — anchor neighbors to the window, not the dropdown frame.
- **`PLAYER_ENTERING_WORLD` refires on every loading screen**: init is guarded (`ns.db` nil-check, `varsInitialized`, welcome once-flag); keep new login work behind those guards.
- **Editing non-enUS locale files by hand**: they're owned by the Localization pass; hand edits get overwritten. enUS only.
- **StyLua**: run `stylua` (default config) over Connoisseur-proper Lua before committing; `Features/Restocker/` keeps its vendored style and `Includes/` is never touched. Verify macro-path changes with `tools/parity/check.sh` and Restocker moves with `lua Features/Restocker/Tests/RestockPlannerTest.lua`.

## Contributing

- **Issues**: [GitHub Issues](https://github.com/Gogo1951/Connoisseur/issues).
- **Bug reports**: include game version + locale, class + level, repro steps, and the relevant macro body or chat output. The in-game **Diagnostic Tools** panel (Options → AddOns → Connoisseur) generates pasteable reports — the Event Log and Connoisseur Context sections answer most "my macro didn't update" reports.
- **Discord**: <https://discord.gg/eh8hKq992Q>.
- **PR guidelines**: keep PRs scoped to one change; match house style (StyLua defaults; Restocker keeps its vendored style); tag any data migration with a dated `MIGRATION (remove after YYYY-MM-DD)` comment; check the 255-byte limit for any macro-body change (`./tools/parity/check.sh` must report byte-identical or intentionally-changed baselines); update this document when the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X." Frame it:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player switching between raid groups with different consumable preferences, I wanted Connoisseur to remember the last-selected food per character so I didn't reset it every login. This change adds a `lastSelected` field to the AceDB profile and restores it when the database loads.*

  The User Story makes review faster and gives future maintainers context the diff alone won't carry.
