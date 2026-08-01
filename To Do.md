# To Do

```
Feature 1 — Weapon Buff Macro

Add a `- Weapon Buff` macro that applies sharpening stones, weightstones, and weapon oils. The user picks the buff type per weapon slot; nothing is auto-assigned by class or weapon. This is the non-Rogue sibling of the `- Poisons` macro and follows that macro's wiring wherever it can.

Data. Create `Data/Weapon-Buffs.lua`, modelled on `Data/Poisons.lua`:
- `ns.WeaponBuffGroupBaseItems` — `[groupID] = <base item ID>`, one per type: Sharpening Stone, Weightstone, Mana Oil, Wizard Oil. Group display names resolve at runtime via `GetItemInfo` on the base item the way `ns.GetPoisonGroupName` does, so no group name is ever a locale key.
- `ns.WeaponBuffGroupFallbackNames` — English fallbacks, used only while `GetItemInfo` is still cold. Not a locale surface.
- `ns.WeaponBuffData` — `[ID] = { requiredLevel, groupID }, -- Item Name`. Ship the table with its header comment, a `-- TODO: Add SQL Query` marker, and the row-shape comment ONLY. Leave the rows empty for the maintainer to paste in; do not invent item IDs.
- `ns.WeaponBuffsByGroup` — derived per-group lists sorted best-first, built with the same loop `Data/Poisons.lua` uses for `ns.PoisonsByGroup`.

Macro definition. Create `Features/Macros/Weapon-Buff.lua`, modelled on the `Poisons` registration and body builder at the end of `Features/Macros/Tools-Rogues.lua`. It owns its whole update cycle (`customUpdate`), because slot resolution is not a bag-scan winner.
- `ns.GetBestWeaponBuffForSlot(slot)` — `slot` is `"main"`, `"off"`, or `"twohand"`; reads the matching setting, walks `ns.WeaponBuffsByGroup` for that group best-first, and returns the highest rank in bags that `ns.CachedPlayerLevel` allows, plus its link.
- Two-handed detection: off-hand slot empty AND `GetItemInfo` on `GetInventoryItemLink("player", 16)` reports `INVTYPE_2HWEAPON`. Equipped-item data is a live API read, which the static-data rule explicitly allows.
- Body shapes, matching the Poisons builder's two-step apply plus `/click StaticPopup1Button1` to confirm the replace prompt:
  - Two-hander equipped: both clicks apply the Two-Handed pick to slot 16. Emit `/use 16` with no `[btn:2]` branch — there must be no dead button.
  - Main and off hand both resolved: `/use [btn:2] 16; 17`, left-click off hand, right-click main hand.
  - Only one slot resolved: the single-slot body for that slot.
  - Nothing resolved: fire `ConnNoItem` with the `Weapon Buff` label, as the other macros do.
- Make no attempt to validate that a stone is legal on the equipped weapon type. The user's pick is respected; the client's own error is the feedback.
- If the file passes roughly 250 lines, split the slot resolver into `Features/Macros/Tools-Weapon-Buffs.lua` and load it before the definition.

Config and settings.
- `Data/Data.lua` → add to `ns.Config`: `["Weapon Buff"] = { macro = ns.L["MACRO_WEAPON_BUFF"], defaultID = <Rough Sharpening Stone>, label = ns.L["LABEL_WEAPON_BUFF"] }`.
- `Data/Default-Settings.lua` → add `mainHandWeaponBuffGroup`, `offHandWeaponBuffGroup`, and `twoHandWeaponBuffGroup` to `profile`, all defaulting to the Sharpening Stone group ID, and add `["Weapon Buff"] = true` to `enabledMacros`. On by default for every class, Rogues included.

Events. Add `"PLAYER_EQUIPMENT_CHANGED"` to `ns.EVENT_NAMES` in `Features/Core.lua` and route it to `ns.RequestUpdate()` in the existing plain-event branch, so swapping weapons rebuilds the macro. It is a plain event, not deferred, so leave `DEFERRED_EVENTS` alone. Diagnostics' Event Registration check reads `ns.EVENT_NAMES`, so no diagnostics change is needed.

Options. In `Options/Options-General.lua`, add a "Weapon Buffs" section with three dropdowns — Main Hand, Off Hand, Two-Handed — built by generalizing the existing `PoisonHandDropdown` helper into a slot-and-setting-key form, or by adding a sibling helper next to it. Add the macro's toggle to the Enable Macros section using `MacroToggle`. Place the new section after the Rogues section.

Minimap tooltip. In `Features/Minimap-Button.lua`, add a Weapon Buff block that shows the resolved item per slot, mirroring the Rogue poison block's `UI_MAIN_HAND` / `UI_OFF_HAND` structure and using `UI_TWO_HAND` when a two-hander is equipped.

Locale keys to add to `Locales/enUS.lua` only — the Localization pass handles the other files:
`MACRO_WEAPON_BUFF` ("- Weapon Buff"), `LABEL_WEAPON_BUFF`, `UI_TWO_HAND`, `OPTIONS_WEAPON_BUFF_HEADER`, `OPTIONS_WEAPON_BUFF_DESCRIPTION`, `OPTIONS_WEAPON_BUFF_MAIN_HAND`, `OPTIONS_WEAPON_BUFF_OFF_HAND`, `OPTIONS_WEAPON_BUFF_TWO_HAND`, `TIP_NO_SLOT_WEAPON_BUFF`. Keep `MACRO_WEAPON_BUFF` inside the 16-character macro-name limit.

TOC. Add `Data/Weapon-Buffs.lua` after `Data/Poisons.lua`, and `Features/Macros/Weapon-Buff.lua` after `Features/Macros/Water.lua` in the macro-definitions run.

Do not touch `README.md` or `README-Technical.md`; the ReadMe passes own those.
```

```
Feature 2 — Restock Categories

Give the Restock List level-aware category entries. A category row like "40 Water" always resolves to the best item in that category the player's level allows, instead of pinning one item ID that goes stale every ten levels. Run this before Feature 3, which seeds these rows.

Data. Create `Data/Restock-Categories.lua`:
- `ns.RestockCategories` — `[categoryKey] = { labelKey = "RESTOCKER_CATEGORY_WATER", ladder = { { itemID, requiredLevel }, ... } }`. Ship these keys: Water, Bread, Meat, Fish, Cheese, Fruit, Arrows, Bullets, Bandages.
- Ship the registry with every category key, its `labelKey`, and an empty `ladder` plus the row-shape comment. The maintainer pastes the ladders in; do not invent item IDs.
- Sort each ladder best-first at load with the same derived-lookup loop `Data/Poisons.lua` uses for `ns.PoisonsByGroup`, so the runtime walk is a plain iteration.
- These tables are curated, not query-derived, so no SQL comment. Add the `-- TODO: Add SQL Query` marker only if the maintainer generates them from a Mangos query.

Resolver. Create `Features/Restocker/Category.lua`:
- `ResolveForMerchant(categoryKey)` — walk the ladder downward from the highest tier `ns.CachedPlayerLevel` allows and return the first item the open merchant actually stocks. A vendor that carries no tier at all yields nil and the row is skipped for that vendor. This downward walk is the whole point of the feature: most vendors stock older tiers.
- `ResolveOwnedCount(categoryKey)` — total count across every ladder item, in bags or in the bank as the caller needs, so "40 Water" is satisfied by any mix of tiers.
- `ResolveBestOwned(categoryKey)` — the highest tier currently held, for the row's icon and tooltip.

Saved format. In `Features/Restocker/Restocker.lua`, bump `RS_DATA_VERSION` to 6 and extend the one-line saved format to carry category rows:
- Profiles are keyed by itemID today. Key a category row with the string `"CAT:<categoryKey>"`; `rsItemFromString` already receives the table key, so branch on the string prefix there and return a row carrying `categoryKey` instead of `itemID`.
- `rsItemToString` writes category rows as `Category, <categoryKey>, amount, stash, fromBank, buy [, reaction]`, keeping the existing 1/0 boolean encoding and the same field order.
- `rsInflate` and `rsCleanItem` must pass category rows through untouched — no itemID sync, no itemLink rebuild.
- Leave the pre-v5 migration tolerance alone; it is dated and owned elsewhere.

Buying. In `Features/Restocker/Merchant.lua` and `Features/Restocker/BuyCommand.lua`, resolve a category row through `ResolveForMerchant`, compare `ResolveOwnedCount` against the row's amount, and buy the resolved item up to the target. Honor the row's per-item reputation gate exactly as an item row does. Restocker still never sells.

Bank. In `Features/Restocker/Bank.lua`, support both directions for category rows:
- Withdraw: pull any ladder item from the bank until `ResolveOwnedCount` in bags reaches the target, highest usable tier first.
- Deposit: send the surplus above the target to the bank, lowest tier first, so the newest items stay in bags.

List UI. In `Features/Restocker/ListFrame.lua` and `Features/Restocker/MainFrame.lua`, render a category row with the icon and name of its currently resolved best-owned item, the category label beneath it, and the same Amount, Buy, Deposit, Withdraw, and reputation controls an item row has. Extend the Add control so a category can be added by name from a dropdown alongside the existing drop-an-item and type-an-ID paths. Group category rows under their own list header.

Events. The Restocker runs its own event frames outside Core's dispatcher under the standing interim-architecture ruling. Do not move any of it onto `ns.EVENT_NAMES` and do not add events to Core for this feature.

Diagnostics. Check `ns:BuildSavedVariablesReport` in `Features/Diagnostics.lua` renders the new string-keyed rows; if it assumes numeric keys, widen it. No new manifest entries.

Locale keys to add to `Locales/enUS.lua` only:
`RESTOCKER_CATEGORY_WATER`, `RESTOCKER_CATEGORY_BREAD`, `RESTOCKER_CATEGORY_MEAT`, `RESTOCKER_CATEGORY_FISH`, `RESTOCKER_CATEGORY_CHEESE`, `RESTOCKER_CATEGORY_FRUIT`, `RESTOCKER_CATEGORY_ARROWS`, `RESTOCKER_CATEGORY_BULLETS`, `RESTOCKER_CATEGORY_BANDAGES`, `RESTOCKER_GROUP_CATEGORY`, `RESTOCKER_ADD_CATEGORY`, `RESTOCKER_CATEGORY_TOOLTIP_TITLE`, `RESTOCKER_CATEGORY_TOOLTIP_BODY`, `RESTOCKER_CATEGORY_NO_MATCH`.

TOC. Add `Data/Restock-Categories.lua` after `Data/Explosives.lua`, and `Features/Restocker/Category.lua` after `Features/Restocker/Item.lua`.

Do not touch `README.md` or `README-Technical.md`.
```

```
Feature 3 — Starter Restock List

Run Feature 2 first — this seeds the category rows it introduces.

When a character opens `/crs` and the active profile's list is empty, offer to pre-populate it with a curated starter list for that class instead of showing an empty window.

Data. Create `Data/Restock-Starter-Lists.lua` with `ns.RestockStarterLists`, keyed by class token plus a `DEFAULT` shared block. Each entry is a list of rows in one of two forms: a category row (`{ category = "Water", amount = 40 }`) or a plain item row (`{ itemID = <id>, amount = <n> }`). Ship the table with every class key present, the row-shape comment, and empty bodies; the maintainer pastes the curated contents in. Prefer category rows over item IDs wherever a category exists — that is what keeps the list correct as the character levels. Curated data, so no SQL comment.

Seeding. Create `Features/Restocker/Starter.lua`:
- `SeedStarterList()` — writes the `DEFAULT` rows plus the player's class rows into the active profile, using the same row constructors the Add button uses so nothing bypasses the saved-format code in `Features/Restocker/Restocker.lua`. Skip any row whose key already exists. Print one confirmation line through `ns.PrintMessage` naming how many entries were added.
- `MaybePromptStarterList()` — called when the Restocker window opens. Fires only when the active profile has no rows at all. Show `StaticPopupDialogs["CONNOISSEUR_RESTOCKER_STARTER_LIST"]`, modelled on `CONNOISSEUR_RESTOCKER_DELETE_PROFILE` in `Features/Restocker/MainFrame.lua`.
- Declining is remembered for the session only, in a file-local boolean — never a SavedVariable. The popup returns on the next session's first `/crs` open while the list is still empty. Do not add a saved "never ask again" flag and do not add a Load Starter List button; both were considered and dropped.

Wiring. Call `MaybePromptStarterList()` from the Restocker window's show path in `Features/Restocker/MainFrame.lua`, after the frame is built and the profile is resolved. It must not fire from the bank or merchant auto-open paths — only a deliberate window open should prompt.

Locale keys to add to `Locales/enUS.lua` only:
`RESTOCKER_STARTER_PROMPT` (the popup body), `RESTOCKER_STARTER_ACCEPT`, `RESTOCKER_STARTER_DECLINE`, `RESTOCKER_STARTER_ADDED` (chat confirmation, takes a `%d`). Straight quotes, no em-dashes, no markdown, no emoji.

TOC. Add `Data/Restock-Starter-Lists.lua` after `Data/Restock-Categories.lua`, and `Features/Restocker/Starter.lua` after `Features/Restocker/Category.lua`.

Do not touch `README.md` or `README-Technical.md`.
```


