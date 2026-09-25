# Connoisseur // Notes

> The maintainer's settled rulings for Connoisseur, kept so no review raises them again: exceptions to the Gogo1951 add-on Style Guide, and decisions it leaves open.

## Exceptions

None.

## Decisions

- The TOC `## Title` and `README.md`'s H1 are `Connoisseur & Restocker`, for discoverability of the absorbed Restocker feature; every other surface says `Connoisseur`.
- The mini-map button's Middle-Click clears the current character's Ignore List instantly, with no confirmation, as a deliberate quick-clear, and the Ignore List panel ships no clear-all of its own.
- `README.md`'s Appreciation & History thanks only targon (Free Refills), kvakvs and guardycmw, under the 🚀 lead line: Connoisseur is Gogo1951's own, Restocker is an absorbed subsystem, and ChiliFajita's Auto Restocker is gone from CurseForge and GitHub. The in-game Restocker Praise string names ChiliFajita, kvakvs and guardycmw.
- `README.md`'s Related Add-ons files an add-on built around one Connoisseur job, such as Poisoner for poisons or Feed Me for pet feeding, under 🔴 Alternatives.
- Restocker's saved data lives at `ns.db.global.restocker`, account-wide and outside AceDB profiles, so a profile switch or reset never touches a Restock List or re-offers the Starter List; its named lists and per-character list pointers are data structures, not AceDB profiles.
- Files inside a `Features/` feature subfolder carry the feature name in the basename (`Features/Restocker/Restocker-Window.lua`); `Features/Macros/` keeps its own file names.
- Every `ns` function is dot-defined (nothing on the namespace takes `self`), including where guide snippets show colon methods.
- The Readiness Report ships default-off behind `readinessReportEnabled` as a beta soft launch, and stays default-off; the original `readinessReport` key is retired.
- The Restocker window's Amount box saves as you type: closing the window without pressing Enter keeps what the box holds, and an emptied box lands at 0 (store-all for bank deposits). The live write and the tooltip's "Press Enter" wording both stay.
- Restock Lists are called "List" in every player-facing string, never "Profile"; the `RESTOCKER_PROFILE_*` key names and the `/crs profile` command literal keep their old spelling, and the values are never changed to match the key names.
- New Restock Lists are named for the character's localized class, numbered "Class (2)" on collision, and never auto-join an existing list; legacy "Name-Realm" lists stay as they are, and there is no eponymous backstop list.
- The Poisons macro keeps its `/click StaticPopup1Button1` replace confirmation even though it also accepts any other confirmation box on top; a Weapon Buff macro may reuse it.
- The Restocker window's add box takes dragged items and typed item IDs only: both clients route Shift + Click through `ChatFrameUtil.InsertLink`, which an add-on can't claim without overwriting a Blizzard function.
- The Restock List window keeps its 870px default width, leaving item names 201px at English widths; the column-layout test's default-size floor is 201px to match, and only the minimum width (819px) holds the 150px floor.
- The List Builder names its poison and reagent rows with the client's own item names, not translated strings: a poison type by its ladder's first item, any other row by the item a tick adds. Only rows that stand for a kind of item (the food diets, water, ammo) keep a label, and poison-group and pet-food names in the Macros panel come from the client the same way. Its rows live once, in `Data/Data.lua`, never in a copy per flavor folder, and its window is 640px wide so the longest English name, Rune of Teleportation, fits on one line.
- The consumable data tables leave out oddball items that a data check turns up, even when they share a table's cooldown: Scorpid Surprise (5473), Green Tea Leaf (1401), Holy Spring Water (737) and Night Dragon's Breath (11952) stay out.
- Season of Discovery items live only in `Data/Discovery/`: every other data folder leaves them out with a deliberately-absent note, even where its client's Validate Data reports them OK, since OK only proves the client knows the ID.
- A Classic Era Validate Data report also prunes `Data/Discovery/`: Season of Discovery runs on the same client, so a row Era flags NOT ON CLIENT leaves Discovery too, while Discovery's values wait for a Season of Discovery export.
- The Readiness Report's Flask or 2x Elixirs check counts the zone-limited flask and elixir auras (the Unstable and Shattrath flasks, and Bloodberry) as flasked everywhere, because those auras persist outside their zones and the check errs toward silence.
- Star's Tears and Star's Lament are offered only inside an arena (arena column 1), though the client lets them be used anywhere: they are expensive, and ordinary food and water serve better outside one.
- The four Ogre Brews keep Gruul's Lair (330) among their allowed zones: they work there, though their tooltip names only the Blade's Edge Plateaus.
- Harvest Bread and Winter Veil Loaf carry no arena value though their tooltips say Conjured Item: the TBC client doesn't flag them usable in arenas, so they are never offered there. The data's arena column is also the only test for conjured, so Use Conjured Food & Water First treats them as ordinary food, as it does anything that merely sells for nothing (the Underspore Pod, holiday treats).
- The Feed Pet macro's "You don't currently know Mend Pet." stays its own locale string (`TIP_PET_NO_MEND`) rather than joining the spell-name tips built on `TIP_DONT_KNOW_SPELL`: joining would put Mend Pet's spell ID in every data folder, and the only locale whose clients name the spell differently is esES, where TBC Anniversary says "Aliviar mascota".
- Where one language's clients name the same spell, item or interface label differently, its locale file uses the Classic Era and WoW Forever name: one string serves all three clients, and those two agree.
- Use Conjured Food & Water First (Food and Water only, off by default, When Leveling by default) is the only way a macro passes over your best item, for the free conjured food and water a Mage hands out. Potions, pet food and every other macro always use the best, and there are no custom sort orders or second-best rules (issue #40).
- The options panel shows macro names without their leading "- " (the Enable Macros checkboxes read Food, Water and so on); the macros themselves keep it.
- On every options page, a sub-option stays hidden until its checkbox is ticked. A dropdown then appears on the checkbox's own line with no caption, and a break follows every row; only dependent checkboxes (the scroll and pet food types, the in-town reminder's Play Sound) appear beneath their toggle instead.
- Buff Food, Scroll Buffs and Use Conjured Food & Water First share one Food & Water section, each described in its own hover text; Buff Re-Application and Pet Food Buffs keep their own sections.
- Every when-to-use dropdown (Buff Food, Scroll Buffs, Pet Food Buffs, conjured food and water) offers the same six choices in the same order: Always, When Solo, When in a Party or Raid, When in a Raid, When Leveling, When at Max Level. None is trimmed per feature, even where one reads oddly, such as buff food only when solo. Leveling means below the client's own max level, read from the game rather than hard-coded, and one choice covers one condition: group and level never combine.
- Every options dropdown is the same width. A choice too long for it gets shorter copy rather than a wider box: the Explosives layouts name only the Left-Click, since the Right-Click always does the other.
- A Restock List row's Buy toggle governs every purchase the row makes, so a poison row with Buy off has none of its ingredients bought either.
- The Readiness Report counts an item on either Ignore List as carried: it never names something the player has in their bags as missing.
- The Restock window closes with a merchant or bank only when that visit opened it. A window the player opened stays open until they close it, and a loading screen never closes it.
