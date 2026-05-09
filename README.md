# Connoisseur

Auto-updating macros for your best food, buff food, water, scrolls, healing and mana potions, healthstones, soulstones, mana gems, and bandages. One-click conjuring for Mages and Warlocks, smart Feed Pet for Hunters. Eat well, fight well.

![Consumable-Connoisseur](https://github.com/user-attachments/assets/326eb93f-329f-4967-b750-909011a05b01)

## Features

🧞‍♂️ **Auto-Updating Macros** // Always picks your best food, water, potions, healthstones, mana gems, and bandages — rescans your bags whenever loot, level, or zone changes.

🎯 **Smart Conjuring** // Mages and Warlocks right-click their food, water, healthstone, or soulstone macros to conjure the item on the spot. Middle-click casts Ritual of Refreshment (Mage) or Ritual of Souls (Warlock) for the whole group. The rank auto-matches your target, so a lower-level friend always gets something they can actually use.

🦄 **Class Buttons** // Hunters get an all-in-one `- Feed Pet` macro that handles Call Pet, Feed Pet, Mend Pet, Revive Pet, and Dismiss in a single button. Mages can right-click the `- Mana Gem` macro to conjure a backup gem. Druids can enable DruidMacroHelper integration. Night Elves can drink while Shadowmelded.

📜 **Scroll Buff Stacking** // When you're missing scroll buffs, your Food macro turns into a one-tap scroll applier — fires every missing scroll on you, then flips back to food on the next press.

⚙️ **Tune to Taste** // Drop items into an ignore list to skip them, and restrict buff food, scrolls, and pet food to party or raid only.

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/consumable-connoisseur).
2. Log in. Connoisseur scans your bags and creates macros in your General macro tab.
3. Drag the dash-prefixed macros (`- Food`, `- Water`, `- Health Potion`, etc.) onto your action bars.
4. Optional: type `/foodie` to fine-tune scroll buffs, buff food, pet food, and class options.
5. Never miss a meal! Breakfast, second breakfast, elevenses, luncheon, afternoon tea, dinner, supper… (=

## How It Works

### Macros Created

| Macro Name | Category |
| --- | --- |
| `- Food` | Best food (with optional buff food, scroll stacking, and pet buff food) |
| `- Water` | Best drink |
| `- Health Potion` | Best healing potion |
| `- Mana Potion` | Best mana potion |
| `- Healthstone` | Best Healthstone (Warlock) |
| `- Soulstone` | Best Soulstone (Warlock) |
| `- Mana Gem` | Best Mana Gem (Mage) |
| `- Bandage` | Best bandage (requires First Aid skill) |
| `- Feed Pet` | All-in-one pet button (Hunter only) |

### Minimap Button

Hover for a tooltip showing the current state of every feature, your best food, the ignore list, and class-specific tips. The icon updates to match your current best food.

| Action | Effect |
| --- | --- |
| Left-click | Toggle Buff Food priority |
| Shift + Left-click | Toggle Scroll Buffs |
| Right-click | Ignore current best food |
| Middle-click | Clear ignore list |

<img width="300" src="https://github.com/user-attachments/assets/c57060c0-4eee-44ab-af88-48e077d886cc" />

### Item Selection Priority

For each consumable category, Connoisseur compares every usable item in your bags using this priority order:

1. Buff food preferred (when Buff Food is enabled and Well Fed is missing)
2. Percentage-based items preferred over flat values
3. Highest restore value wins
4. Lowest vendor sell price breaks ties (use up cheap items first)
5. Hybrid food+water items preferred or avoided depending on the slot
6. Fewest total in bags breaks the final tie

Items are filtered out if you don't meet the level requirement, lack the required profession skill (First Aid for bandages, Alchemy for certain potions), or are in the wrong zone.

### Class Features

**Mages** can right-click Food, Water, or Mana Gem macros to conjure items. Middle-click casts Ritual of Refreshment. Targeting a lower-level friendly player auto-selects the appropriate conjure rank.

<img width="300" src="https://github.com/user-attachments/assets/4a4cd1b4-d227-4731-8988-36f505611883" />

**Warlocks** can right-click Healthstone or Soulstone macros to create them. Middle-click casts Ritual of Souls.

**Hunters** get an all-in-one `- Feed Pet` macro. Left-click feeds your pet the cheapest food that still gives max happiness. Right-click or entering combat casts Mend Pet. Shift forces Revive Pet. Ctrl dismisses. If your pet is dead but dismissed, it auto-switches to Revive Pet.

<img width="300" src="https://github.com/user-attachments/assets/6ced7fae-f0bf-48f0-b317-b382e11a3bc1" />

**Night Elves** can enable Shadowmeld Drinking, which appends Shadowmeld to the Water macro so you stealth while drinking.

### Settings

Type `/foodie` or open **Options > AddOns > Connoisseur** to configure the add-on.

<img width="800" src="https://github.com/user-attachments/assets/c0e8e916-b3b9-4ce1-a5ff-d4b023a8ee20" />

**Prioritize Buff Food** // The Food macro prefers items that grant the Well Fed buff, but only when you don't already have it. Can be restricted to party or raid only.

**Scroll Buffs** // Your `- Food` macro doubles as a scroll-buff button. When you're missing scroll buffs, the macro turns into a dedicated scroll-applier — one tap fires every missing scroll on you, off the global cooldown, then flips back to food on the next press. Scrolls always target you, are skipped when a class buff already covers the same stat at equal or greater value, and the macro reverts to food mode immediately when you target a friendly player so it stays safe for Mages conjuring for friends. Firing order: Agility, Strength, Protection, Intellect, Spirit, Stamina.

**Pet Food Buffs** // Uses Kibler's Bits or Sporeling Snacks on your pet when its Well Fed buff is missing. Requires level 55+. Can be restricted to party or raid. Pet food only fires in food mode — if you're missing scroll buffs, scrolls go first.

**Ignore List** // Tell Connoisseur to skip an item it's currently picking. Right-click the minimap button to add the current best food. Middle-click to clear the list. Also clearable from the settings panel.

## Testing & Localization Status

🟢 World of Warcraft Classic (🟡 Season of Discovery) // WoW 1.15.8

🟢 Burning Crusade Anniversary // WoW 2.5.5

🔴 Mists of Pandaria Classic // WoW 5.5.3

🔴 World of Warcraft // WoW 12.0.5

**Localization Status** // Works with all Classic WoW Locales (enUS, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW).

Please reach out if you would like to be involved!

## Links

* [CurseForge](https://www.curseforge.com/wow/addons/consumable-connoisseur)
* [GitHub](https://github.com/Gogo1951/Consumable-Connoisseur)
* [Discord](https://discord.gg/eh8hKq992Q)

## Related Add-ons

🟢 Pairs With // kvakvs's [Buffomat Classic](https://www.curseforge.com/wow/addons/buffomat-classic)

🟢 Pairs With // Pupp3h's [Buffwatch Classic](https://www.curseforge.com/wow/addons/buffwatch-classic)

🟢 Pairs With // ForsakenNGS's [DruidMacroHelper](https://www.curseforge.com/wow/addons/druidmacrohelper)

🟢 Pairs With // ykiigor's [Method Raid Tools](https://www.curseforge.com/wow/addons/method-raid-tools)

🟢 Pairs With // oscarucb's [RaidBuffStatus](https://www.curseforge.com/wow/addons/raidbuffstatus)

🟢 Pairs With // kvakvs's [Restocker Classic](https://www.curseforge.com/wow/addons/restocker-classic)

🟡 Some Overlap // Galeina's [Consumable Checker](https://www.curseforge.com/wow/addons/consumable-checker)

🟡 Some Overlap // aeldra_'s [SmartBuff (Classic)](https://www.curseforge.com/wow/addons/smartbuff-classic)

🔴 Direct Alternative // ollidiemaus's [Auto Potion](https://www.curseforge.com/wow/addons/auto-potion)

🔴 Direct Alternative // ayjaycoding's [Automated Eat Drink Macro Changer](https://www.curseforge.com/wow/addons/automated-eat-drink-macro-changer)

🔴 Direct Alternative // mZHg's [Buffet](https://www.curseforge.com/wow/addons/buffet)

🔴 Direct Alternative // funki's [DrinkBot](https://www.curseforge.com/wow/addons/drinkbot)

🔴 Direct Alternative // FubarVS's [Eat Drink AI](https://www.curseforge.com/wow/addons/eatdrinkai)

🔴 Direct Alternative // executedpoorly's [Feed Me](https://www.curseforge.com/wow/addons/feed-me)

🔴 Direct Alternative // Gazmik Fizzwidget's [Feed-O-Matic](https://www.wowinterface.com/downloads/info4160-FizzwidgetFeed-O-Matic.html)

🔴 Direct Alternative // Aryax's [Well Feed](https://www.curseforge.com/wow/addons/well-feed)
