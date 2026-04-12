# Contributing to Consumable Connoisseur

This guide gets you from zero to making changes in under 10 minutes.

## Environment Setup

You need a WoW Classic or TBC Classic client and a text editor. No build tools, no package managers, no compilation step.

1. Clone the repository into your WoW addons folder: `World of Warcraft/_classic_/Interface/AddOns/Consumable-Connoisseur/`
2. Make sure the folder name is exactly `Consumable-Connoisseur` (must match the TOC filename).
3. Log in to WoW. The addon loads automatically from source.
4. Type `/foodie` to confirm it's running.

To reload after making changes, type `/reload` in the WoW chat window. No restart needed.

## Project Structure at a Glance

The addon has four layers, loaded in this order:

**Data layer** (`Data/*.lua`) — Static item tables. Each file populates `ns.RawData` with item IDs and their properties. If you're adding support for a new consumable, this is where you start. General.lua also holds brand colors, macro configuration, spell tables, and default settings.

**Core layer** (`Core.lua`) — Event registration and the throttled update loop. Receives WoW events, defers during combat, and calls `ns.UpdateMacros()` when safe. You rarely need to touch this unless you're adding a new event trigger.

**Scanner layer** (`Scanner.lua`) — Bag scanning and best-item comparison. Caches item data, evaluates candidates per consumable category, and handles scroll/pet buff overrides. The comparison logic in `IsBetter()` is the heart of the selection algorithm.

**UI layer** (`Macro-Builder.lua`, `Minimap-Button.lua`, `Options.lua`) — Writes macros, renders the minimap tooltip, and provides the AceConfig settings panel. The macro builder also handles Mage/Warlock conjure spell resolution and the Hunter Feed Pet macro.

**Localization** (`Locales/*.lua`) — AceLocale-3.0 files. enUS.lua is the source of truth. Other locale files only override strings that have been translated.

## Key Concepts

**The namespace (`ns`)** — Every Lua file shares the same `ns` table via `local _, ns = ...`. All cross-file communication goes through `ns`. There are no global functions.

**Item cache** — `ConnoisseurDB.itemCache` persists parsed item data across sessions. It resets on version change. Entries are either a structured table or the string `"IGNORE"` for non-consumable items.

**State strings** — Macro-Builder.lua tracks a state string per macro type (e.g. `"12345_S:6789_C_R:111"`). Macros only rewrite when the state changes, avoiding unnecessary `EditMacro()` calls.

**Combat lockdown** — WoW forbids macro creation/editing during combat. All writes defer to `PLAYER_REGEN_ENABLED`.

## Common Tasks

### Adding a New Consumable Item

Open the appropriate data file (e.g. `Data/Potions.lua` for a new potion). Add a line following the existing format:

```lua
[ITEM_ID] = {healAmount, manaAmount, {zoneMapIDs}}, -- Item Name
```

Zone restrictions are optional — omit the third field (or set it to nil) for items usable everywhere. Save, `/reload`, and the scanner will pick it up automatically.

### Adding a New Consumable Category

This is a bigger change that touches multiple files:

1. Add raw data to a new or existing `Data/*.lua` file and register it in `ns.RawData`.
2. Add a `best` entry in Scanner.lua's `best` table with the new category name.
3. Add comparison logic in the `ScanBags()` loop for the new `itemType`.
4. Add a `ns.Config` entry in General.lua with the macro name and default icon item ID.
5. Wire up the TOC if you created a new data file.
6. The macro builder will automatically create a macro for any new Config entry.

### Adding a New Locale String

Add the key to `Locales/enUS.lua` first — this is the authoritative source. Other locale files inherit from enUS automatically via AceLocale's fallback. Only add the key to other locale files when you have an actual translation.

### Adding a New Option

Options.lua uses AceConfig-3.0. Follow the existing pattern: add a default value in `ns.SETTINGS_DEFAULTS` (General.lua), add the toggle/select widget in `GetOptions()` (Options.lua), and wire the getter/setter to read from and write to `ConnoisseurCharDB.settings`. Call `ns.RequestUpdate()` in the setter to trigger a rescan.

### Adding a New Event Trigger

Register the event at the bottom of Core.lua and add a handler case in the `OnEvent` function. Most handlers just call `ns.RequestUpdate()`. If the event carries data that needs caching (like `PLAYER_LEVEL_UP` updates `ns.CachedPlayerLevel`), do that before requesting the update.

## Code Style

The codebase follows the Gogo1951 style guide. Key points:

Sections are separated by 80-character dash comment headers. Local variables use camelCase. Functions on `ns` use PascalCase. Each file is self-contained with a `State` section at the top declaring all file-scoped locals. No global pollution — everything goes through `ns` or stays local.

Colors use the brand palette defined in `ns.Colors` and are applied via `ns.GetColor("KEY")` which returns a WoW color escape string. Localized strings use `L["KEY"]` throughout.

## Testing Changes

There's no automated test suite. Test manually:

1. `/reload` after changes.
2. Check that macros update correctly by adding/removing items from bags.
3. Test with different classes (Mage conjure, Warlock conjure, Hunter feed pet).
4. Test the ignore list (right-click minimap button, verify the item is skipped).
5. Test combat lockdown (start combat, change bags, leave combat, verify macros update).
6. Check the minimap tooltip renders correctly.
7. Open `/foodie` and toggle settings to verify they take effect.

## Packaging and Release

The addon uses pkgmeta for CurseForge/WoWInterface packaging. The `Includes/` folder uses `externals` in pkgmeta to pull library dependencies at package time. When developing locally, you need the library source files in `Includes/` — clone them from their respective repos or copy from another addon.

Version is set in the TOC as `## Version:` and follows the format `YYYY.MM.DD.Letter` (e.g. `2026.04.09.A`). The packager replaces `@project-version@` tokens automatically.

## Getting Help

Open an issue on [GitHub](https://github.com/Gogo1951/Consumable-Connoisseur) or join the [Discord](https://discord.gg/eh8hKq992Q).
