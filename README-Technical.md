# Connoisseur — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Connoisseur. For end-user documentation, see [README.md](https://github.com/Gogo1951/Connoisseur/blob/main/README.md).

## File Map

```
Consumable-Connoisseur/
├── .github/workflows/package.yml               CurseForge release and library vendoring
├── .gitattributes                              Line-ending normalization
├── .gitignore                                  Dev-clutter ignore list
├── .luacheckrc                                 Lint config; excludes Includes/ and Features/Restocker/
├── .pkgmeta                                    Externals and the packager ignore list
├── LICENSE                                     MIT
├── Consumable-Connoisseur.toc                  Load order; one TOC covers Era and TBC Anniversary
├── Data/
│   ├── Data.lua                                Locale init, palette, ns.Config, options grid, conjure spells
│   ├── Default-Settings.lua                    ns.DATABASE_DEFAULTS; profile settings plus six global keys
│   ├── Bandages.lua                            Static item data (SQL-sourced)
│   ├── Explosives.lua                          Static item data; carries the Engineering specialization gate
│   ├── Food-and-Water.lua                      Static item data; buff, zone, arena and conjured flags
│   ├── Healthstones.lua                        Static item data; its own required-level column
│   ├── Mana-Gems.lua                           Static item data plus ns.ConjuredItemIDsBySpell
│   ├── Pet-Foods.lua                           Pet food table plus ns.PetDietMap, the canonical diet numbering
│   ├── Poisons.lua                             Poison table plus the six poison groups
│   ├── Potions.lua                             Static item data
│   ├── Scrolls.lua                             ns.ScrollData and ns.SCROLL_CHECK_ORDER
│   ├── Soulstones.lua                          Static item data
│   └── Consumable-Upgrade-Paths.lua            Staple ladders: what replaces what, by level and expansion
├── Features/
│   ├── Core.lua                                Event dispatcher, AceDB lifecycle, update throttle
│   ├── Utilities.lua                           ns.GetColor, API shims, ns.IsEra / ns.IsTBC, small predicates
│   ├── Announcements.lua                       ns.PrintMessage and the once-per-session welcome
│   ├── Item-Cache.lua                          Derives and caches per-item data; ns.IsKnownConsumable
│   ├── Scanner-Character.lua                   Skills, aura snapshot, scroll resolver, early re-apply
│   ├── Scanner-Inventory.lua                   Bag scan, RANKING_PRIORITY ladder, per-category winners
│   ├── Macros/
│   │   ├── Engine.lua                          Definition registry, body and state-key builders, the 255 trim
│   │   ├── Runtime.lua                         ConnFire / ConnTip / ConnIf / ConnNoItem macro globals
│   │   ├── Tools-<Class>.lua                   What each class knows (resolvers, Feed Pet, Poisons)
│   │   ├── <Category>.lua                      One ns.RegisterMacroType definition per macro
│   │   └── Integration-Druid-Macro-Helper.lua  DMH powershift wrapping (HP / MP / HS)
│   ├── Action-Button-Text.lua                  Macro-name visibility on the default action bars
│   ├── Readiness.lua                           Ready-check self-audit
│   ├── Ignore-List.lua                         The two ignore lists, their scopes, and logout pruning
│   ├── Restocker/                              Bag, bank and vendor restocking (/crs); vendored architecture
│   │   ├── Restocker.lua                       Lifecycle, profiles, one-line saved format (v5), /crs
│   │   ├── RestockerClass.lua                  Type annotations for the RS surface
│   │   ├── Bank.lua                            Coroutine restock loop, watchdogs, in-flight gate
│   │   ├── Bag.lua / Inventory.lua             Container moves; split and merge; specialty-bag gating
│   │   ├── Merchant.lua / BuyCommand.lua       Purchase orders, reputation gate, the grocery list
│   │   ├── Recipe.lua / BuyIngredients.lua     Crafting reagent auto-buy (rogue poisons)
│   │   ├── Upgrade.lua                         Walks list entries up their ladder on level-up
│   │   ├── StarterList.lua                     First-run staple suggestions and their login trigger
│   │   ├── MainFrame.lua / ListFrame.lua       The /crs window
│   │   ├── Module.lua / KvEnv.lua              Namespace plumbing and the vendored key/value env
│   │   └── Events.lua / Item.lua / Cache.lua   Own event frame, item records, lookups
│   ├── Diagnostics.lua                         Runtime-only probes and reports, never persisted
│   └── Minimap-Button.lua                      LDB object, tooltip, click handlers
├── Includes/
│   ├── Images/Connoisseur.tga                  Add-on icon (## IconTexture)
│   ├── Libraries/                              Vendored libraries, never edited by hand
│   └── Sounds/Low-Battery.ogg                  Restocker's town-reminder alert
├── Locales/                                    AceLocale files, 11 locales; enUS.lua is the source of truth
├── Options/
│   ├── Options-Utilities.lua                   Shared widgets, the item-list builder, the ItemLink widget
│   ├── Options-General.lua                     Root General panel
│   ├── Options-Macros.lua                      Macros panel: macro toggles and per-feature behaviour
│   ├── Options-Restocker.lua                   Restocker panel: reminders, auto-open, debug
│   ├── Options-Starter-List-Popup.lua          The first-run Starter List window; never in the Blizzard tree
│   ├── Options-Ignore-List.lua                 Ignore List panel: one tree node per scope
│   ├── Options-Profiles.lua                    Stock AceDBOptions-3.0 panel
│   ├── Options-Diagnostics.lua                 Diagnostic Tools panel
│   └── Options.lua                             Registration, panel routing, and the /foodie command
├── README.md                                   End-user documentation
├── README-Technical.md                         This file
└── README-Testing.md                           Manual test plan
```

The six entries above the TOC are repo scaffolding: `.pkgmeta` strips them at build time, so an installed copy downloaded from CurseForge or Wago does not carry them.

Deprecated files that must stay gone: the pre-restructure `Features/Macro-*.lua` layout, `Features/Restocker/RestockerConf.lua` (superseded by `RestockerClass.lua` annotations), and `Features/Restocker/Settings.lua` (profile add and delete live on `RS` in `Restocker.lua`, and `CrsModule.settingsModule` does not exist).

## Architecture

### Event Loop

`Features/Core.lua` owns one frame and one dispatcher; feature files never register their own events — with one accepted exception, Restocker (below). The full event list is exported as `ns.EVENT_NAMES` so the dispatcher and Diagnostics' Event Registration check can never drift. Unit-filtered events (`UNIT_PET`, `UNIT_SPELLCAST_SUCCEEDED`) register via `RegisterUnitEvent`; `UNIT_AURA` registers only while a buff-tracking feature is active; `QUEST_LOG_UPDATE` registers for Hunters only; `GET_ITEM_INFO_RECEIVED` registers only while a scan is waiting on item data. Those five names live in `DEFERRED_EVENTS`, which is what the plain registration loop skips.

Rebuilds funnel through `ns.RequestUpdate()`: a two-flag throttle (`isUpdatePending` / `isTickScheduled`) arms a 0.5 s `OnUpdate` tick. The flags are separate so a pending update can never strand — any out-of-combat request re-arms a disarmed tick.

### Combat Lockdown

Macros cannot be written in combat. Every path defers: the dispatcher swallows most events under `InCombatLockdown()` (setting `isUpdatePending`), the throttle tick disarms itself, and `PLAYER_REGEN_ENABLED` replays the pending work.

The options opener is the one place that refuses instead of deferring. `ns:OpenOptionsPanel` (`Options/Options.lua`) prints `CHAT_OPTIONS_IN_COMBAT` and returns — it never queues the open for when combat ends — so `/foodie` and the mini-map button's Shift + Middle-Click answer identically.

Five events are handled *above* the dispatcher's lockdown guard, because each must work mid-combat and none touches a protected function:

| Event | Why it runs in combat |
|---|---|
| `PLAYER_LOGIN` | `InitVars` must create `ns.db` even when the player enters the world already fighting (zoning into a running battleground). |
| `UI_ERROR_MESSAGE` | Zone-restriction reporting fires exactly when a zone-locked potion is pressed mid-fight; the dead-pet branch only flips a flag. |
| `PLAYER_LEVEL_UP` | A ding from a killing blow fires in combat, and the event's own level plus `GetSpellInfo` are safe combat reads. The macro *write* still defers. |
| `PLAYER_LOGOUT` | A mid-combat `/reload` still fires it, and the guard would swallow the Ignore List prune. |
| `READY_CHECK` | Ready checks routinely land with the raid already pulling; the report only reads auras and the last scan. |

### Macro UI Deferral

The open Blizzard Macro UI is treated like combat. `MacroFrame` saves its edit box back over the selected macro on selection change and on close, so a body written while the frame is open never shows (the frame doesn't refresh) and is then silently reverted — with the state key already recording the new body, nothing would ever rewrite it, leaving that macro stale until its state key next changed. `ns.UpdateMacros` therefore defers the whole pass while `MacroFrame:IsShown()`, and a one-time `OnHide` hook wipes the state keys and requests a full rebuild the moment the frame closes, which also heals any hand-edit of a Connoisseur macro. The hook is armed at the top of *every* update pass, not from inside the deferral branch: the frame is load-on-demand, and hanging the install off the branch left the hook unarmed whenever someone opened and closed the frame without an update landing in between.

A `forced` rebuild wipes the state table *ahead* of both deferral guards, so a force that arrives in combat or with the Macro UI open keeps its force: the deferred pass runs unforced, and only the already-wiped state guarantees it rewrites bodies whose state key never changed.

### Scan → Compose → Write

1. **Scan** — `ns.ScanBags()` (`Scanner-Inventory.lua`) walks bags once, dispatches every usable item to each registered definition claiming its cached `itemType`, and ranks candidates through the single `RANKING_PRIORITY` ladder: buff food (gated on `ns.AllowBuffFood`) → percent restores → raw restore value → the burn-first steps — conjured, zone-locked, soulbound — → vendor price → high-stack → hybrid → count → itemID. The burn-first steps are boolean tiebreaks ordered by shelf life (spend the copy worth least to you soonest: conjured vanishes at logout, zone-locked dies at the zone door, soulbound can never be traded or sold), deliberately *below* value so "worthless elsewhere" spends a tie but never beats a stronger item, and deliberately ladder steps rather than score bonuses so no bonus can outweigh a real restore difference. Both comparator forms — the single-winner test and the ranked lists' pairwise sort — are generated from that one ordered list by `CompareRecords`, and every record on either side of a comparison is built by the one `FillRecord` function, so a new ladder step is added in exactly two places. The final itemID step makes picks deterministic across reloads, and `CompareRecords` also returns *which* step decided, which is what the Selection Report prints.
2. **Compose** — `Features/Macros/Engine.lua` builds each macro body from the definition's hooks (`conjure`, `buildUseLine`, `getStackIDs`, `buildModeOverride`, `appendBlock`, `stateExtras`); `Data/Data.lua`'s `ns.Config` supplies names and default icons.
3. **Write** — `WriteMacro` creates or edits the shared General-tab macro only when the state key changed. Creation respects `ns.MACRO_SLOT_CUSHION` (currently `0`, so creation pauses only when the General book is completely full) and warns once per session when it pauses, then self-heals when a slot frees.

Usability gates run before ranking, all in `ScanBags`: character level, First Aid / Alchemy / Engineering skill, an Engineering-specialization spell (`requiredSpellID`, checked live so learning Goblin Engineer mid-session takes effect on the next `SPELLS_CHANGED`), zone restriction against `ns.CachedMapID`, and the arena rules — inside an arena only conjured food and water and the arena-only drinks survive, and scroll mode, pet buff food, and buff food are all suppressed. Arena state comes from `IsInInstance()`, never a zone-ID list.

### Item Data Caching

`ns.CacheItemData` (`Features/Item-Cache.lua`) derives a canonical record per item into `ns.db.profile.itemCache` — restore values and requirements from the `ns.RawData` tables, plus the ladder's tie-break facts (vendor price, stack size, and soulbound status via `GetItemInfo`'s `bindType`) read once and cached; items that match no `ns.RawData` table are cached as the string `"IGNORE"` so they are never looked up twice. A `GetItemInfo` cold-call nil marks the scan dirty; `ns.RegisterDataRetry` listens for `GET_ITEM_INFO_RECEIVED` plus a 2 s timer and rescans. The timer carries a budget (`DATA_RETRY_MAX_ATTEMPTS`, 10) because a scan that ends unresolved re-arms the timer that starts the next scan — an id the server never answers for would otherwise spin forever with nothing outside the pair to stop it. The event itself stays registered past the budget: it costs nothing while idle, and a late answer still rebuilds.

Invalidation is two-layered: a version stamp (`itemCacheVersion ~= ns.Version`) wipes on release bumps, and a nil-test of the newest schema field catches same-version dev edits — when adding a cache field, extend that nil-test in `Scanner-Inventory.lua`.

The options panels have their own warmer for the same problem: `ns.WarmItemCache` (`Options/Options-Utilities.lua`) calls `RequestLoadItemDataByID` for the ids a list is showing and repaints the panel through `NotifyChange` as answers land, with the same ten-attempt budget, so an item-list row never sits on a bare id.

### State Encoding

Every input that affects a macro body must appear in its state key, or the macro goes stale. Namespaces are disjoint by prefix so any mode transition forces a rewrite. Standard keys are item-ID-led:

```
ITEMIDS(+HS:stackIDs)?(_C(_M:id)?(_R:id)?(_MR:key)?(_MM:key)?(_NI:key)?)?(_EX:mode)?(_SM|_SE)?
```

`ITEMIDS` is the single itemID, or the comma-joined ranked list for multi-use types so a change in any fallback rank also rewrites. Food's scroll mode uses its own `SCROLLS:` prefix and the Druid override uses `DMH:`, so a transition into or out of either always rewrites. The Poisons and Feed Pet builders keep their own keys under the same lossless-key rule.

## Food Macro: Modes and Overrides

The Food definition (`Features/Macros/Food.lua`) is the busiest:

- **Plain/buff food** — buff food competes only while the scanner's live `ns.AllowBuffFood` is true (setting + party/raid mode + not Well Fed + not self-targeting + not in an arena).
- **Scroll-only mode** — with missing scroll buffs and no friendly-player target, the whole body becomes a scroll applier and flips back next update:

```
#showtooltip
/use [@player] item:4425
/use [@player] item:1180
```

- **Pet-buff override** — `modifyItem` swaps the food for Kibler's Bits or Sporeling Snacks and `buildUseLine` targets `[@pet]`.
- **Stealth Eating** — `appendBlock` adds `/cast [nostealth] Stealth` (Rogues) or Shadowmeld (other Night Elves) under the food line, flag `SE`. Water does the same for drinking (`SM`), Night Elves only, never Rogues.

## Multi-Use Macros and the 255 Trim

Health Potion, Mana Potion, and Healthstone are the `ns.MultiUseMacroTypes`: up to `ns.MULTI_USE_MAX_ITEMS` (3) `/use` lines, best first — safe because each category shares an item cooldown, so one press consumes one item and the extra lines are combat fallbacks. Optional Healthstone stacking appends the stone list under the potion lines.

Macro bodies are capped at 255, and the *unit* of that cap is not settled — Blizzard's macro edit box caps with `letters="255"` while the chat box uses `SetMaxBytes` (Style Guide → MESSAGES → Message Length is canonical). Connoisseur sidesteps the question by measuring bytes: every trim site tests `#body > 255`, and byte length is never smaller than character length, so a body that passes the byte guard is inside either ceiling. **Never convert one of these `#body` checks to a character count.** `BuildStandardBody` sheds stacked stone lines first, then fallback lines bottom-up; the rank-1 line never drops. Two more sites trim the same way, `Integration-Druid-Macro-Helper.lua` (which sheds `/use` lines while protecting the trailing `/cast !Form` and `/dmh end` pair) and `Tools-Hunters.lua`. Localized spell names make this real: a body that fits in enUS can overflow in ruRU, which is the widest-encoding locale the add-on ships and therefore the canary.

Connoisseur never calls `SendChatMessage` — it has no cross-player chat path and defines no `ns.TARGET_MARKER` — so the separate 255-*byte* chat ceiling does not apply anywhere in this codebase.

## Era vs TBC: Warlock Rank Pinning (recurring bug)

Warlock Healthstones and Soulstones are distinctly-named spells on Era (cast bare; appending `(Rank N)` silently no-ops) but numeric ranks on TBC (must pin `(Rank N)`). The split is declared as data — `rankIsTBCOnly` on the `ns.ConjureSpells` lists — and applied only by `ns.GetSmartSpell`. Mage Conjure Food and Water are numeric-rank on both flavors. Read the RECURRING BUG note on `WarlockCreateHealthstone` in `Data/Data.lua` before touching any of it, and test any change on both clients: the Era representation is the one that breaks silently.

## Feed Pet (Hunter)

A custom-update definition in `Tools-Hunters.lua` with three knowledge tiers: print-only stub (any core pet spell missing), Mend-less cascade (10–11), full cascade (12+: ctrl-Dismiss, shift/dead-Revive, `[nopet]` Call-or-Revive, `[btn:2][combat]` Mend, default Feed + food line). Pet food selection prefers the lowest-level max-happiness food, skips active quest objectives, and falls back to above-level food. Dead-but-dismissed pets are detected via `UI_ERROR_MESSAGE` and flip `[nopet]` to Revive. When the localized spell names push the body past 255, the optional modifier shortcuts are shed in order — Dismiss first, then Revive — and the summon, Mend, Feed and food lines are never dropped.

## Poisons (Rogue)

Also custom-update: left-click poisons the off hand (slot 17), right-click (`[btn:2]`) the main hand (slot 16), middle-click (`[btn:3]`) casts Poisons to open the crafting window and stops the macro there. The body `/use`s the poison then the slot, `/click StaticPopup1Button1` to confirm replacement, and clears UI errors. Poison groups per hand come from the profile; group names resolve from the client's own item names, so they localize for free.

## Ignore List

Two lists, and ignoring is **additive**: an item on either one is invisible to every macro's selection, and it stays hidden until it is off both. The per-character list lives on the AceDB profile; the account-wide list is its mirror in `global`. `ns:IsIgnored` is the single test, and the bag scan reads both tables directly.

`Options/Options-Ignore-List.lua` renders every list on the account as a `childGroups = "tree"` panel — one node for Global, then one per profile that holds entries, plus the profile the player is on right now so a first entry is always reachable. Node keys are the scope keys themselves (never positions), because the tree remembers its selection by arg key and a key that shifted when a profile appeared would silently reselect a different character. Rows come from the shared `ns:BuildItemListOptions`, so lists add and remove here exactly as anywhere else, at `ns.OPTIONS_TREE_ROW_WIDTH` rather than the full row width — the tree sidebar takes its share of the panel first, and `Options/Options.lua` seeds that sidebar to `ns.OPTIONS_TREE_WIDTH` so "Name - Realm" keys are not truncated.

Two details are load-bearing:

- **Other profiles are read through `ns.db.sv.profiles`, not `ns.db.profile`.** AceDB materializes only the profile you are on, and it strips default-valued tables at logout — so a character who never ignored anything has no stored `ignoreList`, and one who never changed a setting has no stored profile at all. `ns:GetIgnoreListForScope` returns nil in those cases and only builds what it needs when a write passes `createIfMissing`.
- **Promote, not copy.** A row's per-scope button issues the account-wide add alone; `ns:SetIgnoredInScope` then clears that item off every character's list, because the global list already hides it everywhere and a leftover per-character row could no longer change any outcome. Removing from Global deliberately puts the item back on nobody: there is no record of who held it.

The mini-map button's Right-Click (ignore the food it is offering) and Middle-Click (clear, no confirmation) act on the current character's list only, matching the list its own tooltip shows. Both call `NotifyChange` on the Ignore List panel, since a mini-map click is the one edit path with nothing else to ask for a repaint. On logout, `ns.PruneIgnoreList` drops entries from the current character's list and the account-wide list that no longer match any item data; other characters' lists are pruned when they log out, against their own data.

## Restocker

Vendored subsystem (accepted interim architecture — see the Connoisseur entry in `References/Exceptions.md`) behind `/crs`: shopping profiles stored in its own `ConnoisseurRestockerDB`, its own event frame, and `CrsModule` / `CRS_ADDON` globals. Key mechanics:

- **Bank restocking** is a coroutine stepped by a ping-paced `OnUpdate` timer. Every step re-scans reality (never optimistic bookkeeping), issues at most one move, and waits for item locks to settle. A no-progress watchdog (`MAX_STUCK_STEPS`) stops with an honest report; an in-flight gate (`MAX_INFLIGHT_STEPS`) ignores scans taken while a move is mid-air, because a maintained item's bag-plus-bank total can dip with nothing locked; a bounced exact split escalates to a whole-stack pull whose overshoot is stashed back. Once the moves are done the loop enters a tidy phase with a watchdog of its own.
- **Hard invariant: never sell.** `C_Container.UseContainerItem` sells when a merchant window is open, so `bankModule:RunRestockLogic` (`Bank.lua`) bails the moment `merchantIsOpen` is set — including on a stale flag or an odd `BANKFRAME` / `MERCHANT` event order. There is no sell path at all: the old `BuildSellOrder` was removed, and having too much of an item is left alone.
- **Saved format v5** (`RS_DATA_VERSION`) — each profile is keyed by itemID; items deflate to one comma-separated line per item at logout and inflate at login (`rsItemToString` / `rsItemFromString`). Field order is `itemType, itemName, amount, stashTobank, restockFromBank, buyFromMerchant, reaction, upgrade`, booleans as `1`/`0`. The itemID is never written — the table key *is* the itemID. `reaction` and `upgrade` are always written now; reading stayed backward compatible without a version bump because the parser treats a missing trailing field as absent, and a missing field reads as the "on" default.
- **Crafting reagents buy all-or-nothing per vendor.** `merchantModule:VendorStocksAllReagents` (`Merchant.lua`) gates the poison-ingredient auto-buy: unless the vendor stocks *every* reagent the crafting order still needs (bag-covered reagents excluded; a sold-out limited slot counts as not stocked), none are bought — half a recipe is worse than none, and a trade-goods vendor that carries vials but no dust used to fill bags with vials that couldn't become poisons. Quantity coverage is deliberately not required: a limited slot holding 4 of the 6 dust wanted still crafts 4 poisons. Items the player put on the Restock List directly are their explicit ask and are unaffected.
- Chat and UI strings are localized (`RESTOCKER_*` keys); pacing lives in `Bank.lua`.

### Grocery List and Reminders

`RS.BuildGroceryList` (`Merchant.lua`) is the single answer to "what am I short of": the same shortfall the merchant purchase order computes, minus the vendor, so the required-reputation gate is skipped (it depends on which vendor you walk up to) and crafting reagents are left out (`BuyIngredients` resolves those against the merchant's stock). Counts are bags only, matching what the merchant restock compares against, so the list and the buy agree.

Every reminder reads that one list, so they can never disagree:

- **Entering town** — keyed off the client's own resting flag, which is on in inns and cities and nowhere else, so no zone list is maintained. Only a not-resting → resting edge counts, and three events reach the check because one signal doesn't cover every arrival: `PLAYER_UPDATE_RESTING` (walking in), `PLAYER_ENTERING_WORLD` (login, hearth, portal, leaving an instance — the flag crosses the loading screen with no update event behind it), and `PLAYER_CONTROL_GAINED` (landing off a flight path). A taxi counts as *not* in town for its whole duration, which is what leaves a real edge for the landing to trip. Nothing fires until `PLAYER_ENTERING_WORLD` has said whether this was a login (an arrival, so it reminds) or a `/reload` (not one, so it only records position), and a one-minute cooldown collapses clustered arrivals into one nudge. Chat line and alert sound are independent toggles.
- **Leaving a merchant or a bank** — reported on the way out, after a 0.3 s settle so purchases and bank moves that land on `BAG_UPDATE` are already counted. Each close handler keys off its own tracked open flag, because the client fires `MERCHANT_CLOSED` and `BANKFRAME_CLOSED` on loading-screen teardown with no matching open, and can double-fire them.
- **Mini-map tooltip** — a count, not a list; the full list would run taller than the screen.

Each reminder has a Simple/Verbose mode (`RS.REMINDER_SIMPLE` / `RS.REMINDER_VERBOSE`): the headline alone, or the headline plus one line per short item. Town defaults to Verbose (you are away from your bags and the detail is the point); merchant and bank default to Simple (you are already looking at the window that fixes it).

### Upgrade Ladders

`Data/Consumable-Upgrade-Paths.lua` holds `ns.FoodUpgradeChains`: one ladder per staple family (each food diet, water, arrows, bullets, each poison group, each class reagent), tiers ordered by minimum level and then by expansion. Each tier is `{ minLevel, itemID, addedInExpansion[, removedAfterExpansion] }`.

The expansion flag is hand-set and has to be — a Wrath database cannot say when an item was added, the ID blocks interleave, and its vendor data describes 3.3.5. The tier ordering is load-bearing: where two tiers share a level (65 in every food family) `BestTier` keeps the *last* acceptable one, so a TBC client stops at the Outland item and a Wrath client carries on to the Northrend one.

`RS.UpgradeRestockList` (`Upgrade.lua`) runs on `PLAYER_LEVEL_UP` and moves each eligible entry to a *strictly later* tier, never to "the tier matching my level" — an item above the player's level was stocked deliberately. The new level is passed in from the event rather than read from `UnitLevel`, which still reports the old level while `PLAYER_LEVEL_UP` is being handled; reading it there once cost a whole level of upgrades permanently, because nothing re-checked afterwards. Profiles are keyed by itemID, so a move is a delete plus an insert; if the target tier is already listed the two rows merge and their amounts sum. A per-item `upgrade` flag (nil means on) opts a row out. An unresolved target defers rather than writing the old name against the new ID, and retries on `GET_ITEM_INFO_RECEIVED`.

### Starter List

A character past level 5 whose Restock List is empty gets a one-off window of staples three seconds after a fresh login (`isInitialLogin` only, so a `/reload` never re-opens it, and a mid-combat login skips the offer rather than queuing it). `Features/Restocker/StarterList.lua` owns the trigger, the categories, and what a tick does; `Options/Options-Starter-List-Popup.lua` only draws it — as a standalone AceConfigDialog window, registered like any other panel but never passed to `AddToBlizOptions`.

Every offering is drawn from `ns.FoodUpgradeChains` rather than a list of its own, so the popup can never suggest a staple the upgrader would not then maintain; single-tier reagents ride the same rails and simply never move. Ticks are measured in whole stacks, since that is the unit a bag slot thinks in; a category may override the 1..`maxStacks` dropdown with its own `choices` list (Soul Shards), and `fixedAmount` categories (the Hearthstone, Thieves' Tools, shaman totems) draw no dropdown at all. A few staples arrive pre-ticked by class, added through the same path a hand-tick uses so unticking takes them straight back off. The per-character dismissal flag lives in `ConnoisseurRestockerDB.starterListDismissed`, not on an AceDB profile, so a profile switch or reset cannot resurrect a window the character already answered.

## Diagnostics

Runtime-only (`ns.diagnostics`, never saved; everything defaults off each login). The panel builds reports on button press only, eight of them: Event Registration and API endpoint probes driven by `ns.EVENT_NAMES` and `ns.DIAGNOSTIC_API_CHECKS`, an event log tapped at the top of Core's dispatcher (guarded by a boolean so logging-off costs one check), a Connoisseur Context dump (class and level, profession ranks, the live selections, `ns.DIAGNOSTIC_SPELLS` knowledge, and display context for the mini-map button), a Selection Report that names which `RANKING_PRIORITY` step decided each pick, an Other Add-ons list, a saved-variable dump of both tables, and library versions. The `taintLog` CVar buttons are the only thing Diagnostics ever writes. Its strings are developer-facing plain English and are never localized.

Two kinds of noise control keep the 500-entry event buffer honest, and both count rather than delete — suppressed traffic renders as a per-message tally at the end of the report, biggest offender first:

- `ns.DIAGNOSTIC_EVENT_EXCLUDE` holds `UNIT_AURA`, the one firehose this add-on registers whose signal firings cannot be told apart *at capture* — `ns:LogEvent` runs from the dispatcher before the handler, so nothing yet knows whether this aura change moved anything. The firings that did are written from the other end: `ns.HandleUnitAura` calls `ns:LogEventNow` once it has decided, so the log agrees with what the add-on actually reacted to.
- `ns.MESSAGE_ID_FILTERED_EVENTS` names `UI_ERROR_MESSAGE` and the argument position carrying the text to classify by. `IsCorrelatedMessage` is an **allowlist** of exactly the globals the live handlers compare against — `ERR_ITEM_WRONG_ZONE`, `SPELL_FAILED_TARGETS_DEAD`, `ERR_INV_FULL`, `ERR_BANK_FULL` — read fresh on every call, so the filter cannot drift from the handlers. Never invert it into a denylist of noise ids: noise is unbounded and renumbers across patches. A firing that does not carry the field is logged verbatim, because unclassifiable is signal.

## Saved Variables

Connoisseur uses the **Per-Character** saved-variables model (Style Guide → SAVED VARIABLES → The Two Models): `AceDB:New`'s third argument is omitted in `Features/Core.lua`, so every character lands on its own `"Name - Realm"` profile. **Reset Profile therefore clears only the active character's profile** — its consumable settings, poison groups, its half of the Ignore List, and the derived item cache — while the six account-wide keys on `ns.db.global` survive untouched.

The profile-heavy split follows the Two Models coherence rule rather than an exception: a feature whose state is genuinely per-character keeps its settings on the profile with it, and Connoisseur's consumable choices genuinely differ per character — a level-15 alt and a raiding 60 want different buff food, and two Rogues want their own poison pairs.

- **`ConnoisseurDB`** — the AceDB-3.0 table. `profiles.<name>` holds the settings that legitimately differ per character (macro behaviour toggles and modes, `scrollTypes`, `petBuffTypes`, poison groups, the per-character `ignoreList`, plus the derived `itemCache` / `itemCacheVersion`), so the stock Profiles panel moves real settings. `profileKeys` maps characters to profiles. `global` holds the six genuinely account-wide keys, each for a concrete reason spelled out in `Data/Default-Settings.lua`:
    - `showWelcome` — one login greeting per account.
    - `showMacroNames` — a client-wide action-bar appearance tweak.
    - `readyCheckReport` — a behaviour preference (does Connoisseur speak up?) rather than a consumable choice.
    - `enabledMacros` — account-wide to match the macros themselves, which live in the shared General macro tab, so a character switch only ever rewrites macro bodies, never adds or removes a macro.
    - `minimap` — the LibDBIcon subtable, kept off the profile so profile operations never move the button.
    - `ignoreList` — the account-wide half of the Ignore List, hiding an item from every character at once.

  `OnProfileChanged` / `OnProfileCopied` / `OnProfileReset` all run one `OnProfileChange` handler that resets macro state, refreshes aura tracking, re-pushes the two imperatively-applied global settings (mini-map visibility, macro-name text), notifies every panel in `ns.OPTIONS_REGISTRY`, and requests a rebuild — so a reset or switch takes effect immediately rather than at the next `/reload`.
- **`ConnoisseurRestockerDB`** — Restocker's own account-wide table (accepted interim architecture; see `References/Exceptions.md`). It holds the shopping profiles (`profiles`, one-line item strings keyed by itemID; `profileKeys` mapping "Name-Realm" to the active profile; `currentProfile`), the window's `framePos`, the reminder settings (`restockReminderChat`, `restockReminderSound`, `restockReminderMode`, `merchantReminder`, `merchantReminderMode`, `bankReminder`, `bankReminderMode`), the auto-open toggles (`autoOpenAtBank`, `autoOpenAtMerchant`), the per-character `starterListDismissed` flags, `debugMessages`, and `dataVersion`. Its defaults are applied by hand in `RS:loadSettings` rather than by AceDB; the ones that default to on test for `nil` instead of using `or`, since `or` would rewrite a deliberate `false` on every login.

There is no migration code in either table, and none is ever added — migrations are permanently retired factory-wide. A returning player whose data was never converted falls back to defaults, and that's fine.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed — explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*`/`**` wildcard defaults resolve through metatables.

There is no refill-on-empty list logic: Connoisseur ships no user-editable default item lists (the static tables in `Data/` are code, not saved data), and settings maps like `enabledMacros` deliberately survive being all-false. The nearest thing is the Restocker's Starter List, and it is a one-off offer on a fresh character rather than a re-seed — an emptied Restock List stays empty. The derived `itemCache` is lazy-initialized outside the defaults table because Core owns its invalidation.

## Adding a New Consumable Category

1. Add the static data to a new `Data/<Category>.lua` under `ns.RawData.<Category>`, with the originating SQL query in a comment (or `-- TODO: Add SQL Query`).
2. List the file in the TOC's `# Data` block and add the defensive `ns.RawData.<Category> = ns.RawData.<Category> or {}` line in `Features/Item-Cache.lua`.
3. Extend `ns.CacheItemData` with a branch deriving the canonical record (`itemType`, values, requirements), and add the table to `ns.IsKnownConsumable` so Ignore List pruning recognizes it.
4. Create `Features/Macros/<Category>.lua` calling `ns.RegisterMacroType` (see the definition protocol at the top of `Engine.lua`); add the TOC line among the definitions.
5. Add the macro to `ns.Config` in `Data/Data.lua` (macro name ≤ 16 characters — the cap is noted above the `MACRO_*` block in `enUS.lua`), `enabledMacros` in `Data/Default-Settings.lua`, an Enable Macros toggle in `Options/Options-Macros.lua`, and `MACRO_*` / `LABEL_*` keys in `Locales/enUS.lua` only.
6. Mind the 255 macro ceiling if the body stacks lines — ruRU is the canary. Check the written body in-game on both clients before shipping.

## Adding a New Registered Event

Add the name to `ns.EVENT_NAMES` in `Features/Core.lua` and a dispatcher branch — registration and the Diagnostics event and registration checks pick it up together. Add it to `DEFERRED_EVENTS` too if it must register conditionally or via `RegisterUnitEvent`.

Restocker is the exception: it keeps its own frame and its own `RS:RegisterEvent` table (`Restocker.lua`, wired in `Events.lua`). That dispatcher keeps **one handler per event**, so anything else wanting an event it already registers has to share the existing registration rather than add a second one.

## Adding a New Scroll Type or Restocker Recipe

- Scrolls: add the type to `ns.ScrollData` in `Data/Scrolls.lua` (items best-first, `conflictSpells` with base amounts), `ns.SCROLL_CHECK_ORDER`, `scrollTypes` defaults, an options toggle, and enUS keys. `Scanner-Character.lua` derives `ns.ScrollItemLookup`, the buff-ID sets, and the reverse conflict maps from `ns.ScrollData` at load, so nothing else needs a matching edit.
- Restocker crafted items: add the recipe in `Features/Restocker/BuyIngredients.lua` via `ClassicRecipe` / `TbcRecipe` with itemID plus English reagent names.

## Adding a New Upgrade Ladder or Starter List Staple

1. Add the ladder to `ns.FoodUpgradeChains` in `Data/Consumable-Upgrade-Paths.lua`, tiers ordered by minimum level and then by expansion. Give it a `kind`, plus the key its category is looked up by (`diet` for food, `group` for poisons, `reagent` for a reagent string). Set the expansion flag by hand; a fourth field marks the last expansion a tier exists in.
2. A ladder alone is enough for `Upgrade.lua` — anything on it now follows the player's level.
3. To offer it on the first-run window too, add one entry to `STARTER_CATEGORIES` in `Features/Restocker/StarterList.lua` with its `section`, an `L["..."]` label, the matching `chainKey`, and either `stackSize` / `maxStacks` or `fixedAmount`. Add `classes` to limit who is offered it and `defaultFor` to pre-tick it. A category whose ladder is missing is dropped at load rather than crashing the popup.
4. Add the label key to `Locales/enUS.lua` only, and check the popup's height constants in `Options/Options-Starter-List-Popup.lua` if the new row changes how many a class sees.

## Adding a Player-Managed Item List

Every list of items the player builds renders through `ns:BuildItemListOptions` in `Options/Options-Utilities.lua`, which owns the shape: the add row (accepting a bare id or a shift-clicked item link, rejecting anything else), one inline group per item sorted by name, an optional per-row action column, and the icon-only remove button. The panel supplies only `getSourceTable`, `onAdd`, `onRemove`, `notifyKey`, and its labels. Restore Defaults is deliberately absent — a list the player built from nothing has nothing to restore — so a panel needing a clear-all seats that control in its own head, where it can carry the confirm the Style Guide requires of a destructive action.

## Localization

- **Structure** — locale files live in `Locales/<locale>.lua`, each registered through AceLocale-3.0's `NewLocale`. `enUS.lua` is the source of truth and the only file that passes the `true` default-fallback flag; every string originates there and the other ten locales translate from it. All eleven register under the literal `"Connoisseur"`, which is `ns.LOCALE_NAME` in `Data/Data.lua` — not the packaged folder name.
- **Keeping locales in sync** — every other locale carries a translation of the same key set; AceLocale falls back to English via `__index` for anything missing at runtime. Aligning the files is the Localization pass's job (`3 - Copy Cleanup & Localization Prompt.md`) — don't hand-edit non-enUS locales during ordinary work; new keys go into `enUS.lua` only and fall back until that pass runs. WoW ships a fixed locale set and every supported locale file already exists, so there is no "add a new locale" step.
- **Placeholders** — `%s` / `%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime.
- **Spanish** — `esES` / `esMX` are two separate, self-contained files; identical strings in both is correct and expected.
- **Locale overflow** — ruRU encodes widest, so it is the canary against the 255 macro ceiling; the trims in `Engine.lua`, `Integration-Druid-Macro-Helper.lua`, and `Tools-Hunters.lua` exist because of it. Macro *names* have their own hard cap of 16 characters, noted in `enUS.lua` above the `MACRO_*` block. The Starter List popup has a third kind of width budget: its rows are sized to fixed AceConfig widths, so a locale with long staple labels wraps a row rather than truncating it.
- Diagnostics strings are developer-facing plain English in `Features/Diagnostics.lua` — never localized.

## Common Pitfalls

- **Editing macros in combat**: silently blocked by the client. Always route through `ns.RequestUpdate()`; the pending flag replays on `PLAYER_REGEN_ENABLED`.
- **Editing macros while the Blizzard Macro UI is open**: the frame's save-back reverts the write after the state key already recorded it, so the macro sticks stale. `ns.UpdateMacros` defers while `MacroFrame:IsShown()` and its `OnHide` hook rebuilds on close — never write around that guard, and never move the hook install back inside the deferral branch.
- **Appending `(Rank N)` to warlock stones on Era**: the `/cast` silently no-ops. The `rankIsTBCOnly` flag and `ns.GetSmartSpell` own this — don't "simplify" the spell families together.
- **A body input missing from the state key**: the macro silently goes stale. Lossless keys are the rule; mode overrides use disjoint prefixes so transitions always rewrite.
- **`GetItemInfo` cold nils**: a fresh login can't resolve uncached items. The scan flags `dataRetry` and re-runs on `GET_ITEM_INFO_RECEIVED` — never assume the first scan is complete. Restocker's upgrades and Starter List adds defer on the same miss and retry on the same event, rather than writing a row with the wrong name; options panels hand their cold ids to `ns.WarmItemCache`.
- **Reading `UnitLevel("player")` inside a `PLAYER_LEVEL_UP` handler**: it still returns the *old* level. Use the level the event passes, as Core and `RS.UpgradeRestockList` both do.
- **Overflowing macro bodies in wide locales**: always assemble-then-trim (see the three trim sites). `#body` measures bytes, which passes either reading of the 255 ceiling — don't loosen it to a character count.
- **Passing a numeric `1` to `CreateMacro`'s `perCharacter` argument**: the client boolean-checks it, so a number lands in General only by accident. Omit the argument — that is the unambiguous spelling of "General tab".
- **`UseContainerItem` at a merchant sells the item**: the bank restock loop must never run with the merchant window open — guarded in `RunRestockLogic`.
- **Registering a second handler for an event Restocker already uses**: its dispatcher keeps one handler per event, so the later registration silently replaces the earlier one. Share the existing registration instead (see `Events.lua`).
- **Assuming AceDB's defaults resolve through metatables**: only `*`/`**` wildcard defaults do. Scalars and tables are copied into the saved table with `rawset`, so a key that is no longer declared in the defaults is neither filled in nor stripped — whatever the user last saved is still sitting there to be read.
- **Assuming every profile is materialized**: AceDB only builds the profile you are on, and strips default-valued tables at logout. Anything walking `ns.db.sv.profiles` (the Ignore List scopes) must treat a missing profile or a missing subtable as normal, and create on write rather than on read.
- **`UIDropDownMenu_SetWidth` padding**: the dropdown's invisible frame is width plus padding (620 px in the Restocker footer) — anchor neighbors to the window, not the dropdown frame.
- **`PLAYER_ENTERING_WORLD` refires on every loading screen**: init is guarded (`ns.db` nil-check, `varsInitialized`, welcome once-flag), and Restocker's Starter List trigger checks `isInitialLogin`; keep new login work behind those guards.
- **Putting a new setting on the wrong scope**: the profile is the default here, because consumable choices genuinely differ per character. Only add to `global` when the setting is account-wide for a concrete reason — and document that reason in `Data/Default-Settings.lua` alongside the existing six.
- **Editing non-enUS locale files by hand**: they're owned by the Localization pass; hand edits get overwritten. enUS only.
- **StyLua and luacheck**: run `stylua` (default config) over Connoisseur-proper Lua before committing, then a clean `luacheck .` from the add-on root — the repo's `.luacheckrc` carries the config. `Features/Restocker/` keeps its vendored style and is excluded from lint; `Includes/` is never touched by either.

## Contributing

- **Issues**: [GitHub Issues](https://github.com/Gogo1951/Connoisseur/issues).
- **Bug reports**: include game version and locale, class and level, repro steps, and the relevant macro body or chat output. The in-game **Diagnostic Tools** panel (Options → AddOns → Connoisseur, or `/foodie`) generates pasteable reports — the Event Log, Connoisseur Context, and Selection Report sections answer most "my macro didn't update" reports.
- **Discord**: <https://discord.gg/eh8hKq992Q>.
- **PR guidelines**: keep PRs scoped to one change; match house style (StyLua defaults plus a clean `luacheck .`; Restocker keeps its vendored style); ship no migration code — migrations are permanently retired, and saved data that no longer parses falls back to defaults; check the 255 macro ceiling for any macro-body change; update this document when the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X." Frame it:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player switching between raid groups with different consumable preferences, I wanted Connoisseur to remember the last-selected food per character so I didn't reset it every login. This change adds a `lastSelected` field to the AceDB profile and restores it when the database loads.*

  The User Story makes review faster and gives future maintainers context the diff alone won't carry.
