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