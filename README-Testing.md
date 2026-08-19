# Connoisseur — Manual Test Plan

This is the manual test plan for Connoisseur — the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Connoisseur/blob/main/README-Technical.md).

## How to run this plan

Run the whole list on Classic Era, then again on TBC Anniversary. Do a `/reload` before starting each flavor.

Work top to bottom. Every step tells you exactly what to do, what you should see, and what failure looks like — if a step doesn't match its expected result, it failed. Steps are numbered continuously from 1 to 264 across the whole document, so a bug report only needs "failed on step N."

**Start with "Verify this release's changes."** Those first 23 steps cover everything that changed since the last release, and they are where a regression is most likely to be waiting. If one of them fails, report it before running the rest — the standing sections will only pile noise on top of a build you already know is broken.

Several steps behave differently on the two clients and say so in the step itself. Those are not optional on either flavor — the client a step warns about is precisely the one where that step earns its keep. **A run on only one flavor is not a completed run.**

Connoisseur has class-gated and race-gated features, and the sections that cover them say so in their opening line. If you can't field the character a section needs, that section is **untested**, not passed — note it on the sign-off grid.

## Before you start

Gather these once so you aren't caught short mid-run:

- **Both flavors installed** — Classic Era and TBC Anniversary. The add-on ships for both, and both must be tested.
- **A character that was already using the previous release**, with settings it has changed, an ignore list, and a Restock List it has built up. This release deletes the one-time data conversions, so "does an existing player's data still load" is a real test and needs a real save file. Do **not** delete your SavedVariables before this run.
- **A character that has never run Connoisseur** — a fresh alt is ideal, for the opposite case.
- **At least eleven free macro slots in your General macro tab.** Connoisseur creates its macros there, shared by every character on the account. One step deliberately fills the tab, so have something you can delete afterwards.
- **A second character on the same account**, for the per-character vs account-wide settings checks. Any level, any class.
- **A character you can gain a level on** — a low-level alt with a quest ready to turn in is ideal. Two steps need an actual level-up, and nothing else triggers a Restock List upgrade.
- **A character at level 5 or below**, and one at **level 6 or above**, for the Starter List pop-up's level gate.
- **Class characters, for the class sections:** a **Mage** (conjure Food/Water/Mana Gem), a **Warlock** (Healthstone, Soulstone), a **Hunter with a living pet** (Feed Pet), a **Rogue who has trained Poisons** and can equip a weapon in each hand, a **Druid** who knows Bear and Cat form with [DruidMacroHelper](https://www.curseforge.com/wow/addons/druidmacrohelper) installed, and a **Night Elf who is not a Rogue** (Shadowmeld).
- **Consumables in your bags:** at least two tiers of food and two of drink, one buff food (something that grants Well Fed), three health potions of different strengths, two mana potions, a bandage, and an explosive. Poor-quality low-level items are fine — the tests are about which one gets picked, not how strong it is.
- **Professions:** a character with **First Aid** (bandages) and one with **Engineering** (explosives), plus a character with *neither*, for the negative tests.
- **Two or more different scroll types** (Scroll of Agility, Scroll of Stamina, etc.) on the character you use for the Food macro section.
- **Kibler's Bits or Sporeling Snacks** and a **level 55+ Hunter or Warlock with a live pet**, for the Pet Food Buffs section. Skip that section if you can't field one.
- **A second player**, for the party/raid restriction modes and the Ready Check section. A two-person party is enough.
- **A vendor who sells a stackable consumable you can afford**, plus **bank access with free slots in both bags and bank**, for the Restocker section. One step also needs a **completely full bank**, so be ready to fill it and empty it again.
- **An inn or a city you can walk into from outside**, for the in-town restock reminder. It fires on arrival, so you need to be somewhere else first.
- **Your game sound turned on**, for the restock alert.
- **A vendor who stocks poison reagents**, for the Rogue reagent-buying step.
- **Something to fight** — any open-world mob or a target dummy. Several steps need you to be genuinely in combat, not merely flagged.
- **A non-English client** — only for the optional localization spot-check at the end.

Unless a step says otherwise, be **out of combat, out of an arena, and with no target selected**.

## Verify this release's changes

This release deletes code rather than adding features: the one-time conversions that folded old saved data into the current layout are gone now that their window has closed, and five fallbacks for older game clients went with them — including the second route the options panel used to open through. The mini-map tooltip also changed shape: every "what am I carrying" row now puts its item on the right of its title instead of on a line below it. Because most of this is removal, the question every step below asks is *does the thing that used to be propped up still stand on its own.* Run these first, on both flavors.

**Your existing data still loads**

**1.** On the character that was already using the previous release, log in with this build. It must come up with **exactly the settings you left it on** — buff food, scrolls, poison types, thresholds, your ignore list, your mini-map button position — with no Lua error window and no red text. Failure is any setting silently back at its install value, which would mean an upgrading player loses their configuration.

**2.** Watch chat during that login. The line **"Imported your Restocker lists."** must **not** appear, on this or any character. That import is gone; if you still see it, the build you are testing isn't this one. Failure is that line printing at all.

**3.** Type `/crs` on the same character. Its Restock List must be the list you built, with each row's amount, its Withdraw / Deposit / Buy toggles, and its reputation setting exactly as you set them, and the **Profile:** dropdown on the profile you were using. Failure is an empty list, a row whose amount has changed on its own, or two rows for one item.

**4.** Open **Options → Diagnostic Tools**, tick **Enable Diagnostic Tools**, and click **Dump Saved Variables**. Exactly **two** tables may be dumped: `ConnoisseurDB` and `ConnoisseurRestockerDB`. A third block named `ConnoisseurCharDB` must **not** be there — that table is no longer loaded at all. A `migrationSeeded` entry inside `ConnoisseurDB`'s `global` block is a harmless leftover from the old conversion and is **not** a failure. Untick **Enable Diagnostic Tools** before moving on. Failure is a `ConnoisseurCharDB` block still being dumped.

**5.** Log in on the character that has never run Connoisseur. It must build its macros, land on its own profile named **Name - Realm**, and start from install defaults, with no error. Failure is an error on a first-ever login, or the character landing on a profile called "Default".

**Opening the options panel now has only one route**

**6.** Type `/foodie`. The panel must open **docked inside the Blizzard Options window**, with Connoisseur selected in the category list on the left. **This step is flavor-sensitive and matters more this release than it ever has — the second, older opening route was removed, so if the docking route isn't there the panel now falls straight through to a standalone floating window. TBC Anniversary is the client that has historically floated, so run this there and not just on Era.** Failure is a window floating free of the Options frame, or nothing happening at all.

**7.** Shift + Middle-Click the mini-map button. It must dock exactly as `/foodie` does. Failure is the two entry points disagreeing, or either one floating.

**8.** Type `/crs config`. Same result again — docked, same panel. Failure is a floating window from this route while `/foodie` docks.

**9.** With **Enable Diagnostic Tools** ticked, click **Test WoW API Endpoints** and find the row **Settings.OpenToCategory**. It must read `[PASS]` on the flavor you are testing. If it reads `[FAIL]`, that is the explanation for a floating panel in the three steps above, and both findings belong in the same bug report. Failure is a `[FAIL]` here.

**10.** Pull a mob and, while in combat, type `/foodie`. Chat must print *"Connoisseur // As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must not open — the combat refusal sits in front of the routing and was not touched by the removal. Failure is the panel opening, silence, or a red `ADDON_ACTION_BLOCKED` error.

**Everything the removed fallbacks used to cover**

**11.** Type `/crs`, then drag the Restocker window's bottom-right corner out and back in. It must resize smoothly and stop at a floor rather than collapsing. The older resize calls were deleted this release, so a window that can no longer be resized is exactly the regression this step is looking for. Failure is a grip that does nothing.

**12.** Click **Test WoW API Endpoints** again and read the resize rows. There must be **one** row, **Frame:SetResizeBounds**, and it must read `[PASS]`. A row named **Frame:SetMinResize (legacy)** must no longer be listed at all. Failure is that legacy row still appearing, or `SetResizeBounds` reading `[FAIL]` on a client where the window plainly resizes.

**13.** In the same report, find the container and item rows. **C_Container.GetContainerNumSlots**, **C_Item.GetItemCount** and **C_Item.GetItemIconByID** each have a `(legacy)` partner row; for each pair, **at least one half must `[PASS]`** — one half failing while its partner passes is correct and expected. There must be **no** `(legacy)` rows for `GetAddOnMetadata`, `GetAddOnInfo`, or `GetNumAddOns` any more. Failure is both halves of a pair failing, or a stale add-on-info legacy row still listed.

**14.** Click **List Installed Add-ons**. The box must fill with every installed add-on, each with a version and a load state — those three add-on-info calls are now made directly, with nothing to fall back on. Failure is an empty box, an error, or every version reading `?`.

**15.** Read the last line of the main **Connoisseur** panel. It must read **Version** followed by a version — a real number in a packaged build, or **"Version Dev"** in an unpackaged working copy. Failure is a blank, a `nil`, or a raw `2026.08.18.A` on screen.

**16.** Loot, buy, or trade yourself a food better than your current pick. Within about a second the `- Food` macro body must rewrite to the new item. This is the bag scan running through the container shim the removal touched. Failure is a macro that only updates after a `/reload`.

**The mini-map tooltip's new two-column rows**

**17.** Hover the mini-map button and read the **Current Food** row. The title **Current Food** must be on the **left** and the food's **icon and quality-coloured item link on the right of the same line** — not on a line of its own underneath. A blue **Right-Click / Ignore** row must sit below it. Failure is the item still on its own line, or the icon and the name splitting across the two columns with the icon left and the name right.

**18.** Empty every food out of your bags and hover again. The right-hand side of that row must read the single word **None**, and the sentence **"No suitable Food found in your bags."** must appear on its own wrapping line underneath it. Failure is a whole sentence sitting in the right-hand column, a blank right-hand side, or a raw `UI_NONE` on screen.

**19.** *Hunter or Rogue.* Check the class item rows the same way: a Hunter's **Current Pet Food**, and a Rogue's **Main Hand** and **Off Hand**. Each must be a title on the left with the item on the right, and must fall back to **None** plus the wrapping "No suitable …" sentence when nothing resolves. Failure is one of these rows keeping the old stacked layout while Current Food changed.

**20.** With something short on your Restock List, read the **Restocker Report** row. The count — **"1 Order Outstanding"** or **"N Orders Outstanding"** — must now sit on the **right of the Restocker Report title, on the same line**, and must match the number of short items in `/crs`. Failure is the count on its own line below the title, or a count that disagrees with the list.

**21.** Restock everything you are short of and hover again. The right-hand side must read **Fully Stocked** in green, with the full sentence **"Congratulations, you're fully stocked up!"** on the wrapping line beneath it. The same must show on a character with an **empty** Restock List. Failure is the section vanishing instead of answering, or the long sentence being pushed into the right-hand column.

**22.** Look at the tooltip as a whole while all of those rows have items in them. It must stay roughly as wide as an item tooltip. Failure is the box stretching most of the way across your screen — the right-hand column never wraps, so anything long that ends up there drags the whole tooltip out with it.

**Two reworded descriptions**

**23.** Open the **Macros** page and read two descriptions closely. Under **Enable Macro Names on Buttons** the sentence must end **"…which hides the names the game shows on its own."** — the older wording said Blizzard had "recently" started showing them, and must be gone. Under **Potions & Healthstones** the sentence must read **"each Potion and Healthstone macro"**, not "Potion & Healthstone". Both must be full sentences in your language on every client. Failure is either old wording surviving, a raw key in place of a description, or an untranslated English sentence on a non-English client.

When steps 1–23 pass on **both** Classic Era and TBC Anniversary, this release's changes are verified — proceed to `4 - Pre-Launch Review Prompt.md`.

## Loading, the AddOns list, and the settings panel

**24.** Log in with Connoisseur enabled. No Lua error window may appear, and no red error text may print in chat. Failure is any error popup naming Connoisseur, or the add-on missing from the AddOns list entirely.

**25.** Watch your chat frame at login. A welcome line must print in the shape *"Connoisseur // Version …. Settings (including the option to disable this message) can be found under Options > AddOns > Connoisseur…"*, with the name in blue, the `//` in grey, and the body in white. Failure is no message, an uncoloured line, or a line containing `nil` or a stray `%s`.

**26.** Open the character-select or in-game **AddOns** list and find Connoisseur. Its icon must render — the small Connoisseur artwork, not a blank square or a question mark. Failure is a missing icon, which means the icon path in the TOC doesn't match the file that shipped.

**27.** Type `/foodie`. The settings must appear **docked inside the Blizzard Options window**, with Connoisseur selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **This step is flavor-sensitive — TBC Anniversary is the client where the panel has historically floated free, so run it there and not just on Era.**

**28.** With Connoisseur selected, look at the category list. Five entries must be reachable and must open without error, in this order: the main **Connoisseur** panel, **Macros**, **Restocker**, **Profiles**, and **Diagnostic Tools**. Failure is a missing entry, an entry that opens blank, or an entry nested under the wrong parent.

**29.** Read the main **Connoisseur** page from top to bottom. It must hold only these, in this order: an intro paragraph, **Enable Welcome Message**, **Enable Mini-map Button**, a **/Commands** header, a **Ready Check** header with its description and the **Report Readiness on Ready Check** toggle, **Feedback & Support**, and a version line. Nothing about macros, buff food, scrolls, pet food, explosives, poisons, or the ignore list may appear on this page. Failure is any of those appearing here, or one of the seven above going missing.

**30.** Read every label and description across those five pages. Each must be a sentence or a label in your language. Failure is a raw key showing through — text like `OPTIONS_ENABLE_MACROS_HEADER` or `FEATURE_BUFF_FOOD` on screen instead of words — or a blank where a label belongs.

**31.** Read the **/Commands** section on the main page. `/foodie` must appear in blue followed by **"Opens the Options Interface for this add-on."**, and `/crs` in blue followed by **"Opens the Restocker window to manage your Restock List."** Failure is a missing command, a command with no description, or an uncoloured command.

**32.** Find the four rows under **Feedback & Support**, labelled **Discord**, **GitHub**, **CurseForge**, and **Wago**. Each must be **a label on the left and its URL box on the right, on one line**, all four boxes beginning at the same left edge and ending at the same right edge, each showing its complete address with nothing cut off. Click into one, select all, and copy — the copied address must be the full link. Failure is a label sitting above its box, boxes of differing widths, an address truncated at the edge of the field, or a link pointing somewhere unrelated to this add-on.

**33.** Type junk into one of those boxes and press Enter, then click to another panel and back. The box must show its original URL again. These are display fields you copy from, never fields you edit. Failure is your typed text sticking.

**34.** Read the last line of the main panel. It must read **Version** followed by a version. In an unpackaged working copy it correctly reads **"Version Dev"**; in a packaged release build it must read a real version number. On a non-English client the word "Version" must be translated, while `/foodie`, `/crs`, the four URLs, and the names Discord, GitHub, CurseForge, and Wago must all stay **English** — that is deliberate, not a missed translation. Failure is a raw key, or a translated slash command, which would simply stop working.

**35.** Read the **Ready Check** section on the main page. It must have a header, a description explaining what gets reported, and the **Report Readiness on Ready Check** toggle. Failure is a missing description, or the toggle sitting on the Macros page instead.

**36.** Untick **Enable Welcome Message**, tick **Prioritize Buff Food** on the Macros page, and set the **Explosives** dropdown there to **Left-Click Toss**. Type `/reload` and reopen both panels. All three must have held their new values. Failure is any of them reverting, which means the setting isn't being saved.

**37.** Log out fully and log back in on the same character. **No welcome line may print**, and the three settings from the previous step must still hold. Failure is the welcome message appearing anyway, or settings surviving a reload but not a relog.

**38.** Restore the settings you changed — welcome on, buff food off, Explosives back to **Left-Click @player**. Each must take effect as you set it, and the `- Explosives` macro body must rewrite to match. Type `/reload`: the UI must come back with no error window and no red text, the welcome line must print again, `/foodie` must still open the panel, and your macros must still be in the General tab. Failure is a setting that won't go back, an error on reload, or a macro that vanished.

## The Macros panel

**39.** Open the **Macros** page and read it top to bottom: an intro paragraph, **Enable Macro Names on Buttons**, **Enable Macros**, **Potions & Healthstones**, **Buff Re-Application**, **Buff Food**, **Scroll Buffs**, **Pet Food Buffs**, **Explosives**, **Ignore List**, then whichever of **Druids**, **Rogues**, and **Night Elves** your character qualifies for. Failure is a section out of order, a section missing, or a class section showing for the wrong class.

**40.** Read the **Enable Macros** section. It must list one toggle per macro, all ticked, labelled with the macro names themselves: `- Bandage`, `- Explosives`, `- Food`, `- Health Potion`, `- Healthstone`, `- Mana Gem`, `- Mana Potion`, `- Soulstone`, `- Water`, plus `- Feed Pet` **only on a Hunter** and `- Poisons` **only on a Rogue**. Failure is a Hunter-only or Rogue-only toggle showing on the wrong class, or a macro with no toggle.

**41.** Read the **Potions & Healthstones** section. It must carry the **Combine Healthstones into Health Potion Macro** toggle and a description explaining that macros can't change during combat and that the icon can go stale on long fights while the click still uses your best item. Failure is a missing or raw-key description.

**42.** Tick **Re-Apply Expiring Buffs**. A dropdown must appear **on the same row, to the right of the toggle, with no caption of its own**, reading **When < 2 Minutes Left**. Open it: exactly five values, each beginning with "When <" — When < 1 Minute Left, then When < 2, 3, 4, and 5 Minutes Left. Untick the toggle and the dropdown must disappear. Failure is a caption above the dropdown, a value reading "< 2 Minutes Left" without the leading "When", a wrong default, or a dropdown that lingers once the feature is off.

**43.** Tick **Prioritize Buff Food**. An unlabelled dropdown must appear on the same row offering **Always**, **Only when in a Party or Raid**, and **Only when in a Raid**, in that order, defaulting to Always. The same dropdown must appear beside **Include Scroll Buffs** and **Use Pet Food Buffs** when you tick those. Failure is a missing dropdown, a different set of choices, or a different order.

**44.** Tick **Include Scroll Buffs**. An **Include Scroll Types in Check** group must appear with six ticked boxes: Agility, Intellect, Protection, Spirit, Stamina, Strength. Untick the feature — the group must disappear. Failure is the group persisting, or a missing scroll type.

**45.** Tick **Use Pet Food Buffs**. An **Include Pet Food Types in Check** group must appear with two ticked boxes: **Kibler's Bits** and **Sporeling Snacks**. Failure is a missing entry or the group not appearing.

**46.** Read the **Explosives** dropdown. It must default to **Left-Click @player, Right-Click Toss** and offer exactly one alternative, **Left-Click Toss, Right-Click @player**. Then look at the class and race sections at the bottom of the page: **Druids** must appear only on a Druid, **Rogues** only on a Rogue, and **Night Elves** only on a Night Elf who is not a Rogue. Failure is any other Explosives default or a third entry, or a class section appearing for a character it doesn't apply to.

## Options Interface in combat

The panel is protected by the client during combat, so Connoisseur refuses rather than letting you hit a blocked-action error. Every route in is gated the same way.

**47.** Pull a mob and, while in combat, type `/foodie`. Chat must print *"Connoisseur // As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must not open. Failure is the panel opening, silence, or a red `ADDON_ACTION_BLOCKED` error.

**48.** Still in combat, Shift + Middle-Click the mini-map button. Identical result — same line, no panel. Failure is the two entry points disagreeing.

**49.** Still in combat, type `/crs config`. Identical result again. Then type `/crs` alone: the Restocker window must still open, because only the Options route is gated. Failure is `/crs config` opening the panel, or `/crs` refusing.

**50.** Leave combat. The panel must not open by itself. The refusal is final, never a queued open that fires later. Failure is the panel appearing on its own a few seconds after the fight.

## Settings scope — per character vs account-wide

Five Connoisseur settings are account-wide: **Enable Welcome Message**, **Enable Mini-map Button**, **Enable Macro Names on Buttons**, **Report Readiness on Ready Check**, and every **Enable Macros** toggle. Everything else on the Macros panel is per character. The whole **Restocker** options page is account-wide, but each character keeps its own Restock List.

**51.** On character A, tick **Prioritize Buff Food**, tick **Include Scroll Buffs**, and tick **Re-Apply Expiring Buffs**. Log out and log in on character B on the same account, and open the Macros panel. All three must be **off** on B — these are per-character consumable choices. Failure is B inheriting A's settings.

**52.** Still on character B, untick **Enable Welcome Message**. Log back to character A and open the panel. It must now be **unticked on A too**. Failure is A still showing it ticked. Re-tick it before continuing.

**53.** On character A, untick **Enable Macros → `- Bandage`**. The `- Bandage` macro must vanish from your General macro tab immediately. Log in on character B: the macro must still be gone and the toggle must still be unticked, because the macros live in the shared General tab. Failure is B recreating the macro, or B showing the toggle ticked.

**54.** Re-tick `- Bandage` on character B. The macro must reappear in the General tab within a second or two, with a body built from **B's** bags — not A's. Failure is the macro not returning, or returning with an item B doesn't have.

**55.** Untick **Enable Mini-map Button** on character A, then log in on character B. The button must be hidden there too. Re-tick it before continuing. Failure is the button reappearing on B.

**56.** On character A, untick **Enable At-Bank Restock Reminders** on the Restocker page and add a distinctive item to that character's Restock List. Log in on character B: the reminder toggle must still be **unticked**, and B's Restock List must **not** contain that item. Failure is the toggle resetting, or one character's shopping list following you around the account.

## Slash commands

**57.** Type `/crs`. The Restocker window must toggle open, and typing it again must close it. Failure is a command that only ever opens, or one that errors.

**58.** Type `/crs show`. The Restocker window must open, and stay open if it was already open — this command shows, it doesn't toggle. Failure is the window closing.

**59.** Type `/crs config`. Connoisseur's options panel must open, exactly as `/foodie` does. Failure is nothing happening.

**60.** Type `/crs help`. Chat must print a list of every `/crs` command with a description for each: `show`, `config`, and the five `profile` subcommands (`add`, `delete`, `rename`, `copy`, `use`). Failure is an empty print, a command with no description, or a raw key like `RESTOCKER_HELP_SHOW` in the output.

**61.** Type `/crs profile` with nothing after it. Chat must print the five profile usage lines rather than doing anything. Then type `/crs profile add` with no name — it must print that one usage line, not error. Failure is a Lua error on either.

## Mini-map button

**62.** Hover the mini-map button and read the tooltip top to bottom. It must show, in order: **Connoisseur** with the version on the right; a **Buff Food** row with **Enabled** or **Disabled** on the right, a description line, and a blue **Left-Click / Toggle** row; a **Scroll Buffs** row with the same shape and a **Shift + Left-Click / Toggle** row; a **Current Food** row; then your class block if you have one; then a **Restocker Report** row; and finally **Connoisseur Options** with **Shift + Middle-Click** under it. Failure is a missing section, a state that reads neither Enabled nor Disabled, raw keys instead of words, or a slash command shown anywhere in the tooltip.

**63.** Read the **Current Food** row. The title must be on the left and an item icon plus a clickable item link on the right of the same line, naming the food the `- Food` macro is currently set to, with a **Right-Click / Ignore** row beneath it. If you truly have no food in bags the right-hand side must read **None** and the line below must read "No suitable Food found in your bags." Failure is a blank row, or a food named here that disagrees with the `- Food` macro body.

**64.** Left-click the mini-map button. The Buff Food state in the tooltip must flip between Enabled and Disabled, and the **Prioritize Buff Food** toggle on the Macros panel must agree. Failure is the tooltip not updating, or the panel disagreeing with the tooltip.

**65.** Shift + Left-click the button. The Scroll Buffs state must flip, and **Include Scroll Buffs** on the Macros panel must agree. Failure is the same as above, or Shift + Left-click toggling Buff Food instead.

**66.** With food in your bags, Right-click the button. The current best food must be added to the ignore list, the **Current Food** row must switch to your *next*-best food, and an **Ignore List** section must appear in the tooltip naming the ignored item with its icon and quality colour. Failure is nothing changing, or the same food still being picked.

**67.** Middle-click the button. The Ignore List section must disappear entirely and Current Food must return to the food it named before. Failure is the list surviving, or the tooltip needing a reload to catch up.

**68.** Shift + Middle-click the button. The options panel must open, docked, exactly as `/foodie` does. Failure is nothing happening, or the ignore list being cleared instead — Shift + Middle-click is checked before plain Middle-click and must win.

**69.** With something short on your Restock List, read the **Restocker Report** row. It sits between your class block and the **Connoisseur Options** block, and must show **"1 Order Outstanding"** or **"N Orders Outstanding"** on the right of its title, matching the number of short items in `/crs`. Failure is a missing row or a count that disagrees with the list.

**70.** Restock everything you're short of and hover again. The right-hand side must read **Fully Stocked** in green, with "Congratulations, you're fully stocked up!" underneath. It must read the same on a character with an **empty** Restock List. Failure is the row vanishing instead of answering.

**71.** Look at the button's icon, then loot or buy a clearly better food so the macro's pick changes. The icon must change to match the new best food without a `/reload`. Failure is a frozen icon.

**72.** Drag the mini-map button to a different spot on the mini-map ring, then `/reload`. It must return to where you dragged it. Failure is the button snapping back to its old position.

**73.** Untick **Enable Mini-map Button** on the main panel. The button must disappear immediately. Re-tick it — it must return to the same spot. Failure is a button that needs a reload to hide or show.

## The macros themselves

**74.** Open the macro window and confirm every Connoisseur macro is in the **General** tab, not the character-specific tab. Failure is any of them in the per-character tab — they'd stop being shared across the account.

**75.** Read each macro name. None may exceed 16 characters and each must begin with `- `. Failure is a truncated or renamed macro.

**76.** Loot, buy, or trade yourself a food better than your current pick. Within about a second the `- Food` macro body must rewrite to the new item, and the action-bar icon must follow. Failure is a stale macro that only updates after a `/reload`.

**77.** Open the Blizzard macro window (`/macro`), click the **General** tab, select `- Food`, and leave the window open while you loot a better food. The body on screen must **not** change while the window is open, and no Lua error may appear. Close the window — the rebuild must land within a second or two, without a `/reload`, and `- Food` must then name the better food. Failure is a macro left on the old item, which is the stale-macro failure this deferral exists to prevent; failure is also a rewrite happening while the window is open, because the frame would save the old text straight back over it.

**78.** With `/macro` open and `- Food` selected, right-click the mini-map button to ignore the current best food — a forced rebuild arriving while the window is open. Close the window and read the body: it must name your **next**-best food. Failure is a body still on the ignored item.

**79.** Open `/macro`, select any Connoisseur macro, type junk into its body, and close the window. Connoisseur must overwrite it with a correct body. Then `/reload` and read every macro you touched in the last three steps — each must still hold a correct body. Failure is your junk surviving, or a body that looked right until the UI rebuilt.

**80.** Untick **Enable Macros → `- Explosives`**. The macro must be **deleted** from the General tab, not just emptied. Re-tick it — it must be recreated with a working body. Failure is an orphaned empty macro left behind, or one that doesn't come back.

**81.** Tick **Enable Macro Names on Buttons** on the Macros panel. The macro name text must appear under the icon on your default action bar buttons immediately. Untick it — the text must vanish immediately, and must still be hidden after a `/reload`. Failure is either direction needing a `/reload`, or the names reappearing on reload.

**82.** Fill your General macro tab with junk macros until it is completely full, then trigger a rebuild (loot something, or `/reload`). A chat line must print explaining that some Connoisseur macros couldn't be created because your macro slots are full, and pointing at the Enable Macros section. It must print **once**, not repeatedly. Failure is silence, or the message spamming every update.

**83.** Delete one junk macro to free a slot, then loot something to trigger a rebuild. The missing Connoisseur macro must be created automatically, with no `/reload` needed. Delete the rest of your junk macros, then log in on a different character with a different set of consumables: the macro **count** must not change — no macro added, none removed — but the bodies must rewrite to that character's own best items. Failure is a macro that only appears after a reload, macros being deleted and recreated on a character switch, or bodies still naming the previous character's items.

## Food macro

**84.** With several foods in your bags, read the `- Food` macro body. The `/use item:` number must match the food named in the mini-map tooltip's Current Food row. Failure is the two disagreeing.

**85.** Empty every food out of your bags and press the `- Food` macro. Chat must print *"Connoisseur // No suitable Food found in your bags."* Failure is silence, a red error, or a message naming the wrong category.

**86.** Put a buff food (one that grants Well Fed) and a stronger plain food in your bags, and tick **Prioritize Buff Food**. With **no** Well Fed buff on you, the macro must pick the **buff food** even though the plain food restores more. Failure is the plain food winning.

**87.** Eat the buff food to full so you have the Well Fed buff, and wait for the macro to rebuild. It must now pick the **plain food** — buff food only competes while the buff is missing. Failure is the macro still offering buff food you don't need.

**88.** Target **yourself**, then trigger a rebuild. The macro must skip buff food and scrolls and revert to plain food. Failure is buff food or scroll mode surviving a self-target.

**89.** Set the Buff Food dropdown to **Only when in a Raid** and stand ungrouped. Buff food must stop being preferred. Group up as a party of two — still not preferred. Convert to a raid — it must be preferred again. Failure is any of the three states behaving like another.

**90.** Tick **Include Scroll Buffs** with at least two different scroll types in your bags and none of those buffs on you. The `- Food` macro must switch entirely to scroll mode: the body must be `#showtooltip` followed only by `/use [@player] item:` lines, one per missing scroll, with **no** food line. Failure is a body that still contains food, or one missing a scroll you're carrying.

**91.** Read the order of those scroll lines. They must fire in this order: **Agility, Strength, Protection, Intellect, Spirit, Stamina** — skipping any type you don't have or have unticked. Failure is a different order.

**92.** Press the macro once. Every missing scroll must be applied to **you** in one press, off the global cooldown, regardless of what you have targeted. Failure is only one scroll firing, or a scroll landing on your target.

**93.** With all those buffs now on you, wait for the rebuild and read the body again. It must have flipped back to the normal food form. Failure is the macro staying stuck in scroll mode.

**94.** Untick a scroll type in **Include Scroll Types in Check** while missing that buff. The macro must stop offering that scroll but keep offering the others. Failure is the unticked type still appearing in the body.

**95.** With scrolls missing, target a **friendly player**. The macro must revert to food mode so a Mage can right-click to conjure for a friend without firing scrolls on themselves. Drop the target — scroll mode must return. Failure is scroll mode surviving a friendly target.

**96.** Get a class buff that covers the same stat as one of your scrolls at an equal or greater value (for example a Paladin's Blessing of Kings against a Scroll of Strength). That scroll must be skipped while the class buff holds, and the others must still fire. Failure is a wasted scroll.

**97.** *Hunter or Warlock, level 55+, with a live pet.* Tick **Use Pet Food Buffs** with Kibler's Bits or Sporeling Snacks in your bags and no Well Fed buff on your pet. The `- Food` macro's use line must become `/use [@pet] item:` with the pet food's ID. Press it — your **pet** must be fed, not you. Failure is the food targeting you, or the override not applying.

**98.** With both a missing scroll buff **and** a hungry pet, read the body. Scrolls must win — the macro must be in scroll mode, with the pet food waiting for the next press. Failure is pet food firing while scrolls are still missing.

**99.** Take your pet's level above the food, or dismiss the pet, and rebuild. The pet override must drop and the macro must return to feeding **you**. Failure is a `[@pet]` line with no pet.

**100.** *Rogue, or a Night Elf who is not a Rogue.* Tick **Enable Stealth Eating**. The Food macro body must gain a `/cast [nostealth] ` line naming **Stealth** on a Rogue or **Shadowmeld** on a Night Elf. Press it out of stealth — you must stealth and eat. Failure is the wrong ability, or no line at all.

**101.** *Arena only, and optional.* Enter an arena with Buff Food, Scroll Buffs, and Pet Food Buffs all on. All three must be suppressed inside the arena and the macro must be plain food. Failure is buff food or scrolls firing in an arena.

## Water macro

**102.** With two drinks of different strength in your bags, the `- Water` macro must pick the stronger one, and its body must be `#showtooltip item:` plus a `/use item:` line. Press it — you must drink. Failure is the weaker drink winning, or nothing happening.

**103.** Put a hybrid food-and-drink item (a Mage's conjured Mana Strudel, or a Sunfruit-style item) in your bags alongside a dedicated drink of the same value. `- Water` must prefer the **dedicated** drink while `- Food` prefers the **hybrid** — one bag slot covering both needs. Failure is both macros picking the same item when a dedicated one is available.

**104.** *Night Elf who is not a Rogue.* Tick **Enable Stealth Drinking**. The `- Water` body must gain `/cast [nostealth] Shadowmeld` under the drink line. On a **Night Elf Rogue** this toggle must not be visible at all — Rogues get the Rogues section instead. Failure is the toggle appearing for a Rogue, or the line appearing on a non-Night-Elf.

## Potions, Healthstones, and the multi-use fallback

**105.** With three health potions of different strengths in your bags, read the `- Health Potion` body. It must contain **three** `/use item:` lines, strongest first. Failure is only one line, or the weakest potion listed first.

**106.** Press the macro. Exactly **one** potion must be consumed — the strongest. Failure is two potions being drunk on one press.

**107.** Enter combat, drink your last strong potion, and press the macro again while still in combat. It must fall through and drink the next-best potion, because macros can't be rewritten mid-fight. Failure is a dead button.

**108.** Do the same for `- Mana Potion` with two mana potions: two ranked lines, strongest first, one consumed per press. Failure is the same as above.

**109.** *Warlock, or anyone carrying a Healthstone.* Tick **Combine Healthstones into Health Potion Macro**. The `- Health Potion` body must gain the Healthstone's `/use item:` line **below** the potion lines. Press it once — a potion **and** a Healthstone must both be consumed, since they're on separate cooldowns. Failure is only one of the two firing, or the stone line landing above the potions.

**110.** Read the `- Health Potion` body with stacking on and three potions in bags. The whole body must fit the macro limit with nothing cut off mid-line, and the **first** `/use` line must always be present. Failure is a body cut off mid-line, or the rank-1 potion line missing.

**111.** Press `- Healthstone` and `- Mana Gem` with the item in bags. Each must use it. With the category emptied, each must print its own "No suitable … found in your bags." line rather than doing nothing. Failure is a silent dead button.

**112.** Read the **Potions & Healthstones** description on the Macros panel. It must read as one sentence explaining that macros cannot change during combat and that each **Potion and Healthstone** macro is pre-built with your best item plus up to two fallbacks. Failure is a broken sentence or a raw key.

## Bandages and Explosives

**113.** On a character **with First Aid**, with a bandage in bags, `- Bandage` must name that bandage. On a character **without First Aid**, the same macro must find nothing — press it and chat must print "No suitable Bandage found in your bags." Failure is a bandage being offered to someone who can't use it.

**114.** Carry two bandages your First Aid skill covers, one stronger than the other. The stronger must win. Now carry one whose required skill is **above** your level — it must be ignored. Failure is an unusable bandage being picked.

**115.** On a character **with Engineering** and a bomb in bags, `- Explosives` must name it. On a character **without** Engineering, only an Ez-Thro-style explosive (usable by anyone) may be picked; a normal bomb must not be. Failure is a non-Engineer being handed a bomb they can't throw.

**116.** With two explosives of different damage, the higher-minimum-damage one must win. Failure is the weaker bomb being chosen.

**117.** With the Explosives dropdown on **Left-Click @player, Right-Click Toss**, read the macro body. Its use line must place `[@player]` on the default (left) click. Press it — the explosive must go off **at your feet with no targeting reticle**. Right-click must give you the normal reticle. Failure is a reticle on left-click.

**118.** Switch the dropdown to **Left-Click Toss, Right-Click @player**. The body must rewrite immediately and the two clicks must swap behaviour. Failure is the body not changing, which means the click layout isn't in the macro's state.

**119.** Bind `- Explosives` to a key and press the key. It must behave exactly like a **left**-click. Failure is a keybind behaving like a right-click.

## Mages

*Mage only.* Skip this section on any other class, and mark it untested on the sign-off.

**120.** Hover the mini-map button. A class block headed **Attention Mages** must appear, in Mage blue, with a line naming your Food, Water, and Mana Gem macros and one instruction per line. Failure is a missing block, or tips for a class you aren't.

**121.** With no target, right-click the `- Food` macro. You must begin casting Conjure Food at the highest rank you know. Do the same on `- Water` for Conjure Water. Failure is the click doing nothing, or casting the wrong spell.

**122.** Read the `- Food` body and find its conjure line. On **both** flavors the spell must be rank-pinned, in the shape `Conjure Food(Rank N)`. Failure is a bare spell name with no rank, which would always conjure the highest rank regardless of target.

**123.** Target a **lower-level friendly player** and right-click `- Food`. The rank must drop so the conjured item is one they can actually use — check the body rewrote to a lower `(Rank N)` while they're targeted. Failure is the rank staying pinned to your own level.

**124.** Right-click `- Mana Gem`. You must conjure a mana gem. Right-click **again** while holding that gem — because gems are unique, it must conjure the **next rank down** rather than failing. Failure is a red "you already have one" error on the second press.

**125.** Middle-click `- Food` or `- Water`. **On TBC Anniversary at level 70** you must cast Ritual of Refreshment. **On Classic Era the spell does not exist**, so the middle-click must do nothing at all and print nothing. Failure on Era is a chat line naming a spell you can never learn; failure on Anniversary is the ritual not casting.

**126.** On a Mage below the level for Conjure Water, right-click `- Water`. Chat must print *"You don't currently know Conjure Water."* Failure is silence or a wrong spell name.

## Warlocks

*Warlock only.* Skip this section on any other class, and mark it untested on the sign-off.

**127.** Hover the mini-map button. A class block headed **Attention Warlocks** must appear in Warlock purple, naming your Healthstone and Soulstone macros. Failure is a missing or wrong-class block.

**128.** Right-click `- Healthstone`. You must begin casting Create Healthstone. Right-click again while holding that stone — it must create the **next rank down** rather than failing on the duplicate. Failure is a red duplicate error on the second press.

**129.** **This is the highest-risk step in the plan, and the reason both flavors matter.** Read the `- Healthstone` body's `/cast` line. **On Classic Era it must be a bare, fully-named spell** such as `Create Healthstone (Minor)` with **no** `(Rank N)` appended. **On TBC Anniversary it must be rank-pinned**, in the shape `Create Healthstone(Rank 3)`. Failure on Era is a `(Rank N)` suffix, which builds a spell name that doesn't exist and makes the right-click **silently do nothing** — no error, no cast. Test the click itself on both flavors, not just the body text.

**130.** Right-click `- Soulstone`. You must create a Soulstone at the best rank you know. Read the body and apply the same Era-vs-TBC rule as the previous step: bare name on Era, `(Rank N)` on Anniversary. Failure is the same silent no-op.

**131.** Middle-click `- Healthstone`. **On TBC Anniversary at level 68+** you must cast Ritual of Souls. **On Classic Era the spell does not exist**, so nothing must happen and nothing must print. Failure is a chat line on Era naming a spell you can never learn.

**132.** On a Warlock below level 18, right-click `- Soulstone`. Chat must print *"You don't currently know Create Soulstone…"* using the client's own spell name. Failure is silence, or a raw spell ID in the message.

## Hunters

*Hunter only.* Skip this section on any other class, and mark it untested on the sign-off.

**133.** Hover the mini-map button. A class block headed **Attention Hunters** must appear in Hunter green, and below it a **Current Pet Food** row naming — on the right of its title — the food the macro will feed. Failure is a missing block, or a pet food named here that disagrees with the macro body.

**134.** With a living pet out and pet food in bags, left-click `- Feed Pet`. Your pet must be fed. Failure is nothing happening, or a red "your pet doesn't like that" error.

**135.** Check which food it chose. It must be the **lowest-level food that still gives maximum happiness** — not the most expensive one you own. Failure is an unnecessarily good food being burned.

**136.** Put a food in your bags that is an objective for a quest in your log, and make it the food the rule above would otherwise pick. It must be **skipped**. Failure is the macro eating your quest items.

**137.** Dismiss your pet and press the macro. It must Call Pet. Now let your pet die, dismiss it, and press again — it must switch to **Revive Pet** on its own. Failure is the macro still trying to Call a dead pet.

**138.** Right-click the macro with a live pet out, and separately press it while in combat. Both must cast **Mend Pet**. Hold **Shift** and press — it must force **Revive Pet**. Hold **Ctrl** and press — it must **Dismiss** the pet. Failure is any modifier doing the wrong thing.

**139.** On a Hunter below level 10 (before the pet quests), read the body. It must be a two-line stub that prints *"You don't currently know Call Pet, Dismiss Pet, Feed Pet, or Revive Pet."* when pressed. On a level 10–11 Hunter without Mend Pet, right-click must print *"You don't currently know Mend Pet."* rather than silently doing nothing. Failure is a macro that references spells the Hunter can't cast.

**140.** With no usable pet food in bags, press the macro. Chat must print *"You don't currently have any food that is useful for your pet."*, and the tooltip's **Current Pet Food** row must read **None** with the "No suitable Pet Food found in your bags." sentence beneath it. Failure is silence, or a blank row.

## Rogues

*Rogue only, with the Poisons skill trained.* Skip this section on any other class, and mark it untested on the sign-off.

**141.** Hover the mini-map button. A class block headed **Attention Rogues** must appear in Rogue yellow, followed by a **Main Hand** and an **Off Hand** row, each naming on its right the poison that hand will get, or reading **None** with "No suitable Poison found in your bags." beneath it. Failure is a missing block or a blank row.

**142.** Open the Macros panel's **Rogues** section. Two dropdowns — **Main Hand Poison Type** and **Off Hand Poison Type** — must each offer six choices named in your client's own language: Anesthetic, Crippling, Deadly, Instant, Mind-numbing, and Wound Poison, defaulting to **Instant Poison**. Failure is a missing type, an English name on a non-English client, or a raw number showing as a choice.

**143.** With a weapon in each hand and the matching poisons in your bags, **left**-click `- Poisons`. Your **Off Hand** must be poisoned. **Right**-click — your **Main Hand** must be poisoned. Failure is the hands being crossed.

**144.** With a poison already on a weapon, press the macro for that hand again. The existing poison must be replaced automatically, with no confirmation popup left on screen for you to click. Failure is a popup you have to dismiss by hand.

**145.** **Middle**-click the macro. The Poisons crafting window must open. Failure is nothing happening on a Rogue who knows Poisons.

**146.** Empty the selected poison type for one hand out of your bags. Clicking **that** hand's button must print *"You're out of the selected poison for this weapon."* while the **other** hand still works normally. Failure is both hands going dead, or silence on the empty one.

**147.** Carry a poison rank above your level. It must be ignored in favour of the best rank you can actually use. Failure is an unusable poison being selected.

## Druids

*Druid only, with DruidMacroHelper installed.* Skip this section on any other class, and mark it untested on the sign-off.

**148.** Open the Macros panel's **Druids** section and tick **Enable DruidMacroHelper Integration**. A dropdown must appear beside the toggle, with **no caption of its own**, offering exactly **Return to Bear** and **Return to Cat** and defaulting to Return to Bear. Failure is a missing dropdown, a caption above it, a third option, or values reading just "Bear" and "Cat".

**149.** Read the `- Health Potion`, `- Mana Potion`, and `- Healthstone` bodies. Each must now begin with `/dmh` guard lines and end with a `/cast !` line naming your chosen form followed by `/dmh end`. Failure is any of the three left un-wrapped, or a wrapped macro whose last line is missing.

**150.** In Cat or Bear form, press `- Health Potion`. You must powershift out, drink, and shift back to the form you chose. Change the dropdown to **Return to Cat** and confirm the return form changes in both the body and in play. Failure is being left in caster form.

**151.** Untick the integration. All three macros must return to their plain bodies. Failure is a leftover `/dmh` line.

## Night Elves

*Night Elf who is not a Rogue.* Night Elf Rogues use the Rogues section instead.

**152.** Open the Macros panel. A **Night Elves** section must be visible with **Enable Stealth Drinking**, **Enable Stealth Eating**, and a grey pro tip explaining to pick one because eating or drinking after you stealth breaks stealth. On a Night Elf Rogue this section must be **absent**. Failure is the section showing for a Rogue or missing for a Night Elf.

**153.** Tick both toggles and press first `- Water`, then `- Food`. Each must Shadowmeld and then drink or eat. Failure is either macro missing its Shadowmeld line.

## Ignore list

**154.** With nothing ignored, open **Macros → Ignore List**. You must see the header, a description sentence, a **Clear Ignore List** button that is **greyed out**, the line **"This list is empty."**, and an **Add by Item ID** row with a text box beside it. Failure is a clickable Clear button over an empty list, or a missing "empty" line.

**155.** Right-click the mini-map button to ignore your current best food, then come back to this section. A row must have appeared showing the item's **icon and its quality-coloured name**, the "This list is empty." line must be gone, and **Clear Ignore List** must now be clickable. Failure is the ignore landing in the tooltip but never reaching this panel.

**156.** Type a food's item ID into **Add by Item ID** and press Enter. The item must be added as a row and the box must clear itself. If the client hasn't seen that item before, the row may briefly read a grey **"Loading ID: …"** — it must resolve to the real icon and name on its own within a few seconds, **without reopening the panel**. Failure is a row stuck on the loading text.

**157.** Type a word that isn't an item ID into that box and press Enter. **Nothing** may be added, no Lua error may appear, and you must be told **"Type an item ID, or Shift + Click an item link in chat."** Failure is a dead row appearing for a number that is not an item.

**158.** Click into the **Add by Item ID** box, then Shift + Click an item link in your chat frame. The link must drop into the box; press Enter and that item must be added. Failure is the Shift + Click going nowhere, or the box refusing a whole item link.

**159.** Hover the small icon at the right-hand end of a row. Its tooltip must read **Remove**. Click it — that one row must disappear, with no confirmation prompt, and the item must become selectable again. Failure is a confirm popup on a single-row removal, or the row surviving.

**160.** With several foods in bags, right-click the mini-map button to ignore the current best. Read the `- Food` body — it must now name a **different** item. Failure is the macro still using the ignored food.

**161.** Ignore two more foods the same way. The tooltip's **Ignore List** section must list all three, sorted alphabetically, each with its icon and quality colour, and the **Macros → Ignore List** section must show the same three rows. Failure is a missing entry, an unsorted list, or the two views disagreeing.

**162.** Add a fourth item from the panel instead, using **Add by Item ID**. It must appear in the mini-map tooltip's Ignore List too, and the `- Food` macro must stop picking it. Failure is a panel-added ignore that the scanner never honours.

**163.** `/reload`. The ignore list must survive. Failure is it emptying itself.

**164.** Log in on a **different character**. The ignore list must be **empty** there — it's a per-character setting. Failure is one character's ignores following you around the account.

**165.** Middle-click the mini-map button. The list must clear, the section must disappear from the tooltip, the panel must show "This list is empty.", and the previously-ignored food must be selectable again. Failure is a list that survives the clear.

**166.** Ignore something again, then click **Clear Ignore List** on the panel. A confirmation reading **"Remove every item from your Ignore List?"** must appear. Confirm it — every row must go, "This list is empty." must return, the button must grey out again, and the **Ignore List** section must disappear from the mini-map tooltip. Failure is the list clearing with no confirmation at all, or the tooltip needing a `/reload` to catch up.

## Buff Re-Application

**167.** Tick **Re-Apply Expiring Buffs** and set the threshold to **When < 5 Minutes Left**. With a Well Fed buff on you that has **more** than five minutes remaining, the Food macro must offer plain food. Failure is buff food being offered against a healthy buff.

**168.** Wait until that Well Fed buff drops under five minutes. The macro must now treat it as expired and offer **buff food** again. The same rule must apply to scrolls and pet food. Failure is having to lose the buff entirely before the macro reacts.

## Ready Check

**169.** In a party of two, with **Report Readiness on Ready Check** ticked, have your partner start a ready check. Exactly one line must print in **your** chat frame only, in the shape *"Connoisseur // Missing: … // Well Fed 12 min"*. Ask your partner — they must **not** have seen it. Failure is anything reaching group chat; this add-on has no cross-player chat path at all.

**170.** With every tracked buff up, run another ready check. The line must read *"Ready to go!"* followed by the remaining time on each tracked buff. Failure is an all-clear that still lists something missing.

**171.** Turn off Buff Food and Scroll Buffs, then run a ready check. Those two must vanish from the report entirely — a feature you've switched off is never reported on. Failure is the line nagging you about buffs you don't use.

**172.** Untick **Report Readiness on Ready Check** and run another. **Nothing** must print. Failure is the report appearing anyway.

**173.** Leave the group and confirm the setting is still off on a **different character** — this one is account-wide, unlike the buffs it reports on. Re-tick it before continuing. Failure is the toggle resetting per character.

## Combat behaviour

**174.** Pull a mob. While in combat, loot or receive a better food. The `- Food` macro must **not** change mid-fight, and no Lua error may appear. Failure is an error, or a macro that appears to rewrite in combat.

**175.** Kill the mob and leave combat. The macro must rewrite to the better food within a second or two, with no `/reload`. Failure is the pending update being dropped, leaving a stale macro until something else triggers a rescan.

**176.** Enter combat and press each Connoisseur macro in turn. Each must use its item normally. No macro may throw a Lua error mid-combat. Failure is any error at all.

**177.** Level up (or use a character that will), and confirm the macros rebuild for the new level afterwards. Failure is a macro still filtering to your previous level.

## Chat output

Connoisseur only ever prints to **you** — it never sends to say, party, raid, or whisper. Every line in this section is a local print.

**178.** Every printed line must be in the shape *"Connoisseur // message"*, with the name blue, the `//` grey, and the body white. Failure is an uncoloured line, a doubled add-on name, or a line with no separator.

**179.** Press a macro whose item can't be used in your current zone (a zone-restricted potion outside its zone). Chat must print a bug-report line naming the item link, the item ID, your zone, subzone, and map ID, and ending with the full Discord invite address. Failure is a raw item number where a link belongs, a `nil` in the line, a trailing `%s`, or nothing printing at all.

**180.** Press each macro with its category emptied from your bags. Each must print "No suitable *X* found in your bags." with the right category name — Food, Water, Health Potion, Mana Potion, Bandage, Explosive, Healthstone, Mana Gem, Soulstone, Poison. Failure is the wrong label, or a raw key like `LABEL_MANA_GEM` in the message.

## Connoisseur Restocker — the options page

**181.** Open the **Restocker** page and read it top to bottom: a description, **Enable In-Town Restock Reminders**, **Enable At-Merchant Restock Reminders**, **Enable At-Bank Restock Reminders**, **Enable List Builder when Restock List is Empty**, a **Restocker Window** header, an **Advanced** header, and a **Praise** header. Failure is a missing section or one in the wrong place.

**182.** Read the description at the top. It must end with **"Type /crs to open the list."**, with `/crs` rendered in blue inside the sentence. Failure is a literal `%s` on screen, or the command drawn in the same colour as the body text.

**183.** Check the three reminder toggles. All three must ship **ticked**, and each must have a dropdown beside it **with no caption of its own**, offering exactly **Simple** and **Verbose**. The defaults are **Verbose** for **Enable In-Town Restock Reminders** and **Simple** for the other two. Failure is a reminder shipping off, a captioned dropdown, a third choice, or the wrong default.

**184.** Untick one of the three reminders. Its dropdown must disappear. Re-tick it — the dropdown must come back holding the same value. Failure is a dropdown that lingers over a switched-off reminder.

**185.** With **Enable In-Town Restock Reminders** ticked, look directly beneath it. There must be an **indented** sub-row holding a grey **Play Sound** checkbox and a small speaker icon. Untick the In-Town reminder — the **whole** indented row must vanish, leaving no blank indented line behind. Failure is the checkbox disappearing while its indent stays.

**186.** Click the speaker icon. The restock alert must play. It must play whether **Play Sound** is ticked or not — hearing the alert before turning it on is the point. Failure is silence, or a click that does nothing.

**187.** Read the rest of the page. **Enable List Builder when Restock List is Empty** must be ticked. Under **Restocker Window** there must be **Open at Bank** and **Open at Merchant**. Under **Advanced** there must be **Enable Restocker Debug Messages**. Under **Praise** there must be a paragraph naming **ChiliFajita**, **kvakvs**, and **guardycmw** — those three names stay in English on every client, which is deliberate. Failure is a missing control, or a translated name.

**188.** Untick **Open at Merchant**, then log in on a second character and open the Restocker page. It must still be unticked — the toggles on this page are account-wide, unlike the macro settings. Your **Restock List** itself must still be that character's own. Re-tick it before continuing. Failure is the toggle resetting per character, or one shared list across the account.

## Connoisseur Restocker — the Starter List pop-up

**189.** On a character at **level 6 or above**, type `/crs` and delete every row so the Restock List is empty. Now log out to character select and log back in. About three seconds after the loading screen a window titled **Connoisseur Restocker** must open, with three paragraphs: one saying your list is empty, one explaining what ticking a box does, and one ending **"…by typing /crs."** with `/crs` in blue. Failure is no window, a window over a list that isn't empty, or a `%s` where the command belongs.

**190.** Read its section headers. **Food & Water** must always be there. **Ammo** only on a Hunter, Warrior or Rogue. **Poisons** only on a Rogue, led by a note that opens with a yellow **Attention Rogues** and says the ingredients buy themselves. **Reagents & Tools** carries your class's own entries plus **Hearthstone**, which every class gets. Failure is another class's section appearing, or a section drawn with nothing in it.

**191.** Check which boxes are already ticked when the window opens. **Bread** on every class; **Water** on Druid, Hunter, Mage, Paladin, Priest, Shaman and Warlock; **Meat** on a Hunter. Type `/crs` behind the window — those exact items must already be on the list. Failure is a pre-ticked box whose item never reached the list, or water pre-ticked on a Warrior or Rogue.

**192.** Hover a checkbox. The tooltip must name **the exact item** a tick adds right now and **how many** of it. Food, water, ammo and poison entries must also promise to keep **upgrading them as you level**; a single-tier reagent such as Hearthstone must use the shorter sentence with no upgrade promise. Failure is a tooltip naming an item the tick doesn't add, or a `nil` in the sentence.

**193.** Set a food's stacks dropdown to **3 Stacks** *before* ticking its box, then tick it. `/crs` must show that item with an amount of **60**. Now change the dropdown to **1 Stack** with the box still ticked — the amount in `/crs` must drop to **20**. Failure is the dropdown only working in one of the two directions.

**194.** Look at **Hearthstone**, **Thieves' Tools**, the four Shaman totems, and **Soul Shards**. None of them may have a stacks dropdown at all — their checkbox takes the whole cell instead. Failure is a "2 Stacks" choice offered on a Hearthstone.

**195.** Untick every box so the list is empty again, close the window, and type `/reload`. It must **not** reopen — a reload is not a fresh login. Failure is the window returning on every reload.

**196.** Log out to character select and back in. The window must return. This time tick **"Don't show this again for this character."** on the bottom row beside **Close**, then close it. Log out and back in again — no window. Open **Options → Restocker**: **Enable List Builder when Restock List is Empty** must now be **unticked**. Re-tick it there, relog, and the window must be back. Failure is the two controls disagreeing, or the dismissal following you to another character.

**197.** On a character at **level 5 or below** with an empty Restock List, log in. No window may appear at all. Failure is the pop-up opening on a character still in the starter zone.

## Connoisseur Restocker — the window

**198.** Type `/crs`. The window must open titled **Connoisseur Restocker**, with a filter box reading "Filter items...", an **Add** box, a **Profile:** dropdown, and **New Profile**, **Copy**, **Delete**, and **Rename:** controls. Failure is a missing control, or raw keys in place of labels.

**199.** Read a collapsed row. It must show only a **[+]** expander, the item icon, the item name, an amount box, and a remove button. The Withdraw, Deposit, Buy, Rep and Upgrade controls must **not** be on that line. Failure is an all-in-one row, or a name clipped by a button strip.

**200.** Click a row's **[+]**. It must grow its second line and the expander must become **[−]**. Now click a different row's **[+]** — the first row must close on its own. Only one row is ever open at a time. Failure is two rows open together.

**201.** Read that second line. It must hold three labelled groups: **Bank** with **Withdraw** and **Deposit**, **Merchant** with **Buy** and a **Rep:** button, and **Upgrade** with an **Automatic** button. Hover each control — every one must have a tooltip that reads as a sentence. Failure is a missing control or an untooltipped one.

**202.** On an expanded row, turn **Buy** off (or set a reputation), then collapse the row. A small dot must appear on the summary line to say something inside has been changed away from its defaults. A row you have left alone must have no dot. Failure is no way to tell a changed row from an untouched one while both are closed.

**203.** Hover the item icon on a summary line — the item's own game tooltip must appear. Click the icon, or the item name, and the row must expand exactly as the **[+]** does. Failure is either being a dead spot.

**204.** On an expanded row, click the **Rep:** button. It must offer **Any**, **Friendly**, **Honored**, **Revered**, and **Exalted**, each showing its discount. Pick **Honored** — the button must then read **Rep: Honored**. Hover it: the tooltip must be headed **Required Vendor Reputation**, explain that vendors below that standing are skipped, list the discounts (Friendly 5%, Honored 10%, Revered 15%, Exalted 20%), and end with **"Click to change."** Failure is a button that reads only a bare standing with no "Rep:", or a missing discount.

**205.** Hover the **Rep:** button again and look at the shape of the tooltip, not its words. Every line must wrap inside a normal tooltip box roughly as wide as an item tooltip. Failure is the box stretching most of the way across the screen to fit the longest sentence on one line — check the same way on the **Add** box and the Withdraw/Deposit/Buy buttons, whose tooltips wrap through the same helper.

**206.** Drag an item from your bags onto the **Add** box — the item must appear in the list. Then type a numeric item ID into it and press Enter — that item must be added by name and icon. Type junk that isn't an item ID: nothing may be added and no Lua error may appear. Failure is an error on bad input.

**207.** Hover the **Add** box. Its tooltip must read **"Add an Item / Drop an item from your bag, or type a numeric item ID."** While the box is empty it must show the placeholder **"Drop an item here, or type its ID..."** inside it. Failure is an empty unlabelled box.

**208.** With the window open, drag a new item in from your bags. It must appear under a **New** group heading at the top of the list. Close the window and reopen it — that item must have moved into its real type group (Consumable, Trade Goods, and so on), sorted by name among its peers. Failure is items piling up under "New" for ever.

**209.** Set an amount, press Enter, close the window and reopen it. The amount must have stuck. Failure is it reverting.

**210.** Type text into the filter box. Once you've typed two characters or more the list must narrow to matching items — matching on name, item type, or item ID — and must restore when you clear it. Failure is the filter doing nothing.

**211.** Click the remove button on a row. That item must leave the list immediately and must still be gone after a `/reload`. Failure is a row that comes back.

**212.** Drag the window's bottom-right corner and make it bigger, then smaller. The list, the filter box and the profile row must all follow the frame — nothing clipped, nothing stranded, no row overlapping another. Shrinking must stop at a floor rather than collapsing the window. Failure is a layout that only looks right at its opening size.

**213.** Move the window, resize it, `/reload`, and type `/crs`. It must return exactly where and how big you left it. Log in on another character and open it — same size and place there too, because the window's geometry is account-wide. Failure is the window snapping back to centre or to its default size.

## Connoisseur Restocker — Restock List upgrades

**214.** Type `/crs` and expand a food, water, ammo or poison row. Its **Upgrade** group's **Automatic** button must be switched **on**. Hover it — the tooltip must be headed **Upgrade With Your Level**. Failure is Automatic shipping off on a staple.

**215.** Expand a row for something with no upgrade path — a potion, a bandage, or a Hearthstone. Its **Automatic** button must be **off**, and clicking it must not turn it on. Failure is a bandage offering to upgrade itself.

**216.** On a low-level character with a staple on the list and **Automatic** on, gain the level that opens the next tier. Chat must print **"Your Restock List has been upgraded."** followed by one line per item naming the old item and its amount, then the new item and its amount. Open `/crs` — the new item must be there carrying **your** amount, your three toggles, and your reputation setting. Failure is a silent swap, a swap that resets your amount, or a line that names an item without linking it.

**217.** Turn **Automatic** off on a staple and then level past its next tier. It must stay exactly where it is, and no upgrade line may print for it. Failure is the upgrader ignoring the switch.

**218.** Put both a tier and the tier above it on the list, both with **Automatic** on and with different amounts, then level past the higher one. The two rows must **merge** into a single row for the higher tier with the two amounts **added together**. Failure is two rows for the same shopping trip, or one amount overwriting the other.

## Connoisseur Restocker — vendors, the bank, and profiles

**219.** **The most serious step in this section.** With a Restock List item you hold **more** of than your target, open a vendor. **Nothing may be sold.** Check your bags and your money before and after — both must be unchanged apart from any purchase. Restocker never sells; too many of an item is left untouched. Failure is any item leaving your bags at a merchant.

**220.** With an item on your list set to **Buy** and an amount above what you carry, open a vendor who sells it. Connoisseur must buy you up to your target automatically — never past it. Failure is nothing being bought, or over-buying.

**221.** Hold **Shift** while opening a vendor window. Restocking must be skipped entirely — no purchases, and no report on closing. Failure is Shift being ignored.

**222.** Set an item's **Rep:** to a standing you have **not** reached with the vendor's faction, then open that vendor. That item must be skipped. Lower it back to **Any** and reopen — it must be bought. Failure is the reputation gate being ignored.

**223.** *Rogue only.* Put a poison on your Restock List with a target above what you carry, and leave a pile of that same poison **in your bank**. Visit a vendor who stocks the reagents. Connoisseur must buy the reagents anyway — the poisons sitting in the bank must not cancel the purchase, because a tradeskill can only consume what is in your bags. Failure is nothing being bought at a vendor who plainly stocks what you need.

**224.** With an item set to **Withdraw**, some of it in your bank, and less than your target in your bags, open the bank. Connoisseur must move the shortfall from bank to bags, one move at a time, and finish with a chat line reading "Restocking complete. Hold Shift while opening the bank to skip restocking. Type /crs to edit your Restock List." Failure is nothing moving, or a silent finish.

**225.** With an item set to **Deposit** and more than your target in your bags, open the bank. The surplus must be moved into the bank. Set the amount to **0** and reopen — **all** of that item must be stashed. Failure is the surplus staying in your bags.

**226.** Hold **Shift** while opening the bank. Nothing must move. Failure is Shift being ignored.

**227.** Fill your bank completely and open it with a Deposit item pending. Restocking must stop with an honest message naming the reason — *"Restocking stopped. Your bank is full; free a slot and reopen it."* Free one bank slot and reopen: the deposit must now complete. Then fill your **bags** instead and repeat with a Withdraw item: the message must name your bags, not your bank. Failure is a silent stall, an endless retry loop, the wrong reason being named, or a run that stays dead after you make room.

**228.** Tick **Open at Bank** and **Open at Merchant** on the **Restocker** options page. The Restocker window must open by itself at each. Untick them — it must stay closed. Failure is the window ignoring the toggle.

**229.** Tick **Enable Restocker Debug Messages** under **Advanced** and open the bank. Step-by-step decisions must print to chat. `/reload` — the toggle must still be on, because unlike Diagnostic Tools this one deliberately persists. Untick it before continuing. Failure is the toggle resetting on reload, or debug output continuing after you turn it off.

**230.** Type `/crs profile add Raid`. A profile named Raid must be created and selectable from the dropdown. Add an item to it, then `/crs profile use` your original profile — your original list must be intact and Raid's item must not be in it. Failure is one list leaking into the other.

**231.** Click **Copy** with Raid active. A new profile must be created named after the current one with "Copy" appended, holding the same items. Failure is a copy that comes up empty, or a name collision that errors.

**232.** Click **Delete** with Raid active. A confirmation must appear naming the profile and warning it can't be undone. Confirm — the profile must be gone and must stay gone after a `/reload`. Failure is deletion without confirmation, or a profile that returns.

**233.** Log in on a **different character** and open `/crs`. It must show that character's **own** list, not the first character's. Failure is one shared list across the account.

## Connoisseur Restocker — reminders and chat reports

**234.** Put an item on your Restock List set to **Buy**, with a target above what you carry, and open a vendor who stocks plenty of it. Chat must print **"1 restocking order filled."** — or **"N restocking orders filled."** when more than one item was topped up. Failure is a number that counts vendor clicks rather than items on your list.

**235.** Do the same at a vendor who stocks **fewer** than you need. Chat must print **"1 restocking order partly filled."** Then open a vendor who stocks **nothing** on your list — chat must stay completely silent. Failure is a partial run claiming to be filled, or a pointless line at a vendor with nothing for you.

**236.** With something still short, close the merchant window. Within about a second chat must print **"N restocking orders outstanding."** and nothing else, because the At-Merchant reminder defaults to **Simple**. Switch that dropdown to **Verbose** and repeat: the same headline must now be followed by one line per short item, reading how many you have, how many you want, and the item's link. Failure is per-item lines in Simple mode, or a headline with no items behind it in Verbose.

**237.** Close the merchant window with **nothing** short. Chat must stay silent. Failure is an empty report.

**238.** Repeat both of the last two checks at the **bank**: closing it must print the outstanding report, Verbose must add the per-item lines, and nothing short must mean silence. Failure is the bank reminder behaving differently from the merchant one.

**239.** With something short on your list, walk from open country into an **inn or a city**. Chat must print **"Don't forget to Restock while you are in town!"**, followed — because this reminder defaults to **Verbose** — by one line per short item, and the alert sound must play. Walk out and back in: it must fire again on each fresh arrival, and **not** repeat while you simply stand there. Failure is a reminder with nothing short, a reminder on every `/reload` inside the inn, or a reminder that never comes.

**240.** Untick **Play Sound**, leaving the In-Town reminder itself on, and arrive in town again. The chat reminder must still print, and no sound may play. Failure is the alert firing with the sound switched off.

**241.** Set the In-Town reminder's dropdown to **Simple** and arrive in town again. Only the headline may print — no per-item lines. Failure is Verbose output from a Simple setting.

## Profiles panel

**242.** Open Options → AddOns → Connoisseur → **Profiles**. The current profile must be named for your character, in the shape **Name - Realm** — not "Default". Failure is every character landing on one shared profile.

**243.** Change several settings on the Macros panel (Buff Food on, Scroll Buffs on, a poison type, a threshold), then click **Reset Profile**. All of them must return to their install values, and the Macros panel must show the reset values as soon as you click back to it, **without a `/reload`**. Failure is settings surviving the reset, or a stale panel.

**244.** Confirm that Reset Profile did **not** change the five account-wide settings — Welcome Message, Mini-map Button, Macro Names on Buttons, Ready Check, and the Enable Macros toggles — did **not** touch anything on the Restocker page, and did **not** move your mini-map button or empty your Restock List. Failure is any of those being reset or the button jumping position.

**245.** Create a profile called `Test`, change **Prioritize Buff Food** while on it, switch back to your character's profile, and confirm each profile holds its own value with the panel updating immediately on the switch. Use **Copy From** to copy your character's profile into `Test` — the settings must transfer. `/reload` with `Test` active — it must still be active. Switch back and delete `Test` with no error. Failure is a leak between profiles, a profile that resets across a reload, or an error on delete.

## Diagnostic Tools panel

**246.** Log in fresh and open Options → AddOns → Connoisseur → **Diagnostic Tools**. Only two things may be visible: the warning paragraph and the **Enable Diagnostic Tools** toggle, which must be **off**. Failure is the toggle being on by default, or any report button visible before you enable anything.

**247.** Tick **Enable Diagnostic Tools**. Ten sections must appear below it without reopening the panel: Event Log, Event Registration, API Endpoints, Connoisseur Context, Item Selection, Other Add-ons, Saved Variables, Library Versions, Taint Log, and External Tools — the last being two hint lines naming `/console scriptErrors 1` and `/etrace`. Failure is a missing section, or the panel needing a reopen.

**248.** Click **Show Captured Events** before starting a log. The output box must say no events were captured, under a header naming the add-on, its version, and your client. Failure is an error or an unexplained empty box.

**249.** Click **Start Event Log**, go loot something or change zone, then click **Show Captured Events**. The output must list timestamped events with their arguments. Click **Stop Event Log** and show again — the log must be empty. Failure is an empty log after a demonstrable event, or old entries surviving the stop.

**250.** With a log running, spam a red combat error (press an ability that is not ready, repeatedly), then click **Show Captured Events**. Those errors must **not** appear as individual timestamped lines; they must be folded into a `-- Suppressed (uncorrelated) traffic --` block at the bottom, one row per message with a count (`x12`), biggest count first. The same block must carry a `UNIT_AURA(player) x…` row. Errors Connoisseur acts on are exempt and still log in full — trigger one by using a zone-restricted item in the wrong zone. Failure is repeated errors filling the log line by line, or the zone-restriction error being folded away. **Read the summary block, not the log body, when you're looking for the noise — its absence from the body is the point.**

**251.** Click **Test Event Registration**. Every event Connoisseur registers must show `[PASS]`, and the summary must say they all register on this client. Failure is any `[FAIL]`.

**252.** Click **Test WoW API Endpoints**. Three rows are modern/legacy pairs — **C_Container.GetContainerNumSlots**, **C_Item.GetItemCount** and **C_Item.GetItemIconByID**, each against a `(legacy)` partner — and for those a `[FAIL]` on one half while its partner passes is **expected and correct**, because each client provides only one of the two. Every other row, **Frame:SetResizeBounds** and **Settings.OpenToCategory** included, stands alone and must read `[PASS]`. Failure is both halves of a pair failing, or a `[FAIL]` on any unpaired row.

**253.** Click **Show Connoisseur Context**. It must print your live class, level, professions skills, flavor (Era or TBC), and the add-on's current state. Failure is `nil` where a real value belongs.

**254.** Click **Show Selection Report**. It must name what each macro picked, the runners-up it beat, and the ranking step that decided each one. If it's empty, trigger a rescan (loot something, or change zone) as the hint under the button says, and click again — candidates are only kept while diagnostics are on. Failure is a report that stays empty after a rescan.

**255.** Click **List Installed Add-ons**, **Dump Saved Variables**, and **List Library Versions** in turn. Each must fill its box with readable text. The Saved Variables dump must show **exactly two** tables, `ConnoisseurDB` and `ConnoisseurRestockerDB`, and the values in it must match what the settings panels are currently showing. Failure is any button producing nothing, stored values disagreeing with the panel, or a third table being dumped.

**256.** Read the Taint Log state line, click **Turn On Taint Log** — it must read level 2 — then **Turn Off Taint Log** — it must return to level 0. Failure is the number not moving. **Leave taint logging off when you're done.**

**257.** Untick **Enable Diagnostic Tools**. Everything below the toggle must disappear immediately and any running event log must stop. Tick it back on, `/reload`, and reopen: the toggle must be **off** again — diagnostics is deliberately session-only and never persists. Failure is diagnostics still enabled after a reload.

## Flavor differences to watch

Do not skim these. Each one behaves differently on the two clients, and a plan run on only the forgiving flavor will pass while the add-on is broken for half its users.

- **Options panel docking (steps 6 and 27)** — correct on Classic Era; **TBC Anniversary is the client where the panel has historically floated free** of the Options window instead of docking inside it. **This release removed the second opening route**, so there is now one docking route and a floating-window last resort behind it — a flavor that can't take the docking route will float every time. Connoisseur does have `/foodie` and a mini-map button, so a floating panel isn't fatal, but it is still a failure.
- **Warlock stone rank pinning (steps 129–130)** — the single most repeated bug in this add-on's history, and it has broken **Era** three times. Era spells each tier distinctly and must be cast bare; TBC uses numeric ranks and must pin `(Rank N)`. Getting it wrong on Era produces a **silent no-op** — the right-click simply does nothing, with no error to warn you. Test the click, not just the body text, on both flavors.
- **Ritual of Refreshment and Ritual of Souls (steps 125 and 131)** — these spells **do not exist on Classic Era**. The correct Era behaviour is a middle-click that does nothing and prints nothing. On TBC Anniversary they must actually cast. Passing on one flavor tells you nothing about the other.
- **Modern/legacy API pairs (steps 13 and 252)** — the three surviving pairs resolve differently per client, so which half reads `[PASS]` is expected to differ between Era and Anniversary. Only both halves failing is a bug.
- **Restock List upgrade ladders (step 216)** — Classic Era's ladders top out around level 45, so an Era character stops being upgraded long before 60; TBC Anniversary keeps climbing through Outland tiers. A ladder that stalls on Era at 45 is correct; one that stalls on Anniversary is not.
- **Rogue poison types (step 190 onward)** — Anesthetic Poison is TBC-only, so the Starter List's Poisons section shows five types on Era and six on Anniversary. A missing Anesthetic row on Era is correct, not a bug.
- **Level-gated content** — Anniversary reaches level 70 and Era stops at 60, so several picks (higher potion and food tiers, the level-68+ and level-70 rituals, higher conjure ranks) can only be exercised on Anniversary. A macro that picks correctly at 60 has not been proven at 70.
- **Macro body length** — the same macro is longer on some clients than others once localized spell names are involved. See the localization spot-check below; the trims that protect against this are the ones step 110 exercises.

## Localization spot-check

Optional, and only worth running on a non-English client. Connoisseur ships eleven locales and writes macro bodies out of client-localized spell names, so this is where breakage shows up.

**258.** Log in on a non-English client and read all five options pages, the mini-map tooltip, the Restocker window, and the Starter List pop-up. Every label, description, and tip must render in that language. Failure is a raw key showing through — text like `FEATURE_SCROLL_BUFFS` or `RESTOCKER_WITHDRAW_LABEL` on screen instead of a sentence. These must stay **English on every client and are not failures**: the slash commands `/foodie` and `/crs`, the four URLs, the service names Discord, GitHub, CurseForge, and Wago, the word "Restocker" in the category list, and the three names in the Praise paragraph. A translated slash command would simply stop working.

**259.** Read the two strings this release added to the mini-map tooltip: the **None** that stands in for an item that didn't resolve, and the **Fully Stocked** the Restocker Report shows when nothing is short. Both must be translated, and both must be **short enough to read as a value** beside their titles rather than pushing the tooltip wider. Failure is a raw `UI_NONE` or `UI_RESTOCKER_STOCKED_SHORT` on screen, an untranslated English word, or a translation long enough to stretch the tooltip across the screen.

**260.** Trigger each chat message you can: the welcome line, a "No suitable *X* found" line, a Ready Check report, the in-combat options refusal, an in-town restock reminder, a "restocking orders filled" line, a Restock List upgrade line, and a "You don't currently know *X*" tip. Each must read as one complete sentence. Failure is `nil` anywhere in a line, a stray `%s` or `%d`, a value appearing twice, or values landing in the wrong slots.

**261.** Read the Starter List pop-up's checkbox labels and its stacks dropdowns. Every label must fit on its row without pushing its dropdown onto a line of its own, and the dropdowns must read "1 Stack" / "N Stacks" in that language. Failure is a row that wraps and shears the column beside it.

**262.** **This is the highest-risk localization check.** On a **Hunter**, read the `- Feed Pet` body. The whole body must be under the macro limit and must still end with its `/use item:` food line. **ruRU is the canary** — Cyrillic spell names cost roughly double, and the Feed Pet cascade names up to five of them. It is correct and expected for the Ctrl-Dismiss and Shift-Revive shortcuts to be **dropped** in a wide locale; it is a failure if the summon branch, the Mend branch, the default Feed, or the trailing food line goes missing, or if the body is cut off mid-line.

**263.** On a **Warlock** on ruRU or deDE, read the `- Health Potion` body with **Combine Healthstones** on and three potions in bags. It must fit the limit, and it must shed the stacked Healthstone lines **first**, then potion fallbacks from the bottom — the first potion line is never dropped. Failure is a truncated last line or a missing rank-1 potion.

**264.** On a **Druid** on ruRU, read a DruidMacroHelper-wrapped macro. It must still end with `/cast !<form>` and `/dmh end`. Then open **Diagnostic Tools → Show Connoisseur Context** and read the pet diet names against what `/dump GetPetFoodTypes()` returns while your pet is out — they must match exactly. Finally, read the translated sentences alongside the English ones: some languages reorder a sentence so a value lands in a different position, which is **intentional and correct** and must not be "fixed" by a translator. Failure is a missing `/dmh` line, mismatched diet names (pet food selection then dies silently, with the Starter List's food rows going wrong alongside it), or a sentence that is genuinely ungrammatical.

## Sign-off

Manual testing is complete when **every step passes on both Classic Era and TBC Anniversary**. A single flavor is half a run. Once both rows below are filled in and passing, the add-on is ready for `4 - Pre-Launch Review Prompt.md`.
