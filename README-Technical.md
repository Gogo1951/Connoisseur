# Connoisseur // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Connoisseur. For end-user documentation, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md).

## File Map

```
Connoisseur/
├── .github/
│   └── workflows/
│       └── package.yml                         CurseForge release and library vendoring
├── .gitattributes                              Line-ending normalization
├── .gitignore                                  Dev-clutter ignore list
├── .luacheckrc                                 Lint config; skips Includes/ and the offline suites
├── .pkgmeta                                    Externals and the packager ignore list
├── Consumable-Connoisseur.toc                  Load order; one TOC covers Era and TBC Anniversary
├── Data/
│   ├── Data.lua                                Locale init, palette, ns.MacroConfig, options grid, conjure spells
│   ├── Default-Settings.lua                    ns.DATABASE_DEFAULTS, and why each key sits in its scope
│   ├── Bandages.lua                            Static item data (SQL-sourced)
│   ├── Consumable-Upgrade-Paths.lua            Staple ladders: what replaces what, by level and expansion
│   ├── Elixirs.lua                             Flask and elixir buff IDs, plus the questionable-gear names
│   ├── Explosives.lua                          Static item data; carries the Engineering specialization gate
│   ├── Food-and-Water.lua                      Static item data; buff, zone, arena and conjured flags
│   ├── Healthstones.lua                        Static item data; its own required-level column
│   ├── Mana-Gems.lua                           Static item data plus ns.ConjuredItemIDsBySpell
│   ├── Pet-Foods.lua                           Pet food table plus ns.PetDietMap, the canonical diet numbering
│   ├── Poison-Recipes.lua                      Crafted poison to reagent rows, flagged per expansion
│   ├── Poisons.lua                             Poison table plus the six poison groups
│   ├── Potions.lua                             Static item data
│   ├── Scrolls.lua                             ns.ScrollData and ns.SCROLL_CHECK_ORDER
│   ├── Soulstones.lua                          Static item data plus the soulstone buff IDs
│   └── Starter-List-Categories.lua             What the first-run Restock List window offers
├── Features/
│   ├── Core.lua                                Event dispatcher, AceDB lifecycle, update throttle
│   ├── Utilities.lua                           ns.GetColor, API shims, ns.IsEra / ns.IsTBC, small predicates
│   ├── Announcements.lua                       ns.PrintMessage and the once-per-session welcome
│   ├── Item-Cache.lua                          Derived per-item data, plus the session GetItemInfo memo
│   ├── Scanner-Character.lua                   Skills, aura snapshot, scroll resolver, early re-apply
│   ├── Scanner-Inventory.lua                   Bag scan, RANKING_PRIORITY ladder, per-category winners
│   ├── Macros/
│   │   ├── Engine.lua                          Definition registry, body and state-key builders, the 255 trim
│   │   ├── Runtime.lua                         ConnFire / ConnTip / ConnIf / ConnNoItem macro globals
│   │   ├── Tools-Mages.lua                     Mage conjure resolvers (food, water, mana gem, table)
│   │   ├── Tools-Warlocks.lua                  Warlock conjure resolvers (healthstone, soulstone, soulwell)
│   │   ├── Tools-Rogues.lua                    The Poisons macro, start to finish
│   │   ├── Tools-Hunters.lua                   Pet spells, pet food, and the Feed Pet macro
│   │   ├── Bandage.lua                         One ns.RegisterMacroType definition
│   │   ├── Explosive.lua                       Definition plus the click-layout dropdown
│   │   ├── Food.lua                            Definition: buff food, pet-buff override, scroll-only mode
│   │   ├── Health-Potion.lua                   Definition plus optional healthstone stacking
│   │   ├── Healthstone.lua                     Definition
│   │   ├── Mana-Gem.lua                        Definition
│   │   ├── Mana-Potion.lua                     Definition
│   │   ├── Soulstone.lua                       Definition
│   │   ├── Water.lua                           Definition plus the Shadowmeld drinking line
│   │   └── Integration-Druid-Macro-Helper.lua  DMH powershift wrapping (HP / MP / HS)
│   ├── Action-Button-Text.lua                  Macro-name visibility on the default action bars
│   ├── Readiness-Probes.lua                    Live reads: expiring buffs, weapon buffs, gear, talents
│   ├── Readiness.lua                           The Readiness Report: what it says, and when it stays quiet
│   ├── Ignore-List.lua                         The two ignore lists, their scopes, and logout pruning
│   ├── Restocker/                              The Restock List, behind /crs
│   │   ├── Restocker-List.lua                  The list itself: lookups, the New group, adding an item
│   │   ├── Restocker-Saved-Lists.lua           Named Restock Lists: add, rename, copy, delete, switch
│   │   ├── Restocker-Saved-Format.lua          The one-line saved format, inflate and deflate
│   │   ├── Restocker-Bags.lua                  Bag and bank slot scanning and item-move primitives
│   │   ├── Restocker-Bank.lua                  Withdraw and deposit engine: coroutine, pacing, watchdogs
│   │   ├── Restocker-Merchant.lua              Purchase orders, the buy loop, the grocery list
│   │   ├── Restocker-Crafting-Reagents.lua     Recipe resolution and the reagent purchase order
│   │   ├── Restocker-Upgrade.lua               Level-up ladder application
│   │   ├── Restocker-Window.lua                Frame, geometry, filter box, add row, shared tooltip
│   │   ├── Restocker-Window-Columns.lua        The grid: columns, widths, shared colors, the header
│   │   ├── Restocker-Window-Filter.lua         What shows, in what order, under which category
│   │   ├── Restocker-Window-Rows.lua           The controls on the grid, and the render loop
│   │   ├── Restocker-Window-Categories.lua     The category pane and its selection state
│   │   ├── Restocker-Window-Footer.lua         The list selector, Copy and Delete, the rename box
│   │   ├── Restocker-Starter-List.lua          First-run staples: categories, ticking, login trigger
│   │   ├── Restocker-Reminders.lua             Town, bank and merchant shortfall reminders
│   │   ├── Restocker-Events.lua                Lifecycle and the event map Core dispatches through
│   │   ├── Restocker-Slash-Command.lua         The /crs dispatcher (registered in Options/Options.lua)
│   │   └── Tests/                              Dev-only offline suites, run with plain lua
│   ├── Tests/
│   │   └── ReadinessTest.lua                   Dev-only offline suite for the Readiness Report
│   ├── Diagnostics.lua                         Runtime-only probes and reports, never persisted
│   └── Minimap-Button.lua                      LDB object, tooltip, click handlers
├── Includes/
│   ├── Images/
│   │   └── Connoisseur.tga                     Add-on icon (## IconTexture)
│   ├── Libraries/                              Vendored libraries, never edited by hand
│   └── Sounds/
│       └── Low-Battery.ogg                     The Restock List's town-reminder alert
├── Locales/                                    AceLocale files, eleven locales; enUS.lua is the source of truth
├── Options/
│   ├── Options-Utilities.lua                   Shared widgets, the item-list builder, the ItemLink widget
│   ├── Options-General.lua                     Root General panel
│   ├── Options-Macros.lua                      Macros panel: which macros exist, and how each behaves
│   ├── Options-Restocker.lua                   Restocker panel: reminders, auto-open, the Starter List button
│   ├── Options-Starter-List-Popup.lua          The first-run window; never added to the Blizzard tree
│   ├── Options-Ignore-List.lua                 Ignore List panel: one tree node per scope
│   ├── Options-Readiness.lua                   Readiness Report panel: master switch and its categories
│   ├── Options-Profiles.lua                    Stock AceDBOptions-3.0 panel
│   ├── Options-Diagnostics.lua                 Diagnostic Tools panel
│   └── Options.lua                             Registration, panel routing, /foodie and /crs
├── LICENSE                                     MIT
├── README.md                                   End-user documentation
├── README-Technical.md                         This file
├── README-Testing.md                           Manual test plan
└── To Do.md                                    Maintainer backlog
```

Three names for one add-on, and they do not all match. The GitHub repo is `Connoisseur`, the installed folder and the CurseForge slug are `Consumable-Connoisseur` (which is why the TOC is named that, and why `ADDON_NAME` reads that way), and the in-Lua brand identity is `Connoisseur`, pinned once as `ns.LOCALE_NAME` in `Data/Data.lua` and reused for the AceLocale lookup, the LibDBIcon key, and the LDB object name.

`.pkgmeta`'s ignore list strips the repo scaffolding above the TOC at build time, along with `LICENSE`, `To Do.md`, and `Features/Restocker/Tests/`, so an installed copy downloaded from CurseForge or Wago does not carry them.

Every file inside a `Features/` feature subfolder carries the feature name in its basename, so an editor tab or a stack trace identifies itself without the folder: `Restocker-Window.lua`, never `Window.lua`. `Features/Macros/` is the one exception, keeping the layout its own restructure settled.

The whole add-on hangs off the shared namespace with **dot functions only**. Nothing on `ns` takes `self`, including the Diagnostics framework and the options opener, where the Style Guide's snippets show colon methods. A Restock List function is `ns.UpdateRestockList` in exactly the way a scanner function is `ns.ScanBags`, and names that would be ambiguous on a shared namespace carry the feature word (`ns.ShowRestockWindow`, not `ns.Show`).

Deprecated files that must stay gone: the pre-restructure `Features/Macro-*.lua` layout, and the whole pre-rename Restocker file set, which was renamed wholesale to the `Restocker-*.lua` scheme above. Do not reintroduce `Bag.lua`, `Bank.lua`, `Bank-Restock.lua`, `BuyCommand.lua`, `BuyIngredients.lua`, `Cache.lua`, `Containers.lua`, `Events.lua`, `Inventory.lua`, `Item.lua`, `KvEnv.lua`, `List.lua`, `List-Categories.lua`, `ListFrame.lua`, `MainFrame.lua`, `Merchant.lua`, `Module.lua`, `Profiles.lua`, `Recipe.lua`, `Restocker.lua`, `RestockerClass.lua`, `RestockerConf.lua`, `Settings.lua`, `StarterList.lua`, `Upgrade.lua`, or the annotation-only `Specs/` stubs. The module registry (`Module.lua`), the flavor-flag duplicate (`KvEnv.lua`) and the second saved-variables table are all dissolved into the namespace, `ns.IsEra` / `ns.IsTBC`, and `ConnoisseurDB`.

## Architecture

### Event Loop

`Features/Core.lua` owns one frame and one dispatcher; feature files never register their own events, the Restock List included. The full event list is exported as `ns.EVENT_NAMES` so the dispatcher and Diagnostics' Event Registration check can never drift.

Five names live in `DEFERRED_EVENTS`, which is what the plain registration loop skips, because each needs conditional or unit-filtered registration:

| Event | How it registers |
|---|---|
| `UNIT_PET`, `UNIT_SPELLCAST_SUCCEEDED` | `RegisterUnitEvent` on `player` |
| `UNIT_AURA` | `RegisterUnitEvent` on `player` and `pet`, only while a buff-tracking feature is active (`ns.UpdateAuraTracking`) |
| `QUEST_LOG_UPDATE` | Hunters only, re-decided on every arrival in `RefreshArrivalState` |
| `GET_ITEM_INFO_RECEIVED` | Only while somebody is waiting on item data |

`GET_ITEM_INFO_RECEIVED` has two independent waiters (the bag scan and the Restock List), so it goes through the keyed `ns.RequestItemInfoEvents` / `ns.ReleaseItemInfoEvents` pair and unregisters only when the last waiter releases. Keyed rather than counted: a waiter that asks twice must not have to release twice.

Rebuilds funnel through `ns.RequestUpdate()`: a two-flag throttle (`isUpdatePending` and `isTickScheduled`) arms a 0.5 second `OnUpdate` tick. The flags are separate so a pending update can never strand, because any out-of-combat request re-arms a disarmed tick.

Two firehose events diff before they request. `PLAYER_TARGET_CHANGED` fires on every tab, and only three facts about a target reach a macro body (is it a friendly player, is it the player, what level is it), so the dispatcher records that signature and requests only on a change. Anything new that reads the target must join that signature or its macro goes stale. `UNIT_AURA` does the same in `ns.HandleUnitAura`, comparing the Well Fed state and the two scroll inputs.

### Combat Lockdown

Macros cannot be written in combat. Every path defers: the dispatcher swallows most events under `InCombatLockdown()` (setting `isUpdatePending`), the throttle tick disarms itself, and `PLAYER_REGEN_ENABLED` replays the pending work.

The options opener is the one place that refuses instead of deferring. `ns.OpenOptionsPanel` (`Options/Options.lua`) prints `CHAT_OPTIONS_IN_COMBAT` and returns. It never queues the open for when combat ends, so `/foodie` and the mini-map button's Shift plus Middle-Click answer identically.

Several branches are handled *above* the dispatcher's lockdown guard, because each must work mid-combat and none touches a protected function:

| Event | Why it runs in combat |
|---|---|
| `PLAYER_LOGIN` | `InitVars` must create `ns.db` even when the player enters the world already fighting (zoning into a running battleground). |
| The Restock List handlers | A merchant or bank window cannot open in combat, and a logout mid-fight must still pack the list for the saved-variables file. |
| `UI_ERROR_MESSAGE` | Zone-restriction reporting fires exactly when a zone-locked potion is pressed mid-fight; the dead-pet branch only flips a flag. |
| `PLAYER_LEVEL_UP` | A ding from a killing blow fires in combat, and the event's own level plus `GetSpellInfo` are safe combat reads. The macro *write* still defers. |
| `PLAYER_LOGOUT` | A mid-combat `/reload` still fires it, and the guard would swallow the Ignore List prune. |
| `READY_CHECK` | Ready checks routinely land with the raid already pulling; the report only reads auras, gear and the last scan. |

### Macro UI Deferral

The open Blizzard Macro UI is treated like combat. `MacroFrame` saves its edit box back over the selected macro on selection change and on close, so a body written while the frame is open never shows (the frame does not refresh) and is then silently reverted. With the state key already recording the new body, nothing would ever rewrite it, leaving that macro stale until its state key next changed.

`ns.UpdateMacros` therefore defers the whole pass while `MacroFrame:IsShown()`, and a one-time `OnHide` hook wipes the state keys and requests a full rebuild the moment the frame closes, which also heals any hand-edit of a Connoisseur macro. The hook is armed at the top of *every* update pass, not from inside the deferral branch: the frame is load-on-demand, and hanging the install off the branch left the hook unarmed whenever someone opened and closed the frame without an update landing in between. One gap survives by design, a first open-and-close with no macro update in between.

A `forced` rebuild wipes the state table *ahead* of both deferral guards, so a force that arrives in combat or with the Macro UI open keeps its force: the deferred pass runs unforced, and only the already-wiped state guarantees it rewrites bodies whose state key never changed.

### Scan, Compose, Write

1. **Scan.** `ns.ScanBags()` (`Scanner-Inventory.lua`) walks bags once, dispatches every usable item to each registered definition claiming its cached `itemType`, and ranks candidates through the single `RANKING_PRIORITY` ladder: buff food (gated on `ns.AllowBuffFood`), percent restores, raw restore value, the burn-first steps (conjured, zone-locked, soulbound), vendor price, high-stack, hybrid, count, itemID. The burn-first steps are boolean tiebreaks ordered by shelf life, so you spend the copy worth least to you soonest: conjured vanishes at logout, zone-locked dies at the zone door, soulbound can never be traded or sold. They sit deliberately *below* value, so "worthless elsewhere" spends a tie but never beats a stronger item, and they are deliberately ladder steps rather than score bonuses so no bonus can outweigh a real restore difference. Both comparator forms, the single-winner test and the ranked lists' pairwise sort, are generated from that one ordered list by `CompareRecords`, and every record on either side of a comparison is built by the one `FillRecord` function, so a new ladder step is added in exactly two places. The final itemID step makes picks deterministic across reloads, and `CompareRecords` also returns *which* step decided, which is what the Selection Report prints.
2. **Compose.** `Features/Macros/Engine.lua` builds each macro body from the definition's hooks (`conjure`, `buildUseLine`, `getStackIDs`, `buildModeOverride`, `appendBlock`, `stateExtras`); `Data/Data.lua`'s `ns.MacroConfig` supplies names and default icons.
3. **Write.** `WriteMacro` creates or edits the shared General-tab macro only when the state key changed. Creation respects `ns.MACRO_SLOT_CUSHION` (currently `0`, so creation pauses only when the General book is completely full) and warns once per session when it pauses, then self-heals when a slot frees.

Usability gates run before ranking, all in `ScanBags`: character level, First Aid / Alchemy / Engineering skill, an Engineering-specialization spell (`requiredSpellID`, checked live so learning Goblin Engineer mid-session takes effect on the next `SPELLS_CHANGED`), zone restriction against `ns.CachedMapID`, and the arena rules. Inside an arena only conjured food and water and the arena-only drinks survive, and scroll mode, pet buff food, and buff food are all suppressed. Arena state comes from `IsInInstance()`, never a zone-ID list.

The scan also publishes what it saw: `ns.BestSelection` (the live per-category winner records), `ns.ScannedItemCounts` and `ns.ScannedItemLinks` (the bag walk itself). All three are wiped and refilled in place on every pass, so they are the *last* scan's snapshot. Read them, never retain them, and never write to them from outside `ScanBags`.

### Item Data Caching

Two caches sit side by side in `Features/Item-Cache.lua`, and they answer different questions.

`ns.CacheItemData` derives a canonical consumable record per item into `ns.db.profile.itemCache`: restore values and requirements from the `ns.RawData` tables, plus the ladder's tiebreak facts (vendor price, stack size, and soulbound status via `GetItemInfo`'s `bindType`) read once and cached. Items that match no `ns.RawData` table are cached as the string `"IGNORE"` so they are never looked up twice. This one is persisted, which is why its `id` field keeps that spelling: every saved entry on every character already carries the key.

`ns.GetItemData` is a plain session memo over `GetItemInfo`, thrown away at logout, answering for any item at all (name, link, icon, stack size). A miss is memoized under a sentinel, because the Restock List asks for the same cold item many times inside one redraw. Only ID-keyed misses are remembered, since `GET_ITEM_INFO_RECEIVED` reports an id and that is the only key `ns.ForgetItemDataMiss` can clear again. `ns.GetItemHyperlink` rides on it and always returns something clickable, hand-building `|Hitem:|` from the id when the cache is cold.

A `GetItemInfo` cold-call nil marks the scan dirty. `ns.RegisterDataRetry` keeps `GET_ITEM_INFO_RECEIVED` subscribed and arms a 2 second timer to rescan. The timer carries a budget (`DATA_RETRY_MAX_ATTEMPTS`, 10) because a scan that ends unresolved re-arms the timer that starts the next scan, so an id the server never answers for would otherwise spin forever with nothing outside the pair to stop it. The event itself stays registered past the budget: it costs nothing while idle, and a late answer still rebuilds.

Invalidation of the persisted cache is two-layered: a version stamp (`itemCacheVersion ~= ns.Version`) wipes on release bumps, and a nil-test of the newest schema field catches same-version dev edits. When adding a cache field, extend that nil-test in `Scanner-Inventory.lua`; the newest field today is `isSoulbound`.

The options panels have their own warmer for the same problem. `ns.WarmItemCache` (`Options/Options-Utilities.lua`) calls `RequestLoadItemDataByID` for the ids a list is showing and repaints the panel through `NotifyChange` as answers land, with the same ten-attempt budget and one chain per registry name, so an item-list row never sits on a bare id.

### State Encoding

Every input that affects a macro body must appear in its state key, or the macro goes stale. Namespaces are disjoint by prefix so any mode transition forces a rewrite. Standard keys are item-ID-led:

```
ITEMIDS(+HS:stackIDs)?(_C(_M:id)?(_R:id)?(_MR:key)?(_MM:key)?(_NI:key)?)?(_EX:mode)?(_SM|_SE)?
```

`ITEMIDS` is the single itemID, or the comma-joined ranked list for multi-use types so a change in any fallback rank also rewrites. Food's scroll mode uses its own `SCROLLS:` prefix and the Druid override uses `DMH:`, so a transition into or out of either always rewrites. The Poisons and Feed Pet builders keep their own keys under the same lossless-key rule.

## Food Macro: Modes and Overrides

The Food definition (`Features/Macros/Food.lua`) is the busiest:

- **Plain and buff food.** Buff food competes only while the scanner's live `ns.AllowBuffFood` is true (setting, plus party or raid mode, plus not Well Fed, plus not self-targeting, plus not in an arena). Targeting yourself is a deliberate testing aid: it forces plain-food mode so you can see what the macro picks without re-toggling settings.
- **Scroll-only mode.** With missing scroll buffs and no friendly-player target, the whole body becomes a scroll applier and flips back next update:

```
#showtooltip
/use [@player] item:4425
/use [@player] item:1180
```

- **Pet-buff override.** `modifyItem` swaps the food for Kibler's Bits or Sporeling Snacks and `buildUseLine` targets `[@pet]`.
- **Stealth Eating.** `appendBlock` adds `/cast [nostealth] Stealth` for Rogues, or Shadowmeld for other Night Elves, under the food line, flagged `SE` in the state key. Water does the same for drinking (`SM`), Night Elves only, never Rogues. Scroll-only mode bypasses this, which is correct: a scroll tap is not a meal.

## Multi-Use Macros and the 255 Trim

Health Potion, Mana Potion, and Healthstone are the `ns.MultiUseMacroTypes`: up to `ns.MULTI_USE_MAX_ITEMS` (3) `/use` lines, best first. That is safe because each category shares an item cooldown, so one press consumes one item and the extra lines are combat fallbacks for when macros cannot be rewritten. Optional Healthstone stacking appends the stone list under the potion lines.

Macro bodies are capped at 255, and the *unit* of that cap is not settled. Blizzard's macro edit box caps with `letters="255"` while the chat box uses `SetMaxBytes` (Style Guide, MESSAGES, Message Length is canonical). Connoisseur sidesteps the question by measuring bytes: every trim site tests `#body > 255`, and byte length is never smaller than character length, so a body that passes the byte guard is inside either ceiling. **Never convert one of these `#body` checks to a character count.**

There are three trim sites, and each protects a different tail:

| Site | Sheds | Never drops |
|---|---|---|
| `Engine.lua`, `BuildStandardBody` | Stacked stone lines first, then ranked fallback lines bottom-up | The rank-1 `/use` line |
| `Integration-Druid-Macro-Helper.lua` | `/use` lines from the bottom | The trailing `/cast !Form` and `/dmh end` pair |
| `Tools-Hunters.lua` | Optional modifier shortcuts, Dismiss then Revive | Summon, Mend, Feed, and the food line |

Localized spell names make this real: a body that fits in enUS can overflow in ruRU, which is the widest-encoding locale the add-on ships and therefore the canary.

Connoisseur never calls `SendChatMessage`. It has no cross-player chat path and defines no `ns.TARGET_MARKER`, so the separate 255-*byte* chat ceiling does not apply anywhere in this codebase.

## Era vs TBC: Warlock Rank Pinning

This has broken Era three times. Warlock Healthstones and Soulstones are distinctly-named spells on Era, where they must be cast bare because appending `(Rank N)` builds a spell name that does not exist and the `/cast` silently no-ops. On TBC they are one spell with numeric ranks and the rank must be pinned. The split is declared as data, `rankIsTBCOnly` on the `ns.ConjureSpells` lists, and applied only by `ns.GetSmartSpell`. Mage Conjure Food and Water are numeric-rank on *both* flavors, so their rank suffix is correct everywhere.

Read the RECURRING BUG note on `WarlockCreateHealthstone` in `Data/Data.lua` before touching any of it, do not "simplify" the two spell families together, and test any change on both clients: the Era representation is the one that breaks silently.

## Feed Pet (Hunter)

A custom-update definition in `Tools-Hunters.lua` with three knowledge tiers: a print-only stub (any core pet spell missing), a Mend-less cascade (levels 10 to 11), and the full cascade (12 and up: ctrl-Dismiss, shift or dead Revive, `[nopet]` Call-or-Revive, `[btn:2][combat]` Mend, default Feed plus the food line). Pet food selection prefers the lowest-level max-happiness food, skips active quest objectives, and falls back to above-level food. Dead-but-dismissed pets are detected through `UI_ERROR_MESSAGE` and flip `[nopet]` to Revive.

`QUEST_LOG_UPDATE` is registered for Hunters only, because quest-objective skipping is its sole consumer and it fires often enough that a full rescan on every other class would be pure cost.

## Poisons (Rogue)

Also custom-update. Left-click poisons the off hand (slot 17), right-click (`[btn:2]`) the main hand (slot 16), and middle-click (`[btn:3]`) casts Poisons to open the crafting window and stops the macro there. The body `/use`s the poison then the slot, clicks `StaticPopup1Button1` to confirm replacement, and clears UI errors so an empty off hand does not spam the screen. Poison groups per hand come from the profile, and group names resolve from the client's own item names, so they localize for free. Poisons are not soulbound, so a twink can carry ranks above their level; the required-level column in `Data/Poisons.lua` gates those out.

## Readiness Report

On `READY_CHECK`, one private print naming what still needs fixing. Nothing is ever sent to group chat.

**Silence is the normal output, and that is the whole design.** A category with nothing wrong prints nothing, and a clean character prints nothing at all. There is no all-clear line, and none should ever be added: a report that greets a prepared player is one that gets switched off. That silence is what lets the report cover this much without becoming noise, so a switch may only ever be able to *add* a line about something broken.

The report prints as up to three lines, each dropped when empty, each branded through `ns.PrintMessage` so no body line reads as coming from another add-on:

```
Connoisseur // Readiness Report
Connoisseur // Missing Buffs : ... . Expiring Soon : ...
Connoisseur // Missing Items : ... . Damaged Gear : ...
Connoisseur // Character : ... . Non-combat Gear Equipped : ...
```

Three gating rules run through the whole feature:

- **Two switches per buff.** The per-character macro switch says the character uses the thing at all, and the account-wide report switch says to mention it. The macro switch is tested first, because reporting a buff the character never applies is noise whatever the report is set to. Flask, weapon buffs and the group soulstone have no macro behind them and answer to their report switch alone.
- **Never nag at something nobody can fix.** The Healthstone and the group Soulstone gate on a Warlock being present, Mana Gem on the player being a Mage, Mana Potion on the class having a mana bar (a static class set, not `UnitPowerType`, which reads energy for a druid in cat form), and the main-hand weapon buff is satisfied by a Shaman in the group.
- **Read the last scan, do not rescan.** Missing items come from `ns.BestSelection`, which the throttled bag scan keeps current. `ScanBags` fills every category whether or not its macro is enabled, so a player who turned a macro off still gets a truthful answer about what they are carrying.

Coverage is settled from the aura snapshot rather than from `ns.ScrollOverrideIDs` alone, because that list holds only scrolls the player has in bags, so someone missing the buffs with no scrolls to fire would read as covered. The soulstone check asks whether a stone is *up* on anyone rather than whether anyone holds one: seven unused stones resurrect nobody. Its known limitation is that the aura APIs only answer for members the client can see, which makes the failure mode a false "missing", never a false "all clear".

`ns.BuildReadinessLines` is split from `ns.ReportReadiness` so Diagnostic Tools can render the same answer on demand. That is the only way to tell the report's two silences apart, since "you are ready" and "it never ran" look identical in a chat window. The builder deliberately ignores the master switch and the arena gate; the caller decides whether the report is allowed to speak.

The whole report is skipped inside a PvP Arena. That gate predates the character and gear lines, which *are* actionable in an arena prep window, so it is currently suppressing lines it was never written about.

## Ignore List

Two lists, and ignoring is **additive**: an item on either one is invisible to every macro's selection, and it stays hidden until it is off both. The per-character list lives on the AceDB profile; the account-wide list is its mirror in `global`. `ns.IsIgnored` is the single test, and the bag scan reads both tables directly.

`Options/Options-Ignore-List.lua` renders every list on the account as a `childGroups = "tree"` panel: one node for Global, then one per profile that holds entries, plus the profile the player is on right now so a first entry is always reachable. Node keys are the scope keys themselves, never positions, because the tree remembers its selection by arg key and a key that shifted when a profile appeared would silently reselect a different character. Rows come from the shared `ns.BuildItemListOptions`, at `ns.OPTIONS_TREE_ROW_WIDTH` rather than the full row width, since the tree sidebar takes its share of the panel first; `Options/Options.lua` seeds that sidebar to `ns.OPTIONS_TREE_WIDTH` so "Name - Realm" keys are not truncated.

Two details are load-bearing:

- **Other profiles are read through `ns.db.sv.profiles`, not `ns.db.profile`.** AceDB materializes only the profile you are on, and it strips default-valued tables at logout, so a character who never ignored anything has no stored `ignoreList`, and one who never changed a setting has no stored profile at all. `ns.GetIgnoreListForScope` returns nil in those cases and builds only what it needs when a write passes `createIfMissing`.
- **Promote, do not copy.** A row's per-scope button issues the account-wide add alone; `ns.SetIgnoredInScope` then clears that item off every character's list, because the global list already hides it everywhere and a leftover per-character row could no longer change any outcome. Removing from Global deliberately puts the item back on nobody: there is no record of who held it.

The mini-map button's Right-Click (ignore the food it is offering) and Middle-Click (clear, no confirmation) act on the current character's list only, matching the list its own tooltip shows. Both call `NotifyChange` on the Ignore List panel, since a mini-map click is the one edit path with nothing else to ask for a repaint. Every mutation also wipes the macro state and forces a rebuild, because an item ignored while its macro already names it has to be written out of that body, not just out of the list. On logout, `ns.PruneIgnoreList` drops entries from the current character's list and the account-wide list that no longer match any item data; other characters' lists are pruned when they log out, against their own data.

## Restock List

The Restock List, behind `/crs`. It is an ordinary part of the add-on: it hangs off the shared namespace, its events run through Core's dispatcher, its data lives on `ns.db.global.restocker`, and it is formatted and linted like every other file. Key mechanics:

- **Bank restocking** is a coroutine stepped by a ping-paced `OnUpdate` timer. Every step re-scans reality (never optimistic bookkeeping), issues at most one move, and waits for item locks to settle. A no-progress watchdog (`MAX_STUCK_STEPS`) stops with an honest report; an in-flight gate (`MAX_INFLIGHT_STEPS`) ignores scans taken while a move is mid-air, because a maintained item's bag-plus-bank total can dip with nothing locked; a bounced exact split escalates to a whole-stack pull whose overshoot is stashed back. Once the moves are done the loop enters a tidy phase (full-absorb stack merges only) with a watchdog of its own.
- **Hard invariant: never sell.** `C_Container.UseContainerItem` sells when a merchant window is open, so `RunRestockLogic` (`Restocker-Bank.lua`) bails the moment `ns.merchantIsOpen` is set, including on a stale flag or an odd `BANKFRAME` / `MERCHANT` event order. There is no sell path at all, and having too much of an item is left alone.
- **The one-line saved format.** Each item deflates to a single comma-separated string at logout and inflates at login (`Restocker-Saved-Format.lua`), so the SavedVariables file has exactly one physical line per item instead of the many WoW's serializer would spend on a table. Field order is `itemType, itemName, amount, stashTobank, restockFromBank, buyFromMerchant, reaction, upgrade, buyExtra`, with booleans as `1` and `0`. The itemID is never written, because the table key *is* the itemID. There is **no version stamp and none is needed**: the parser reads every shape the format has ever had (lines with no leading type, older lines that repeated the id), and the next save rewrites them in the current form. A new trailing field can be appended without any migration, because a missing trailing field reads as that flag's own default, which is on for `reaction` and `upgrade` and **off** for `buyExtra` (a row written before that field existed never asked for a vendor buyout).
- **Buy Extra.** An ordinary order asks for the shortfall and caps down to what the vendor holds. An Extra row instead takes a *limited* slot's whole count, up or down, which is the useful behavior for the scarce Classic consumables that trickle back a few at a time. Unlimited slots are deliberately untouched by Extra, since "buy every one they have" has no end on a slot that never runs out.
- **Crafting reagents buy all-or-nothing per vendor.** `VendorStocksAllReagents` (`Restocker-Merchant.lua`) gates the poison-ingredient auto-buy: unless the vendor stocks *every* reagent the crafting order still needs (bag-covered reagents excluded, and a sold-out limited slot counting as not stocked), none are bought. Half a recipe is worse than none, and a trade-goods vendor that carries vials but no dust used to fill bags with vials that could not become poisons. Quantity coverage is deliberately not required: a limited slot holding 4 of the 6 dust wanted still crafts 4 poisons. Items the player put on the list directly are their explicit ask and are unaffected.
- **Counting is by itemID everywhere except the reagent order.** `GetMerchantItemInfo` reports a localized *name*, so the crafting purchase order has to key by name to merge against merchant slots. Every other count (`BuildPurchaseOrder`, `BuildGroceryList`, the bank engine) keys by id, because a name-keyed count reads 0 for a saved line whose name never resolved and then buys a full stack of something already in the bags.

### Grocery List and Reminders

`ns.BuildGroceryList` (`Restocker-Merchant.lua`) is the single answer to "what am I short of": the same shortfall the merchant purchase order computes, minus the vendor. The required-reputation gate is skipped, since it depends on which vendor you walk up to, and crafting reagents are left out, since `Restocker-Crafting-Reagents.lua` resolves those against the merchant's stock. Counts are bags only, matching what the merchant restock compares against, so the list and the buy agree.

Every reminder reads that one list, so they can never disagree:

- **Entering town.** Keyed off the client's own resting flag, which is on in inns and cities and nowhere else, so no zone list is maintained. Only a not-resting to resting edge counts, and three events reach the check because one signal does not cover every arrival: `PLAYER_UPDATE_RESTING` (walking in), `PLAYER_ENTERING_WORLD` (login, hearth, portal, leaving an instance, where the flag crosses the loading screen with no update event behind it), and `PLAYER_CONTROL_GAINED` (landing off a flight path). A taxi counts as *not* in town for its whole duration, which is what leaves a real edge for the landing to trip. Nothing fires until `PLAYER_ENTERING_WORLD` has said whether this was a login (an arrival, so it reminds) or a `/reload` (not one, so it only records position), and a one-minute cooldown collapses clustered arrivals into one nudge. Chat line and alert sound are independent toggles.
- **Leaving a merchant or a bank.** Reported on the way out, after a 0.3 second settle so purchases and bank moves that land on `BAG_UPDATE` are already counted. Each close handler keys off its own tracked open flag, because the client fires `MERCHANT_CLOSED` and `BANKFRAME_CLOSED` on loading-screen teardown with no matching open, and can double-fire them.
- **Mini-map tooltip.** A count, not a list; the full list would run taller than the screen.

Each reminder has a Simple or Verbose mode (`ns.REMINDER_SIMPLE` / `ns.REMINDER_VERBOSE`): the headline alone, or the headline plus one line per short item. Town defaults to Verbose (you are away from your bags and the detail is the point); merchant and bank default to Simple (you are already looking at the window that fixes it).

### Upgrade Ladders

`Data/Consumable-Upgrade-Paths.lua` holds `ns.FoodUpgradeChains`: one ladder per staple family (each food diet, water, arrows, bullets, each poison group, each class reagent). A chain carries a `kind` plus the key its category is looked up by (`diet` for food, `group` for poisons, `reagent` for a reagent string), and its `tiers` are ordered by minimum level and then by expansion. Each tier is `{ minLevel, itemID, addedInExpansion[, removedAfterExpansion] }`.

The expansion flag is hand-set and has to be. A Wrath database cannot say when an item was added, the ID blocks interleave, and its vendor data describes 3.3.5. The tier ordering is load-bearing: where two tiers share a level (65 in every food family) `BestTier` keeps the *last* acceptable one, so a TBC client stops at the Outland item and a Wrath client carries on to the Northrend one. `diet` uses `ns.PetDietMap`'s numbering, not `item_template.FoodType`, which disagrees with it on four of six values.

`ns.UpgradeRestockList` (`Restocker-Upgrade.lua`) runs on `PLAYER_LEVEL_UP` and moves each eligible entry to a *strictly later* tier, never to "the tier matching my level", because an item above the player's level was stocked deliberately. The new level is passed in from the event rather than read from `UnitLevel`, which still reports the old level while `PLAYER_LEVEL_UP` is being handled; reading it there once cost a whole level of upgrades permanently, since nothing re-checked afterwards. It also runs on `PLAYER_ENTERING_WORLD` as a catch-up, because a ding is not the only way a list falls behind (levels gained with the add-on disabled, a list copied off a higher character). Lists are keyed by itemID, so a move is a delete plus an insert; if the target tier is already listed the two rows merge and their amounts sum. A per-item `upgrade` flag (nil means on) opts a row out. An unresolved target defers rather than writing the old name against the new ID, and retries on `GET_ITEM_INFO_RECEIVED`.

### Starter List

A character past level 5 whose Restock List is empty gets a one-off window of staples shortly after a fresh login (`isInitialLogin` only, so a `/reload` never re-opens it), and it is reachable afterwards from the Restocker panel's own button. `Features/Restocker/Restocker-Starter-List.lua` owns the trigger, the categories, and what a tick does; `Options/Options-Starter-List-Popup.lua` only draws it, as a standalone AceConfigDialog window registered like any other panel but never passed to `AddToBlizOptions`.

Every offering is drawn from `ns.FoodUpgradeChains` rather than a list of its own, so the popup can never suggest a staple the upgrader would not then maintain; single-tier reagents ride the same rails and simply never move. A ticked staple is added at the best tier for the character's level, through the same resolver the upgrader uses. Ticks are measured in whole stacks, since that is the unit a bag slot thinks in; a category may override the dropdown with its own `choices` list, and `fixedAmount` categories draw no dropdown at all. A few staples arrive pre-ticked by class, added through the same path a hand-tick uses so unticking takes them straight back off. The per-character dismissal flag lives in `ns.db.global.restocker.starterListDismissed`, not on an AceDB profile, so a profile switch or reset cannot resurrect a window the character already answered.

### The Window

The Restock List window is hand-built from Blizzard templates rather than AceGUI, and its geometry lives in `ns.db.global.restocker.framePos` so one layout follows the player across every character. Every closed control is a Blizzard frame, the list selector included, so a skin that restyles AceGUI globally (ElvUI ships one) cannot restyle one control and nothing around it. Two of them open an `AceGUI:Create("Dropdown-Pullout")` when clicked: the reputation cell and the list selector. Blizzard's `UIDropDownMenu` drives shared global frames (`DropDownList1`, `UIDROPDOWNMENU_OPEN_MENU`) that its own secure code also uses, so routing through them leaves taint behind, while AceGUI owns its frames and raises the pullout to `TOOLTIP` strata, which is also what keeps it in front of the FULLSCREEN-strata window without poking a Blizzard frame.

The grid is split deliberately: `Restocker-Window-Columns.lua` defines the columns, widths, gaps and colors once, and both the header and every row lay out through the same walk, so they cannot drift apart. `Restocker-Window-Filter.lua` is pure data (which items show, in what order, under which category) and touches no frame; it works off a `view` built once per redraw, because the sort comparator asks for an item's group on every comparison and resolving it there made an item-cache lookup O(n log n) per keystroke in the filter box.

## Diagnostics

Runtime-only (`ns.diagnostics`, never saved; everything defaults off at every login). The panel builds reports on button press only, nine of them: Event Log, Event Registration, API Endpoints, Connoisseur Context, Item Selection, Readiness Report, Other Add-ons, Saved Variables, and Library Versions. Event Registration and the API probes are driven by `ns.EVENT_NAMES` and `ns.DIAGNOSTIC_API_CHECKS` so they cannot drift from what the add-on actually uses; the event log is tapped at the top of Core's dispatcher behind a boolean read, so logging-off costs one comparison. The `taintLog` CVar buttons are the only thing Diagnostics ever writes. Its strings are developer-facing plain English and are never localized.

Three reports are worth knowing about:

- **Item Selection** names which `RANKING_PRIORITY` step decided each pick, which is what turns "this item lost" into "it lost on price". Candidate retention runs only while the panel is enabled, so normal play pays one boolean test per candidate; the retained list is wiped unconditionally at the start of every scan so switching the panel off leaves nothing stale behind.
- **Readiness Report** renders the report as it would print right now, without waiting for a ready check, and lists which switches are on. It exists to separate the report's two silences.
- **Saved Variables** dumps `ConnoisseurDB` in its real on-disk shape. Any `itemCache` and each list under `global.restocker.profiles` are counted rather than printed, so the report stays readable. Note the two `profiles` keys are different things: AceDB's own profile table prints in full because it holds the settings a bug report is about.

Two kinds of noise control keep the 500-entry event buffer honest, and both count rather than delete. Suppressed traffic renders as a per-message tally at the end of the report, biggest offender first:

- `ns.DIAGNOSTIC_EVENT_EXCLUDE` holds `UNIT_AURA`, the one firehose this add-on registers whose signal firings cannot be told apart *at capture*, because `ns.LogEvent` runs from the dispatcher before the handler and nothing yet knows whether this aura change moved anything. The firings that did are written from the other end: `ns.HandleUnitAura` calls `ns.LogEventNow` once it has decided, so the log agrees with what the add-on actually reacted to.
- `ns.MESSAGE_ID_FILTERED_EVENTS` names `UI_ERROR_MESSAGE` and the argument position carrying the text to classify by. `IsCorrelatedMessage` is an **allowlist** of exactly the globals the live handlers compare against (`ERR_ITEM_WRONG_ZONE`, `SPELL_FAILED_TARGETS_DEAD`, `ERR_INV_FULL`, `ERR_BANK_FULL`), read fresh on every call so the filter cannot drift from the handlers. Never invert it into a denylist of noise ids: noise is unbounded and renumbers across patches. A firing that does not carry the field is logged verbatim, because unclassifiable is signal.

## Saved Variables

Connoisseur uses the **Per-Character** saved-variables model (Style Guide, SAVED VARIABLES, The Two Models): `AceDB:New`'s third argument is omitted in `Features/Core.lua`, so every character lands on its own `"Name - Realm"` profile. **Reset Profile therefore clears only the active character's profile**, which is its consumable settings, poison groups, its half of the Ignore List, and the derived item cache, while everything on `ns.db.global` survives untouched.

The profile-heavy split follows the Two Models coherence rule rather than an exception: a feature whose state is genuinely per-character keeps its settings on the profile with it, and Connoisseur's consumable choices genuinely differ per character. A level-15 alt and a raiding 60 want different buff food, and two Rogues want their own poison pairs.

**`ConnoisseurDB`** is the only saved table Connoisseur declares, and the TOC's `SavedVariables` line names nothing else. Its shape:

- **`profiles.<name>`** holds the settings that legitimately differ per character: the macro behavior toggles and modes, `scrollTypes`, `petBuffTypes`, poison groups, the per-character `ignoreList`, plus the derived `itemCache` and `itemCacheVersion`. `profileKeys` maps characters to profiles.
- **`global`** holds four kinds of account-wide state, each for a concrete reason spelled out on the key in `Data/Default-Settings.lua`: presentation (`showWelcome`, `showMacroNames`, `minimap`), the shared macro set (`enabledMacros`, account-wide to match the macros themselves, which live in the shared General macro tab, so a character switch only ever rewrites macro bodies and never adds or removes a macro), the Readiness Report's master switch and its per-category switches (a behavior preference rather than a consumable choice), and the account-wide half of the Ignore List.
- **`global.restocker`** holds the whole Restock List subsystem: the named shopping lists (`profiles`, one-line item strings keyed by itemID), `profileKeys` mapping a character to the list it uses, `currentProfile`, the window's `framePos`, the reminder settings and modes, the auto-open toggles, and the per-character `starterListDismissed` flags. It sits on `global` rather than a profile on purpose: those `profiles` are the player's own shopping lists, not AceDB profiles, so the stock Reset Profile control must never reach them.

`OnProfileChanged`, `OnProfileCopied` and `OnProfileReset` all run one handler that resets macro state, refreshes aura tracking, re-pushes the two imperatively-applied global settings (mini-map visibility and macro-name text), notifies every panel in `ns.OPTIONS_REGISTRY`, and requests a rebuild, so a reset or switch takes effect immediately rather than at the next `/reload`.

There is no migration code and none is ever added; migrations are permanently retired factory-wide. A returning player whose data was never converted falls back to defaults, and that is fine. What does exist is explicit deprecated-key cleanup at init: the retired Ready Check switches listed in `ns.RETIRED_READY_CHECK_KEYS`, and two retired Restock List keys. `readinessReport` is on that list for a subtle reason worth knowing before reusing any retired name: AceDB copies scalar defaults into the saved table, so that key already sits as `true` in every existing saved file, and reading it back would switch the new opt-in report on for exactly the players it ships off for. Its replacement is the deliberately new `readinessReportEnabled`.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed, and explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*` and `**` wildcard defaults resolve through metatables.

There is no refill-on-empty list logic. Connoisseur ships no user-editable default item lists (the static tables in `Data/` are code, not saved data), and settings maps like `enabledMacros` deliberately survive being all-false. The nearest thing is the Starter List, and that is a one-off offer on a fresh character rather than a re-seed: an emptied Restock List stays empty. The derived `itemCache` is lazy-initialized outside the defaults table because Core owns its invalidation.

## Adding a New Consumable Category

1. Add the static data to a new `Data/<Category>.lua` under `ns.RawData.<Category>`, with the originating SQL query in a comment (or `-- TODO: Add SQL Query`).
2. List the file in the TOC's `# Data` block and add the defensive `ns.RawData.<Category> = ns.RawData.<Category> or {}` line in `Features/Item-Cache.lua`.
3. Extend `ns.CacheItemData` with a branch deriving the canonical record (`itemType`, values, requirements), and add the table to `ns.IsKnownConsumable` so Ignore List pruning recognizes it.
4. Create `Features/Macros/<Category>.lua` calling `ns.RegisterMacroType` (see the definition protocol at the top of `Engine.lua`), and add the TOC line among the definitions.
5. Add the macro to `ns.MacroConfig` in `Data/Data.lua` (macro name at most 16 characters, a cap noted above the `MACRO_*` block in `enUS.lua`), `enabledMacros` in `Data/Default-Settings.lua`, an Enable Macros toggle in `Options/Options-Macros.lua`, and `MACRO_*` and `LABEL_*` keys in `Locales/enUS.lua` only.
6. Mind the 255 macro ceiling if the body stacks lines; ruRU is the canary. Check the written body in-game on both clients before shipping.

## Adding a New Ranking Step

1. Add the step to `RANKING_PRIORITY` in `Features/Scanner-Inventory.lua`, in the position that expresses the preference. The order *is* the specification.
2. Fill its field in `FillRecord`, in the same file. Both sides of every comparison are built there, so this is the second and last place a step is added.
3. Add it to `CopyCandidateRecord` as well. A field left out of the diagnostic copy does not make its step neutral, it makes the step decide, because a real boolean tests unequal to a missing one.
4. Prefer a boolean ladder step over a numeric bonus folded into `score`. A bonus can outweigh a genuine restore difference, and two equal bonuses cancel each other instead of ranking.

## Adding a New Registered Event

Add the name to `ns.EVENT_NAMES` in `Features/Core.lua` and a dispatcher branch. Registration and the Diagnostics event and registration checks pick it up together. Add it to `DEFERRED_EVENTS` too if it must register conditionally or through `RegisterUnitEvent`.

The Restock List registers nothing of its own: `Restocker-Events.lua` fills `ns.RESTOCKER_EVENT_HANDLERS`, keyed by event name, and Core's dispatcher calls into it ahead of the combat-lockdown guard (none of those handlers touches a protected function). That table keeps **one handler per event**, so anything else wanting an event already in it has to share the existing entry rather than add a second one. `ns.OnRestockerEnteringWorld` is the worked example: the arrival check, the Starter List popup and the level catch-up all hang off the one `PLAYER_ENTERING_WORLD` entry.

## Adding a New Scroll Type or Poison Recipe

- **Scrolls:** add the type to `ns.ScrollData` in `Data/Scrolls.lua` (items best-first, `conflictSpells` with base amounts), then to `ns.SCROLL_CHECK_ORDER`, the `scrollTypes` defaults, an options toggle, and enUS keys. `Scanner-Character.lua` derives `ns.ScrollItemLookup`, the buff-ID sets, and the reverse conflict maps from `ns.ScrollData` at load, so nothing else needs a matching edit.
- **Poison recipes:** add a row to `ns.PoisonRecipes` in `Data/Poison-Recipes.lua`: the crafted itemID, its `{ reagentID, count }` pairs, and the expansion column where the recipe differs between clients.

## Adding a New Upgrade Ladder or Starter List Staple

1. Add the ladder to `ns.FoodUpgradeChains` in `Data/Consumable-Upgrade-Paths.lua`, tiers ordered by minimum level and then by expansion. Give it a `kind`, plus the key its category is looked up by (`diet` for food, `group` for poisons, `reagent` for a reagent string). Set the expansion flag by hand; a fourth field marks the last expansion a tier exists in.
2. A ladder alone is enough for `Restocker-Upgrade.lua`. Anything on it now follows the player's level.
3. To offer it on the first-run window too, add one row to `ns.StarterListCategories` in `Data/Starter-List-Categories.lua` with its `section`, an `L["..."]` label, the matching `chainKey`, and either `stackSize` and `maxStacks` or `fixedAmount`. Add `classes` to limit who is offered it and `defaultFor` to pre-tick it. A category whose ladder is missing is dropped at load rather than crashing the popup open.
4. Add the label key to `Locales/enUS.lua` only, and check the popup's height constants in `Options/Options-Starter-List-Popup.lua` if the new row changes how many a class sees.

## Adding a Player-Managed Item List

Every list of items the player builds renders through `ns.BuildItemListOptions` in `Options/Options-Utilities.lua`, which owns the shape: the add row (accepting a bare id or a shift-clicked item link, rejecting anything else), one inline group per item sorted by name, an optional per-row action column, and the icon-only remove button. The panel supplies only `getSourceTable`, `onAdd`, `onRemove`, `notifyKey`, its labels, and optionally `rowWidth` and `startOrder`. Restore Defaults is deliberately absent, because a list the player built from nothing has nothing to restore, so a panel needing a clear-all seats that control in its own head where it can carry the confirm the Style Guide requires of a destructive action.

## Localization

- **Structure.** Locale files live in `Locales/<locale>.lua`, each registered through AceLocale-3.0's `NewLocale`. `enUS.lua` is the source of truth and the only file that passes the `true` default-fallback flag; every string originates there and the other ten locales translate from it. All eleven register under the literal `"Connoisseur"`, which is `ns.LOCALE_NAME` in `Data/Data.lua`, not the packaged folder name.
- **Keeping locales in sync.** Every other locale carries a translation of the same key set; AceLocale falls back to English through `__index` for anything missing at runtime. Aligning the files is the Localization pass's job (`3 - Copy Cleanup & Localization Prompt.md`). Do not hand-edit non-enUS locales during ordinary work; new keys go into `enUS.lua` only and fall back until that pass runs. WoW ships a fixed locale set and every supported locale file already exists, so there is no "add a new locale" step.
- **Placeholders.** `%s` and `%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime.
- **Spanish.** `esES` and `esMX` are two separate, self-contained files; identical strings in both is correct and expected.
- **Locale overflow.** ruRU encodes widest, so it is the canary against the 255 macro ceiling; the three trims exist because of it. Macro *names* have their own hard cap of 16 characters, noted in `enUS.lua` above the `MACRO_*` block. The Starter List popup has a third kind of width budget: its rows are sized to fixed AceConfig widths, so a locale with long staple labels wraps a row rather than truncating it.
- Diagnostics strings are developer-facing plain English in `Features/Diagnostics.lua` and are never localized.

## Common Pitfalls

- **Editing macros in combat**: silently blocked by the client. Always route through `ns.RequestUpdate()`; the pending flag replays on `PLAYER_REGEN_ENABLED`.
- **Editing macros while the Blizzard Macro UI is open**: the frame's save-back reverts the write after the state key already recorded it, so the macro sticks stale. `ns.UpdateMacros` defers while `MacroFrame:IsShown()` and its `OnHide` hook rebuilds on close. Never write around that guard, and never move the hook install back inside the deferral branch.
- **Appending `(Rank N)` to warlock stones on Era**: the `/cast` silently no-ops. The `rankIsTBCOnly` flag and `ns.GetSmartSpell` own this; do not "simplify" the spell families together.
- **A body input missing from the state key**: the macro silently goes stale. Lossless keys are the rule, and mode overrides use disjoint prefixes so transitions always rewrite.
- **Reading the target without joining the target signature**: `PLAYER_TARGET_CHANGED` only requests a rebuild when the friendly, self, or level reading changes, so a new body input read off the target would never trigger one.
- **`GetItemInfo` cold nils**: a fresh login cannot resolve uncached items. The scan flags `dataRetry` and re-runs on `GET_ITEM_INFO_RECEIVED`; never assume the first scan is complete. The Restock List's upgrades and Starter List adds defer on the same miss and retry on the same event rather than writing a row with the wrong name, and options panels hand their cold ids to `ns.WarmItemCache`.
- **Reading `UnitLevel("player")` inside a `PLAYER_LEVEL_UP` handler**: it still returns the *old* level. Use the level the event passes, as Core and `ns.UpgradeRestockList` both do.
- **Overflowing macro bodies in wide locales**: always assemble then trim (see the three trim sites). `#body` measures bytes, which passes either reading of the 255 ceiling; do not loosen it to a character count.
- **Passing a numeric `1` to `CreateMacro`'s `perCharacter` argument**: the client boolean-checks it, so a number lands in General only by accident. Omit the argument, which is the unambiguous spelling of "General tab".
- **`UseContainerItem` at a merchant sells the item**: the bank restock loop must never run with the merchant window open. Guarded in `RunRestockLogic`.
- **Registering a second handler for an event the Restock List already uses**: `ns.RESTOCKER_EVENT_HANDLERS` keeps one handler per event, so the later entry silently replaces the earlier one. Share the existing entry instead.
- **Counting Restock List items by name**: a saved line whose name never resolved reads as 0 in bags and buys a full stack of something you already have. Count by itemID; the crafting reagent order is the one exception, and only because `GetMerchantItemInfo` reports a name.
- **Folding a nil-defaults flag into `x and false or nil`**: `false` is falsy, so the `or` takes over and the expression yields nil for every input. The off state becomes unstorable and the setting comes back on at the next login (see `ItemFromString`).
- **Assuming AceDB's defaults resolve through metatables**: only `*` and `**` wildcard defaults do. Scalars and tables are copied into the saved table with `rawset`, so a key that is no longer declared in the defaults is neither filled in nor stripped, and whatever the user last saved is still sitting there to be read. That is why a retired key name is nil'd rather than reused.
- **Assuming every profile is materialized**: AceDB only builds the profile you are on, and strips default-valued tables at logout. Anything walking `ns.db.sv.profiles` (the Ignore List scopes) must treat a missing profile or a missing subtable as normal, and create on write rather than on read.
- **Blizzard dropdowns in the hand-built Restock List window**: `UIDropDownMenu` drives shared global frames its own secure code also uses, so running through them leaves taint behind. The reputation cell and the list selector use an `AceGUI:Create("Dropdown-Pullout")` instead. Two consequences: an AceGUI widget's frame is wider than the box it draws, so anchor neighbours to the window rather than to the widget, and a `Dropdown-Item-Toggle` does **not** close its own pullout (unlike `-Execute`), so those menus close explicitly on pick.
- **`PLAYER_ENTERING_WORLD` refires on every loading screen**: init is guarded (`ns.db` nil-check, `varsInitialized`, a welcome once-flag), and the Starter List trigger checks `isInitialLogin`. Keep new login work behind those guards, and never hang SavedVariables setup off this event.
- **Adding an all-clear line to the Readiness Report**: silence is the feature. A report that fires when everything is fine is one players switch off entirely.
- **Putting a new setting on the wrong scope**: the profile is the default here, because consumable choices genuinely differ per character. Only add to `global` when the setting is account-wide for a concrete reason, and document that reason in `Data/Default-Settings.lua` alongside the existing keys.
- **Editing non-enUS locale files by hand**: they are owned by the Localization pass, so hand edits get overwritten. enUS only.
- **StyLua and luacheck**: run `stylua` (default config) over every Lua file before committing, then a clean `luacheck .` from the add-on root; the repo's `.luacheckrc` carries the config. `Includes/` is vendored and never touched by either. The `Tests/` folders are excluded from lint alone, because the offline suites deliberately stub the WoW globals the config declares read-only.

## Contributing

- **Issues**: [GitHub Issues](https://github.com/Gogo1951/Connoisseur/issues).
- **Bug reports**: include game version and locale, class and level, repro steps, and the relevant macro body or chat output. The in-game **Diagnostic Tools** panel (Options, AddOns, Connoisseur, or `/foodie`) generates pasteable reports. The Event Log, Connoisseur Context, Item Selection and Readiness Report sections answer most "my macro did not update" and "the report said nothing" tickets.
- **Discord**: <https://discord.gg/eh8hKq992Q>.
- **PR guidelines**: keep PRs scoped to one change; match house style (StyLua defaults plus a clean `luacheck .`); ship no migration code, since migrations are permanently retired and saved data that no longer parses falls back to defaults; check the 255 macro ceiling for any macro-body change (Style Guide, MESSAGES, Message Length); and update this document when the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Do not just say "I changed X." Frame it:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player switching between raid groups with different consumable preferences, I wanted Connoisseur to remember the last-selected food per character so I did not reset it every login. This change adds a `lastSelected` field to the AceDB profile and restores it when the database loads.*

  The User Story makes review faster and gives future maintainers context the diff alone will not carry.
