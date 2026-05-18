# Connoisseur — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Connoisseur. For end-user documentation, see [README.md](README.md).

---

## File Map

```text
Consumable-Connoisseur/
├── Consumable-Connoisseur.toc    Load order and metadata
├── Core.lua                       Event dispatch, throttling, error handling
├── Macro-Builder-General.lua      Macro composition, write-back, conjure-block assembly
├── Macro-Builder-Druids.lua       DruidMacroHelper override for HP / MP / HS
├── Macro-Builder-Hunters.lua      Feed Pet macro and pet knowledge-tier handling
├── Macro-Builder-Mages.lua        Mage conjure resolvers (Water, Food, Mana Gem)
├── Macro-Builder-Warlocks.lua     Warlock conjure resolvers (Healthstone, Soulstone)
├── Minimap-Button.lua             LDB data object and minimap UI
├── Options.lua                    Settings panel
├── Data/
│   ├── Bandages.lua               Bandage item definitions
│   ├── Data-General.lua           Brand colors, class colors, defaults, conjure spell tables, spell/item IDs
│   ├── Food-and-Water.lua         Food/water/buff-food definitions
│   ├── Healthstones.lua           Healthstone item definitions
│   ├── Mana-Gems.lua              Mana gem item definitions
│   ├── Pet-Foods.lua              Hunter pet food itemLevel/diet/quest data
│   ├── Potions.lua                Health and mana potion definitions
│   ├── Scrolls.lua                Scroll item, buff, and conflict-spell data
│   └── Soulstones.lua             Soulstone item definitions
├── Locales/
│   └── enUS.lua                   English strings (other locales loaded by .toc)
└── Scanner/
    ├── Buffs.lua                  Aura inspection: Well Fed, scrolls, pet buffs
    ├── Inventory.lua              Bag scan and best-item selection
    └── Item-Data.lua              Async item data fetch and cache
```

---

## Architecture

### Event Loop

Core.lua owns a single hidden frame that listens for the events that should trigger a rescan: `BAG_UPDATE_DELAYED`, `PLAYER_LEVEL_UP`, `ZONE_CHANGED_NEW_AREA`, `PLAYER_TARGET_CHANGED`, `UNIT_PET`, `UNIT_AURA`, etc. All of these route through `RequestUpdate()`, which sets a "dirty" flag and a 0.5-second throttle timer. The actual rescan and macro rewrite happens on the next `OnUpdate` tick where the throttle has elapsed.

This deliberate coalescing prevents macro thrashing — looting a 30-stack of bandages fires `BAG_UPDATE_DELAYED` once, but a vendor sweep can fire it dozens of times in a few frames.

### Combat Lockdown

Macro edits via `EditMacro` are silently dropped during combat lockdown. Any update path that runs during combat sets the dirty flag and exits early; the next post-combat tick performs the deferred rewrite. `PLAYER_REGEN_ENABLED` triggers a forced rebuild to flush whatever queued up while locked.

### Scan → Compose → Write

`ns.UpdateMacros()` runs three phases:

1. **Scan** (`Scanner/Inventory.lua`): walks all bag slots, calls `ScanBags()` which iterates `best[]` per category, applying the comparison ladder (buff food preference → percent vs flat → score → vendor price → hybrid preference → bag count). Side effects: populates `ns.BestFoodID`, `ns.ScrollOverrideIDs`, `ns.PetBuffOverrideID`.

2. **Compose** (`Macro-Builder-General.lua` plus class-specific resolver files): for each consumable type in `Config`, builds the macro body string. The body is a concatenation of: tooltip line → conjure block (Mage/Warlock click handlers) → scroll block (Food only) → state-write line → action block → optional Shadowmeld suffix. Class-specific files (`Macro-Builder-Mages.lua`, `Macro-Builder-Warlocks.lua`, `Macro-Builder-Druids.lua`, `Macro-Builder-Hunters.lua`) register entries into `ns.ConjureResolvers` (or own a dedicated builder, in Hunters' case) that `Macro-Builder-General.lua` consults during composition.

3. **Write**: hashes the composition into a state key, compares against `currentMacroState[typeName]`, and only calls `EditMacro` if the body has actually changed. Writing during combat is a no-op; the dirty flag re-runs on `PLAYER_REGEN_ENABLED`.

### Item Data Caching

`Scanner/Item-Data.lua` lazily resolves item details (name, classID, subclassID, sell price, required level, required skill) via `GetItemInfo`. First requests on a fresh client return `nil`; the addon reschedules a retry until the data is available, then writes it to `ConnoisseurDB.itemCache`. The cache is keyed by addon version — a version bump invalidates everything to pick up new fields or corrected data without leaving stale entries behind.

### State Encoding

Every macro write is preceded by computing a state key that captures every input that affects the body. The Food macro uses one of two disjoint key namespaces:

**Food mode:**

```text
ITEMID(_C(_M:mid)?(_R:rid)?(_MR:key)?(_MM:key)?(_NI:key)?)?(_SM)?
```

- `ITEMID` — primary item slotted into the macro (or `none`).
- `_C` — conjure block present.
- `_M:mid` — middle-click spell ID (Ritual of Refreshment / Ritual of Souls).
- `_R:rid` — right-click spell ID (current rank).
- `_MR:key` — right-click miss tip (player can't yet cast the right-click conjure).
- `_MM:key` — middle-click miss tip (player can't yet cast the middle-click conjure).
- `_NI:key` — no-item miss tip (replaces the generic "no item in bags" message for classes that can eventually conjure this category).
- `_SM` — Shadowmeld suffix appended (Night Elf Water macro).

**Scroll mode:**

```text
SCROLLS:s1,s2,...
```

**DMH mode** (Druid Health Potion / Mana Potion / Healthstone with DruidMacroHelper integration enabled):

```text
DMH:formKey:ITEMID
```

`formKey` is `bear` or `cat` per the `druidReturnForm` setting. See the [DruidMacroHelper Integration](#druidmacrohelper-integration-druid-hp--mp--hs) deep-dive for the body shape.

The three prefixes (`ITEMID`, `SCROLLS:`, `DMH:`) are pairwise disjoint — item IDs are numeric (no colon), `SCROLLS:` and `DMH:` use different stems — so any transition between modes always changes the key and always triggers a rewrite. Within a mode, a different ordered list of scroll IDs, a different selected item, or a different return form is also a different key, so the relevant change always causes a rewrite.

If the key matches `currentMacroState[typeName]`, the macro is byte-for-byte identical to what's already written and we skip the `EditMacro` call. This is what makes `BAG_UPDATE_DELAYED` storms cheap.

---

## Macro Composition Details

### Food Macro: Two Modes

The Food macro has two modes that swap automatically based on what buffs the player needs and what target is selected.

**Scroll mode** — active when (a) `useScrolls` is on, (b) at least one tracked scroll buff is missing, (c) the player has those scrolls in bags, and (d) the player is not targeting another friendly player. The body is just scrolls, in priority order:

```text
#showtooltip
/use [@player] item:SCROLL1
/use [@player] item:SCROLL2
```

Bare `#showtooltip` resolves the action-bar icon to the first scroll. The user taps once to fire all missing scrolls. After the next bag/buff scan picks up the new auras, scroll mode exits and the macro flips to food mode for the next press.

**Food mode** — active in all other cases. Standard food-macro layout, the same as before scrolls existed:

```text
#showtooltip item:FOODID
/cast [btn:3] Ritual of Refreshment; [btn:2] Conjure Bread(Rank N);
/stopmacro [btn:3][btn:2]
/run ConnFire(FOODID)
/use item:FOODID
```

The two modes never coexist in the same body. The split keeps each macro readable and predictable: scroll mode is purely for buffing yourself; food mode is purely for eating (and conjure-for-friend on right-click).

**Why targeting a friendly player flips to food mode.** Mages right-click their Food macro to conjure bread for a friend. If scroll mode were active, the right-click would hit `/use [@player] item:SCROLL1` first and fire scrolls on the *Mage*, not give bread to the friend. Dropping scroll mode the moment a friendly player is targeted keeps the conjure-for-friend interaction clean. The PLAYER_TARGET_CHANGED event re-runs the macro update, the state key flips between `SCROLLS:...` and `ITEMID_C_M:..._R:...` namespaces, and the body rewrites.

The conjure block uses `/stopmacro` to short-circuit: a right-click conjures bread and stops, never reaching the scroll or food lines. A left-click skips the conjure block entirely and runs everything below it.

### The 255-Character Limit

WoW silently truncates macro bodies at 255 characters. Both Food modes fit comfortably:

- **Scroll mode**: `#showtooltip\n` (14 chars) plus at most 6 scrolls × ~25 chars each ≈ 164 chars total. No truncation logic needed.
- **Food mode**: identical to the pre-scrolls macro shape, so no new pressure on the limit. The `ConnFire(itemID)` global helper in Core.lua keeps the state-write line short — `/run ConnFire(NNN)` (~19 chars) versus an inlined `/run ConnoisseurState.lastID=NNN;ConnoisseurState.lastTime=GetTime()` (~65 chars) — which matters most for non-English locales where conjure spell names get long.

The 8-char `ConnFire` name is short enough to be useful and distinctive enough (the `Conn…` prefix) to keep global-collision risk negligible against the addon ecosystem.

`ns.SCROLL_CHECK_ORDER` (defined in `Data/Scrolls.lua`) is the priority list: Agility, Strength, Protection, Intellect, Spirit, Stamina. Scroll mode fires scrolls in this order on a single press.

### Friendly-Player Target Handling

When the player has another friendly player targeted, `HasFriendlyPlayerTarget()` returns true and scroll mode is suppressed — the Food macro stays in food mode regardless of buff state. This keeps the conjure-for-friend interaction clean (a Mage can right-click `- Food` while targeting a guildie to give them bread, without firing scrolls on themselves first).

The macro update loop registers `PLAYER_TARGET_CHANGED` so the rebuild fires (under the 0.5s throttle) the moment the target changes. Because the state key namespaces are disjoint (`SCROLLS:...` vs `ITEMID_C_M:..._R:...`), entering or leaving a friendly-player target always triggers a rewrite.

The same `HasFriendlyPlayerTarget()` helper is used by `GetSmartSpell()` for Mage/Warlock conjure rank downranking — when targeting a lower-level friend, the conjure rank caps at their level.

### Pet Food Override

`ns.PetBuffOverrideID` substitutes the Food slot's *itemID* with Kibler's Bits or Sporeling Snacks when the player's pet lacks the food buff and the player has the items in bags. This is intentionally a substitution rather than an additive line: only one `Well Fed` buff exists, and the player can only consume one item per macro press.

Pet buff override is part of food mode only — when scroll mode is active, the macro fires only scrolls. The user taps once for scrolls, then on the next press scroll mode exits and pet food (or normal food) takes over.

### Mana Gem Uniqueness

Mana Gems are unique-equipped — the player can hold only one rank in their bag at a time. `GetSmartSpell` for the Mana Gem macro passes `checkUnique = true`, which queries `C_Item.GetItemCount` for each rank's conjured item ID and skips ranks the player already has. The result: clicking the Mana Gem macro conjures the highest rank you don't already own, so a second press immediately gives you a backup gem at the next rank down.

### Hunter Feed Pet

The Feed Pet macro is built separately by `UpdateFeedPetMacro()` because its conditional structure is unlike the consumable macros — a single button needs to dispatch to Feed, Mend, Call, Revive, or Dismiss based on modifiers, button, pet state, and combat state.

The compact form uses bracket conditional groups to stay well under 255 chars even in heavily-localized clients (German has the longest spell names):

```text
/cast [mod:ctrl] Dismiss Pet; [mod:shift][@pet,dead] Revive Pet; [nopet] Call Pet; [btn:2][combat] Mend Pet; Feed Pet
/stopmacro [mod][btn:2][nopet][@pet,dead][combat]
/use item:FOODID
```

When the pet is dead and dismissed, `[nopet]` swaps to Revive Pet so a single click works regardless of pet state. Combat forces Mend Pet because Feed Pet can't be cast in combat.

### DruidMacroHelper Integration (Druid HP / MP / HS)

When `enableDruidMacroHelper` is on for a Druid character, the Health Potion, Mana Potion, and Healthstone macros are rewritten to use the [DruidMacroHelper](https://www.curseforge.com/wow/addons/druidmacrohelper) addon's `/dmh` slash syntax. The shape lets a druid powershift out of form, `/use` the consumable, and shift back into bear or cat — guarded against breaking form when the consumable is on cooldown, the player is stunned, on GCD, or out of mana.

Each consumable type uses a slightly different `/dmh` guard prefix, copied from the DMH addon's own examples:

- **Health Potion** — `/dmh start` (stun + GCD + mana check) plus `/dmh cd pot` (shared-potion-CD check)
- **Healthstone** — `/dmh start` plus `/dmh cd hs`
- **Mana Potion** — `/dmh stun gcd cd pot` — explicitly skips the mana check, since the whole point of a mana pot is that the druid is OOM and would otherwise fail the start guard

The macro returns to the form named by `settings.druidReturnForm` (`"bear"` or `"cat"`), set via the dropdown in the Druids options section.

**Why hard-coded rather than auto-tracked.** WoW prevents `EditMacro` calls during combat lockdown. Any auto-tracking design — listening to `UPDATE_SHAPESHIFT_FORM` and rewriting the body in response — would queue updates for after combat ends, leaving the macro stale during the actual combat where the druid powershifts back and forth. A druid who shifted cat→bear mid-combat and pressed the macro before `PLAYER_REGEN_ENABLED` would end up in cat instead of bear (or vice versa). The hard-coded preference eliminates the risk; switching forms in earnest is an out-of-combat action, and the dropdown is one click.

**Bear vs Dire Bear smartness.** At login, `Core.lua` resolves the bear form spell name via `GetSpellInfo(9634)` (Dire Bear Form, learned at level 40 in pre-Cataclysm builds) with a fallback to `GetSpellInfo(5487)` (Bear Form). The dropdown stores the abstract `"bear"` preference; the macro builder substitutes whichever real spell name the druid has learned, so the same dropdown setting renders the correct `/cast !Bear Form` or `/cast !Dire Bear Form` for the character's level.

---

## Saved Variables

Two scopes:

- **`ConnoisseurDB`** (account-wide): `minimap` table for LibDBIcon, `itemCache` table keyed by item ID, `itemCacheVersion` for cache invalidation, `showWelcome` (boolean, default `true`) for the on-login welcome message.
- **`ConnoisseurCharDB`** (per-character): `ignoreList` (set of item IDs), `settings` table with all toggle/mode/type fields. Defaults are merged from `ns.SETTINGS_DEFAULTS` on load so new settings introduced in updates pick up sensible values. Druid-specific fields (`enableDruidMacroHelper` boolean, `druidReturnForm` `"bear"`/`"cat"`) are present on every character but only consulted when `ns.IsDruid` is true.

When changing the saved-variable schema, never silently rewrite user data. Add a one-shot migration in `InitVars()` (Core.lua), gated on the presence of the legacy field so it runs once and then becomes a no-op. Remove the migration after the upgrade window has passed.

---

## Adding a New Consumable Category

1. Add a data file in `Data/` describing item IDs, restore values, vendor prices, level requirements, and any zone restrictions or required skills. Use existing files as templates — keep the structure flat (a numeric-keyed item table) for easy diffing.
2. Add the file to the load order in `Consumable-Connoisseur.toc`.
3. Add a `Config` entry in `Data/Data-General.lua` with the macro name (use a localized string from `Locales/enUS.lua`) and a `defaultID` for the placeholder tooltip.
4. Add a `best[]` entry in `Scanner/Inventory.lua` and a branch in the `itemType` dispatch.
5. Add the `Item-Data.lua` `itemType` classification for the new category.
6. Add the macro name to `enabledMacros` defaults in `Data-General.lua`.
7. Add a localization key to `Locales/enUS.lua` (`MACRO_*` prefix, full words — `MACRO_HEALTH_POTION`, not `MACRO_HPOT`).

Test against the 255-character limit with the longest possible spell names. German enables this by setting `SET locale "deDE"` in the .toc — most overflow bugs surface in deDE, frFR, or ruRU first.

---

## Adding a New Locale

Copy `Locales/enUS.lua` to `Locales/<locale>.lua`. Change the `NewLocale("Connoisseur", "<locale>", true)` call to drop the `true` (which marks the file as the default fallback). Translate every string. Add the file to the .toc immediately after `Locales/enUS.lua`.

Be conservative with macro string lengths. Macro names cap at 16 characters. The `MSG_BUG_REPORT` template can be longer but should still fit a chat line. Macro action lines that include localized spell names (Mage conjure, Warlock conjure, Hunter Mend Pet, Shadowmeld) are the most likely places to hit the 255-char cap.

---

## Common Pitfalls

- **Editing macros in combat**: silently fails. Always defer via the dirty flag.
- **Querying `GetItemInfo` cold**: returns nil on first call. Use the retry path in `Item-Data.lua`, don't loop until it succeeds.
- **Forgetting state encoding**: if you add a new input that affects the macro body, add it to the state key. Otherwise the body won't rewrite when that input changes.
- **Hardcoding spell names**: always resolve via `GetSpellInfo(spellID)`. Names vary across locales and patch revisions.
- **Stacking too many lines in Food**: food mode and scroll mode each have their own budget. Food mode keeps the same shape it had pre-scrolls, so additions there should walk the worst-case 255-char check on a deDE Mage at max level. Scroll mode is short and won't approach the limit, but anything you add there should still be measured.
- **Auto-tracking druid form**: don't. `EditMacro` is gated by `InCombatLockdown`, so any auto-tracker that listens to `UPDATE_SHAPESHIFT_FORM` produces stale macros during combat — exactly when a druid is powershifting in earnest. Use the hardcoded `druidReturnForm` setting; the user picks bear or cat via the dropdown and the macro reflects that choice. Switching is one out-of-combat click.

---

## Contributing

Pull requests welcome at https://github.com/Gogo1951/Connoisseur. For bugs or feature ideas, please open a GitHub issue with:

- Game version and locale
- Class and level
- Reproduction steps
- The relevant macro body, copied from the in-game macro window

Discussion happens on Discord: https://discord.gg/eh8hKq992Q.

When opening a PR:

- Keep changes scoped — one concern per PR is easier to review.
- Match the existing code style (4-space indent, no trailing whitespace, comments above non-obvious blocks).
- If you change saved-variable structure, add a one-shot migration in `InitVars()` (Core.lua) gated on the legacy field, and plan its removal in a later release.
- If you change the macro body composition, walk the worst-case 255-char check on a deDE-locale Mage at max level.
- Update this document if the architecture or file map changes.
