# Connoisseur

Macros that automatically use your best food, buff food, water, potions, healthstones, bandages, and scrolls, plus a Restock List that keeps your bags full and upgrades your consumables as you level. Quality of life automation, peak performance.

![Consumable-Connoisseur](https://github.com/user-attachments/assets/326eb93f-329f-4967-b750-909011a05b01)

## Features

🧞‍♂️ **Auto-Updating Macros** // Always picks your best food, water, potions, healthstones, mana gems, bandages, and explosives — rescans your bags whenever loot, level, or zone changes.

🛒 **A Restock List That Grows With You** // Tick your staples once and Connoisseur runs the errands forever: buys from vendors, moves items to and from the bank, and steps your food, water, ammo, poisons, and potions up a tier every time you outlevel them. It never sells anything. Type `/crs`.

🎯 **Smart Conjuring** // Mages and Warlocks right-click their food, water, healthstone, or soulstone macros to conjure the item on the spot. Middle-click casts Ritual of Refreshment (Mage) or Ritual of Souls (Warlock) for the whole group. The rank auto-matches your target, so a lower-level friend always gets something they can actually use.

🦄 **Class Buttons** // Hunters get an all-in-one `- Feed Pet` macro that calls, feeds, mends, revives, and dismisses from a single button. Rogues get a dual-hand `- Poisons` applier. Druids can enable DruidMacroHelper powershifting. Night Elves and Rogues can stealth while eating or drinking.

📜 **Raid-Ready Buffs** // When you're missing scroll buffs, your Food macro turns into a one-tap scroll applier. Buffs about to fall off count as already gone, so you top up before the pull instead of ten seconds into it — and every ready check prints exactly what you're still missing, where only you can see it.

## Setup

1.  Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/consumable-connoisseur) or [Wago](https://addons.wago.io/addons/connoisseur).
2.  Log in. Connoisseur scans your bags and creates macros in your General macro tab.
3.  Drag the dash-prefixed macros (`- Food`, `- Water`, `- Health Potion`, etc.) onto your action bars.
4.  Optional: type `/foodie` to fine-tune scroll buffs, buff food, pet food, and class options.
5.  Around level 6, tick your staples in the Restock List window when it offers itself — or type `/crs` any time to build the list yourself.
6.  Connoisseur // Never miss a meal! Breakfast, second breakfast, elevenses, luncheon, afternoon tea, dinner, supper… (=

## How It Works

### Macros Created

| Macro Name      |Category                                                                |
| --------------- |----------------------------------------------------------------------- |
| <code>- Food</code> |Best food (with optional buff food, scroll stacking, and pet buff food) |
| <code>- Water</code> |Best drink                                                              |
| <code>- Health Potion</code> |Best healing potion (optionally with your best Healthstone stacked underneath) |
| <code>- Mana Potion</code> |Best mana potion                                                        |
| <code>- Bandage</code> |Best bandage (requires First Aid skill)                                 |
| <code>- Explosives</code> |Highest-damage bomb, grenade, or sapper (requires Engineering skill; Ez-Thro usable by anyone) |
| <code>- Feed Pet</code> |All-in-one pet button (Hunter only)                                     |
| <code>- Healthstone</code> |Best Healthstone (Warlock)                                              |
| <code>- Mana Gem</code> |Best Mana Gem (Mage)                                                    |
| <code>- Poisons</code> |Dual-hand poison applier (Rogue only)                                   |
| <code>- Soulstone</code> |Best Soulstone (Warlock)                                                |

### Slash Commands

| Command | Effect |
| ------- | ------ |
| `/foodie` | Opens the Connoisseur options interface |
| `/crs` | Opens the Restocker window to manage your Restock List |

### Minimap Button

Hover for a tooltip showing the current state of every feature, your best food, the ignore list, and class-specific tips. The icon updates to match your current best food.

| Action             |Effect                    |
| ------------------ |------------------------- |
| Left-click         |Toggle Buff Food priority |
| Shift + Left-click |Toggle Scroll Buffs       |
| Right-click        |Ignore current best food  |
| Middle-click       |Clear ignore list         |
| Shift + Middle-click |Open Connoisseur options |

<img src="https://github.com/user-attachments/assets/c57060c0-4eee-44ab-af88-48e077d886cc" width="260">

### Item Selection Priority

For each consumable category, Connoisseur compares every usable item in your bags using this priority order:

1.  Buff food preferred (when Buff Food is enabled and Well Fed is missing)
2.  Percentage-based items preferred over flat values
3.  Highest restore value wins
4.  Free conjured items beat purchased items of equal value
5.  Lowest vendor sell price breaks ties (use up cheap items first)
6.  Hybrid food+water items preferred or avoided depending on the slot
7.  Fewest total in bags breaks the final tie

Items are filtered out if you don't meet the level requirement, lack the required profession skill (First Aid for bandages, Alchemy for certain potions, Engineering for explosives), require an engineering specialization you haven't learned (Goblin Engineer), or are in the wrong zone. Explosives are ranked by their minimum damage.

### Connoisseur Restocker

**Building the list takes about ten seconds.** Around level 6, Connoisseur offers you a starter list: tick the staples you actually carry — bread, water, arrows, poisons, your class reagents, even your Hearthstone — pick how many stacks of each, and close the window. Bread comes pre-ticked for everyone, water for the mana classes, meat for hunters. After that, `/crs` opens the list any time, and you can drag anything else in straight from your bags.

**Your list grows with you.** Food, water, ammo, poisons, and potions all follow clean upgrade paths as you level, and Connoisseur walks your list up them without being asked. Refreshing Spring Water at level 1 becomes Ice Cold Milk at 5, Melon Juice at 15, Sweet Nectar at 25, Moonberry Juice at 35, Morning Glory Dew at 45. You never open the window to do it, and every swap is announced in chat so you know exactly what changed. It only ever moves forward — an item above your level is left alone, because you meant to stock it — and anything without an upgrade path stays exactly where you put it. Each row has its own **Automatic** toggle if you'd rather drive one yourself.

**At a vendor**, Connoisseur buys you back up to your target, with an optional reputation requirement per item since better standing means better prices. Rogues get a bonus here: put the finished poison on your list and the ingredients buy themselves at any vendor that stocks them.

**At the bank**, it tops your bags up from your stash and deposits the extra. Each item carries its own Withdraw, Deposit, and Buy toggles, so one list runs your whole consumable logistics chain.

Restocker never sells anything — too many of an item is left untouched. The window can open itself when you reach a bank or a merchant, and optional reminders speak up when you hit an inn or a city short of something, so the errands run without you thinking about them.

Every character keeps its own list, and you can copy, rename, or delete profiles right from the window — handy for raid-night versus farming loadouts.

This feature started life as a separate add-on: Connoisseur ships an updated version with bug fixes and UX improvements that couldn't get rolled into the upstream builds — see History below.

<img width="550" src="https://github.com/user-attachments/assets/c84a532b-28b2-42f3-9af7-24c3b4f371dc" />

### Class Features

**Mages** can right-click Food, Water, or Mana Gem macros to conjure items. Middle-click casts Ritual of Refreshment. Targeting a lower-level friendly player auto-selects the appropriate conjure rank.

<img src="https://github.com/user-attachments/assets/4a4cd1b4-d227-4731-8988-36f505611883" width="260">

**Warlocks** can right-click Healthstone or Soulstone macros to create them. Middle-click casts Ritual of Souls.

**Hunters** get an all-in-one `- Feed Pet` macro. Left-click feeds your pet the cheapest food that still gives max happiness. Right-click or entering combat casts Mend Pet. Shift forces Revive Pet. Ctrl dismisses. If your pet is dead but dismissed, it auto-switches to Revive Pet.

<img src="https://github.com/user-attachments/assets/6ced7fae-f0bf-48f0-b317-b382e11a3bc1" width="260">

**Rogues** get a `- Poisons` macro: left-click poisons your Off Hand, right-click your Main Hand, middle-click opens the poison crafting window. Pick a poison type per hand in the options, and existing poisons are replaced automatically. Rogues can also enable Stealth Eating, which stealths you while you snack.

**Night Elves** can enable Stealth Drinking and Stealth Eating, which append Shadowmeld to the Water or Food macro so you vanish while you refresh. Pick one — eating or drinking after you stealth breaks your stealth.

### Settings

Type `/foodie` or open **Options > AddOns > Connoisseur** to configure the add-on.

Settings are **per character**, so your raiding 60 and your level-15 alt each keep their own consumable choices — buff food, scrolls, pet food, poisons, and the rest. The **Profiles** tab lets you copy a setup from one character to another, or reset one back to defaults.

Five options stay account-wide: the welcome message, the minimap button, macro names on buttons, **Ready Check**, and **Enable Macros**. Ready Check is a behaviour preference — whether Connoisseur speaks up at all — so you answer it once, though what it reports on still follows each character's own settings. Enable Macros is shared because the macros themselves are: they live in your General macro tab, which every character shares, so turning one off removes it everywhere. Switching characters never adds or removes a macro; it just rewrites the bodies to that character's best items.

<img src="https://github.com/user-attachments/assets/c0e8e916-b3b9-4ce1-a5ff-d4b023a8ee20" width="800">

**Prioritize Buff Food** // The Food macro prefers items that grant the Well Fed buff, but only when you don't already have it. Can be restricted to party or raid only.

**Scroll Buffs** // Your `- Food` macro doubles as a scroll-buff button. When you're missing scroll buffs, the macro turns into a dedicated scroll-applier — one tap fires every missing scroll on you, off the global cooldown, then flips back to food on the next press. Scrolls always target you, are skipped when a class buff already covers the same stat at equal or greater value, and the macro reverts to food mode immediately when you target a friendly player so it stays safe for Mages conjuring for friends. Firing order: Agility, Strength, Protection, Intellect, Spirit, Stamina.

**Buff Re-Application** // Fights outlast buffs. Set a threshold and anything with less time left counts as already expired, so your macros offer a fresh one before the pull rather than halfway through the fight. Applies to Buff Food, Scroll Buffs, and Pet Food Buffs.

**Ready Check** // When a ready check starts, Connoisseur prints what you're still missing and how long your tracked buffs have left. Only you see it — nothing is ever sent to group chat. It reports only what you can fix in those few seconds: Well Fed, scrolls, pet food, and a Healthstone when there's a Warlock around to ask.

**Combine Healthstones** // Adds your best Healthstone to the bottom of the Health Potion macro, so one press uses a potion and a stone.

**Explosives** // Choose the click layout for the `- Explosives` macro. The `@player` option skips the targeting reticle and sets the explosive off right at your feet — ideal when your target is in melee range — while Toss uses the normal targeting reticle. Default: Left-Click @Player, Right-Click Toss. (Keybind presses count as left-click.)

**Pet Food Buffs** // Uses Kibler's Bits or Sporeling Snacks on your pet when its Well Fed buff is missing. Requires level 55+. Can be restricted to party or raid. Pet food only fires in food mode — if you're missing scroll buffs, scrolls go first.

**Ignore List** // Tell Connoisseur to skip an item it's currently picking. Right-click the minimap button to add the current best food. Middle-click to clear the list. Also clearable from the settings panel.

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

- ChiliFajita's [Auto Restocker](https://www.curseforge.com/wow/addons/autorestocker)
- kvakvs's [Restocker Classic](https://www.curseforge.com/wow/addons/restocker-classic)
- guardycmw's [Restocker (MoP)](https://www.curseforge.com/wow/addons/restocker-mop)

## Related Add-ons

🟢 Pairs With // ForsakenNGS's [DruidMacroHelper](https://www.curseforge.com/wow/addons/druidmacrohelper)

🟢 Pairs With // Gogo1951's [Magic Eraser](https://www.curseforge.com/wow/addons/magic-eraser)

🟢 Pairs With // ykiigor's [Method Raid Tools](https://www.curseforge.com/wow/addons/method-raid-tools)

🟢 Pairs With // Gogo1951's [Play It Forward](https://www.curseforge.com/wow/addons/play-it-forward)

🟢 Pairs With // Gogo1951's [Water Dispenser](https://www.curseforge.com/wow/addons/water-dispenser-revisited)

🟡 Some Overlap // wumatic1's [BuffBuddy](https://www.curseforge.com/wow/addons/buffbuddy)

🟡 Some Overlap // nyxito's [Consumable Tracker Classic/TBC](https://www.curseforge.com/wow/addons/consumabletracker)

🟡 Some Overlap // zac12's [Consumables Checker](https://www.curseforge.com/wow/addons/consumables-checker-classic-wow-raid-tracker)

🟡 Some Overlap // humfras's [Poisoner](https://www.curseforge.com/wow/addons/poisoner)

🟡 Some Overlap // zac12's [Readycheck](https://www.curseforge.com/wow/addons/ready-check)

🔴 Direct Alternative // ollidiemaus's [Auto Potion](https://www.curseforge.com/wow/addons/auto-potion)

🔴 Direct Alternative // mZHg's [Buffet](https://www.curseforge.com/wow/addons/buffet)

🔴 Direct Alternative // executedpoorly's [Feed Me](https://www.curseforge.com/wow/addons/feed-me)

🔴 Direct Alternative // noobsgonewild's [Feed Pet Plus Macro](https://www.curseforge.com/wow/addons/feed-pet-plus-macro)

🔴 Direct Alternative // IzC's [IzC Auto Consumables](https://www.curseforge.com/wow/addons/izc-auto-consumables)
