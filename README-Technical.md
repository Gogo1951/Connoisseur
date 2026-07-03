# Connoisseur — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Connoisseur. For end-user documentation, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md).

---

## File Map

```text
Consumable-Connoisseur/
├── Consumable-Connoisseur.toc      Load order, metadata, SavedVariables (Interface 11508 / 20506)
├── README.md                       End-user documentation
├── README-Technical.md             This file
├── Data/
│   ├── Data.lua                    Brand identity, palette, class colors, URLs, OPTIONS_REGISTRY, Config, ConjureSpells, spell/item IDs
│   ├── Default-Settings.lua        ns.CHAR_DEFAULTS (per-character) + ns.GLOBAL_DEFAULTS (account)
│   ├── Bandages.lua                Bandage item table
│   ├── Food-and-Water.lua          Food / water / buff-food table
│   ├── Healthstones.lua            Healthstone table + conjure→item map
│   ├── Mana-Gems.lua               Mana gem table + conjure→item map
│   ├── Pet-Foods.lua               Pet food itemLevel/diet/quest table + diet-name map
│   ├── Potions.lua                 Health / mana potion table
│   ├── Scrolls.lua                 Scroll item / buff / conflict-spell data + scan priority
│   └── Soulstones.lua              Soulstone table
├── Features/
│   ├── Core.lua                    SavedVariable lifecycle, ApplyDefaults merge, central event dispatcher, throttle, version
│   ├── Utilities.lua               Color accessor, cross-client API shims, mode/spell predicates
│   ├── Announcements.lua           PrintMessage + login welcome message (player-only prints)
│   ├── Macro-Runtime.lua           Macro-callback globals (ConnFire / ConnTip / ConnIf / ConnNoItem) + ConnoisseurState transport
│   ├── Item-Cache.lua              Derives/caches per-item consumable metadata; ignore-list pruning
│   ├── Scanner-Character.lua       Aura inspection (Well Fed, scrolls, pet buffs), profession skills, scroll/pet overrides
│   ├── Scanner-Inventory.lua       Bag scan + best-item selection (single-winner, ranked multi-use, pet food)
│   ├── Macro-Builder-General.lua   Macro composition / write-back, conjure-block assembly
│   ├── Macro-Builder-Druids.lua    DruidMacroHelper override (HP / MP / HS)
│   ├── Macro-Builder-Hunters.lua   Feed Pet macro, knowledge tiers, 255-byte trim
│   ├── Macro-Builder-Mages.lua     Mage conjure resolvers (Water, Food, Mana Gem)
│   ├── Macro-Builder-Warlocks.lua  Warlock conjure resolvers (Healthstone, Soulstone)
│   ├── Diagnostics.lua             Runtime-only Diagnostic Tools (event log, API/event probes, dumps); never localized
│   └── Minimap-Button.lua          LDB data object + minimap tooltip / click handlers
├── Options/
│   ├── Options-Utilities.lua       Shared option-widget constructors + mode labels
│   ├── Options-General.lua         The single settings panel (all feature options live here)
│   ├── Options-Diagnostics.lua     Diagnostic Tools panel
│   └── Options.lua                 AceConfig registration, panel navigation, /foodie slash command
├── Locales/
│   ├── enUS.lua                    English strings (source of truth)
│   └── …                           deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW (loaded by .toc)
└── Includes/
    ├── Images/                     Connoisseur.tga (icon / minimap texture)
    └── Libraries/                  Vendored: LibStub, CallbackHandler-1.0, AceLocale/GUI/Config-3.0, LibDataBroker-1.1, LibDBIcon-1.0
```

Load order (`.toc`): Includes → Locales → Data → Features (Core first, then Utilities, Announcements, Macro-Runtime, Item-Cache, scanners, macro builders, Diagnostics, Minimap-Button) → Options (Utilities, General, Diagnostics, then `Options.lua` last).

---

## Architecture

### Event Loop

`Features/Core.lua` owns a single hidden frame and a central dispatcher. Every event the addon uses is listed once in `ns.CORE_EVENTS` (the dispatcher registers the plain events from it, and the diagnostics Event-Registration check reads the same list, so the two can never drift). The rescan-triggering events — `BAG_UPDATE_DELAYED`, `ITEM_PUSH`, `PLAYER_LEVEL_UP`, `ZONE_CHANGED_NEW_AREA`, `PLAYER_TARGET_CHANGED`, `GROUP_ROSTER_UPDATE`, `SPELLS_CHANGED`, `SKILL_LINES_CHANGED`, `UNIT_PET`, `UNIT_AURA`, `UNIT_SPELLCAST_SUCCEEDED`, `GET_ITEM_INFO_RECEIVED`, `QUEST_LOG_UPDATE`, etc. — route through `RequestUpdate()`, which sets a dirty flag and a 0.5-second throttle (`UPDATE_THROTTLE`). The rescan and macro rewrite happen on the next `OnUpdate` tick once the throttle elapses.

This coalescing prevents macro thrashing — looting a 30-stack of bandages fires `BAG_UPDATE_DELAYED` once, but a vendor sweep can fire it dozens of times in a few frames. Routing everything through one dispatcher is also what makes the diagnostics event log complete: a feature file that registered its own frame would bypass the tap.

A few events are registered conditionally to avoid paying for them when unused: `UNIT_AURA` only while buff-food / scroll / pet-buff tracking is active (`UpdateAuraTracking`), `QUEST_LOG_UPDATE` only for Hunters (pet-food quest-objective skipping), and `GET_ITEM_INFO_RECEIVED` only while an item lookup is pending (`RegisterDataRetry`).

### Combat Lockdown

`CreateMacro` / `EditMacro` / `DeleteMacro` are blocked during combat lockdown. Any update path that runs in combat sets the dirty flag and exits early (`UpdateMacros` and `UpdateFeedPetMacro` both guard at entry); the deferred rewrite replays on `PLAYER_REGEN_ENABLED`. `PLAYER_LOGIN`, `PLAYER_LEVEL_UP`, and `UI_ERROR_MESSAGE` are handled *ahead* of the lockdown guard because they must work mid-combat and touch no protected functions (a level-up from a killing blow, a zone-restriction error on a potion pressed mid-fight, etc.); the actual macro write still defers to the post-combat tick.

### Scan → Compose → Write

`ns.UpdateMacros()` runs three phases:

1. **Scan** (`Features/Scanner-Inventory.lua`): `ScanBags()` walks every bag slot and selects the best item per category via the comparison ladder (buff-food preference → percent vs flat → score → vendor price → hybrid preference → fewest in bags). Multi-use categories (Health Potion, Healthstone, Mana Potion) collect ranked candidates instead of a single winner. Side effects populate `ns.BestFoodID`, `best[].topIDs`, `ns.ScrollOverrideIDs`, `ns.PetBuffOverrideID`; Hunter pet food is scanned by `ScanPetFood()`.

2. **Compose** (`Features/Macro-Builder-General.lua` + class resolver files): for each type in `ns.Config`, builds the body string: tooltip line → conjure block → action block → optional Shadowmeld suffix (or a dedicated scroll-only body / DMH override when those modes apply). Class files (`Macro-Builder-Mages.lua`, `-Warlocks.lua`) register into `ns.ConjureResolvers`; `Macro-Builder-Druids.lua` exposes `BuildDruidMacroOverride`; `Macro-Builder-Hunters.lua` owns `UpdateFeedPetMacro`.

3. **Write**: hashes the composition into a state key, compares against `currentMacroState[typeName]`, and only calls `EditMacro` (or `CreateMacro` for a new macro) when the body actually changed. Writing during combat is a no-op; the dirty flag re-runs on `PLAYER_REGEN_ENABLED`.

### Item Data Caching

`Features/Item-Cache.lua` derives a canonical per-item shape (itemType, heal/mana values, required level, required First Aid / Alchemy skill, vendor price, max stack, zone restrictions, buff-food/percent flags) from the static `ns.RawData.*` tables plus a one-time `GetItemInfo` read, and stores it in `ConnoisseurDB.itemCache`. Non-consumables are cached as the sentinel `"IGNORE"` so they are never re-derived. `GetItemInfo` returns `nil` on a cold client; when that happens the scan sets a retry flag, `RegisterDataRetry()` registers `GET_ITEM_INFO_RECEIVED` and a 2-second `C_Timer` fallback, and the scan re-runs once data arrives. The cache is keyed by addon version (`itemCacheVersion`): a version bump wipes it on load to pick up corrected data or new fields without stale entries.

### State Encoding

Every macro write is preceded by a state key capturing every input that affects the body. Each macro type lives in one of several **pairwise-disjoint** key namespaces, so any transition between modes always changes the key and forces a rewrite:

**Standard / food mode:**

```text
ITEMIDS(_C(_M:mid)?(_R:rid)?(_MR:key)?(_MM:key)?(_NI:key)?)?(_SM)?
```

- `ITEMIDS` — the slotted item ID, or `none`; for multi-use types (Health Potion, Healthstone, Mana Potion) it is the comma-joined ranked list so a change in any fallback rank also rewrites.
- `_C` — conjure block present. `_M:mid` / `_R:rid` — middle/right-click spell IDs. `_MR` / `_MM` / `_NI` — "spell not yet learned" miss-tip keys (right / middle / no-item).
- `_SM` — Shadowmeld suffix appended (Night Elf Water macro).

**Scroll mode** (`SCROLLS:s1,s2,…`) and **DMH mode** (`DMH:formKey:id1,id2,…`, where `formKey` is `bear`/`cat`) use distinct stems. Numeric item IDs carry no colon, so they can't collide with the `SCROLLS:` / `DMH:` prefixes. If the key matches `currentMacroState[typeName]`, the body is byte-for-byte identical to what's written and the `EditMacro` call is skipped — this is what makes `BAG_UPDATE_DELAYED` storms cheap.

---

## Macro Composition Details

### Food Macro: Two Modes

The Food macro swaps between two modes based on what the player needs and what is targeted.

**Scroll mode** — active when (a) `useScrolls` is on, (b) at least one tracked scroll buff is missing, (c) the player has those scrolls in bags, and (d) the player is not targeting another friendly player. The body is just scrolls, in `ns.SCROLL_CHECK_ORDER` priority (Agility, Strength, Protection, Intellect, Spirit, Stamina):

```text
#showtooltip
/use [@player] item:SCROLL1
/use [@player] item:SCROLL2
```

Bare `#showtooltip` resolves the action-bar icon to the first scroll. One tap fires all missing scrolls; the next bag/aura scan sees the buffs and the macro flips back to food mode.

**Food mode** — every other case. Standard layout:

```text
#showtooltip item:FOODID
/cast [btn:3] Ritual of Refreshment; [btn:2] Conjure Food(Rank N);
/stopmacro [btn:3][btn:2]
/run ConnFire(FOODID)
/use item:FOODID
```

The conjure block uses `/stopmacro` to short-circuit: a right-click conjures and stops, never reaching the food line; a left-click skips the conjure block and eats. The two modes never coexist in one body — scroll mode is purely for self-buffing, food mode purely for eating (and conjure-for-friend on right-click).

**Why a friendly-player target flips to food mode.** Mages right-click their Food macro to conjure bread for a friend. In scroll mode the right-click would hit `/use [@player] item:SCROLL1` and fire scrolls on the *Mage* instead. `HasFriendlyPlayerTarget()` suppresses scroll mode whenever another friendly player is targeted; `PLAYER_TARGET_CHANGED` re-runs the update, and because the namespaces are disjoint (`SCROLLS:…` vs the `ITEMIDS…` form) the body always rewrites on the transition. The same helper drives `GetSmartSpell()` conjure downranking — targeting a lower-level friend caps the conjured rank at their level.

### Macro-Callback Globals

Macro bodies invoke helpers through `/run`, which executes in the global environment and cannot see the addon namespace. `Macro-Runtime.lua` therefore defines a small set of **intentional globals** — `ConnFire`, `ConnTip`, `ConnIf`, `ConnNoItem`, and the `ConnoisseurState` transport table. It loads after `Announcements.lua` (the tips print through `ns.PrintMessage`) and before the macro builders that emit the `/run Conn…` lines invoking them. This is the documented exception to "the only globals are SavedVariables, slash commands, and named frames"; the distinctive `Conn…` prefix keeps collision risk negligible. `ConnFire(itemID)` stamps the firing item into `ConnoisseurState` so Core's `UI_ERROR_MESSAGE` handler can name the culprit on an `ERR_ITEM_WRONG_ZONE`. Using the short global instead of an inlined snippet saves bytes against the 255-byte limit — which matters most in long locales.

### The 255-Byte Limit

WoW silently truncates macro bodies at **255 bytes** (bytes, not characters — multibyte locales hit it sooner). Both Food modes fit comfortably: scroll mode is `#showtooltip` + at most six `/use [@player] item:N` lines (~164 bytes); food mode keeps its pre-scrolls shape. The Hunter Feed Pet macro is the one that can overflow and so carries an explicit trim (below).

### Friendly-Player Target Handling

See "Why a friendly-player target flips to food mode" above — `HasFriendlyPlayerTarget()` (`Macro-Builder-General.lua`) is the single source of truth, shared by the Food scroll-mode gate and `GetSmartSpell()` downranking.

### Pet Food Override

`ns.PetBuffOverrideID` substitutes the Food slot's *itemID* with Kibler's Bits or Sporeling Snacks when the player's pet lacks the food buff and the items are in bags. It is a substitution, not an extra line: only one `Well Fed` buff exists and one item is consumed per press. The override is part of food mode only; scroll mode fires scrolls alone, and the next press (scrolls applied) lets pet food or normal food take over.

### Mana Gem Uniqueness

Mana Gems are unique — only one rank can sit in bags at a time. `GetSmartSpell` for the Mana Gem macro passes `checkUnique = true`, consulting `ns.ConjuredItemIDsBySpell` (`Data/Mana-Gems.lua`) and `ns.GetItemCount` (the `C_Item`/global shim from `Utilities.lua`) to skip ranks already held. Clicking conjures the highest rank you don't own, so a second press gives a backup at the next rank down. Warlock Healthstones use the same mechanism (`Data/Healthstones.lua`); Soulstones deliberately do **not** (`checkUnique = false`) because their 30-minute use cooldown means only one can ever be deployed.

### Hunter Feed Pet

`ns.UpdateFeedPetMacro()` (`Features/Macro-Builder-Hunters.lua`) builds this macro separately because one button must dispatch to Feed / Mend / Call / Revive / Dismiss based on modifier, button, pet state, and combat. Three knowledge tiers drive the shape:

- **Tier A** (pre-10, any of Feed/Revive/Call/Dismiss Pet missing) — a print-only stub.
- **Tier B** (10–11, no Mend Pet) — the full cascade minus Mend, plus a click-time tip on `[btn:2][combat]`.
- **Tier C** (12+, all known) — the full cascade.

Tier C, full form:

```text
#showtooltip
/cast [mod:ctrl] Dismiss Pet; [mod:shift][@pet,dead] Revive Pet; [nopet] Call Pet; [btn:2][combat] Mend Pet; Feed Pet
/stopmacro [mod][btn:2][nopet][@pet,dead][combat]
/use item:FOODID
```

When the pet is dead and dismissed, `[nopet]` swaps to Revive Pet so one click works regardless of pet state; combat forces Mend Pet because Feed Pet can't be cast in combat.

**255-byte trim.** The cascade names up to five client-localized spells, so a body that fits in enUS (~196 bytes) overflows in multibyte locales — ruRU runs ~306 bytes. `ComposeFeedPetBody(tier, itemID, includeDismiss, includeRevive)` assembles the body from two flags, and `BuildFeedPetBody` builds the full body, then while it exceeds 255 bytes sheds the optional shortcuts in priority order — `[mod:ctrl]` Dismiss first, then `[mod:shift]`/`[@pet,dead]` Revive — rebuilding the matching `/stopmacro` token set each time. The `[nopet]` summon, the `[btn:2][combat]` Mend branch, the default Feed, and the `/use` food line are **never** dropped, so core feed/summon behavior survives in every locale; only the modifier conveniences are shed. (The consumable and DMH builders carry analogous trims that drop stacked `/use` fallback lines.)

### DruidMacroHelper Integration (Druid HP / MP / HS)

When `enableDruidMacroHelper` is on for a Druid, the Health Potion, Mana Potion, and Healthstone macros are rewritten to use the [DruidMacroHelper](https://www.curseforge.com/wow/addons/druidmacrohelper) addon's `/dmh` syntax so the druid powershifts out of form, `/use`s the consumable, and shifts back — guarded against breaking form when the item is on cooldown, the player is stunned, on GCD, or OOM. Guard prefixes (from `ns.DMHGuards`, copied from DMH's own examples):

- **Health Potion** — `/dmh start` (stun + GCD + mana) plus `/dmh cd pot`
- **Healthstone** — `/dmh start` plus `/dmh cd hs`
- **Mana Potion** — `/dmh stun gcd cd pot` — skips the mana check, since a mana pot is for when the druid is OOM

The return form comes from `settings.druidReturnForm` (`"bear"`/`"cat"`).

**Why hard-coded, not auto-tracked.** `EditMacro` is blocked in combat, so any design that listened to `UPDATE_SHAPESHIFT_FORM` and rewrote the body would leave the macro stale during the very combat where a druid powershifts — pressing it could land the druid in the wrong form. The hard-coded preference avoids that; switching forms in earnest is an out-of-combat action and the dropdown is one click.

**Bear vs Dire Bear.** At login `Core.lua` resolves the bear form name via `GetSpellInfo(9634)` (Dire Bear Form) with a fallback to `GetSpellInfo(5487)` (Bear Form). The dropdown stores the abstract `"bear"`; the builder substitutes whichever the character actually knows.

---

## Diagnostics

`Features/Diagnostics.lua` + `Options/Options-Diagnostics.lua` are the standard Diagnostic Tools panel. Everything there is **runtime-only and side-effect free** — the enable gate and event log live in the in-memory `ns.diagnostics` table (never SavedVariables), default off, and reset to off each session because nothing is persisted. The dispatcher's log tap is a single guarded call (`if ns.diagnostics.logging then ns:LogEvent(event, ...) end`), so logging-off costs one boolean check. Diagnostics strings are developer-facing and deliberately **not localized** (they live in `ns.DiagnosticsStrings`). The one write the panel ever makes is the `taintLog` CVar, via its explicit button.

---

## Saved Variables

Two scopes, two defaults tables.

- **`ConnoisseurDB`** (account-wide, `SavedVariables`):
  - `showWelcome` — boolean; the on-login welcome message (default `true`).
  - `minimap` — LibDBIcon subtable. Its `hide` flag is the single source of truth for button visibility (the "Enable Minimap Button" toggle is its inverse: `hide = false` means shown). LibDBIcon owns position and the rest of the subtable.
  - `enabledMacros` — per-macro-type on/off (`["Water"] = true`, …). **Account-wide**: the macros live in the shared General macro tab, so which ones Connoisseur maintains is an account-level choice. Class-gated macros (Feed Pet, conjures) still build only for the right class regardless of the toggle.
  - `itemCache` — derived per-item metadata keyed by item ID (see Item Data Caching).
  - `itemCacheVersion` — addon version stamp; a mismatch wipes `itemCache` on load.
- **`ConnoisseurCharDB`** (per-character, `SavedVariablesPerCharacter`):
  - `ignoreList` — set of item IDs to skip during best-item selection.
  - `settings` — per-character feature preferences: buff food (`useBuffFood`, `buffFoodMode`), scrolls (`useScrolls`, `scrollsMode`, `scrollTypes`), pet buff food (`usePetBuffFood`, `petBuffFoodMode`, `petBuffTypes`), Night Elf `enableShadowmeldDrinking`, Druid `enableDruidMacroHelper` + `druidReturnForm`. Druid/Night-Elf fields exist on every character but are only consulted when `ns.IsDruid` / `ns.IsNightElf`.

Defaults live in `Data/Default-Settings.lua`: `ns.CHAR_DEFAULTS` seeds `ConnoisseurCharDB.settings`, and `ns.GLOBAL_DEFAULTS` seeds `ConnoisseurDB` (welcome message, minimap `hide`, `enabledMacros`). `InitVars()` (`Features/Core.lua`) applies both with the recursive `ApplyDefaults` merge. "Reset All" (`ns.ResetSettings`) wipes the per-character `settings` + `ignoreList` and re-resets the account-wide `enabledMacros`, but deliberately leaves `showWelcome` and the minimap subtable (and its saved position) untouched.

When changing the schema, never silently rewrite user data. Add a one-shot migration in `InitVars()` gated on the legacy field so it runs once and then becomes a no-op, and remove it after the upgrade window. If a new table name is involved, keep both the old and new `SavedVariables` lines in the `.toc` until the migration has run.

> `ApplyDefaults` runs after any migration; it fills only nil fields and never overrides explicit user values.

---

## Adding a New Consumable Category

1. Add a data file in `Data/` (e.g. `Data/Elixirs.lua`) populating `ns.RawData.Elixirs` — a numeric item-keyed table of restore values, level/skill requirements, vendor prices, and any zone restrictions. Keep the row shape flat and lead with a column-header comment; include the originating SQL query (or a `-- TODO: Add SQL Query` marker).
2. Add the file to the `# Data` block in `Consumable-Connoisseur.toc`.
3. Add a `ns.Config` entry in `Data/Data.lua` (macro name from a `MACRO_*` locale key, a `defaultID` for the placeholder tooltip, and a `label` from a `LABEL_*` key). If it stacks ranked fallbacks, add it to `ns.MultiUseMacroTypes`.
4. In `Features/Item-Cache.lua`: add `ns.RawData.Elixirs = ns.RawData.Elixirs or {}` to the safety-init block, a membership check in `ns.IsKnownConsumable`, and an `itemType` branch in `ns.CacheItemData`.
5. In `Features/Scanner-Inventory.lua`: add a `best[]` entry (and `ResetBest` handles it generically) plus a branch in the `itemType` dispatch — single-winner via `IsBetter`, or `AddRankedCandidate` for a multi-use type.
6. Add the macro key to `enabledMacros` in `ns.GLOBAL_DEFAULTS` (`Data/Default-Settings.lua`) and a `MacroToggle` row in `Options/Options-General.lua`.
7. Add the `MACRO_*` and `LABEL_*` keys to `Locales/enUS.lua` (full words — `MACRO_HEALTH_POTION`, not `MACRO_HPOT`).
8. If the category has conjure semantics, add a resolver in the relevant `Macro-Builder-{Class}.lua`.

Walk the worst-case **255-byte** check with the longest localized spell names. ruRU is the current worst case (it overflows the Hunter Feed Pet cascade); deDE and koKR are also long. Switch locale via the client / `Config.wtf` to test.

---

## Adding a New Locale

Copy `Locales/enUS.lua` to `Locales/<locale>.lua`. Drop the `true` argument from `NewLocale("Connoisseur", "<locale>", true)` — that flag marks the default fallback; only `enUS.lua` sets it. Translate every string. Add the file to the `.toc` immediately after `Locales/enUS.lua`.

`esES.lua` and `esMX.lua` are separate files even though the Spanish strings are usually identical. Macro names cap at **16 characters**; macro action lines carrying localized spell names (Mage/Warlock conjure, Hunter pet spells, Shadowmeld) are the most likely to hit the 255-byte cap. The `DIET_*` keys must match `GetPetFoodTypes()` output exactly on that client (verify in-game), and `RANK` must match the client's `/cast Spell(Rank N)` wording.

---

## Common Pitfalls

- **Editing macros in combat**: silently fails. Always defer via the dirty flag; the rewrite replays on `PLAYER_REGEN_ENABLED`.
- **Querying `GetItemInfo` cold**: returns `nil` on first call. Use the `GET_ITEM_INFO_RECEIVED` retry path in `Item-Cache.lua`; don't busy-loop.
- **Forgetting state encoding**: if you add an input that affects the body, add it to the state key, or the macro won't rewrite when that input changes.
- **Hardcoding spell names**: always resolve via `GetSpellInfo(spellID)` — names vary by locale and patch.
- **Counting characters, not bytes**: the limit is 255 *bytes*. Multibyte locales (ruRU/koKR/zhCN) overflow sooner; the Feed Pet builder trims modifier branches to compensate (see its deep-dive), and the consumable/DMH builders drop stacked `/use` lines.
- **Putting account-wide state in the per-character table (or vice versa)**: `enabledMacros`, `showWelcome`, and the minimap live in `ConnoisseurDB`; feature toggles and the ignore list live in `ConnoisseurCharDB`. Seed new defaults into the matching table.
- **Auto-tracking druid form**: don't. `EditMacro` is gated by combat lockdown, so an `UPDATE_SHAPESHIFT_FORM` auto-tracker produces stale macros mid-combat. Use the hard-coded `druidReturnForm` setting.

---

## Contributing

Pull requests welcome at https://github.com/Gogo1951/Connoisseur. Open a GitHub issue for bugs or ideas, including:

- Game version and locale
- Class and level
- Reproduction steps
- The relevant macro body, copied from the in-game macro window, and any chat output

Discussion happens on Discord: https://discord.gg/eh8hKq992Q.

When opening a PR:

- Keep changes scoped — one concern per PR is easier to review.
- Match the existing code style (4-space indent, no trailing whitespace, block comments for anything multi-line; run StyLua).
- If you change saved-variable structure, add a one-shot migration in `InitVars()` (`Features/Core.lua`) gated on the legacy field, and plan its removal.
- If you change macro composition, walk the worst-case **255-byte** check in the longest locale (ruRU for pet/conjure names).
- Update this document if the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X." Frame it by who it helps and why:

   **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

   **Example:** *As a Mage who carries multiple gem ranks, I wanted a second Mana Gem press to conjure a backup instead of failing on the unique-item error. This change passes `checkUnique` through `GetSmartSpell` so the macro downranks to the next gem the player doesn't already hold.*

   The User Story makes review faster and gives future maintainers context the diff alone won't carry.
