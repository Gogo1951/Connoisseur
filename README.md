# Connoisseur & Restocker

Macros that automatically use your best food, buff food, water, potions, healthstones, bandages, and scrolls, plus a Restock List that keeps your bags full and upgrades your consumables as you level. Quality-of-life automation for peak performance.

**TL;DR:** Be raid ready without thinking about your consumables. Connoisseur picks the best items in your bags, while Restocker keeps your essentials stocked and upgraded so you're always prepared for the next pull.

![Consumable-Connoisseur](https://github.com/user-attachments/assets/326eb93f-329f-4967-b750-909011a05b01)

## Features

🧞‍♂️ **Auto-Updating Macros** // Always use your best food, water, potions, bandages, healthstones, mana gems, and explosives. Connoisseur automatically adapts to what you have in your bags and always uses the best item available.

🛒 **Restocker, Revisited** // Keep your essentials in your bags without making trips to town. Restocker buys what you need, pulls it from the bank, stores surplus, and automatically upgrades your food, water, ammo, poisons, potions, and class reagents as you level, so your restock list always keeps pace with you.

🎯 **Class-Smart Macros** // Mages and Warlocks can conjure food, water, mana gems, healthstones, and soulstones directly from their macros, with ranks matched to your target. Hunters get an all-in-one pet button for feeding, healing, reviving, and dismissing, while Rogues can apply both weapon poisons from a single macro.

✅ **Readiness Report** // Know you're ready before anyone has to ask. When a ready check starts, Connoisseur privately tells you which consumables or other essentials you're missing, so you can fix them before the pull.

🧠 **Smart Automation** // Spend less time managing consumables and more time playing. Connoisseur handles the small but constant jobs that get in the way, from choosing the right consumable to keeping your bags stocked, upgrading your supplies, and handling class-specific chores. Set it up once and stay focused on the fight.

## Setup

1.  Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/consumable-connoisseur) or [Wago](https://addons.wago.io/addons/connoisseur).
2.  Log in. Connoisseur scans your bags and creates macros in your General macro tab.
3.  Drag the dash-prefixed macros (`- Food`, `- Water`, `- Health Potion`, etc.) onto your action bars.
4.  Optional: type `/foodie` to fine-tune scroll buffs, buff food, pet food, and class options.
5.  From level 6, tick your staples in the List Builder when it offers itself, or type `/crs` any time to build the list yourself.
6.  *"Luck favors the prepared, darling."*

## How It Works

### Macros Created

| Macro Name | Category |
| --- | --- |
| `- Food` | Best food, with optional buff food, scroll stacking, and pet buff food |
| `- Water` | Best drink |
| `- Health Potion` | Best healing potion, optionally with your best Healthstone stacked underneath |
| `- Mana Potion` | Best mana potion |
| `- Bandage` | Best bandage (requires First Aid skill) |
| `- Explosives` | Highest-damage bomb, grenade, or sapper (requires Engineering skill; Ez-Thro usable by anyone) |
| `- Feed Pet` | All-in-one pet button (Hunter only) |
| `- Healthstone` | Best Healthstone in your bags. Warlocks can also create one from the macro |
| `- Mana Gem` | Best Mana Gem. Mages can also conjure one from the macro |
| `- Poisons` | Dual-hand poison applier (Rogue only) |
| `- Soulstone` | Best Soulstone. Warlocks can also create one from the macro |

**How it picks.** For every category, Connoisseur ranks each usable item in your bags:

- Highest restore value wins, and a percentage restore beats a flat one.
- Buff food jumps the queue when Buff Food is on and Well Fed is missing.
- Ties go to whatever loses its worth soonest: conjured items first, then items that only work in one zone, then soulbound ones, then whatever vendors for least.
- Anything you can't actually use is filtered out entirely, whether that's a level requirement, a missing profession skill, or the wrong zone. Inside a PvP Arena, where the game blocks ordinary food and drink, only conjured items and the arena's own drinks are offered.

The game forbids editing a macro in combat, so your Potion and Healthstone macros are pre-built with your best item plus up to two fallbacks. On a long fight the icon and tooltip can go stale, but the press still uses the best item actually in your bags.

### Restocker

**Building the list takes about ten seconds.** From level 6, Connoisseur offers you a List Builder at login whenever your Restock List is empty. Tick the staples you actually carry (bread, water, arrows, poisons, your class reagents, even your Hearthstone), pick how many stacks of each, and close the window. Bread comes pre-ticked for everyone, water for the mana classes, meat for hunters. After that, `/crs` opens the list any time, and you can drop anything else in straight from your bags.

**Your list grows with you.** Food, water, ammo, poisons, potions, and class reagents all follow clean upgrade paths, and Connoisseur walks your list up them without being asked. Refreshing Spring Water at level 1 becomes Ice Cold Milk at 5, Melon Juice at 15, Sweet Nectar at 25, Moonberry Juice at 35, Morning Glory Dew at 45. Every swap is announced in chat, so you know exactly what changed. It only ever moves forward: an item above your level is left alone, because you meant to stock it, and anything without an upgrade path stays exactly where you put it.

**Every row carries its own toggles**, so one list runs your whole consumable logistics chain:

| Toggle | What it does |
| --- | --- |
| **Buy** | Buys the shortfall while the merchant window is open |
| **Extra** | Empties a vendor's limited stock, the few-at-a-time goods they trickle back. Unlimited supply is ignored |
| **Take** | Withdraws what you're short of from the bank |
| **Store** | Deposits the surplus into the bank. An Amount of 0 stores all of it |
| **Rep** | Skips vendors you haven't reached a standing with, since standing also cuts the price: Friendly 5% off, Exalted 20% |
| **Upgrade** | Lets this row climb its upgrade path as you level, for when you'd rather drive the rest yourself |

**Rogues get a bonus.** Put the finished poison on your list and the ingredients buy themselves at any vendor that stocks them all.

Restocker never sells anything. A surplus goes to your bank if you've asked it to, and is otherwise left alone. The window can open itself when you reach a bank or a merchant, and optional reminders speak up when you hit an inn or a city short of something, or report what's still outstanding as you close a merchant or the bank. Reminders come simple or itemised, with an alert sound available for when chat is busy.

Lists are named, so a character can switch between them or share one with an alt, and copy, rename, and delete all live in the window. Handy for raid-night versus farming loadouts.

This feature started life as a separate add-on. Connoisseur ships an updated version with bug fixes and UX improvements that couldn't get rolled into the upstream builds. See History below.

<img width="600" src="https://github.com/user-attachments/assets/c90aab80-cc69-49ba-86b0-a38ac44a7276" />

<img width="500" src="https://github.com/user-attachments/assets/476c78a5-f1d8-4d1d-b40e-0dd650add8f0" />

### Class Features

**Mages** can right-click Food, Water, or Mana Gem macros to conjure items, and right-click the Mana Gem again for a lower-rank backup. Middle-click Food or Water to cast Ritual of Refreshment. Targeting a lower-level friendly player conjures Food or Water at a rank they can actually use.

<img src="https://github.com/user-attachments/assets/4a4cd1b4-d227-4731-8988-36f505611883" width="260">

**Warlocks** can right-click Healthstone or Soulstone macros to create them, and right-click Healthstone again for a lower-rank backup. Middle-click Healthstone to cast Ritual of Souls. Targeting a lower-level friendly player makes a stone sized for them.

**Hunters** get an all-in-one `- Feed Pet` macro. Left-click feeds your pet the lowest-level food that still gives full happiness. Right-click or entering combat casts Mend Pet. Shift forces Revive Pet. Ctrl dismisses. If your pet is dead but dismissed, it auto-switches to Revive Pet.

<img src="https://github.com/user-attachments/assets/6ced7fae-f0bf-48f0-b317-b382e11a3bc1" width="260">

**Rogues** get a `- Poisons` macro: left-click poisons your Off Hand, right-click your Main Hand, middle-click opens the Poisons window. Pick a poison type per hand in the options, and existing poisons are replaced automatically. Rogues can also enable Stealth Eating, which stealths you while you snack.

**Druids** can enable DruidMacroHelper integration, which builds powershifting macros for Health Potions, Mana Potions, and Healthstones, returning you to Bear or Cat afterwards.

**Night Elves** can enable Stealth Drinking and Stealth Eating, which append Shadowmeld to the Water or Food macro so you vanish while you refresh. Pick one, because eating or drinking after you stealth breaks your stealth.

### Mini-Map Button

Hover for a tooltip showing the current state of every feature, your best food, your ignore list, class-specific tips, and a Restocker Report counting how many restocking orders are still outstanding. The icon updates to match your current best food.

| Action | Effect |
| ------ | ------ |
| Left-click | Toggle Buff Food priority |
| Shift + Left-click | Toggle Scroll Buffs |
| Right-click | Ignore current best food |
| Middle-click | Clear ignore list |
| Shift + Middle-click | Open Connoisseur options |

Right-click and Middle-click act on this character's own ignore list. The account-wide Global list is edited from the options panel.

<img src="https://github.com/user-attachments/assets/c57060c0-4eee-44ab-af88-48e077d886cc" width="260">

### Options

Type `/foodie` to open the options, or `/crs` to open the Restocker window. The options also live under **Options > AddOns > Connoisseur**.

- **Macros** // Which macros get built, and how each one picks its item: buff food, scroll buffs, buff re-application, pet food, explosives, poisons, and the class options.
- **Ignore List** // Items no macro will ever offer again, per character or account-wide.
- **Restocker** // Reminders, opening at the bank or a merchant, and the List Builder.
- **Readiness Report** // What Connoisseur checks when a ready check starts. Ships switched off, so turn it on to use it.
- **Profiles** // Copy one character's setup onto another, or reset one back to defaults.

Most settings are per character, so your raiding 60 and your level-15 alt each keep their own consumable choices. The macros themselves, the Readiness Report, and your Restock Lists are account-wide.

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

## History

👾 **I didn't create this add-on, I just updated it.**

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

🟡 Some Overlap // humfras's [Poisoner](https://www.curseforge.com/wow/addons/poisoner)

🟡 Some Overlap // zac12's [Readycheck](https://www.curseforge.com/wow/addons/ready-check)

🔴 Direct Alternative // ollidiemaus's [Auto Potion](https://www.curseforge.com/wow/addons/auto-potion)

🔴 Direct Alternative // DetectivePyralis's [AutoShop](https://www.curseforge.com/wow/addons/autoshop)

🔴 Direct Alternative // mZHg's [Buffet](https://www.curseforge.com/wow/addons/buffet)

🔴 Direct Alternative // executedpoorly's [Feed Me](https://www.curseforge.com/wow/addons/feed-me)

🔴 Direct Alternative // noobsgonewild's [FeedPetPlusMacro TBC](https://www.curseforge.com/wow/addons/feedpetplusmacro-tbc)
