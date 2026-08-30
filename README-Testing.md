# Connoisseur // Manual Test Plan

This is the manual test plan for Connoisseur, the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Connoisseur/blob/main/README-Technical.md).

## Before you start

**Run the whole list on Classic Era, then `/reload` and run it again on TBC Anniversary.** Steps are numbered continuously so you can report "failed on step N."

Gather these once so you aren't caught short mid-run:

- **Both flavors installed**, Classic Era and TBC Anniversary.
- **A character that was already using the previous release**, with a Restock List it had built. Do **not** delete your SavedVariables before this run. What happens to existing saved data is the biggest thing this release changes, and you only get one chance to watch it happen.
- **A second character on the same account**, set to the same Restock List as the first.
- **A Warlock** who can make a Healthstone and a Soulstone.
- **A Hunter with a pet**, and pet food in their bags.
- **A Rogue with Poisons trained**, and a poison on their Restock List with a target above what they carry.
- **A second player.** A ready check needs a group, so five steps below need them. On TBC Anniversary one of those steps queues a skirmish together.
- **Three vendors scouted before you start:** one selling a **limited-stock** item you can put on your list (the few-at-a-time goods a vendor trickles back), one stocking **every** reagent your listed poison needs, and one stocking **only some** of them.
- **Bank and merchant access**, and **a loading screen you can cross**: a boat, a zeppelin, or an instance portal.
- **Something to fight**, any open-world mob or a target dummy.
- **In your bags:** two tiers of food, a health potion, a mana potion, and no bandage you are able to use.
- **Equipped:** one piece of gear under 20% durability, and one thing that does not belong in a fight, such as a PvP trinket or a fishing pole.
- **On TBC Anniversary only:** a flask, or two different elixirs, that you can drink.
- **A non-English client**, only for the optional localization step at the end.

Unless a step says otherwise, be **out of combat with no target selected**.

## Verify this release's changes

Since the last release (2026.08.25.A), five things changed. The Restock List moved out of its own saved file into Connoisseur's, so lists built on the old release are not carried across. The Restock List window was rebuilt, gaining a category pane, a filter box, banded columns, named lists in the footer, and a List Builder button. A new per-item **Extra** toggle buys out a vendor's limited stock. The ready-check report was rebuilt as the **Readiness Report**, with an options page of its own, seventeen switches, and a soft launch that ships it switched off. And Hunter pet food now reads the bag scan the add-on has just finished instead of walking your bags a second time. Run these first, on both flavors.

**The Restock List moved into Connoisseur's saved file**

**1.** On the character that was already using the previous release, log in with this build. No Lua error may appear, and every Connoisseur setting must survive: your macros, your toggles, and your Ignore List are all exactly as you left them. Your **Restock List, however, must be empty.** That is correct, not a bug: the list moved into Connoisseur's own saved file and old lists are deliberately not carried over. Then wait about three seconds. On a character past level 5, the **List Builder** window must offer itself with staples already ticked. Failure is an error at login, Connoisseur's own settings lost along with the list, or the List Builder never appearing.

**2.** Tick a few staples in that window and close it, then open `/crs` and add one more item by dropping it from your bags into the box reading "Drop Item here, or type Item ID". Every row must appear immediately. Now `/reload`: the rows are still there. Now log out fully and back in: still there. Failure is a list that empties on either trip, which would mean the new saved file isn't being written.

**The Restock List window**

**3.** Look over the `/crs` window against this layout. Down the left is a category pane with **All items** at the top and one row per item type below it, each carrying a count. Across the top is a filter box reading "Filter items...". The grid's headings are banded: **Bank** over **Take** and **Store**, **Merchant** over **Buy**, **Extra** and **Rep**, then **Upgrade**, then **Amount**. Along the bottom is a **List** selector, a rename box with a **Rename** button, and **Copy** and **Delete** buttons. An **Open List Builder** button sits with the controls. Failure is a missing band or column, headings that don't line up over the cells beneath them, or an item name squeezed to an unreadable sliver.

**4.** Type a few letters of one item into the filter box: the list narrows to matches as you type, and the clear button beside it empties the box and brings everything back. Now click a category in the left pane: only that type shows, and the counts beside each category still describe the whole list. Click **All items** to return. Failure is a filter that does nothing, a category that shows the wrong items, or no way back to the full list.

**5.** Click the **Rep** cell on any row. The standing menu must draw **in front of** the window, not behind it, and must close by itself the moment you pick a standing. Then find a row for an item with no upgrade path, something like a Hearthstone or Thieves' Tools: its **Upgrade** toggle must be unavailable rather than offering an upgrade that will never arrive. Failure is a menu that opens behind the window, a menu that stays open after a pick, or a red `ADDON_ACTION_BLOCKED` error, which means the window is tainting Blizzard's own frames.

**Named Restock Lists**

**6.** From the footer, open the **List** selector and pick **New List**: you get an empty list, and the first one is untouched when you switch back. Type a new name in the rename box and press **Rename**. **Copy** clones the current list into a new one, and **Delete** asks you to confirm before removing one. Now log to the second character set to that same list: it must be following the **new name**, with the same rows on it. Last, confirm `/crs profile add`, `use`, `rename`, `copy` and `delete` do the same things from chat. Failure is a rename that only one character sees, a copy that shares rows with its source instead of cloning them, or a delete with no confirmation.

**Buy Extra**

**7.** Put the **limited-stock** item on your list with **Buy** on and a small target, tick **Extra** on its row, and open that vendor. Connoisseur must buy the vendor's **whole** limited stock of it, past your target amount. Then tick **Extra** on something that vendor sells in unlimited supply: that one must still buy only up to your target, because Extra deliberately ignores unlimited stock. Neither visit may print a claim that restocking finished when nothing was actually bought. Failure is Extra stopping at the target, Extra draining your gold on an unlimited item, or a "complete" line over an empty purchase.

**The Readiness Report**

**8.** Open **Options > Connoisseur > Readiness Report**. On a fresh install the page must show **one** switch, **Enable Readiness Report on Ready Check**, switched **off**, with every section below it hidden. This is deliberate: the report ships off and each player opts in. Turn it on, and the three sections **Missing Buffs**, **Missing Items** and **Character** must appear. Now press **Reset Readiness Report Settings**: it must ask you to confirm, then collapse the page back to that single switch. Failure is the report arriving already on, sections visible while the master switch is off, or a reset with no confirm.

**9.** Turn the report back on and read the switches. Exactly three ship **on**: **Soulstone Inactive**, **Healthstone** and **Mana Gem**. Everything else ships **off**. Then check the flavor difference: the **Flask or 2x Elixirs** row must be **absent on Classic Era** and **present on TBC Anniversary**, since Era doesn't run on flasks. Failure is a different set of switches on by default, or the Flask row appearing on Era.

**10.** Group with your second player, and set yourself up to fail: damaged gear equipped, a fishing pole or PvP trinket on, no bandages, and the matching switches turned on. Have them run a ready check. Chat must print a **Readiness Report** headline followed by up to three lines, each one branded "Connoisseur //" and each reading as complete clauses, such as "Missing Items : Bandages. Damaged Gear : *link*". Now fix everything the report named and run another ready check: **nothing at all** may print, not even the headline. Silence is the report working. Failure is a headline over no lines, an unbranded line, or any output from a character with nothing wrong.

**11.** *Warlock and a group.* With **Soulstone Inactive** on, carry Soulstones in your bags but put none on anyone, and run a ready check: the report must name the Soulstone. Now use one on a group member and run another: that line must go quiet. Stones sitting unused in bags must never count as covered. This step matters more than it looks: the spell IDs behind it have not been confirmed against a live client, so a wrong one shows up here or nowhere. Failure is a line that stays quiet with no stone deployed, or one that keeps nagging after a stone is up.

**12.** Open **Options > Connoisseur > Diagnostic Tools**, tick **Enable Diagnostic Tools**, and press **Show Readiness Report**. It must render what the report would say right now without waiting for a ready check, followed by a `-- Category switches --` block listing every switch and whether it is on. This is how you tell a report that is quiet because you are ready apart from one that never ran, so it must work solo, with no group. Failure is an empty box, or a switch list that disagrees with the Readiness Report page.

**Hunter pet food**

**13.** *Hunter.* Log out and back in with your pet already out and pet food in your bags. Within a second or so the `- Feed Pet` macro must name a real food, and pressing it must feed the pet. Do this from a cold login rather than a `/reload`, because that is the case the change affects. Failure is a `- Feed Pet` macro that stays blank, or one that only finds food after you loot something.

When steps 1-13 pass on both flavors, this release's changes are verified. Proceed to `4 - Pre-Launch Review Prompt.md`.

## Core checks

**14.** Log in with Connoisseur enabled. No Lua error window and no red text; a colored welcome line must print in the shape "Connoisseur // Version ...". Type `/reload`: the UI must come back clean and the welcome line must print again. Failure is any error naming Connoisseur, or no welcome line.

**15.** Open the options from **every** entry point: type `/foodie`, Shift + Middle-Click the mini-map button, type `/crs config`, and pick Connoisseur from the Blizzard Options > AddOns category list. Each must open the settings **docked inside the Blizzard Options window**, with Connoisseur selected in the category list on the left, showing Macros, Ignore List, Restocker, Readiness Report, Profiles and Diagnostic Tools beneath it. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **TBC Anniversary is the flavor that historically breaks this**, so a tester who runs only Era has not finished.

**16.** Pull a mob. While in combat, try `/foodie` and Shift + Middle-Click: each must print "Connoisseur // As a safety precaution, the Options Interface cannot be opened during combat." and the panel must **not** open. `/crs` on its own must still open the Restocker window, because only the Options route is gated. Still in the fight, loot or receive a better consumable: no macro may rewrite and no error may appear, and pressing each macro must still use its item. Now leave combat: the pending rebuild must land within a second or two, and the options panel must **not** open by itself. Failure is the panel opening, silence instead of the message, a red `ADDON_ACTION_BLOCKED` error, or an update dropped so the macro stays stale.

**17.** Work through the mini-map button's clicks against its tooltip. Left-Click flips Buff Food, Shift + Left-Click flips Scroll Buffs, Right-Click ignores your current best food and the **Current Food** row switches to the next best, Middle-Click clears this character's ignore list instantly with no confirmation (deliberate), and Shift + Middle-Click opens the options. The tooltip's Restocker Report must count the orders you are still short. After each toggle, the Macros panel must agree with the tooltip. Failure is any click doing something its tooltip doesn't say, or the two views disagreeing.

**18.** Type `/crs`: the Restocker window must toggle open and closed. `/crs show` must open it without toggling. `/crs help` must print every command with a description, no raw keys. `/crs profile` with nothing after it must print usage lines rather than erroring. Failure is a Lua error or a command that silently does nothing.

**19.** Loot, buy, or trade yourself a food better than your current pick. Within about a second the `- Food` macro, in the **General** macro tab, must rewrite to the new item, and the tooltip's Current Food row must agree. Then empty every food out of your bags and press `- Food`: chat must print "Connoisseur // No suitable Food found in your bags.", and each macro prints the same shape with its own category name when its category is empty. Failure is a macro that only updates after a `/reload`, macros landing in the character-specific tab, silence on an empty category, or the wrong category label.

**20.** *Warlock.* Read the `- Healthstone` and `- Soulstone` bodies' `/cast` lines, then right-click each. **On Classic Era the spell must be a bare full name**, such as `Create Healthstone (Minor)`, with no `(Rank N)`. **On TBC Anniversary it must be rank-pinned**, as in `Create Healthstone(Rank 3)`. This is the most-repeated bug in this add-on's history, and getting it wrong on Era makes the right-click **silently do nothing**, so test the click itself on both flavors rather than only the body text.

**21.** With **more** of a Restock List item than your target, open a vendor: **nothing may ever be sold**, so check bags and money before and after. With **less** than target and Buy on, open a vendor who stocks it: Connoisseur must buy up to the target and never past it. Hold Shift while opening the vendor: restocking must be skipped entirely. Then, on the Rogue, open the vendor stocking **every** reagent your listed poison needs: each one buys. Open the vendor stocking **only some**: nothing may be bought, and chat prints once "This merchant doesn't stock every ingredient your poisons need. Skipping them all." Failure is any item leaving your bags at a merchant, over-buying, Shift being ignored, or half a recipe filling your bags.

**22.** With an item set to **Take** and short in your bags, open the bank: the shortfall must move from bank to bags, ending with the "Restocking complete..." chat line. With an item set to **Store** and surplus in your bags, the surplus must move to the bank. Hold Shift while opening the bank: nothing moves. Failure is a silent finish, nothing moving, or Shift being ignored.

**23.** Set the At-Merchant reminder's dropdown to **Verbose** on the Restocker options page, then close a merchant window with something still short. Chat must print the "N restocking orders outstanding." headline followed by one line per short item, each a complete sentence with a working, clickable item link, no `nil`, no stray `%s` or `%d`, and no half-rendered link. Then cross a loading screen without visiting a merchant or the bank: no restocking line may print as the world loads. Failure is per-item lines missing in Verbose, a broken link, or the headline turning up on arrival from a boat.

**24.** Open **Options > Diagnostic Tools** on a fresh login: the **Enable Diagnostic Tools** toggle must be **off**, and off again after a `/reload`, since it is deliberately session-only. Tick it, click **Start Event Log**, spam a red combat error by pressing an ability that isn't ready over and over, then click **Show Captured Events**: the spam must **not** appear as individual timestamped lines. Read the `-- Suppressed (uncorrelated) traffic --` block at the end, where it must fold into one counted row such as `x12`. Failure is diagnostics surviving a reload, or spam flooding the log line by line.

**25.** *Optional, non-English client.* Read the seven options pages, the mini-map tooltip, and the Restocker window. Every label and description must render in that language with no raw key like `OPTIONS_READINESS_FLASK` on screen. The Readiness Report page and the rebuilt Restocker window are the newest copy: the seventeen switches and their silver descriptions, the **Bank** and **Merchant** column bands, the short **Take**, **Store**, **Rep** and **Extra** headings, the **All items** category, and the list footer's buttons all have to read in that language, and a column heading must not grow so wide that it crushes the item name beside it. Trigger a few chat lines, the welcome line, a "No suitable ... found" line, the poison-reagent skip line from step 21, and a Readiness Report line: each must read as one complete sentence with no `nil` and no stray `%s` or `%d`. The slash commands `/foodie` and `/crs`, the four URLs, and the names Discord, GitHub, CurseForge and Wago stay **English on every client**. That is deliberate, not a missed translation.

This plan deliberately skips the deep per-class macro matrix (Mage conjure ranks and Ritual of Refreshment, Hunter Feed Pet's full cascade, Rogue poison hands, Druid DruidMacroHelper wraps, Night Elf stealth eating), Restock List upgrades on level-up, the entering-town reminder, per-character settings scope, and the Profiles panel. Refresh coverage there when a release touches those systems.

When every step passes on **both** Classic Era and TBC Anniversary, manual testing is complete. Proceed to `4 - Pre-Launch Review Prompt.md`.
