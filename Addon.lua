-- This addon provides a macro which will use a randomly-selected hearthstone,
-- including the standard hearthstone item and any hearthstone toys available to
-- the player. This will not activate any hearthstones which do not return the
-- player to their home inn.

local addonName, addon = ...

-- Initialize addon state.
addon.eligibleToyIds = {}
addon.eligibleItemIds = {}
addon.hasFavorites = false

-- Randomly choose a hearthstone from the lists of eligible toys and items. The
-- chosen hearthstone will be used in the generated macro.
function addon:ChooseHearthstone()
	local castName = nil
	local count = #self.eligibleToyIds + #self.eligibleItemIds
	if count > 0 then
		local index = math.random(count)
		if index > #self.eligibleToyIds then
			castName = C_Item.GetItemNameByID(self.HEARTHSTONE_ITEM_ID)
		else
			local toyId = self.eligibleToyIds[index]
			_, castName, _, _, _, _ = C_ToyBox.GetToyInfo(toyId)
		end
	end

	self:UpdateMacro(castName)
end

-- Update the set of hearthstone items available in the player's bags. This
-- should only ever include the generic hearthstone item. If the player has
-- marked one or more hearthstone toys as favorites, the generic hearthstone
-- will be ignored in favor of those.
function addon:UpdateBags()
	wipe(self.eligibleItemIds)

	if not self.hasFavorites then
		for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bagId) do
				local itemId = GetContainerItemID(bagId, slot)
				if itemId == self.HEARTHSTONE_ITEM_ID then
					table.insert(self.eligibleItemIds, itemId)
				end
			end
		end
	end
end

-- Update the macro to use the given hearthstone toy or item. If the macro does
-- not yet exist, it will be created for the current character.
function addon:UpdateMacro(castName)
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
function addon:UpdateToys()
	wipe(self.eligibleToyIds)
	self.hasFavorites = false

	for _, toyId in pairs(addon.HEARTHSTONE_TOY_ID) do
		if PlayerHasToy(toyId) then
			local _, _, _, isFavorite, _, _ = C_ToyBox.GetToyInfo(toyId)
			if isFavorite then
				-- If any hearthstone toys are marked as favorites, restrict the
				-- random choice to just those toys.
				if not self.hasFavorites then
					wipe(self.eligibleToyIds)
					self.hasFavorites = true
				end
				table.insert(self.eligibleToyIds, toyId)
			elseif not self.hasFavorites then
				table.insert(self.eligibleToyIds, toyId)
			end
		end
	end
end