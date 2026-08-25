# Connoisseur — Manual Test Plan

This is the manual test plan for Connoisseur — the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Connoisseur/blob/main/README-Technical.md).

## Before you start

**Run the whole list on Classic Era, then `/reload` and run it again on TBC Anniversary.** Steps are numbered continuously so you can report "failed on step N."

Gather these once so you aren't caught short mid-run:

- **Both flavors installed** — Classic Era and TBC Anniversary.
- **A character that was already using the previous release**, with settings it has changed and a Restock List it has built. Do **not** delete your SavedVariables before this run — "does an existing player's data still work" is a real test.
- **A second character on the same account**, carrying at least one food the first character also carries. The Ignore List steps log between the two.
- **A Rogue with the Poisons skill trained**, a poison on their Restock List with a target above what they carry, and three vendors scouted before you start: one that stocks **every** reagent that poison needs (a poison supplier), one that stocks **only some** of them (a general trade-goods vendor carrying Crystal Vials but not the dusts), and one that stocks **none**.
- **A Warlock** who can create a Healthstone and a Soulstone. A **Mage** also works for the conjure-detection step, but only a Warlock can run the stone-rank step.
- **Potions:** two health potions of different strengths. On TBC Anniversary, also a **Crystal Healing Potion** and a **Super Healing Potion** together in one bag, and a **Super Rejuvenation Potion**; on Classic Era, a **Minor** or **Major Rejuvenation Potion**.
- **Food:** at least two tiers of food in your bags.
- **An unused stat scroll** — a Scroll of Strength, Agility, or the like, whose buff you are not already carrying.
- **An item on your Restock List** you can test Buy, Withdraw, and Deposit with, plus vendor and bank access.
- **Something to fight** — any open-world mob or a target dummy.
- **A loading screen you can cross** — a boat, a zeppelin, or an instance portal.
- **A second player**, for one step only: a TBC Anniversary skirmish queue and a ready check inside the arena.
- **A non-English client** — only for the optional localization step at the end.

Unless a step says otherwise, be **out of combat with no target selected**.

## Verify this release's changes

Since the last release (2026.08.18.B), seven things changed: the way ties between equal consumables are broken was rebuilt from hidden score bonuses into an explicit burn-first order (conjured, then zone-locked, then soulbound, then cheaper, then bigger stacks — with raw restore value always deciding first); the Rejuvenation Potions were added to the potion data and Rulkster's Secret Sauce was removed from it; the Ignore List moved out of the Macros page onto a panel of its own and gained an account-wide **Global** list beside the per-character ones; the scroll and pet-food picks, which used to run around the Ignore List entirely, now honor it; Restocker's poison-reagent buying became all-or-nothing at each vendor, with a new chat line when it stands down; the Mage/Warlock conjure detection was aligned so the mini-map tooltip and the macros can no longer disagree about which spells you know; and two messages that fired when they shouldn't were silenced. Run these first, on both flavors.

**Consumable tie-breaking**

**1.** On the character that was already using the previous release, log in with this build. It must come up with your settings and Restock List exactly as you left them, with no Lua error — the item cache rebuilds itself for the new soulbound data with nothing for you to click. Then loot or buy any consumable that changes a pick: the macro must rewrite within about a second. Failure is an error at login, a lost setting, or a macro that only updates after a `/reload`.

**2.** *TBC Anniversary.* With a **Crystal Healing Potion** and a **Super Healing Potion** both in your bags, read the `- Health Potion` macro body. Both heal the same, so the tie-break decides — and the Crystal potion is soulbound, so its `/use` line must come **first**. Then open **Options → Diagnostic Tools**, tick **Enable Diagnostic Tools**, trigger a rescan (loot something), and click **Show Selection Report**: the report must name the step that decided the pick. Failure is the Super Healing Potion listed first — the add-on hoarding the potion you can't trade or sell while burning the one you can.

**3.** Put a plainly **stronger** potion in your bags alongside a weaker one that is soulbound or zone-locked. The stronger potion must be picked, always — the burn-first preferences only ever break ties, never outvote a real difference in healing. Failure is the weaker flagged potion winning, which is exactly the regression the rework removed.

**4.** Put your flavor's **Rejuvenation Potion** in your bags (Minor or Major on Era, Super on Anniversary). It restores both health and mana, so **both** the `- Health Potion` and `- Mana Potion` bodies must list it. On Anniversary, also confirm **Rulkster's Secret Sauce** no longer appears in the `- Health Potion` body if you own one — it was removed from the potion data. Failure is either macro ignoring the Rejuvenation Potion, or the Sauce still being offered as a potion.

**Ignore List**

**5.** Open **Options → Ignore List** — it is now its own page in the category list, sitting between Restocker and Profiles, and the **Macros** page must no longer carry an Ignore List section at all. The panel splits in two: a list of scopes on the left, holding **Global** and your current character, and the selected scope's items on the right. In your character's pane, add the food your `- Food` macro is currently using — type its item ID into the **Add by Item ID** box, or Shift + Click its link in chat. The row appears and the macro switches to your next-best food within about a second. Click the row's remove icon and the food comes back. Failure is an Ignore List still on the Macros page, a rejected item ID, or a macro that keeps offering an item you just ignored.

**6.** With that food ignored again on your character, click the row's **Global** button. The row must **move** — out of your character's pane, into the **Global** one — not appear in both. Now Middle-Click the mini-map button to clear your character's list: the item must stay ignored, because the quick-clear only empties the character's own list. Log to your second character carrying the same food: its `- Food` macro must refuse that item too, and **Global** must show it there as well. Failure is the item reappearing on either character, a row living in two scopes at once, or the Middle-Click emptying the Global list.

**7.** Turn Scroll Buffs on (Shift + Left-Click the mini-map button) with an unused stat scroll in your bags: the `- Food` macro must switch to using that scroll. Add the scroll to your character's Ignore List — the macro must go straight back to offering food, and pressing it must eat rather than use the scroll. Take it off the list and the scroll must come back. Failure is a scroll the macro keeps using after you ignored it; that pick used to bypass the Ignore List completely. *(A Hunter's `- Feed Pet` pick honors the list the same way now — and a pet food you ignore must still be ignored after a `/reload`, not quietly dropped from the list.)*

**Poison reagents buy all-or-nothing** *(Rogue)*

**8.** Open the vendor that stocks **every** reagent your listed poison needs. Connoisseur must buy each reagent up to what the crafting order calls for, exactly as before. Failure is nothing being bought at a fully stocked supplier.

**9.** Open the vendor that stocks **only some** of the needed reagents. **No reagents may be bought at all** — half a recipe used to fill your bags with vials that couldn't become poisons — and chat must print, once for the visit, *"This merchant doesn't stock every ingredient your poisons need. Skipping them all."* Then open the vendor that stocks **none** of them: nothing may be bought and **nothing may print**, because a skipped order is only news at a vendor that had some of it. Failure is vials bought for the skipped recipe, the message repeating, or the message appearing at the vendor with none.

**10.** Add a **Crystal Vial directly to your Restock List** as its own row and reopen the some-but-not-all vendor from step 9: the vials must buy normally, because a direct ask is not part of the crafting order. Then put enough Crystal Vials **in your bags** to cover the recipe's vial need and reopen that same vendor: what the bags already cover is no longer required of it, so the remaining reagents it does stock must now buy. Failure is the directly listed row being skipped, or the vendor still treated as incomplete over a reagent you already hold.

**Mage & Warlock conjure detection**

**11.** On a Mage or Warlock who knows their conjure spells, hover the mini-map button and right-click the matching macro (`- Food` / `- Water` on a Mage, `- Healthstone` / `- Soulstone` on a Warlock). The **Attention Mages** / **Attention Warlocks** tooltip block must appear **and** the right-click must actually conjure — the two read spell knowledge through the same check now and must always agree. On a character below the spell's level, the click must instead print the *"You don't currently know …"* tip. **Run this on both flavors** — the two clients answer the underlying spell-known question differently, which is why the second lookup exists. Failure is a tooltip block with a dead right-click, or a working conjure with no block.

**Messages that should now stay quiet**

**12.** *TBC Anniversary.* In a party with your second player, out in the world, run a ready check: the readiness line must print as usual. Now queue a skirmish together and run another ready check **inside the arena**: nothing may print at all. Buff food, scrolls, and pet food are all blocked in there, so the report would only be a nag about the unfixable. Failure is any readiness line inside the arena.

**13.** With something still short on your Restock List and the At-Merchant reminder on, cross a loading screen **without visiting a merchant or the bank** — ride a boat or zeppelin, or step through an instance portal. No restocking line may print as the world loads. Failure is the *"N restocking orders outstanding."* headline turning up on arrival; the client fires the merchant- and bank-closed events on every loading screen, and that used to be enough to trigger the reminder.

When steps 1–13 pass on **both** Classic Era and TBC Anniversary, this release's changes are verified — proceed to `4 - Pre-Launch Review Prompt.md`.

## Core checks

**14.** Log in with Connoisseur enabled. No Lua error window and no red text; a colored welcome line must print in the shape *"Connoisseur // Version …"*. Type `/reload` — the UI must come back clean and the welcome line must print again. Failure is any error naming Connoisseur, or no welcome line.

**15.** Open the options from **every** entry point: type `/foodie`, Shift + Middle-Click the mini-map button, type `/crs config`, and pick Connoisseur from the Blizzard Options → AddOns category list. Each must open the settings **docked inside the Blizzard Options window**, with Connoisseur selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame — and **TBC Anniversary is the flavor that historically breaks this**, so a tester who runs only Era has not finished.

**16.** Pull a mob. While in combat, try `/foodie` and Shift + Middle-Click: each must print *"Connoisseur // As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must **not** open — but `/crs` alone must still open the Restocker window, because only the Options route is gated. Still in the fight, loot or receive a better consumable: no macro may rewrite and no error may appear, and pressing each macro must still use its item. Now leave combat: the pending rebuild must land within a second or two, and the options panel must **not** open by itself. Failure is the panel opening, silence instead of the message, a red `ADDON_ACTION_BLOCKED` error, or an update dropped so the macro stays stale.

**17.** Work through the mini-map button's clicks against its tooltip: Left-Click flips the Buff Food state, Shift + Left-Click flips Scroll Buffs, Right-Click ignores your current best food (the **Current Food** row must switch to the next-best), Middle-Click instantly clears the ignore list with no confirmation (deliberate), and Shift + Middle-Click opens the options. After each toggle, the Macros panel must agree with the tooltip. Failure is any click doing something its tooltip doesn't say, or the two views disagreeing.

**18.** Type `/crs` — the Restocker window must toggle open and closed. `/crs show` must open without toggling. `/crs help` must print every command with a description, no raw keys. `/crs profile` with nothing after it must print usage lines rather than erroring. Failure is a Lua error or a command that silently does nothing.

**19.** Loot, buy, or trade yourself a food better than your current pick. Within about a second the `- Food` macro — in the **General** macro tab — must rewrite to the new item, and the tooltip's Current Food row must agree. Then empty every food out of your bags and press `- Food`: chat must print *"Connoisseur // No suitable Food found in your bags."*, and each macro prints the same shape with its own category name when its category is empty. Failure is a macro that only updates after a `/reload`, macros landing in the character-specific tab, silence on an empty category, or the wrong category label.

**20.** *Warlock.* Read the `- Healthstone` and `- Soulstone` bodies' `/cast` lines, then right-click each. **On Classic Era the spell must be a bare full name** (such as `Create Healthstone (Minor)`) with no `(Rank N)`; **on TBC Anniversary it must be rank-pinned** (`Create Healthstone(Rank 3)`). This is the most-repeated bug in this add-on's history, and getting it wrong on Era makes the right-click **silently do nothing** — so test the click itself on both flavors, not just the body text.

**21.** With **more** of a Restock List item than your target, open a vendor: **nothing may ever be sold** — check bags and money before and after. With **less** than target and Buy on, open a vendor who stocks it: Connoisseur must buy up to the target and never past it. Hold Shift while opening the vendor: restocking must be skipped entirely. Failure is any item leaving your bags at a merchant, over-buying, or Shift being ignored.

**22.** With an item set to **Withdraw** and short in your bags, open the bank: the shortfall must move from bank to bags, ending with the "Restocking complete…" chat line. With an item set to **Deposit** and surplus in your bags, the surplus must move to the bank. Hold Shift while opening the bank: nothing moves. Failure is a silent finish, nothing moving, or Shift being ignored.

**23.** Set the At-Merchant reminder's dropdown to **Verbose** on the Restocker options page, then close a merchant window with something still short. Chat must print the *"N restocking orders outstanding."* headline followed by one line per short item — each a complete sentence with a working, clickable item link, no `nil`, no stray `%s`, and no half-rendered link. Failure is per-item lines missing in Verbose, or a broken link.

**24.** Open **Options → Diagnostic Tools** on a fresh login: the **Enable Diagnostic Tools** toggle must be **off**, and off again after a `/reload` — it is deliberately session-only. Tick it, click **Start Event Log**, spam a red combat error (press an ability that isn't ready, repeatedly), then click **Show Captured Events**: the spam must **not** appear as individual timestamped lines — read the `-- Suppressed (uncorrelated) traffic --` block at the end, where it must fold into one counted row (`x12`). Failure is diagnostics surviving a reload, or spam flooding the log line by line.

**25.** *Optional, non-English client.* Read the six options pages, the mini-map tooltip, and the Restocker window: every label and description must render in that language, with no raw key like `FEATURE_SCROLL_BUFFS` on screen. The Ignore List page is the newest copy — its description, the **Global** scope and its button, and the empty-list line all have to read in that language, and an item still loading must read as *"Loading ID: 12345"* with a real number in it. Trigger a few chat lines — the welcome line, a "No suitable … found" line, and the poison-reagent skip line from step 9 — each must read as one complete sentence with no `nil` and no stray `%s` or `%d`. The slash commands `/foodie` and `/crs`, the four URLs, and the names Discord, GitHub, CurseForge, and Wago stay **English on every client** — that is deliberate, not a missed translation.

This plan deliberately skips the deep per-class macro matrix (the Hunter Feed Pet cascade, Rogue poison hands, Druid DruidMacroHelper wraps, Night Elf stealth eating), the Starter List pop-up, Restock List level upgrades, per-character settings scope, and the Profiles panel — refresh coverage there when a release touches those systems.

When every step passes on **both** Classic Era and TBC Anniversary, manual testing is complete — proceed to `4 - Pre-Launch Review Prompt.md`.
