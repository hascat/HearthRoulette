-- This addon provides a macro which will use a randomly-selected hearthstone,
-- including the standard hearthstone item and any hearthstone toys available to
-- the player. This will not activate any hearthstones which do not return the
-- player to their home inn.

local addonName, addon = ...

-- Initialize addon state.
addon.eligibleItems = {}
addon.eligibleToys = {}
addon.hasFavorites = false

-- Return a random item from the given table, or nil if the table is empty.
local function RandomItem(t)
	if #t > 0 then
		return t[random(#t)]
	else
		return nil
	end
end

-- Randomly choose a hearthstone from the lists of eligible toys and items. The
-- chosen hearthstone will be used in the generated macro.
function addon:ChooseHearth()
	local castName = nil
	if #self.eligibleToys > 0 then
		castName = RandomItem(self.eligibleToys)
	else
		castName = RandomItem(self.eligibleItems)
	end

	self:_UpdateMacro(castName)
end

-- Update the set of hearth items and toys available, then choose a new hearth.
function addon:UpdateAll()
	self:_UpdateToys()
	self:_UpdateItems()
	self:ChooseHearth()
end

-- Update the set of hearth items available, then choose a new hearth.
function addon:UpdateItems()
	self:_UpdateItems()
	self:ChooseHearth()
end

-- Update the set of hearth toys available, then choose a new random hearth.
function addon:UpdateToys()
	self:_UpdateToys()
	self:ChooseHearth()
end

-- Update the set of hearthstone items available in the player's bags. This
-- should only ever include the generic hearthstone item. If the player has
-- marked one or more hearthstone toys as favorites, the generic hearthstone
-- will be ignored in favor of those.
function addon:_UpdateItems()
	wipe(self.eligibleItems)

	for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bagId) do
			local itemId = GetContainerItemID(bagId, slot)
			if itemId == self.HEARTHSTONE_ITEM_ID then
				local castName = C_Item.GetItemNameByID(self.HEARTHSTONE_ITEM_ID)
				table.insert(self.eligibleItems, castName)
			end
		end
	end
end

-- Update the macro to use the given hearthstone toy or item. If the macro does
-- not yet exist, it will be created for the current character.
function addon:_UpdateMacro(castName)
	local name, _, _, _ = GetMacroInfo(addonName)

	local body = nil
	if not castName then
		body = "/run print(\"No hearthstone or hearthstone-like toys found!\")"
	else
		body = "/cast " .. castName
	end

	if not name then
		CreateMacro(addonName, addon.MACRO_ICON_ID, body, false)
	else
		EditMacro(addonName, addonName, addon.MACRO_ICON_ID, body)
	end
end

-- Build up a list of all known hearthstone toys. If any of these are marked as
-- favorites, only the favorited toys will be included in the list.
function addon:_UpdateToys()
	wipe(self.eligibleToys)
	self.hasFavorites = false
	
	for _, toyId in pairs(addon.HEARTHSTONE_TOY_ID) do
		if PlayerHasToy(toyId) then
			local _, toyName, _, isFavorite, _, _ = C_ToyBox.GetToyInfo(toyId)
			if isFavorite then
				if not self.hasFavorites then
					wipe(self.eligibleToys)
					self.hasFavorites = true
				end
				table.insert(self.eligibleToys, toyName)
			elseif not self.hasFavorites then
				table.insert(self.eligibleToys, toyName)
			end
		end
	end
end