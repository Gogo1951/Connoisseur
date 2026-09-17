# Connoisseur & Restocker

Macros that automatically use your best food, buff food, water, potions, healthstones, bandages, and scrolls, plus a Restock List that keeps your bags full and upgrades your consumables as you level. Quality-of-life automation for peak performance.

**TL;DR:** Set it up once and stop thinking about consumables. Connoisseur picks the best items in your bags, while Restocker keeps everything stocked and upgraded as you level. Your bars stay smart, your bags stay ready, and you stay focused on the fight.

![Consumable-Connoisseur](https://github.com/user-attachments/assets/326eb93f-329f-4967-b750-909011a05b01)

## Features

🧞‍♂️ **Always the Best Item** // Automatically use your best food, water, potions, bandages, healthstones, mana gems, and explosives. Connoisseur adapts to what's in your bags and always picks the best item available.

🛒 **Restocker, Revisited** // Keep your essentials in your bags without making trips to town. Restocker buys what you need, pulls it from the bank, stores surplus, and automatically upgrades your food, water, ammo, poisons, potions, and class reagents as you level, so your restock list always keeps pace with you.

🎯 **Class-Smart Macros** // Mages and Warlocks can conjure food, water, mana gems, healthstones, and soulstones directly from their macros, with ranks matched to your target. Hunters get an all-in-one pet button for feeding, healing, reviving, and dismissing, while Rogues can apply both weapon poisons from a single macro.

✅ **Readiness Report** // Know you're ready before anyone has to ask. When a ready check starts, Connoisseur privately tells you which consumables or other essentials you're missing, so you can fix them before the pull.

🧠 **Smart Automation** // Spend less time managing consumables and more time playing. Connoisseur handles the small but constant jobs that get in the way, from choosing the right consumable to keeping your bags stocked, upgrading your supplies, and handling class-specific chores. Set it up once and stay focused on the fight.

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/consumable-connoisseur) or [Wago](https://addons.wago.io/addons/connoisseur).
2. Log in. Connoisseur scans your bags and creates its macros in your General macro tab.
3. Drag the dash-prefixed macros (`- Food`, `- Water`, `- Health Potion`, and the rest) onto your action bars.
4. Optional: type `/foodie` to choose which macros exist and tune buff food, scrolls, pet food, and your class options.
5. From level 6, tick your staples in the List Builder when it appears at login, or type `/crs` any time to build your Restock List.
6. *"Luck favors the prepared, darling."*

## How It Works

### Macros Created

| Macro | Uses |
| --- | --- |
| `- Food` | Best food, plus optional buff food, scroll buffs, and pet buff food |
| `- Water` | Best drink |
| `- Health Potion` | Best healing potion, optionally with your best Healthstone stacked underneath |
| `- Mana Potion` | Best mana potion |
| `- Healthstone` | Best Healthstone |
| `- Mana Gem` | Best Mana Gem, optionally ranked alongside Demonic and Dark Runes |
| `- Soulstone` | Best Soulstone |
| `- Bandage` | Best bandage your First Aid skill allows |
| `- Explosives` | Hardest-hitting bomb, grenade, or sapper your Engineering skill allows, with Ez-Thro Dynamite open to everyone |
| `- Feed Pet` | All-in-one pet button (Hunters only) |
| `- Poisons` | Poisons for both weapons from one button (Rogues only) |

**How it picks.** Connoisseur ranks every usable item in your bags:

- A percentage restore beats a flat one, then the biggest restore wins.
- Buff food jumps the queue when Buff Food is on and you're missing Well Fed.
- Ties go to whatever loses its worth soonest: conjured items first, then items that only work in one zone, then soulbound ones, then whatever vendors for least.
- Anything you can't use is filtered out, whether that's a level requirement, a missing profession skill, or the wrong zone.
- Inside a PvP Arena, where the game blocks ordinary food and drink, only conjured items and the arena's own drinks are offered.
- Macros can't be edited in combat, so the Potion and Healthstone macros carry your best item plus up to two fallbacks. On a long fight the icon can go stale, but a press still uses the best item in your bags.

### Restocker

- **Build your list in ten seconds.** From level 6, the List Builder appears at login while your Restock List is empty. Tick the staples you carry (food, water, ammo, poisons, class reagents, even your Hearthstone), pick how many stacks of each, and you're done. After that, `/crs` opens the Restocker window any time, and you can drop in anything else from your bags.
- **Your list levels with you.** Food, water, ammo, poisons, potions, and class reagents climb their upgrade paths as you level, and every swap is announced in chat. Refreshing Spring Water becomes Ice Cold Milk at 5, Melon Juice at 15, Sweet Nectar at 25, and so on. Anything above your level, or without an upgrade path, stays exactly where you put it.
- **Rogues get a bonus.** Put the finished poison on your list and its ingredients buy themselves at any merchant that stocks them all.
- **Reminders** speak up when you reach an inn or a city short of something, or when you close a merchant or the bank with orders still outstanding. Pick one line or item by item, with an optional alert sound for busy chat.
- **Named lists** let a character switch loadouts or share one with an alt. Copy, rename, and delete all live in the window.
- **Hold Shift** while opening the bank to skip restocking for that visit.

Every row carries its own toggles:

| Toggle | What It Does |
| --- | --- |
| **Buy** | Buys the shortfall while a merchant window is open |
| **Extra** | Buys a merchant's whole limited stock, the few-at-a-time goods they slowly restock, even past your target |
| **Take** | Takes what you're short from the bank |
| **Store** | Stores the surplus in the bank, or all of it with an Amount of 0 |
| **Rep** | Skips merchants below the standing you pick, which also cuts the price: Friendly 5% off, up to Exalted 20% |
| **Upgrade** | Lets the row climb its upgrade path as you level. Untick it to keep that exact item |

<img width="600" src="https://github.com/user-attachments/assets/c90aab80-cc69-49ba-86b0-a38ac44a7276" />

<img width="500" src="https://github.com/user-attachments/assets/476c78a5-f1d8-4d1d-b40e-0dd650add8f0" />

### Class Features

- **Mages** // Right-Click Food or Water to conjure more, or Middle-Click either one for Ritual of Refreshment. Right-Click Mana Gem to conjure a gem, and again for a lower-rank backup. Targeting a lower-level player conjures food or water they can use.

<img src="https://github.com/user-attachments/assets/4a4cd1b4-d227-4731-8988-36f505611883" width="260">

- **Warlocks** // Right-Click Healthstone to create one, and again for a lower-rank backup, or Middle-Click it for Ritual of Souls. Right-Click Soulstone to create one. Targeting a lower-level player makes a Healthstone sized for them.
- **Hunters** // `- Feed Pet` is an all-in-one pet button. Left-Click calls, feeds, or revives your pet, feeding it the lowest-level food that still gives full happiness. Right-Click, or click during combat, to cast Mend Pet. Hold Shift to force Revive, or Ctrl to Dismiss.

<img src="https://github.com/user-attachments/assets/6ced7fae-f0bf-48f0-b317-b382e11a3bc1" width="260">

- **Rogues** // Left-Click `- Poisons` for your Off Hand, Right-Click for your Main Hand, or Middle-Click to open the Poisons window. Pick each hand's poison in the options, and old poisons are replaced automatically. Stealth Eating slips you into Stealth while you snack.
- **Druids** // With DruidMacroHelper integration on, your Health Potion, Mana Potion, and Healthstone macros powershift you out of form, use the item, and put you back in Bear or Cat.
- **Night Elves** // Stealth Drinking and Stealth Eating add Shadowmeld to the Water or Food macro. Pick one, since eating or drinking after you stealth breaks it.

### Mini-Map Button

- Hover for the state of Buff Food and Scroll Buffs, your current best food, this character's Ignore List, tips for your class, and a Restocker Report of what's still short.
- The icon changes to match your current best food.

| Action | Effect |
| --- | --- |
| Left-Click | Toggle Buff Food |
| Shift + Left-Click | Toggle Scroll Buffs |
| Right-Click | Ignore your current best food |
| Middle-Click | Clear this character's Ignore List |
| Shift + Middle-Click | Open the Options Interface |

<img src="https://github.com/user-attachments/assets/c57060c0-4eee-44ab-af88-48e077d886cc" width="260">

### Options

Type `/foodie` to open the Options Interface, also found under **Options > AddOns > Connoisseur**, or `/crs` to open the Restocker window.

- **Connoisseur** // The welcome message, the mini-map button, the `/foodie` and `/crs` commands, and where to reach the author.
- **Macros** // Which macros exist and how each one picks: buff food, scroll buffs, buff re-application, pet food buffs, Healthstone stacking, Demonic and Dark Runes, explosive clicks, and the class options. Connoisseur hides macro names on your action buttons unless you switch them back on here.
- **Ignore List** // Items no macro will ever offer, on the Global list for every character or on one character's own list.
- **Restocker** // Reminders and how much they say, the alert sound, opening the window at a bank or merchant, and the List Builder.
- **Readiness Report** // What a ready check reports on. It ships switched off, so turn it on to use it.
- **Profiles** // Copy one character's setup onto another, or reset one back to defaults.
- **Diagnostic Tools** // Read-only probes to paste into a bug report.

Most settings are per character, so your raiding 60 and your level-15 alt keep their own consumable choices. Which macros exist, the Readiness Report, and your Restock Lists are account-wide.

<img src="https://github.com/user-attachments/assets/c0e8e916-b3b9-4ce1-a5ff-d4b023a8ee20" width="800">

## Testing & Localization Status

🟢 World of Warcraft Classic (🟡 Season of Discovery) // WoW 1.15.9

🟢 Burning Crusade Anniversary // WoW 2.5.6

🔴 Mists of Pandaria Classic // WoW 5.5.4

🔴 World of Warcraft // WoW 12.1.0

**Localization Status** // Works with all Classic WoW Locales (enUS, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW).

Please reach out if you would like to be involved!

## Links

- [GitHub](https://github.com/Gogo1951/Connoisseur)
- [Discord](https://discord.gg/eh8hKq992Q)

## Appreciation & History

🚀 **This add-on stands on the shoulders of those that came before.**

- kvakvs's [Restocker Classic](https://www.curseforge.com/wow/addons/restocker-classic)
- guardycmw's [Restocker (MoP)](https://www.curseforge.com/wow/addons/restocker-mop)

## Related Add-ons

🟢 Pairs With // ForsakenNGS's [DruidMacroHelper](https://www.curseforge.com/wow/addons/druidmacrohelper)

🟢 Pairs With // Gogo1951's [Magic Eraser](https://www.curseforge.com/wow/addons/magic-eraser)

🟢 Pairs With // ykiigor's [Method Raid Tools](https://www.curseforge.com/wow/addons/method-raid-tools)

🟢 Pairs With // Gogo1951's [Play It Forward](https://www.curseforge.com/wow/addons/play-it-forward)

🟢 Pairs With // Gogo1951's [Water Dispenser](https://www.curseforge.com/wow/addons/water-dispenser-revisited)

🟡 Some Overlap // Kemayo's [BankStack](https://www.curseforge.com/wow/addons/bank-stack)

🟡 Some Overlap // kvakvs's [Buffomat Classic](https://www.curseforge.com/wow/addons/buffomat-classic)

🟡 Some Overlap // Pupp3h's [Buffwatch Classic](https://www.curseforge.com/wow/addons/buffwatch-classic)

🟡 Some Overlap // lanscetre's [Necrosis](https://www.curseforge.com/wow/addons/necrosis-tbc-classic-bcc)

🟡 Some Overlap // Venomisto's [Nova Consumes Helper](https://www.curseforge.com/wow/addons/nova-consumes-helper)

🔴 Direct Alternative // ollidiemaus's [Auto Potion](https://www.curseforge.com/wow/addons/auto-potion)

🔴 Direct Alternative // MuffinManKen's [AutoBar Classic](https://www.curseforge.com/wow/addons/autobar-classic)

🔴 Direct Alternative // mZHg's [Buffet](https://www.curseforge.com/wow/addons/buffet)

🔴 Direct Alternative // executedpoorly's [Feed Me](https://www.curseforge.com/wow/addons/feed-me)

🔴 Direct Alternative // humfras's [Poisoner](https://www.curseforge.com/wow/addons/poisoner)
