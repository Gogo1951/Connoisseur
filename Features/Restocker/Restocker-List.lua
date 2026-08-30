local _, ns = ...
local L = ns.L

--[[
    Items added during this viewing of the window, keyed by itemID.

    A long Restock List buries a just-added item in whatever type group it
    belongs to, so newly added items are pulled into a "New" group at the top
    where their Withdraw/Deposit/Buy/reputation controls can be set straight
    away.

    "New" is a note about THIS list, THIS sitting -- so it clears the moment
    either becomes untrue: when the Restocker window closes (Restocker-Window.lua's
    OnHide), when the Starter List popup closes (its host's OnHide in
    Options-Starter-List-Popup.lua), and on every profile event -- create,
    switch, clone, copy, delete -- via ns.UseRestockList plus the two direct sites
    in ns.DeleteRestockList and ns.CopyIntoCurrentRestockList that never pass through it.

    Deliberately a plain field on Restocker rather than anything under settings: this is
    view state for one sitting and must never reach SavedVariables.
]]
ns.restockNewItems = {}

function ns.ClearRestockNewItems()
	wipe(ns.restockNewItems)
end

--------------------------------------------------------------------------------
-- Item Lookups
--------------------------------------------------------------------------------

--[[
    Adds parked on a cold item cache, keyed by itemID. Drained by
    ns.OnRestockerItemInfoReceived below when the client answers.
]]
ns.restockItemWait = {}

--[[
    Four things here can be waiting on the client to resolve an item: a pending
    add, a crafting recipe, a deferred upgrade and a deferred Starter List tick.
    The client answers GET_ITEM_INFO_RECEIVED once per item it resolves, which
    during a login is a flood, so Core is asked to listen only while at least one
    of the four is outstanding, and released the moment they all drain.

    Called after anything that adds to those queues, and at the end of the handler
    that drains them.
]]
function ns.SyncRestockItemInfoSubscription()
	local waiting = next(ns.restockItemWait) ~= nil
		or next(ns.pendingRecipes) ~= nil
		or (ns.HasPendingUpgrade and ns.HasPendingUpgrade())
		or (ns.HasPendingStarterAdds and ns.HasPendingStarterAdds())

	if waiting then
		ns.RequestItemInfoEvents("restocker")
	else
		ns.ReleaseItemInfoEvents("restocker")
	end
end

function ns.OnRestockerItemInfoReceived(itemID, success)
	if success == nil then
		return
	end

	--[[
	    This event IS the answer, so the remembered miss has to go first: every
	    retry below asks ns.GetItemData again and would otherwise read the sentinel.
	]]
	ns.ForgetItemDataMiss(itemID)

	--[[
	    If this was an autobuy item setup item request. Tested with next(), not #:
	    ns.pendingRecipes is keyed by itemID (Restocker-Crafting-Reagents.lua), so it is a sparse
	    table and the length operator reads 0 no matter how many recipes are waiting.
	]]
	if next(ns.pendingRecipes) ~= nil then
		ns.RetryWaitingRecipes()
	end

	-- If this was an item add request for an unknown item
	if ns.restockItemWait[itemID] then
		ns.restockItemWait[itemID] = nil
		ns.AddRestockItem(itemID)
	end

	--[[
	    An upgrade deferred because its target had not resolved yet. GetItemInfo
	    asked the server on that miss, so this event is the answer arriving; the
	    retry is free once nothing is pending.
	]]
	if ns.HasPendingUpgrade and ns.HasPendingUpgrade() then
		ns.UpgradeRestockList()
	end

	--[[
	    A Starter List tick deferred the same way (Restocker-Starter-List.lua): its item had
	    not resolved when the box was ticked, and this event is the answer arriving.
	]]
	if ns.HasPendingStarterAdds and ns.HasPendingStarterAdds() then
		ns.RetryPendingStarterAdds()
	end

	ns.SyncRestockItemInfoSubscription()
end

--------------------------------------------------------------------------------
-- Adding An Item
--------------------------------------------------------------------------------

--[[
    Shift-clicking an item routes through HandleModifiedItemClick, which asks
    ChatEdit_InsertLink to place the link. Replacing that global is the only way
    to claim the click, because the add box has to SUPPRESS the default (return
    true) rather than run alongside it, which is what hooksecurefunc would do.

    Installed at PLAYER_LOGIN, not at file scope. Every add-on that hooks this
    global does it while its own files load, so a file-scope install races them
    and loses to anyone loading later who replaces rather than chains -- and the
    symptom is silent, since the click just goes somewhere else. By login the
    field has settled, so chaining on top of it puts this last.

    Guarded on the window: the frame is only built at PLAYER_LOGIN too, so an
    early or failed-build click must fall through to whatever we chained.
]]
function ns.InstallRestockLinkCapture()
	-- luacheck: globals ChatEdit_InsertLink
	local previousInsertLink = ChatEdit_InsertLink
	ChatEdit_InsertLink = function(link)
		local editBox = ns.restockWindow and ns.restockWindow.editBox
		if editBox and editBox:IsVisible() and editBox:HasFocus() then
			ns.AddRestockItem(link)
			return true
		end
		return previousInsertLink(link)
	end
	ns.restockLinkCapture = ChatEdit_InsertLink
end

--[[
    Whether the capture above is still the live ChatEdit_InsertLink. Another
    add-on replacing it without chaining is the one failure this feature has, and
    it is invisible from in game, so Diagnostics reports it rather than leaving a
    dead shift-click to be guessed at.
]]
function ns.IsRestockLinkCaptureInstalled()
	-- luacheck: read_globals ChatEdit_InsertLink
	return ns.restockLinkCapture ~= nil and ChatEdit_InsertLink == ns.restockLinkCapture
end

function ns.AddRestockItem(text)
	local settings = ns.restockSettings
	local currentProfile = settings.profiles[settings.currentProfile]

	if tonumber(text) then
		text = tonumber(text)
	end

	local itemInfo = ns.GetItemData(text)
	if itemInfo == nil then
		--[[
		    Park the pending add under its itemID whenever the input carries one: the
		    retry in ns.OnRestockerItemInfoReceived looks up by the numeric itemID the
		    event hands it, so an add keyed by a raw item link (what a shift-click from
		    chat drops in) would never be found again and the item would silently never
		    arrive. Unparseable input keeps its own key, which simply never retries.
		]]
		local waitKey = text
		if type(text) == "string" then
			waitKey = tonumber(text:match("item:(%d+)")) or text
		end
		ns.restockItemWait[waitKey] = true
		ns.SyncRestockItemInfoSubscription()
		return
	end

	local itemID = (itemInfo).itemID

	-- Profiles are keyed by itemID, so a duplicate is a simple lookup
	if currentProfile[itemID] ~= nil then
		return
	end

	local buyItem = {}

	buyItem.itemName = (itemInfo).itemName
	buyItem.itemType = (itemInfo).itemType
	buyItem.itemID = itemID
	--[[
	    One stack of the item, not one unit: a fresh row asking for a single
	    juice reads as a typo, and a stack is the amount everything actually
	    trades in. Items that do not stack report a max of 1, so gear and tools
	    land at exactly one with no special case.
	]]
	buyItem.amount = math.max(1, (itemInfo).itemStackCount or 1)
	-- New items default to everything ON: buy from merchant, stash to bank, restock from bank
	buyItem.buyFromMerchant = true
	buyItem.stashTobank = true
	buyItem.restockFromBank = true

	currentProfile[itemID] = buyItem

	--[[
	    Flag it for the "New" group and jump the list back to the top, so the row
	    you just created is on screen rather than filed away in its type group
	    somewhere down a long list. Its toggles are already visible on the row, so
	    there is nothing left to open.
	]]
	ns.restockNewItems[itemID] = true
	--[[
	    Select New, which the row above just joined. Whatever category the pane
	    was showing, the item is not in it -- and a row that vanishes the moment
	    it is added is the one way this pane can lie about what is on the list.
	    Selecting the group the item IS in beats falling back to All: it puts the
	    new row on screen alone rather than somewhere in a list of thirty-seven.
	]]
	ns.restockSelectedGroup = L["RESTOCKER_GROUP_NEW"]

	ns.UpdateRestockList()

	local scrollFrame = ns.restockWindow and ns.restockWindow.scrollFrame
	if scrollFrame then
		scrollFrame:SetVerticalScroll(0)
	end
end
