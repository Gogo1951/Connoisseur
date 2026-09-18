# Connoisseur // Manual Test Plan

This is the manual test plan for Connoisseur, the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Connoisseur/blob/main/README-Technical.md).

## Before you start

**Run the whole list on Classic Era, then `/reload` and run it again on TBC Anniversary.** Steps are numbered continuously so you can report "failed on step N."

Gather these once so you aren't caught short mid-run:

- **A Mage** that knows at least two ranks of Conjure Water, and **a second player of a lower level** you can target. The same player is targeted again in step 6 and grouped with you in step 8.
- **A Warlock** with a Soulstone and a Healthstone spell trained.
- **A Rogue with Poisons trained**, carrying poison, with a poison on its Restock List set above what it carries.
- **A Hunter** with a pet out and at least two foods it eats in the bags.
- **A character with First Aid** carrying one bandage its skill allows and one it doesn't yet.
- **A character with at least one unspent talent point.**
- **Three vendors scouted before you start:** one selling items you can put on your list, one stocking **every** reagent your listed poison needs, and one stocking **only some** of them.
- **Bank access with at least one bank bag** bought and equipped, and **a loading screen you can cross**: a boat, a zeppelin, or an instance portal.
- **Something to fight**, any open-world mob or a target dummy.
- **In your bags:** a buff food, at least two plain foods of different quality, and a scroll whose buff you don't have (Scroll of Stamina, for example), with no Well Fed buff on you.
- **Equipped:** one piece of gear under 20% durability.
- **A non-English client**, only for the optional localization step at the end.

Unless a step says otherwise, be **out of combat with no target selected**.

## Verify this release's changes

Since the last release (2026.09.16.A), Connoisseur reads spells, spell names, profession skills, the quest log, your pet's diet and merchant listings through new routes, and rebuilds its picture of your bank on every visit. That work prepares for WoW Forever, but every one of those routes runs on Classic Era and TBC Anniversary too, so **nothing should look different there**. These steps prove it. The release also stops a bank restock from hanging on an item stuck in place, keeps `/crs profile use` from pointing a character at a list that doesn't exist, fills in item names added while others are still loading, hides macro names on one more action bar, and rewords a few tips and tooltips. Run these first, on both flavors.

**The new routes are present**

**1.** Open **Options > Connoisseur > Diagnostic Tools** and hover **Enable Diagnostic Tools**: its tooltip must read "Shows the diagnostic reports and the event log below until you log out or turn it off." Tick it and press **Test WoW API Endpoints**. **C_Spell.GetSpellName**, **C_SpellBook.IsSpellInSpellBook**, **C_SpellBook.IsSpellKnown**, **C_Secrets.ShouldAurasBeSecret** and **C_Secrets.CanCompareUnitTokens** must all read PASS, because nothing stands behind them. The rows come in pairs, such as **C_PetInfo.GetPetFoodTypes** and **GetPetFoodTypes (legacy)**, and on both flavors at least one row of every pair must PASS; the *(legacy)* side is the expected one. Then press **Show Connoisseur Context**: under "-- Spell knowledge --", every spell your character has trained must read `[KNOWN]` with its name filled in. Failure is any of those five rows reading FAIL, a pair where both sides FAIL, or a trained spell shown without `[KNOWN]`.

**Spells and spell names**

**2.** *Mage.* Hover the mini-map button: the tip must read "Right-Click on your Food or Water macros to cast Conjure Food or Conjure Water." Right-Click `- Water`: it must conjure your highest rank. Target your lower-level second player and Right-Click again: the water must be the rank for their level. Target yourself, then clear your target: the next Right-Click must go back to your own rank. Failure is nothing conjured, the wrong rank, or a macro that ignores the target change.

**3.** *Warlock.* Hover the mini-map button: the tips must read "Right-Click on your Healthstone macro to cast Create Healthstone. ..." and "Right-Click on your Soulstone macro to cast Create Soulstone." Right-Click `- Healthstone` and `- Soulstone`: each must create its stone. Failure is old wording, or a Right-Click that creates nothing.

**4.** *Rogue.* Hover the mini-map button: the **Attention Rogues** block must be there, with a poison under Main Hand and Off Hand. Middle-Click `- Poisons`: the Poisons crafting window must open. *Hunter:* with your pet out, press `- Feed Pet`: the pet must eat a food from your bags that its diet accepts, and Mend Pet must appear in the macro body only if you have trained it. Failure is the Rogue block missing, a Middle-Click that does nothing, or the pet offered a food it refuses.

**5.** *First Aid.* Carrying one bandage your skill allows and one it doesn't yet, press `- Bandage`: it must use the one you can use and never try the other. Take the usable bandage out of your bags, tick **Bandages** on the **Readiness Report** page (switch the report on first) and press **Show Readiness Report** under Diagnostic Tools: the report must list **Bandages** under "Missing Items :". Failure is the macro reaching for the bandage your skill blocks, or no Bandages line when you have none you can use.

**Buff food and scrolls**

**6.** Turn **Prioritize Buff Food** on with **When to Use** set to **Always**. `- Food` must offer your buff food. Eat it: within a second of Well Fed appearing, `- Food` must switch to your best plain food. Left-Click the mini-map button twice to switch Buff Food off and back on, cancel Well Fed, and wait: `- Food` must switch back to the buff food. Now Shift + Left-Click to turn Scroll Buffs on while carrying a scroll whose buff you lack: `- Food` must become the scroll, and once you read it and the buff lands, must go back to food. Target your second player: the scroll must drop out of `- Food` while they are targeted. Failure is a Food macro that stops following Well Fed after the toggle, or a scroll offered for a buff you already have.

**The Readiness Report**

**7.** Switch the Readiness Report on and open its page. **Current Spec** must be there **on both flavors**, and **Flask or 2x Elixirs** must be absent on Classic Era and present on TBC Anniversary. Tick **Current Spec** on the character with an unspent talent point and press **Show Readiness Report**: the Character line must name your biggest talent tree with your point spread, and also "1 Unspent Talent Point" or "N Unspent Talent Points". Then tick **Damaged Gear Below** with your damaged piece on and press the button again: the damaged item must show as plain text beginning `|Hitem:`, not as a coloured clickable link, so it pastes cleanly. Failure is the Current Spec switch missing, no unspent-points entry, or a rendered link in the box.

**8.** *Grouped with your second player, the report switched on.* Pull a mob and, **while in combat**, start a ready check: the report must print as usual. This is where the flavors differ: on Classic Era and TBC Anniversary the report prints mid-fight, and silence here is a failure. Tab between targets during the fight, onto yourself and back. Failure is a Lua error, or no report during combat.

**The Restocker**

**9.** Put a **Take** item only inside a **bank bag**, not the bank's main slots, with your bags short of it, and a **Store** item with more in your bags than its Amount. Open the bank: the Take item must come out of the bank bag and the Store surplus must go into the bank, with "Restocking complete..." in chat. Now set up a larger restock and, while the moves are still running, pick up one of the stacks being moved and hold it on your cursor. Within a few seconds the restock must stop waiting: the stack goes back into a slot, and chat ends with either "Restocking complete..." or a line beginning "Restocking stopped." Failure is nothing leaving a bank bag, or a restock that hangs with no closing line.

**10.** With the `/crs` window open, type `/crs profile use NoSuchList`. Nothing may change: the **List** selector keeps your current list and every row stays. Type `/crs profile use` with the name of your other list: the window must switch to it. Hover the **Copy** button in the footer: its tooltip must read "Copy this list into a new one". Failure is a Lua error, a blank List selector, or an empty window after the bad name.

**11.** Quit the game completely, start it again, log in, and open **Options > Connoisseur > Ignore List** straight away. Pick your character and add three item IDs one right after another with **Add by Item ID**, such as 159, 1179 and 1205: every row must fill in its icon and name within a few seconds with the panel left open, including the rows added while the first was still loading. Remove them again afterwards. Failure is a row that stays blank until the panel is reopened.

**12.** On the root **Connoisseur** page, make sure **Enable Macro Names on Buttons** is off. Switch on every extra action bar your client offers and put a Connoisseur macro on each of them and on your main bar: no macro name may show on any. Tick the option: names must appear on every bar at once. Failure is a macro name on any bar while the option is off.

When steps 1-12 pass on both flavors, this release's changes are verified. Proceed to `4 - Pre-Launch Review Prompt.md`.

## Core checks

**13.** Log in with Connoisseur enabled. No Lua error window and no red text; a colored welcome line must print in the shape "Connoisseur // Version ...". Type `/reload`: the UI must come back clean and the welcome line must print again. Failure is any error naming Connoisseur, or no welcome line.

**14.** Open the options from **every** entry point: type `/foodie`, Shift + Middle-Click the mini-map button, type `/crs config`, and pick Connoisseur from the Blizzard Options > AddOns category list. Each must open the settings **docked inside the Blizzard Options window**, with Connoisseur selected in the category list on the left, showing Macros, Ignore List, Restocker, Readiness Report, Profiles and Diagnostic Tools beneath it. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **TBC Anniversary is the flavor that historically breaks this**, so a tester who runs only Era has not finished.

**15.** Pull a mob. While in combat, try `/foodie`, `/crs config` and Shift + Middle-Click: each must print "Connoisseur // As a safety precaution, the Options Interface cannot be opened during combat." and the panel must **not** open. `/crs` on its own must still open the Restocker window, because only the Options route is gated. Press a Connoisseur macro mid-fight: it must use its item with no error. Now leave combat: the options panel must **not** open by itself, and any macro change that waited on the fight must land within a second or two. Failure is the panel opening, silence instead of the message, a red `ADDON_ACTION_BLOCKED` error, or a macro left stale after the fight.

**16.** Work through the mini-map button's clicks against its tooltip. Left-Click flips Buff Food, Shift + Left-Click flips Scroll Buffs, Right-Click ignores your current food and the **Current Food** row switches to the next best, Middle-Click clears this character's Ignore List instantly with no confirmation (deliberate), and Shift + Middle-Click opens the options. After each toggle the tooltip's Enabled or Disabled must flip while you are still hovering, and must agree with the Macros page. Then untick **Enable Mini-map Button** on the root Connoisseur page: the button must vanish at once, and ticking it must bring it straight back, with no `/reload`. Failure is any click doing something its tooltip doesn't say, the two views disagreeing, or a button that needs a reload to hide or return.

**17.** Type `/crs`: the Restocker window must toggle open and closed. `/crs show` must open it without toggling. `/crs help` must print every command with a description, no raw keys. `/crs profile` with nothing after it must print usage lines rather than erroring. Failure is a Lua error or a command that silently does nothing.

**18.** Loot, buy, or trade yourself a food better than your current pick. Within about a second the `- Food` macro, in the **General** macro tab, must rewrite to the new item, and the tooltip's Current Food row must agree. Now type `/macro` to open the game's macro window and, with it still open, eat or destroy the last of your current best food: `- Food` must **not** change while the window is open, and must rewrite to your next best food within a second of closing it. Then empty every food out of your bags and press `- Food`: chat must print "Connoisseur // No suitable Food found in your bags.", and each macro prints the same shape with its own category name when its category is empty. Failure is a macro that only updates after a `/reload`, a macro still stale after the macro window closes, macros landing in the character-specific tab, silence on an empty category, or the wrong category label.

**19.** *Warlock.* Read the `/cast` lines in the `- Healthstone` and `- Soulstone` macro bodies, then Right-Click each macro. **On Classic Era the spell must be a bare full name**, such as `Create Healthstone (Minor)`, with no `(Rank N)`. **On TBC Anniversary it must be rank-pinned**, as in `Create Healthstone(Rank 3)`. A wrong name on Classic Era makes the Right-Click **silently do nothing**, so test the click itself on both flavors rather than only reading the body. Failure is a `(Rank N)` on Classic Era, a missing rank on TBC Anniversary, or a Right-Click that creates nothing.

**20.** With **more** of a Restock List item than your target, open a vendor: **nothing may ever be sold**, so check bags and money before and after. With **less** than target and Buy on, open a vendor who stocks it: Connoisseur must buy up to the target and never past it. Hold Shift while opening the vendor: restocking must be skipped entirely. Then, on the Rogue, open the vendor stocking **every** reagent your listed poison needs: each one buys. Open the vendor stocking **only some**: nothing may be bought, and chat prints "Connoisseur // This merchant doesn't stock every ingredient your poisons need. Skipping them all." Failure is any item leaving your bags at a merchant, over-buying, Shift being ignored, or half a recipe filling your bags.

**21.** Hold Shift while opening the bank: nothing may move. Open it again without Shift and let the restock finish, then close it. Failure is anything moving on the Shift visit.

**22.** On the **Restocker** page, set the **Detail** dropdown under **Enable At-Merchant Restock Reminders** to **Verbose**, then close a merchant window with something still short. Chat must print the "N restocking orders outstanding." headline followed by one line per short item in the shape "3/20 [item]", each a complete line with a working, clickable item link, no `nil`, no stray `%s` or `%d`, and no half-rendered link. Then cross a loading screen without visiting a merchant or the bank: no restocking line may print as the world loads. Failure is per-item lines missing in Verbose, a broken link, or the headline turning up on arrival from a boat.

**23.** Open **Diagnostic Tools** on a fresh login: the **Enable Diagnostic Tools** toggle must be **off**, and off again after a `/reload`, since it is deliberately session-only. Tick it, click **Start Event Log**, spam a red combat error by pressing an ability that isn't ready over and over, then click **Show Captured Events**: the spam must **not** appear as individual timestamped lines. Read the `-- Suppressed (uncorrelated) traffic --` block at the end, where it must fold into one counted row such as `x12`. Failure is diagnostics surviving a reload, or spam flooding the log line by line.

**24.** *Optional, non-English client.* Read the options pages, the mini-map tooltip, the Restocker window and the List Builder. Every label and tooltip must render in that language with no raw key like `OPTIONS_MODE_CAPTION` on screen. This release's reworded copy needs the closest look: the Mage and Warlock tips in the mini-map tooltip, the hover text on the Readiness Report's Mana Gem, Mana Potion and Bandages switches, the Restocker page's description, the Enable Macros description, the Restocker window's Copy tooltip, and the in-town restock reminder. No caption may push its dropdown onto a line of its own, and no Restocker column heading may grow so wide that it crushes the item name beside it. Trigger a few chat lines, the welcome line, a "No suitable ... found" line, the poison-reagent skip line from step 20, and a Readiness Report line: each must read as one complete sentence with no `nil` and no stray `%s` or `%d`, and a Readiness Report line must separate its items with that language's own punctuation. The slash commands `/foodie` and `/crs`, the /Commands heading, the name Restocker, the four URLs, the names Discord, GitHub, CurseForge and Wago, and the whole Diagnostic Tools page stay **English on every client**. That is deliberate, not a missed translation.

This plan deliberately skips the deep per-class macro matrix (Ritual of Refreshment and Ritual of Souls, Hunter Feed Pet's full cascade and its quest-food skip, Rogue poison hands, Druid DruidMacroHelper wraps and their return form, Night Elf stealth eating, Goblin and Gnomish explosives), Restock List upgrades on level-up, the entering-town reminder, per-character settings scope, the Profiles panel, and the arena rules. Refresh coverage there when a release touches those systems.

When every step passes on **both** Classic Era and TBC Anniversary, manual testing is complete. Proceed to `4 - Pre-Launch Review Prompt.md`.
