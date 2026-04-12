# Connoisseur

Creates auto-updating macros for your best consumables, tracking buffs to keep you at peak performance. Features an all-in-one Feed-O-Matic for Hunters and smart right-click conjuring for Mages and Warlocks that adapts to your target's level.

![Consumable-Connoisseur](https://github.com/user-attachments/assets/326eb93f-329f-4967-b750-909011a05b01)

## What It Does

Connoisseur scans your bags every time something changes (loot, vendor purchase, level up, zone change) and rewrites a set of macros so they always use your best available consumable. It picks the highest-value item you can actually use right now, factoring in your level, profession skills, zone restrictions, and then looks at lowest vendor sell price, and lowest stack count, as tiebreakers.

## Quick Start

1. Install from [CurseForge](https://www.curseforge.com/wow/addons/consumable-connoisseur) or clone from [GitHub](https://github.com/Gogo1951/Consumable-Connoisseur).
2. Log in. Connoisseur automatically scans your bags and creates macros in your General macro tab.
3. Drag the macros onto your action bars. They start with a dash: `- Food`, `- Water`, `- Health Potion`, etc.
4. Play normally. The macros update themselves whenever your bags change, you level up, or you move to a new zone.

That's it. No configuration required for basic use.

<img width="300" src="https://github.com/user-attachments/assets/c57060c0-4eee-44ab-af88-48e077d886cc" />

### Macros Created

| Macro Name | Category |
|---|---|
| `- Food` | Best food (or buff food / scroll / pet buff food when enabled) |
| `- Water` | Best drink |
| `- Health Potion` | Best healing potion |
| `- Mana Potion` | Best mana potion |
| `- Healthstone` | Best Healthstone (Warlock) |
| `- Soulstone` | Best Soulstone (Warlock) |
| `- Mana Gem` | Best Mana Gem (Mage) |
| `- Bandage` | Best bandage (requires First Aid skill) |
| `- Feed Pet` | All-in-one pet button (Hunter only) |

### Class Features

**Mages** can right-click Food, Water, or Mana Gem macros to conjure items. Middle-click casts Ritual of Refreshment. Targeting a lower-level friendly player auto-selects the appropriate conjure rank.

<img width="300" src="https://github.com/user-attachments/assets/4a4cd1b4-d227-4731-8988-36f505611883" />

**Warlocks** can right-click Healthstone or Soulstone macros to create them. Middle-click casts Ritual of Souls.

**Hunters** get an all-in-one `- Feed Pet` macro. Left-click feeds your pet the cheapest food that still gives max happiness. Right-click or entering combat casts Mend Pet. Shift forces Revive Pet. Ctrl dismisses. If your pet is dead but dismissed, it auto-switches to Revive Pet.

<img width="300" src="https://github.com/user-attachments/assets/6ced7fae-f0bf-48f0-b317-b382e11a3bc1" />

**Night Elves** can enable Shadowmeld Drinking, which appends Shadowmeld to the Water macro so you stealth while drinking.

## Settings

Type `/foodie` or go to **Options > AddOns > Connoisseur** to open the settings panel.

<img width="800" src="https://github.com/user-attachments/assets/c0e8e916-b3b9-4ce1-a5ff-d4b023a8ee20" />

### Prioritize Buff Food

When enabled, the Food macro prefers items that grant the "Well Fed" buff, but only when you don't already have the buff active. Can be restricted to only activate when in a party or raid.

### Scroll Buffs

When enabled, the Food macro will use attribute scrolls (Agility, Intellect, Protection, Spirit, Stamina, Strength) before regular food when the corresponding scroll buff is missing. Scrolls are targeted at yourself, so they won't accidentally buff your current target. You can toggle individual scroll types on and off. Scrolls are skipped when a class buff (e.g. Arcane Intellect) already covers the same stat at equal or greater value.

### Pet Food Buffs

When enabled, the Food macro will use Kibler's Bits or Sporeling Snacks on your pet when its "Well Fed" buff is missing. Requires level 55+. Can be restricted to party or raid.

### Ignore List

Right-click the minimap button to add your current best food to the ignore list. The addon will skip ignored items and pick the next best option. Middle-click the minimap button to clear the entire ignore list. You can also clear it from the settings panel.

## Minimap Button

Hover for a full tooltip showing the current state of all features, your best food, the ignore list, and class-specific tips. Click actions:

| Action | Effect |
|---|---|
| Left-click | Toggle Buff Food priority |
| Shift + Left-click | Toggle Scroll Buffs |
| Right-click | Ignore current best food |
| Middle-click | Clear ignore list |

The minimap icon updates dynamically to show the icon of your current best food item.

## How Item Selection Works

For each consumable category, the addon picks the best item by comparing every usable item in your bags. The priority order is:

1. Buff food preferred (when Buff Food is enabled and you lack the Well Fed buff)
2. Percentage-based items preferred over flat values
3. Highest restore value wins
4. Lowest vendor sell price breaks ties (use up cheap items first)
5. Hybrid food+water items are preferred or avoided depending on the slot
6. Fewest total count in bags breaks the final tie

Items are filtered out if you don't meet the level requirement, lack the required profession skill (First Aid for bandages, Alchemy for certain potions), or are in the wrong zone for zone-restricted items.

## Saved Variables

Connoisseur stores data in two scopes. Account-wide settings (`ConnoisseurDB`) hold the minimap position and an item data cache that resets on each addon version update. Per-character settings (`ConnoisseurCharDB`) hold your ignore list, buff food preference, scroll settings, and all other toggles.

## Testing Status

🟢 World of Warcraft Classic (🟡 Season of Discover)

🟢 Burning Crusade Anniversary

🔴 Mists of Pandaria Classic

🔴 World of Warcraft

Please reach out if you would like to be involved with testing!

## Report Issues & Get Involved

## Links

- [CurseForge](https://www.curseforge.com/wow/addons/consumable-connoisseur)
- [GitHub](https://github.com/Gogo1951/Consumable-Connoisseur)
- [Discord](https://discord.gg/eh8hKq992Q)
