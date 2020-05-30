local addonName, addon = ...

local events = CreateFrame("Frame", addonName .. "Events", UIParent)
addon.events = events

function events:OnEvent(event, ...)
	if self[event] then
		self[event](self, event, ...)
	end
end

events:SetScript("OnEvent", events.OnEvent)
events:RegisterEvent("ADDON_LOADED")

-- Register events to ensure bad changes and toy changes are handled.
function events:ADDON_LOADED(event, name)
	if name ~= addonName then
		return
	end

	self:UnregisterAllEvents()

    self:RegisterEvent("BAG_UPDATE")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("TOYS_UPDATED")
    self:RegisterEvent("UNIT_SPELLCAST_START")
end

-- Look for hearthstone items in the player's bags any time the bags are
-- updated, then choose a new hearthstone. This ensures the hearthstone item
-- will not be erroneously used if it is removed from the player's bags.
function events:BAG_UPDATE(event, bagId)
    addon:UpdateItems()
end

-- Ensure the toys and items have been scanned when the player enters the world,
-- then update the chosen hearthstone.
function events:PLAYER_ENTERING_WORLD(event)
    addon:UpdateAll()
end

-- Look for hearthstone toys in the player's toy collection, then choose a new
-- hearthstone. This ensures new hearthstone toys become available for use as
-- soon as they are added to the player's collection.
function events:TOYS_UPDATED(event, toyId, isNew, hasFanfare)
    addon:UpdateToys()
end

-- Choose a new hearthstone each time the player casts a spell. This ensures
-- repeated use of the macro results in randomly-chosen hearthstones.
function events:UNIT_SPELLCAST_START(event, unitTarget, castGUID, spellId)
    if unitTarget == "player" then
        addon:ChooseHearth()
    end
end