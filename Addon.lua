-- This addon provides a macro which will use a randomly-selected hearthstone,
-- including the standard hearthstone item and any hearthstone toys available to
-- the player. This will not activate any hearthstones which do not return the
-- player to their home inn.

local addonName, addon = ...

-- Initialize addon state.

addon.eligibleItems = {}
addon.eligibleSpells = {}
addon.eligibleToys = {}

-- Return true if the sum of the given start time and duration is in the
-- future. If this check is performed while a spell is being case, the cooldown
-- reported for the item or spell will be the remaining duration of the global
-- cooldown. The duration is reduced by 1.5 seconds here to adjust for that.
local function IsOnCooldown(start, duration)
    local remainder = GetTime() - start
    return remainder < (duration - 1.5)
end

-- Return true if the given item is on cooldown.
local function IsItemOnCooldown(itemId)
    local start, duration, _ = GetItemCooldown(itemId)
    return IsOnCooldown(start, duration)
end

-- Return true if the given spell is on cooldown.
local function IsSpellOnCooldown(spellId)
    local start, duration, _, _ = GetSpellCooldown(spellId)
    return IsOnCooldown(start, duration)
end

-- Return a random item from the given table, or nil if the table is empty.
local function RandomItem(t)
    if #t > 0 then
        return t[random(#t)]
    else
        return nil
    end
end

-- Randomly choose a hearthstone from the lists of eligible toys, spells, and
-- items. The chosen hearthstone will be used in the generated macro. If all
-- hearthstones are on cooldown, set the macro to emit a message indicating
-- that. If no hearthstones are available, set the macro to emit a message
-- indicating that.
--
-- This function is sensitive to item cache information being available. The
-- item cache may not be populated at login, causing item info queries to return
-- nil values.
function addon:ChooseHearth()
    local cooldown = false

    if #self.eligibleToys > 0 then
        if not IsItemOnCooldown(self.eligibleToys[1]) then
            local toyId = RandomItem(self.eligibleToys)
            local _, toyName, _, _, _, _ = C_ToyBox.GetToyInfo(toyId)
            if toyName then
                self:_SetMacro("/cast " .. toyName)
                return
            end
        else
            cooldown = true
        end
    end

    if #self.eligibleItems > 0 then
        if not IsItemOnCooldown(self.eligibleItems[1]) then
            local itemId = RandomItem(self.eligibleItems)
            local itemName = C_Item.GetItemNameByID(itemId)
            if itemName then
                self:_SetMacro("/cast " .. itemName)
                return
            end
        else
            cooldown = true
        end
    end

    if #self.eligibleSpells > 0 then
        if not IsSpellOnCooldown(self.eligibleSpells[1]) then
            local spellId = RandomItem(self.eligibleSpells)
            local spellName, _, _, _, _, _, _ = GetSpellInfo(spellId)
            self:_SetMacro("/cast " .. spellName)
            return
        else
            cooldown = true
        end
    end

    if cooldown then
        self:_SetMacro("/run print(\"All hearthstones on cooldown!\")")
    else
        self:_SetMacro("/run print(\"No hearthstones found!\")")
    end
end

-- Set the macro to have the given body. If the macro does not yet exist, it
-- will be created for all characters. If the player is in combat, no action is
-- taken.
function addon:_SetMacro(body)
    if InCombatLockdown() then
        return
    end

    local name, _, _, _ = GetMacroInfo(addonName)
    if not name then
        CreateMacro(addonName, self.MACRO_ICON_ID, body, false)
    else
        EditMacro(addonName, addonName, self.MACRO_ICON_ID, body)
    end
end

-- Update the set of hearthstone toys, items and spells available, then choose a
-- new hearthstone.
function addon:UpdateAll()
    self:_UpdateToys()
    self:_UpdateSpells()
    self:_UpdateItems()
    self:ChooseHearth()
end

-- Update the set of hearthstone items, then choose a new hearthstone.
function addon:UpdateItems()
    self:_UpdateItems()
    self:ChooseHearth()
end

-- Update the set of hearthstone spells, then choose a new hearthstone.
function addon:UpdateSpells()
    self:_UpdateSpells()
    self:ChooseHearth()
end

-- Update the set of hearthstone toys, then choose a new hearthstone.
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
            if tContains(self.HEARTHSTONE_ITEM_ID, itemId) then
                table.insert(self.eligibleItems, itemId)
            end
        end
    end
end

-- Populate a set of all known hearthstone spells.
function addon:_UpdateSpells()
    wipe(self.eligibleSpells)

    for _, spellId in pairs(self.HEARTHSTONE_SPELL_ID) do
        if IsPlayerSpell(spellId) then
            table.insert(self.eligibleSpells, spellId)
        end
    end
end

-- Build up a list of all known hearthstone toys. If any of these are marked as
-- favorites, only the favorited toys will be included in the list.
function addon:_UpdateToys()
    wipe(self.eligibleToys)
    local hasFavorites = false

    for _, toyId in pairs(self.HEARTHSTONE_TOY_ID) do
        if PlayerHasToy(toyId) then
            local _, _, _, isFavorite, _, _ = C_ToyBox.GetToyInfo(toyId)
            if isFavorite then
                if not hasFavorites then
                    wipe(self.eligibleToys)
                    hasFavorites = true
                end
                table.insert(self.eligibleToys, toyId)
            elseif not hasFavorites then
                table.insert(self.eligibleToys, toyId)
            end
        end
    end
end