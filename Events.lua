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

-- Register events to ensure bag changes and toy changes are handled.
function events:ADDON_LOADED(_, name)
    if name ~= addonName then
        return
    end

    self:UnregisterAllEvents()

    self:RegisterEvent("BAG_UPDATE")
    self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("SPELLS_CHANGED")
    self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    self:RegisterEvent("TOYS_UPDATED")
end

-- Look for hearthstone and hearthstone-equivalent items in the player's
-- inventory, then choose a random hearthstone. This ensures new hearthstone-
-- equivalent items become available when they are acquired by the player, or
-- become unavailable when removed from the player's inventory.
function events:BAG_UPDATE(...)
    addon:UpdateItems()
end

-- Choose a new hearthstone when the item info cache has been updated. Item info
-- queries performed by ChooseHearth may fail before this event is triggered.
function events:GET_ITEM_INFO_RECEIVED(...)
    addon:ChooseHearth()
end

-- Ensure the toys, items, and spells have been scanned when the player enters
-- the world, then update the chosen hearthstone.
function events:PLAYER_ENTERING_WORLD(...)
    addon:UpdateAll()
end

-- Look for hearthstone-equivalent spells in the player's spellbook, then
-- choose a random hearthstone. This ensures new hearthstone-equivalent spells
-- become available when they are learned by the player.
function events:SPELLS_CHANGED(...)
    addon:UpdateSpells()
end

-- Choose a new hearthstone while casting. This ensures cooldowns will be
-- respected once a hearthstone is used.
function events:SPELL_UPDATE_COOLDOWN(...)
    addon:ChooseHearth()
end

-- Look for hearthstone-equivalent toys in the player's toy collection, then
-- choose a random hearthstone. This ensures new hearthstone-equivalent toys
-- become available when they are added to the player's toy box.
function events:TOYS_UPDATED(...)
    addon:UpdateToys()
end