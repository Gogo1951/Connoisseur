# Connoisseur — Manual Test Plan

This is the manual test plan for Connoisseur — the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Connoisseur/blob/main/README-Technical.md).

## How to run this plan

Run the whole list on Classic Era, then again on TBC Anniversary. Do a `/reload` before starting each flavor.

Work top to bottom. Every step tells you exactly what to do, what you should see, and what failure looks like — if a step doesn't match its expected result, it failed. Steps are numbered continuously from 1 to 207 across the whole document, so a bug report only needs "failed on step N."

**Start with "Verify this release's changes."** Those twenty-one steps cover everything that changed since the last release, and they are where a regression is most likely to be waiting. If one of them fails, report it before running the rest — the standing sections will only pile noise on top of a build you already know is broken.

Several steps behave differently on the two clients and say so in the step itself. Those are not optional on either flavor — the client a step warns about is precisely the one where that step earns its keep. **A run on only one flavor is not a completed run.**

Connoisseur has class-gated and race-gated features, and the sections that cover them say so in their opening line. If you can't field the character a section needs, that section is **untested**, not passed — note it on the sign-off grid.

## Before you start

Gather these once so you aren't caught short mid-run:

- **Both flavors installed** — Classic Era and TBC Anniversary. The add-on ships for both, and both must be tested.
- **At least eleven free macro slots in your General macro tab.** Connoisseur creates its macros there, shared by every character on the account. One step deliberately fills the tab, so have something you can delete afterwards.
- **A second character on the same account**, for the per-character vs account-wide settings checks. Any level, any class.
- **Class characters, for the class sections:** a **Mage** (conjure Food/Water/Mana Gem), a **Warlock** (Healthstone, Soulstone), a **Hunter with a living pet** (Feed Pet), a **Rogue who has trained Poisons** and can equip a weapon in each hand, a **Druid** who knows Bear and Cat form with [DruidMacroHelper](https://www.curseforge.com/wow/addons/druidmacrohelper) installed, and a **Night Elf who is not a Rogue** (Shadowmeld).
- **Consumables in your bags:** at least two tiers of food and two of drink, one buff food (something that grants Well Fed), three health potions of different strengths, two mana potions, a bandage, and an explosive. Poor-quality low-level items are fine — the tests are about which one gets picked, not how strong it is.
- **Professions:** a character with **First Aid** (bandages) and one with **Engineering** (explosives), plus a character with *neither*, for the negative tests.
- **Two or more different scroll types** (Scroll of Agility, Scroll of Stamina, etc.) on the character you use for the Food macro section.
- **Kibler's Bits or Sporeling Snacks** and a **level 55+ Hunter or Warlock with a live pet**, for the Pet Food Buffs section. Skip that section if you can't field one.
- **A second player**, for the party/raid restriction modes and the Ready Check section. A two-person party is enough.
- **A vendor who sells a stackable consumable you can afford**, plus **bank access with free slots in both bags and bank**, for the Restocker section. One step also needs a **completely full bank**, so be ready to fill it and empty it again.
- **Something to fight** — any open-world mob or a target dummy. Several steps need you to be genuinely in combat, not merely flagged.
- **A non-English client** — only for the optional localization spot-check in steps 201–207.

Unless a step says otherwise, be **out of combat, out of an arena, and with no target selected**.

## Verify this release's changes

Six things changed since the last release: the Options Interface now refuses to open in combat, macro rebuilds now stand aside while the Blizzard macro window is open, the options panel gained a label-beside-control row layout, a batch of strings were consolidated and re-worded, the diagnostic event log now folds uncorrelated red-error spam into a summary, and Restocker now recognises the client's full-bag errors by their text rather than by their message number. Run these first, on both flavors.

**Options Interface in combat**

**1.** Out of combat, type `/foodie`. The panel must open, docked in the Blizzard Options window. This is the baseline the next four steps are measured against. Failure is the panel not opening at all — which means something other than the new combat gate is broken, and steps 2–5 will tell you nothing until it's fixed.

**2.** Pull a mob and, while still in combat, type `/foodie`. Chat must print *"Connoisseur // As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must **not** open. Failure is the panel opening anyway, silence with nothing printed, or a red `ADDON_ACTION_BLOCKED` error naming Connoisseur.

**3.** Still in combat, Shift + Middle-Click the mini-map button. It must print the **same** line and open nothing — both entry points share one gate. Failure is a different message, or the button opening the panel while the slash command refuses.

**4.** Still in combat, type `/crs config`. The same line must print and nothing may open. Then type `/crs` on its own — the **Restocker window must still open normally in combat**. Only the Options route is gated. Failure is `/crs config` opening the panel, or plain `/crs` being blocked along with it.

**5.** Kill the mob and leave combat. The options panel must **not** open by itself. The refusal is final, never a queued open that fires later. Failure is the panel appearing on its own a few seconds after the fight.

**Macro rebuilds and the Blizzard macro window**

*This is the fix for macros that went stale and stayed stale until a `/reload`. Run all five steps — the bug was invisible until the macro window was involved.*

**6.** Open the Blizzard macro window (`/macro`), click the **General** tab, and select `- Food`. With the window still open, loot or buy a food better than your current pick. The body on screen must **not** change while the window is open, and no Lua error may appear. Failure is any error.

**7.** Close the macro window, wait a second or two, then reopen `/macro` and read `- Food` again. It must now name the better food. Failure is the body still naming the old food — that is exactly the stale-macro bug, and once it happens the macro stays wrong until something unrelated triggers another rescan.

**8.** With `/macro` open and `- Food` selected, right-click the mini-map button to ignore the current best food. That is a forced rebuild arriving while the window is open. Close the window and read the body: it must name your **next**-best food. Failure is a body still on the ignored item — a forced rebuild has to survive being deferred.

**9.** Open `/macro`, select any Connoisseur macro, type junk into its body, and close the window. Connoisseur must overwrite it with a correct body. Failure is your junk surviving, which means the add-on has lost track of what it last wrote.

**10.** `/reload`, then read every macro you touched in steps 6–9. Each must still hold a correct body. Failure is a body that looked right until the UI rebuilt.

**Options panel layout**

**11.** Open the panel and read **Feedback & Support**. Each of the four entries must be **a label on the left and its URL box on the right, on one line** — Discord, GitHub, CurseForge, Wago. All four boxes must begin at the same left edge and end at the same right edge, and each must show its complete address with nothing cut off. Failure is a label sitting above its box instead of beside it, boxes of differing widths, or an address truncated at the edge of the field.

**12.** Tick **Re-Apply Expiring Buffs**. A dropdown must appear **on the same row, to the right of the toggle, with no caption of its own**, reading **When < 2 Minutes Left**. Open it: exactly five values, each beginning with "When <" — When < 1 Minute Left, then When < 2, 3, 4, and 5 Minutes Left. Untick the toggle and the dropdown must disappear. Failure is a caption above the dropdown, a value reading "< 2 Minutes Left" without the leading "When", a wrong default, or a dropdown that lingers once the feature is off.

**13.** *Druid only.* Tick **Enable DruidMacroHelper Integration**. A dropdown must appear beside it, again with **no caption**, offering exactly **Return to Bear** and **Return to Cat**, defaulting to Return to Bear. Failure is a caption above it, a third option, or values reading just "Bear" and "Cat".

**Re-worded and shared strings**

**14.** Read the **/Commands** section. `/foodie` must appear in blue followed by **"Opens the Options Interface for this add-on."**, and `/crs` in blue followed by **"Opens the Restocker window to manage your Restock List."** Failure is the older "Opens the Connoisseur options interface." wording, a missing description, or an uncoloured command.

**15.** Read the **Connoisseur Restocker** section's description on the same panel. It must end with **"Type /crs to open the list."**, with `/crs` rendered in blue inside the sentence. Failure is a literal `%s` on screen, a missing command, or the command drawn in the same colour as the body text.

**16.** Hover the mini-map button and compare its **Buff Food** and **Scroll Buffs** headers against the panel's section headers of the same names. They must match word for word — both now read from one string. Failure is the tooltip and the panel calling the same feature different things.

**17.** Read the last line of the panel. It must read **Version** followed by a version. On a non-English client the word "Version" must be translated, while `/foodie`, `/crs`, the four URLs, and the names Discord, GitHub, CurseForge, and Wago must all stay **English** — that is deliberate, not a missed translation. Failure is a raw key, or a translated slash command, which would simply stop working.

**18.** Press a macro whose item can't be used where you are — a zone-restricted potion outside its zone. The bug-report line that prints must end with the full Discord invite address. Failure is the line ending in a bare `%s`, a `nil`, or trailing off with no address at all.

**Diagnostic event log**

**19.** Open Options → **Diagnostic Tools**, tick **Enable Diagnostic Tools**, and click **Start Event Log**. Now spam a red combat error — press an ability that isn't ready, ten or more times — and click **Show Captured Events**. Those errors must **not** appear as individual timestamped lines. They must be folded into a block at the bottom of the report headed `-- Suppressed (uncorrelated) traffic --`, one row per message with a count such as `x12`, biggest count first. Failure is the error filling the log line by line, which is what pushes Connoisseur's own events out of the buffer and makes a full report look empty.

**20.** With the log still running, trigger an error Connoisseur actually acts on: use a zone-restricted item in the wrong zone. That one must appear as a **full timestamped line in the log body**, not folded into the summary block. Failure is the correlated error being suppressed too — that would hide the very event the log exists to capture. Click **Stop Event Log** and untick **Enable Diagnostic Tools** before moving on.

**Restocker full-bag handling**

**21.** Put an item on your Restock List set to **Deposit**, hold more of it than your target, fill your bank completely, and open the bank. Restocking must stop with a message naming the reason — *"Restocking stopped. Your bank is full; free a slot and reopen it."* Then free one bank slot and reopen the bank: the deposit must now complete. Failure is a silent stall, an endless retry, a wrong reason named, or a run that stays dead after you make room.

When steps 1–21 pass on **both** Classic Era and TBC Anniversary, this release's changes are verified — proceed to `4 - Pre-Launch Review Prompt.md`.

## Loading, the AddOns list, and the settings panel

**22.** Log in with Connoisseur enabled. No Lua error window may appear, and no red error text may print in chat. Failure is any error popup naming Connoisseur, or the add-on missing from the AddOns list entirely.

**23.** Watch your chat frame at login. A welcome line must print in the shape *"Connoisseur // Version …. Settings (including the option to disable this message) can be found under Options > AddOns > Connoisseur…"*, with the name in blue, the `//` in grey, and the body in white. Failure is no message, an uncoloured line, or a line containing `nil` or a stray `%s`.

**24.** Open the character-select or in-game **AddOns** list and find Connoisseur. Its icon must render — the small Connoisseur artwork, not a blank square or a question mark. Failure is a missing icon, which means the icon path in the TOC doesn't match the file that shipped.

**25.** Type `/foodie`. The settings must appear **docked inside the Blizzard Options window**, with Connoisseur selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **This step is flavor-sensitive — TBC Anniversary is the client where the panel has historically floated free, so run it there and not just on Era.**

**26.** With Connoisseur selected, look at the category list. Three entries must be reachable and must open without error, in this order: the main **Connoisseur** panel, **Profiles**, and **Diagnostic Tools**. Failure is a missing entry, an entry that opens blank, or an entry nested under the wrong parent.

**27.** Read the main panel from top to bottom. The sections must appear in exactly this order: an intro paragraph, **Enable Welcome Message**, **Enable Mini-map Button**, **Enable Macro Names on Buttons**, a **/Commands** header, **Potions & Healthstones**, **Buff Re-Application**, **Buff Food**, **Ready Check**, **Scroll Buffs**, **Pet Food Buffs**, **Explosives**, then any class or race section your character qualifies for, then **Enable Macros**, **Connoisseur Restocker**, **Feedback & Support**, and a version line. Failure is a section out of order or missing entirely.

**28.** Read every label and description on that panel. Each must be a sentence or a label in your language. Failure is a raw key showing through — text like `OPTIONS_ENABLE_MACROS_HEADER` or `FEATURE_BUFF_FOOD` on screen instead of words — or a blank where a label belongs.

**29.** Read the **/Commands** section. It must list both `/foodie` and `/crs`, each in blue and each followed by a description that reads as a full sentence. Failure is a missing command, a command with no description, or an uncoloured command.

**30.** Tick **Re-Apply Expiring Buffs**. A dropdown must appear beside it — no caption of its own — reading **When < 2 Minutes Left**, and offering exactly five choices: When < 1 Minute Left, then When < 2, 3, 4, and 5 Minutes Left. Untick the toggle — the dropdown must disappear. Failure is the dropdown showing while the feature is off, a wrong default, or a missing choice.

**31.** Tick **Prioritize Buff Food**. An unlabelled dropdown must appear on the same row offering **Always**, **Only when in a Party or Raid**, and **Only when in a Raid**, in that order, defaulting to Always. The same dropdown must appear beside **Include Scroll Buffs** and **Use Pet Food Buffs** when you tick those. Failure is a missing dropdown, a different set of choices, or a different order.

**32.** Tick **Include Scroll Buffs**. An **Include Scroll Types in Check** group must appear with six ticked boxes: Agility, Intellect, Protection, Spirit, Stamina, Strength. Untick the feature — the group must disappear. Failure is the group persisting, or a missing scroll type.

**33.** Tick **Use Pet Food Buffs**. An **Include Pet Food Types in Check** group must appear with two ticked boxes: **Kibler's Bits** and **Sporeling Snacks**. Failure is a missing entry or the group not appearing.

**34.** Read the **Explosives** dropdown. It must default to **Left-Click @player, Right-Click Toss** and offer exactly one alternative, **Left-Click Toss, Right-Click @player**. Failure is any other default or a third entry.

**35.** Read the **Enable Macros** section. It must list one toggle per macro, all ticked, labelled with the macro names themselves: `- Bandage`, `- Explosives`, `- Food`, `- Health Potion`, `- Healthstone`, `- Mana Gem`, `- Mana Potion`, `- Soulstone`, `- Water`, plus `- Feed Pet` **only on a Hunter** and `- Poisons` **only on a Rogue**. Failure is a Hunter-only or Rogue-only toggle showing on the wrong class, or a macro with no toggle.

**36.** Find the four rows under **Feedback & Support**, labelled **Discord**, **GitHub**, **CurseForge**, and **Wago**. Each must display a complete, readable URL. Click into one, select all, and copy — the copied address must be the full link, not a fragment. Failure is an empty box, a URL cut off at the edge of the field, or a link pointing somewhere unrelated to this add-on.

**37.** Type junk into one of those boxes and press Enter, then click to another panel and back. The box must show its original URL again. These are display fields you copy from, never fields you edit. Failure is your typed text sticking.

**38.** Read the last line of the main panel. It must show a version. In an unpackaged working copy it correctly reads **"Version Dev"**; in a packaged release build it must read a real version number. Failure is a literal `@project-version@` on screen in a release build.

**39.** Untick **Enable Welcome Message**, tick **Prioritize Buff Food**, and set the Explosives dropdown to **Left-Click Toss**. Type `/reload` and reopen the panel. All three must have held their new values. Failure is any of them reverting, which means the setting isn't being saved.

**40.** Log out fully and log back in on the same character. **No welcome line may print**, and the three settings from step 39 must still hold. Failure is the welcome message appearing anyway, or settings surviving a reload but not a relog.

**41.** Restore the settings you changed in step 39 — welcome on, buff food off, Explosives back to **Left-Click @player**. Each must take effect as you set it, and the `- Explosives` macro body must rewrite to match. Failure is a setting that won't go back, which would leave every later step running against the wrong baseline.

**42.** Type `/reload`. The UI must come back with no error window and no red text, the welcome line must print again, `/foodie` must still open the panel, and your macros must still be in the General tab. Failure is an error on reload, or a macro that vanished.

## Options Interface in combat

The panel is protected by the client during combat, so Connoisseur refuses rather than letting you hit a blocked-action error. Every route in is gated the same way.

**43.** Pull a mob and, while in combat, type `/foodie`. Chat must print *"Connoisseur // As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must not open. Failure is the panel opening, silence, or a red `ADDON_ACTION_BLOCKED` error.

**44.** Still in combat, Shift + Middle-Click the mini-map button. Identical result — same line, no panel. Failure is the two entry points disagreeing.

**45.** Still in combat, type `/crs config`. Identical result again. Then type `/crs` alone: the Restocker window must still open, because only the Options route is gated. Failure is `/crs config` opening the panel, or `/crs` refusing.

**46.** Leave combat. The panel must not open by itself. Failure is a queued open firing after the fight.

## Settings scope — per character vs account-wide

Five settings are account-wide: **Enable Welcome Message**, **Enable Mini-map Button**, **Enable Macro Names on Buttons**, **Report Readiness on Ready Check**, and every **Enable Macros** toggle. Everything else is per character.

**47.** On character A, tick **Prioritize Buff Food**, tick **Include Scroll Buffs**, and tick **Re-Apply Expiring Buffs**. Log out and log in on character B on the same account, and open the panel. All three must be **off** on B — these are per-character consumable choices. Failure is B inheriting A's settings.

**48.** Still on character B, untick **Enable Welcome Message**. Log back to character A and open the panel. It must now be **unticked on A too** — the welcome message is one of the five account-wide settings. Failure is A still showing it ticked. Re-tick it before continuing.

**49.** On character A, untick **Enable Macros → `- Bandage`**. The `- Bandage` macro must vanish from your General macro tab immediately. Log in on character B: the macro must still be gone and the toggle must still be unticked, because the macros live in the shared General tab. Failure is B recreating the macro, or B showing the toggle ticked.

**50.** Re-tick `- Bandage` on character B. The macro must reappear in the General tab within a second or two, with a body built from **B's** bags — not A's. Failure is the macro not returning, or returning with an item B doesn't have.

**51.** Untick **Enable Mini-map Button** on character A, then log in on character B. The button must be hidden there too — mini-map visibility is account-wide. Re-tick it before continuing. Failure is the button reappearing on B.

## Slash commands

**52.** Type `/crs`. The Restocker window must toggle open, and typing it again must close it. Failure is a command that only ever opens, or one that errors.

**53.** Type `/crs show`. The Restocker window must open (and stay open if it was already open — this command shows, it doesn't toggle). Failure is the window closing.

**54.** Type `/crs config`. Connoisseur's options panel must open, exactly as `/foodie` does. Failure is nothing happening.

**55.** Type `/crs help`. Chat must print a list of every `/crs` command with a description for each: `show`, `config`, and the five `profile` subcommands (`add`, `delete`, `rename`, `copy`, `use`). Failure is an empty print, a command with no description, or a raw key like `RESTOCKER_HELP_SHOW` in the output.

**56.** Type `/crs profile` with nothing after it. Chat must print the five profile usage lines rather than doing anything. Then type `/crs profile add` with no name — it must print that one usage line, not error. Failure is a Lua error on either.

## Mini-map button

**57.** Hover the mini-map button and read the tooltip top to bottom. It must show, in order: **Connoisseur** with the version on the right; a **Buff Food** row with **Enabled** or **Disabled** on the right, a description line, and a blue **Left-Click / Toggle** row; a **Scroll Buffs** row with the same shape and a **Shift + Left-Click / Toggle** row; a **Current Food** section; then your class block if you have one; and finally **Connoisseur Options** with **Shift + Middle-Click** under it. Failure is a missing section, a state that reads neither Enabled nor Disabled, or raw keys instead of words.

**58.** Read the **Current Food** section. It must show an item icon and a clickable item link naming the food the `- Food` macro is currently set to, plus a **Right-Click / Ignore** row. If you truly have no food in bags it must instead read "No suitable Food found in your bags." Failure is a blank section, or a food named here that disagrees with the `- Food` macro body.

**59.** Left-click the mini-map button. The Buff Food state in the tooltip must flip between Enabled and Disabled, and the **Prioritize Buff Food** toggle in the options panel must agree. Failure is the tooltip not updating, or the panel disagreeing with the tooltip.

**60.** Shift + Left-click the button. The Scroll Buffs state must flip, and **Include Scroll Buffs** in the panel must agree. Failure is the same as above, or Shift + Left-click toggling Buff Food instead.

**61.** With food in your bags, Right-click the button. The current best food must be added to the ignore list, the **Current Food** section must switch to your *next*-best food, and an **Ignore List** section must appear in the tooltip naming the ignored item with its icon and quality colour. Failure is nothing changing, or the same food still being picked.

**62.** Middle-click the button. The Ignore List section must disappear entirely and Current Food must return to the food from step 58. Failure is the list surviving, or the tooltip needing a reload to catch up.

**63.** Shift + Middle-click the button. The options panel must open, docked, exactly as `/foodie` does. Failure is nothing happening, or the ignore list being cleared instead — Shift + Middle-click is checked before plain Middle-click and must win.

**64.** Look at the button's icon, then loot or buy a clearly better food so the macro's pick changes. The icon must change to match the new best food without a `/reload`. Failure is a frozen icon.

**65.** Drag the mini-map button to a different spot on the mini-map ring, then `/reload`. It must return to where you dragged it. Failure is the button snapping back to its old position.

**66.** Untick **Enable Mini-map Button** in the panel. The button must disappear immediately. Re-tick it — it must return to the same spot. Failure is a button that needs a reload to hide or show.

## The macros themselves

**67.** Open the macro window and confirm every Connoisseur macro is in the **General** tab, not the character-specific tab. Failure is any of them in the per-character tab — they'd stop being shared across the account.

**68.** Read each macro name. None may exceed 16 characters and each must begin with `- `. Failure is a truncated or renamed macro.

**69.** Loot, buy, or trade yourself a food better than your current pick. Within about a second the `- Food` macro body must rewrite to the new item, and the action-bar icon must follow. Failure is a stale macro that only updates after a `/reload`.

**70.** Open the Blizzard macro window and leave it open while you loot a better food. Nothing may rewrite while it's open. Close the window — the rebuild must land within a second or two, without a `/reload`. Failure is a macro left on the old item, which is the stale-macro failure this deferral exists to prevent; failure is also a rewrite happening while the window is open, because the frame would save the old text straight back over it.

**71.** Untick **Enable Macros → `- Explosives`**. The macro must be **deleted** from the General tab, not just emptied. Re-tick it — it must be recreated with a working body. Failure is an orphaned empty macro left behind, or one that doesn't come back.

**72.** Tick **Enable Macro Names on Buttons**. The macro name text must appear under the icon on your default action bar buttons immediately. Untick it — the text must vanish immediately. Failure is either direction needing a `/reload`.

**73.** With that toggle **off**, type `/reload`. The names must still be hidden after the UI rebuilds. Failure is the names reappearing on reload, which means the hide isn't being reapplied.

**74.** Fill your General macro tab with junk macros until it is completely full, then trigger a rebuild (loot something, or `/reload`). A chat line must print explaining that some Connoisseur macros couldn't be created because your macro slots are full, and pointing at the Enable Macros section. It must print **once**, not repeatedly. Failure is silence, or the message spamming every update.

**75.** Delete one junk macro to free a slot, then loot something to trigger a rebuild. The missing Connoisseur macro must be created automatically, with no `/reload` needed. Failure is the macro only appearing after a reload. Delete the rest of your junk macros before continuing.

**76.** Log in on a different character with a different set of consumables. The macro **count** must not change — no macro added, none removed — but the bodies must rewrite to that character's own best items. Failure is macros being deleted and recreated on a character switch, or bodies still naming the previous character's items.

## Food macro

**77.** With several foods in your bags, read the `- Food` macro body. The `/use item:` number must match the food named in the mini-map tooltip's Current Food section. Failure is the two disagreeing.

**78.** Empty every food out of your bags and press the `- Food` macro. Chat must print *"Connoisseur // No suitable Food found in your bags."* Failure is silence, a red error, or a message naming the wrong category.

**79.** Put a buff food (one that grants Well Fed) and a stronger plain food in your bags, and tick **Prioritize Buff Food**. With **no** Well Fed buff on you, the macro must pick the **buff food** even though the plain food restores more. Failure is the plain food winning.

**80.** Eat the buff food to full so you have the Well Fed buff, and wait for the macro to rebuild. It must now pick the **plain food** — buff food only competes while the buff is missing. Failure is the macro still offering buff food you don't need.

**81.** Target **yourself**, then trigger a rebuild. The macro must skip buff food and scrolls and revert to plain food. Failure is buff food or scroll mode surviving a self-target.

**82.** Set the Buff Food dropdown to **Only when in a Raid** and stand ungrouped. Buff food must stop being preferred. Group up as a party of two — still not preferred. Convert to a raid — it must be preferred again. Failure is any of the three states behaving like another.

**83.** Tick **Include Scroll Buffs** with at least two different scroll types in your bags and none of those buffs on you. The `- Food` macro must switch entirely to scroll mode: the body must be `#showtooltip` followed only by `/use [@player] item:` lines, one per missing scroll, with **no** food line. Failure is a body that still contains food, or one missing a scroll you're carrying.

**84.** Read the order of those scroll lines. They must fire in this order: **Agility, Strength, Protection, Intellect, Spirit, Stamina** — skipping any type you don't have or have unticked. Failure is a different order.

**85.** Press the macro once. Every missing scroll must be applied to **you** in one press, off the global cooldown, regardless of what you have targeted. Failure is only one scroll firing, or a scroll landing on your target.

**86.** With all those buffs now on you, wait for the rebuild and read the body again. It must have flipped back to the normal food form. Failure is the macro staying stuck in scroll mode.

**87.** Untick a scroll type in **Include Scroll Types in Check** while missing that buff. The macro must stop offering that scroll but keep offering the others. Failure is the unticked type still appearing in the body.

**88.** With scrolls missing, target a **friendly player**. The macro must revert to food mode so a Mage can right-click to conjure for a friend without firing scrolls on themselves. Drop the target — scroll mode must return. Failure is scroll mode surviving a friendly target.

**89.** Get a class buff that covers the same stat as one of your scrolls at an equal or greater value (for example a Paladin's Blessing of Kings against a Scroll of Strength). That scroll must be skipped while the class buff holds, and the others must still fire. Failure is a wasted scroll.

**90.** *Hunter or Warlock, level 55+, with a live pet.* Tick **Use Pet Food Buffs** with Kibler's Bits or Sporeling Snacks in your bags and no Well Fed buff on your pet. The `- Food` macro's use line must become `/use [@pet] item:` with the pet food's ID. Press it — your **pet** must be fed, not you. Failure is the food targeting you, or the override not applying.

**91.** With both a missing scroll buff **and** a hungry pet, read the body. Scrolls must win — the macro must be in scroll mode, with the pet food waiting for the next press. Failure is pet food firing while scrolls are still missing.

**92.** Take your pet's level above the food, or dismiss the pet, and rebuild. The pet override must drop and the macro must return to feeding **you**. Failure is a `[@pet]` line with no pet.

**93.** *Rogue, or a Night Elf who is not a Rogue.* Tick **Enable Stealth Eating**. The Food macro body must gain a `/cast [nostealth] ` line naming **Stealth** on a Rogue or **Shadowmeld** on a Night Elf. Press it out of stealth — you must stealth and eat. Failure is the wrong ability, or no line at all.

**94.** *Arena only, and optional.* Enter an arena with Buff Food, Scroll Buffs, and Pet Food Buffs all on. All three must be suppressed inside the arena and the macro must be plain food. Failure is buff food or scrolls firing in an arena.

## Water macro

**95.** With two drinks of different strength in your bags, the `- Water` macro must pick the stronger one, and its body must be `#showtooltip item:` plus a `/use item:` line. Press it — you must drink. Failure is the weaker drink winning, or nothing happening.

**96.** Put a hybrid food-and-drink item (a Mage's conjured Mana Strudel, or a Sunfruit-style item) in your bags alongside a dedicated drink of the same value. `- Water` must prefer the **dedicated** drink while `- Food` prefers the **hybrid** — one bag slot covering both needs. Failure is both macros picking the same item when a dedicated one is available.

**97.** *Night Elf who is not a Rogue.* Tick **Enable Stealth Drinking**. The `- Water` body must gain `/cast [nostealth] Shadowmeld` under the drink line. On a **Night Elf Rogue** this toggle must not be visible at all — Rogues get the Rogues section instead. Failure is the toggle appearing for a Rogue, or the line appearing on a non-Night-Elf.

## Potions, Healthstones, and the multi-use fallback

**98.** With three health potions of different strengths in your bags, read the `- Health Potion` body. It must contain **three** `/use item:` lines, strongest first. Failure is only one line, or the weakest potion listed first.

**99.** Press the macro. Exactly **one** potion must be consumed — the strongest. Failure is two potions being drunk on one press.

**100.** Enter combat, drink your last strong potion, and press the macro again while still in combat. It must fall through and drink the next-best potion, because macros can't be rewritten mid-fight. Failure is a dead button.

**101.** Do the same for `- Mana Potion` with two mana potions: two ranked lines, strongest first, one consumed per press. Failure is the same as above.

**102.** *Warlock, or anyone carrying a Healthstone.* Tick **Combine Healthstones into Health Potion Macro**. The `- Health Potion` body must gain the Healthstone's `/use item:` line **below** the potion lines. Press it once — a potion **and** a Healthstone must both be consumed, since they're on separate cooldowns. Failure is only one of the two firing, or the stone line landing above the potions.

**103.** Read the `- Health Potion` body with stacking on and three potions in bags. The whole body must be under 255 characters, and the **first** `/use` line must always be present. Failure is a body cut off mid-line, or the rank-1 potion line missing.

**104.** Read the **Potions & Healthstones** description in the panel. It must explain that macros can't change during combat and that the icon can go stale on long fights while the click still uses your best item. Failure is a missing or raw-key description.

## Bandages and Explosives

**105.** On a character **with First Aid**, with a bandage in bags, `- Bandage` must name that bandage. On a character **without First Aid**, the same macro must find nothing — press it and chat must print "No suitable Bandage found in your bags." Failure is a bandage being offered to someone who can't use it.

**106.** Carry two bandages your First Aid skill covers, one stronger than the other. The stronger must win. Now carry one whose required skill is **above** your level — it must be ignored. Failure is an unusable bandage being picked.

**107.** On a character **with Engineering** and a bomb in bags, `- Explosives` must name it. On a character **without** Engineering, only an Ez-Thro-style explosive (usable by anyone) may be picked; a normal bomb must not be. Failure is a non-Engineer being handed a bomb they can't throw.

**108.** With two explosives of different damage, the higher-minimum-damage one must win. Failure is the weaker bomb being chosen.

**109.** With the Explosives dropdown on **Left-Click @player, Right-Click Toss**, read the macro body. Its use line must place `[@player]` on the default (left) click. Press it — the explosive must go off **at your feet with no targeting reticle**. Right-click must give you the normal reticle. Failure is a reticle on left-click.

**110.** Switch the dropdown to **Left-Click Toss, Right-Click @player**. The body must rewrite immediately and the two clicks must swap behaviour. Failure is the body not changing, which means the click layout isn't in the macro's state.

**111.** Bind `- Explosives` to a key and press the key. It must behave exactly like a **left**-click. Failure is a keybind behaving like a right-click.

## Mages

*Mage only.* Skip this section on any other class, and mark it untested on the sign-off.

**112.** Hover the mini-map button. A class block headed **Attention Mages** must appear, in Mage blue, with a line naming your Food, Water, and Mana Gem macros and one instruction per line. Failure is a missing block, or tips for a class you aren't.

**113.** With no target, right-click the `- Food` macro. You must begin casting Conjure Food at the highest rank you know. Do the same on `- Water` for Conjure Water. Failure is the click doing nothing, or casting the wrong spell.

**114.** Read the `- Food` body and find its conjure line. On **both** flavors the spell must be rank-pinned, in the shape `Conjure Food(Rank N)`. Failure is a bare spell name with no rank, which would always conjure the highest rank regardless of target.

**115.** Target a **lower-level friendly player** and right-click `- Food`. The rank must drop so the conjured item is one they can actually use — check the body rewrote to a lower `(Rank N)` while they're targeted. Failure is the rank staying pinned to your own level.

**116.** Right-click `- Mana Gem`. You must conjure a mana gem. Right-click **again** while holding that gem — because gems are unique, it must conjure the **next rank down** rather than failing. Failure is a red "you already have one" error on the second press.

**117.** Middle-click `- Food` or `- Water`. **On TBC Anniversary at level 70** you must cast Ritual of Refreshment. **On Classic Era the spell does not exist**, so the middle-click must do nothing at all and print nothing. Failure on Era is a chat line naming a spell you can never learn; failure on Anniversary is the ritual not casting.

**118.** On a Mage below the level for Conjure Water, right-click `- Water`. Chat must print *"You don't currently know Conjure Water."* Failure is silence or a wrong spell name.

## Warlocks

*Warlock only.* Skip this section on any other class, and mark it untested on the sign-off.

**119.** Hover the mini-map button. A class block headed **Attention Warlocks** must appear in Warlock purple, naming your Healthstone and Soulstone macros. Failure is a missing or wrong-class block.

**120.** Right-click `- Healthstone`. You must begin casting Create Healthstone. Right-click again while holding that stone — it must create the **next rank down** rather than failing on the duplicate. Failure is a red duplicate error on the second press.

**121.** **This is the highest-risk step in the plan, and the reason both flavors matter.** Read the `- Healthstone` body's `/cast` line. **On Classic Era it must be a bare, fully-named spell** such as `Create Healthstone (Minor)` with **no** `(Rank N)` appended. **On TBC Anniversary it must be rank-pinned**, in the shape `Create Healthstone(Rank 3)`. Failure on Era is a `(Rank N)` suffix, which builds a spell name that doesn't exist and makes the right-click **silently do nothing** — no error, no cast. Test the click itself on both flavors, not just the body text.

**122.** Right-click `- Soulstone`. You must create a Soulstone at the best rank you know. Read the body and apply the same Era-vs-TBC rule as step 121: bare name on Era, `(Rank N)` on Anniversary. Failure is the same silent no-op.

**123.** Middle-click `- Healthstone`. **On TBC Anniversary at level 68+** you must cast Ritual of Souls. **On Classic Era the spell does not exist**, so nothing must happen and nothing must print. Failure is a chat line on Era naming a spell you can never learn.

**124.** On a Warlock below level 18, right-click `- Soulstone`. Chat must print *"You don't currently know Create Soulstone…"* using the client's own spell name. Failure is silence, or a raw spell ID in the message.

## Hunters

*Hunter only.* Skip this section on any other class, and mark it untested on the sign-off.

**125.** Hover the mini-map button. A class block headed **Attention Hunters** must appear in Hunter green, and below it a **Current Pet Food** section naming the food the macro will feed. Failure is a missing block, or a pet food named here that disagrees with the macro body.

**126.** With a living pet out and pet food in bags, left-click `- Feed Pet`. Your pet must be fed. Failure is nothing happening, or a red "your pet doesn't like that" error.

**127.** Check which food it chose. It must be the **lowest-level food that still gives maximum happiness** — not the most expensive one you own. Failure is an unnecessarily good food being burned.

**128.** Put a food in your bags that is an objective for a quest in your log, and make it the food the rule above would otherwise pick. It must be **skipped**. Failure is the macro eating your quest items.

**129.** Dismiss your pet and press the macro. It must Call Pet. Now let your pet die, dismiss it, and press again — it must switch to **Revive Pet** on its own. Failure is the macro still trying to Call a dead pet.

**130.** Right-click the macro with a live pet out, and separately press it while in combat. Both must cast **Mend Pet**. Hold **Shift** and press — it must force **Revive Pet**. Hold **Ctrl** and press — it must **Dismiss** the pet. Failure is any modifier doing the wrong thing.

**131.** On a Hunter below level 10 (before the pet quests), read the body. It must be a two-line stub that prints *"You don't currently know Call Pet, Dismiss Pet, Feed Pet, or Revive Pet."* when pressed. On a level 10–11 Hunter without Mend Pet, right-click must print *"You don't currently know Mend Pet."* rather than silently doing nothing. Failure is a macro that references spells the Hunter can't cast.

**132.** With no usable pet food in bags, press the macro. Chat must print *"You don't currently have any food that is useful for your pet."* Failure is silence.

## Rogues

*Rogue only, with the Poisons skill trained.* Skip this section on any other class, and mark it untested on the sign-off.

**133.** Hover the mini-map button. A class block headed **Attention Rogues** must appear in Rogue yellow, followed by a **Main Hand** and an **Off Hand** section each naming the poison that hand will get, or "No suitable Poison found in your bags." Failure is a missing block or a blank section.

**134.** Open the panel's **Rogues** section. Two dropdowns — **Main Hand Poison Type** and **Off Hand Poison Type** — must each offer six choices named in your client's own language: Anesthetic, Crippling, Deadly, Instant, Mind-numbing, and Wound Poison, defaulting to **Instant Poison**. Failure is a missing type, an English name on a non-English client, or a raw number showing as a choice.

**135.** With a weapon in each hand and the matching poisons in your bags, **left**-click `- Poisons`. Your **Off Hand** must be poisoned. **Right**-click — your **Main Hand** must be poisoned. Failure is the hands being crossed.

**136.** With a poison already on a weapon, press the macro for that hand again. The existing poison must be replaced automatically, with no confirmation popup left on screen for you to click. Failure is a popup you have to dismiss by hand.

**137.** **Middle**-click the macro. The Poisons crafting window must open. Failure is nothing happening on a Rogue who knows Poisons.

**138.** Empty the selected poison type for one hand out of your bags. Clicking **that** hand's button must print *"You're out of the selected poison for this weapon."* while the **other** hand still works normally. Failure is both hands going dead, or silence on the empty one.

**139.** Carry a poison rank above your level. It must be ignored in favour of the best rank you can actually use. Failure is an unusable poison being selected.

## Druids

*Druid only, with DruidMacroHelper installed.* Skip this section on any other class, and mark it untested on the sign-off.

**140.** Open the panel's **Druids** section and tick **Enable DruidMacroHelper Integration**. A dropdown must appear beside the toggle, with no caption of its own, offering **Return to Bear** and **Return to Cat** and defaulting to Return to Bear. Failure is a missing dropdown, a caption above it, or a third option.

**141.** Read the `- Health Potion`, `- Mana Potion`, and `- Healthstone` bodies. Each must now begin with `/dmh` guard lines and end with a `/cast !` line naming your chosen form followed by `/dmh end`. Failure is any of the three left un-wrapped, or a wrapped macro whose last line is missing.

**142.** In Cat or Bear form, press `- Health Potion`. You must powershift out, drink, and shift back to the form you chose. Change the dropdown to **Return to Cat** and confirm the return form changes in both the body and in play. Failure is being left in caster form.

**143.** Untick the integration. All three macros must return to their plain bodies. Failure is a leftover `/dmh` line.

## Night Elves

*Night Elf who is not a Rogue.* Night Elf Rogues use the Rogues section instead.

**144.** Open the panel. A **Night Elves** section must be visible with **Enable Stealth Drinking**, **Enable Stealth Eating**, and a grey pro tip explaining to pick one because eating or drinking after you stealth breaks stealth. On a Night Elf Rogue this section must be **absent**. Failure is the section showing for a Rogue or missing for a Night Elf.

**145.** Tick both toggles and press first `- Water`, then `- Food`. Each must Shadowmeld and then drink or eat. Failure is either macro missing its Shadowmeld line.

## Ignore list

**146.** With several foods in bags, right-click the mini-map button to ignore the current best. Read the `- Food` body — it must now name a **different** item. Failure is the macro still using the ignored food.

**147.** Ignore two more foods the same way. The tooltip's **Ignore List** section must list all three, sorted alphabetically, each with its icon and quality colour. Failure is a missing entry or an unsorted list.

**148.** `/reload`. The ignore list must survive. Failure is it emptying itself.

**149.** Log in on a **different character**. The ignore list must be **empty** there — it's a per-character setting. Failure is one character's ignores following you around the account.

**150.** Middle-click the mini-map button. The list must clear, the section must disappear from the tooltip, and the previously-ignored food must be selectable again. Failure is a list that survives the clear.

## Buff Re-Application

**151.** Tick **Re-Apply Expiring Buffs** and set the threshold to **When < 5 Minutes Left**. With a Well Fed buff on you that has **more** than five minutes remaining, the Food macro must offer plain food. Failure is buff food being offered against a healthy buff.

**152.** Wait until that Well Fed buff drops under five minutes. The macro must now treat it as expired and offer **buff food** again. The same rule must apply to scrolls and pet food. Failure is having to lose the buff entirely before the macro reacts.

## Ready Check

**153.** In a party of two, with **Report Readiness on Ready Check** ticked, have your partner start a ready check. Exactly one line must print in **your** chat frame only, in the shape *"Connoisseur // Missing: … // Well Fed 12 min"*. Ask your partner — they must **not** have seen it. Failure is anything reaching group chat; this add-on has no cross-player chat path at all.

**154.** With every tracked buff up, run another ready check. The line must read *"Ready to go!"* followed by the remaining time on each tracked buff. Failure is an all-clear that still lists something missing.

**155.** Turn off Buff Food and Scroll Buffs, then run a ready check. Those two must vanish from the report entirely — a feature you've switched off is never reported on. Failure is the line nagging you about buffs you don't use.

**156.** Untick **Report Readiness on Ready Check** and run another. **Nothing** must print. Failure is the report appearing anyway.

**157.** Leave the group and confirm the setting is still off on a **different character** — this one is account-wide, unlike the buffs it reports on. Re-tick it before continuing. Failure is the toggle resetting per character.

## Combat behaviour

**158.** Pull a mob. While in combat, loot or receive a better food. The `- Food` macro must **not** change mid-fight, and no Lua error may appear. Failure is an error, or a macro that appears to rewrite in combat.

**159.** Kill the mob and leave combat. The macro must rewrite to the better food within a second or two, with no `/reload`. Failure is the pending update being dropped, leaving a stale macro until something else triggers a rescan.

**160.** Enter combat and press each Connoisseur macro in turn. Each must use its item normally. No macro may throw a Lua error mid-combat. Failure is any error at all.

**161.** Level up (or use a character that will), and confirm the macros rebuild for the new level afterwards. Failure is a macro still filtering to your previous level.

## Chat output

Connoisseur only ever prints to **you** — it never sends to say, party, raid, or whisper. Every line in this section is a local print.

**162.** Every printed line must be in the shape *"Connoisseur // message"*, with the name blue, the `//` grey, and the body white. Failure is an uncoloured line, a doubled add-on name, or a line with no separator.

**163.** Press a macro whose item can't be used in your current zone (a zone-restricted potion outside its zone). Chat must print a bug-report line naming the item link, the item ID, your zone, subzone, and map ID, and ending with the Discord invite address. Failure is a raw item number where a link belongs, a `nil` in the line, a trailing `%s`, or nothing printing at all.

**164.** Press each macro with its category emptied from your bags. Each must print "No suitable *X* found in your bags." with the right category name — Food, Water, Health Potion, Mana Potion, Bandage, Explosive, Healthstone, Mana Gem, Soulstone, Poison. Failure is the wrong label, or a raw key like `LABEL_MANA_GEM` in the message.

## Connoisseur Restocker

**165.** Type `/crs`. The window must open titled **Connoisseur Restocker**, with a filter box reading "Filter items...", an **Add** box, a **Profile:** dropdown, and **New Profile**, **Copy**, **Delete**, and **Rename:** controls. Failure is a missing control, or raw keys in place of labels.

**166.** Hover the **Add** box. A tooltip must read "Add an Item / Drop an item from your bag, or type a numeric item ID." Drag an item from your bags onto it — the item must appear in the list. Failure is nothing happening on drop.

**167.** Type a numeric item ID into the Add box and press Enter. That item must be added by name and icon. Type junk that isn't an item ID — nothing may be added and no Lua error may appear. Failure is an error on bad input.

**168.** Read a list row. It must have the item icon and name, an editable **amount**, a **Buy** toggle, a **Deposit** toggle, a **Withdraw** toggle, a **Required Reputation** control, and a remove button. Hover each — every one must have a tooltip that reads as a sentence. Failure is a missing control or an untooltipped one.

**169.** Set an amount, click away, then reopen the window. The amount must have stuck. Failure is it reverting.

**170.** Click the **Required Reputation** control. It must offer **Any**, **Friendly**, **Honored**, **Revered**, and **Exalted**, each showing its discount percentage. Failure is a missing standing or a missing discount.

**171.** Type text into the filter box. The list must narrow to matching items and restore when you clear it. Failure is the filter doing nothing.

**172.** Drag the window somewhere else, `/reload`, and reopen it. It must return to where you left it. Failure is the window snapping back to centre.

**173.** With an item on your list set to **Buy** and an amount above what you carry, open a vendor who sells it. Connoisseur must buy you up to your target automatically, and chat must print "Finished restocking (purchases: N)." Failure is nothing being bought, or over-buying past your target.

**174.** **The most serious step in this section.** With a Restock List item you hold **more** of than your target, open a vendor. **Nothing may be sold.** Check your bags and your money before and after — both must be unchanged apart from any purchase. Restocker never sells; too many of an item is left untouched. Failure is any item leaving your bags at a merchant.

**175.** Hold **Shift** while opening a vendor window. Restocking must be skipped entirely — no purchases. Failure is Shift being ignored.

**176.** With an item set to **Withdraw**, some of it in your bank, and less than your target in your bags, open the bank. Connoisseur must move the shortfall from bank to bags, one move at a time, and finish with a chat line reading "Restocking complete. Hold Shift while opening the bank to skip restocking. Type /crs to edit your Restock List." Failure is nothing moving, or a silent finish.

**177.** With an item set to **Deposit** and more than your target in your bags, open the bank. The surplus must be moved into the bank. Set the amount to **0** and reopen — **all** of that item must be stashed. Failure is the surplus staying in your bags.

**178.** Hold **Shift** while opening the bank. Nothing must move. Failure is Shift being ignored.

**179.** Fill your bank completely and open it with a Deposit item pending. Restocking must stop with an honest message naming the reason — *"Restocking stopped. Your bank is full; free a slot and reopen it."* Then fill your **bags** instead and repeat with a Withdraw item: the message must name your bags, not your bank. Failure is a silent stall, an endless retry loop, or the wrong reason being named.

**180.** Tick **Open at Bank** and **Open at Merchant** in the options panel. The Restocker window must open by itself at each. Untick them — it must stay closed. Failure is the window ignoring the toggle.

**181.** Tick **Enable Restocker Debug Messages** and open the bank. Step-by-step decisions must print to chat. `/reload` — the toggle must still be on, because unlike Diagnostic Tools this one deliberately persists. Untick it before continuing. Failure is the toggle resetting on reload, or debug output continuing after you turn it off.

**182.** Type `/crs profile add Raid`. A profile named Raid must be created and selectable from the dropdown. Add an item to it, then `/crs profile use` your original profile — your original list must be intact and Raid's item must not be in it. Failure is one list leaking into the other.

**183.** Click **Delete** with Raid active. A confirmation must appear naming the profile and warning it can't be undone. Confirm — the profile must be gone and must stay gone after a `/reload`. Failure is deletion without confirmation, or a profile that returns.

**184.** Log in on a **different character** and open `/crs`. It must show that character's **own** list, not the first character's. Failure is one shared list across the account.

## Profiles panel

**185.** Open Options → AddOns → Connoisseur → **Profiles**. The current profile must be named for your character, in the shape **Name - Realm** — not "Default". Failure is every character landing on one shared profile.

**186.** Change several settings on the main panel (Buff Food on, Scroll Buffs on, a poison type, a threshold), then click **Reset Profile**. All of them must return to their install values, and the main panel must show the reset values as soon as you click back to it, **without a `/reload`**. Failure is settings surviving the reset, or a stale panel.

**187.** Confirm that Reset Profile did **not** change the five account-wide settings — Welcome Message, Mini-map Button, Macro Names on Buttons, Ready Check, and the Enable Macros toggles — and did **not** move your mini-map button. Failure is any of those being reset or the button jumping position.

**188.** Create a profile called `Test`, change **Prioritize Buff Food** while on it, switch back to your character's profile, and confirm each profile holds its own value with the panel updating immediately on the switch. Use **Copy From** to copy your character's profile into `Test` — the settings must transfer. `/reload` with `Test` active — it must still be active. Switch back and delete `Test` with no error. Failure is a leak between profiles, a profile that resets across a reload, or an error on delete.

## Diagnostic Tools panel

**189.** Log in fresh and open Options → AddOns → Connoisseur → **Diagnostic Tools**. Only two things may be visible: the warning paragraph and the **Enable Diagnostic Tools** toggle, which must be **off**. Failure is the toggle being on by default, or any report button visible before you enable anything.

**190.** Tick **Enable Diagnostic Tools**. Ten sections must appear below it without reopening the panel: Event Log, Event Registration, API Endpoints, Connoisseur Context, Item Selection, Other Add-ons, Saved Variables, Library Versions, Taint Log, and External Tools — the last being two hint lines naming `/console scriptErrors 1` and `/etrace`. Failure is a missing section, or the panel needing a reopen.

**191.** Click **Show Captured Events** before starting a log. The output box must say no events were captured, under a header naming the add-on, its version, and your client. Failure is an error or an unexplained empty box.

**192.** Click **Start Event Log**, go loot something or change zone, then click **Show Captured Events**. The output must list timestamped events with their arguments. Click **Stop Event Log** and show again — the log must be empty. Failure is an empty log after a demonstrable event, or old entries surviving the stop.

**193.** With a log running, spam a red combat error (press an ability that is not ready, repeatedly), then click **Show Captured Events**. Those errors must **not** appear as individual timestamped lines; they must be folded into a `-- Suppressed (uncorrelated) traffic --` block at the bottom, one row per message with a count (`x12`), biggest count first. Errors Connoisseur acts on are exempt and still log in full — trigger one by using a zone-restricted item in the wrong zone. Failure is repeated errors filling the log line by line, or the zone-restriction error being folded away. **Read the summary block, not the log body, when you're looking for the noise — its absence from the body is the point.**

**194.** Click **Test Event Registration**. Every event Connoisseur registers must show `[PASS]`, and the summary must say they all register on this client. Failure is any `[FAIL]`.

**195.** Click **Test WoW API Endpoints**. A `[FAIL]` on one half of a modern/legacy pair while its partner passes is **expected and correct** — each client provides only one of the two. Failure is both halves of a pair failing.

**196.** Click **Show Connoisseur Context**. It must print your live class, level, professions skills, flavor (Era or TBC), and the add-on's current state. Failure is `nil` where a real value belongs.

**197.** Click **Show Selection Report**. It must name what each macro picked, the runners-up it beat, and the ranking step that decided each one. If it's empty, trigger a rescan (loot something, or change zone) as the hint under the button says, and click again — candidates are only kept while diagnostics are on. Failure is a report that stays empty after a rescan.

**198.** Click **List Installed Add-ons**, **Dump Saved Variables**, and **List Library Versions** in turn. Each must fill its box with readable text. The Saved Variables dump must show **both** `ConnoisseurDB` and `ConnoisseurRestockerDB`, and the values in it must match what the settings panel is currently showing. Failure is any button producing nothing, or stored values disagreeing with the panel.

**199.** Read the Taint Log state line, click **Turn On Taint Log** — it must read level 2 — then **Turn Off Taint Log** — it must return to level 0. Failure is the number not moving. **Leave taint logging off when you're done.**

**200.** Untick **Enable Diagnostic Tools**. Everything below the toggle must disappear immediately and any running event log must stop. Tick it back on, `/reload`, and reopen: the toggle must be **off** again — diagnostics is deliberately session-only and never persists. Failure is diagnostics still enabled after a reload.

## Flavor differences to watch

Do not skim these. Each one behaves differently on the two clients, and a plan run on only the forgiving flavor will pass while the add-on is broken for half its users.

- **Options panel docking (step 25)** — correct on Classic Era; **TBC Anniversary is the client where the panel has historically floated free** of the Options window instead of docking inside it. Connoisseur does have `/foodie` and a mini-map button, so a floating panel isn't fatal — but it is still a failure.
- **Warlock stone rank pinning (steps 121–122)** — the single most repeated bug in this add-on's history, and it has broken **Era** three times. Era spells each tier distinctly and must be cast bare; TBC uses numeric ranks and must pin `(Rank N)`. Getting it wrong on Era produces a **silent no-op** — the right-click simply does nothing, with no error to warn you. Test the click, not just the body text, on both flavors.
- **Ritual of Refreshment and Ritual of Souls (steps 117 and 123)** — these spells **do not exist on Classic Era**. The correct Era behaviour is a middle-click that does nothing and prints nothing. On TBC Anniversary they must actually cast. Passing on one flavor tells you nothing about the other.
- **Level-gated content** — Anniversary reaches level 70 and Era stops at 60, so several picks (higher potion and food tiers, the level-68+ and level-70 rituals, higher conjure ranks) can only be exercised on Anniversary. A macro that picks correctly at 60 has not been proven at 70.
- **Macro body length** — the same macro is longer on some clients than others once localized spell names are involved. See the localization spot-check below; the trims that protect against this are the ones step 103 exercises.

## Localization spot-check

Optional, and only worth running on a non-English client. Connoisseur ships eleven locales and writes macro bodies out of client-localized spell names, so this is where breakage shows up.

**201.** Log in on a non-English client and read the settings panel, the mini-map tooltip, and the Restocker window. Every label, description, and tip must render in that language. Failure is a raw key showing through — text like `FEATURE_SCROLL_BUFFS` or `RESTOCKER_WITHDRAW_LABEL` on screen instead of a sentence. Four things must stay **English on every client and are not failures**: the slash commands `/foodie` and `/crs`, the four URLs, and the service names Discord, GitHub, CurseForge, and Wago. A translated slash command would simply stop working.

**202.** Trigger each chat message you can: the welcome line, a "No suitable *X* found" line, a Ready Check report, the in-combat options refusal, and a "You don't currently know *X*" tip. Each must read as one complete sentence. Failure is `nil` anywhere in a line, a stray `%s` or `%d`, a value appearing twice, or values landing in the wrong slots.

**203.** **This is the highest-risk localization check.** On a **Hunter**, read the `- Feed Pet` body. The whole body must be under the macro limit and must still end with its `/use item:` food line. **ruRU is the canary** — Cyrillic spell names cost roughly double, and the Feed Pet cascade names up to five of them. It is correct and expected for the Ctrl-Dismiss and Shift-Revive shortcuts to be **dropped** in a wide locale; it is a failure if the summon branch, the Mend branch, the default Feed, or the trailing food line goes missing, or if the body is cut off mid-line.

**204.** On a **Warlock** on ruRU or deDE, read the `- Health Potion` body with **Combine Healthstones** on and three potions in bags. It must fit the limit, and it must shed the stacked Healthstone lines **first**, then potion fallbacks from the bottom — the first potion line is never dropped. Failure is a truncated last line or a missing rank-1 potion.

**205.** On a **Druid** on ruRU, read a DruidMacroHelper-wrapped macro. It must still end with `/cast !<form>` and `/dmh end`. Failure is either of those lines missing, which leaves the druid stuck out of form.

**206.** Open **Diagnostic Tools → Show Connoisseur Context** and read the pet diet names against what `/dump GetPetFoodTypes()` returns while your pet is out. They must match exactly. If they don't, pet food selection dies silently with no error to warn you. Failure is exactly that pattern: everything else fine, pet food finding nothing.

**207.** Read the translated sentences alongside the English ones. Some languages reorder a sentence so a value lands in a different position — this is **intentional and correct**, and a translator should not "fix" it. Failure is only when the sentence is genuinely ungrammatical, or the values are attached to the wrong parts of it.

## Sign-off

Manual testing is complete when **every step passes on both Classic Era and TBC Anniversary**. A single flavor is half a run. Once both rows below are filled in and passing, the add-on is ready for `4 - Pre-Launch Review Prompt.md`.

| Flavor | Tester | Date | Result | Failed steps | Sections untested (no character) |
| --- | --- | --- | --- | --- | --- |
| Classic Era | | | ☐ Pass ☐ Fail | | |
| TBC Anniversary | | | ☐ Pass ☐ Fail | | |
