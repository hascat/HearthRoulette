-- This addon provides a macro which will use a randomly-selected hearthstone,
-- including the standard hearthstone item and any hearthstone toys available to
-- the player. This will not activate any hearthstones which do not return the
-- player to their home inn.

local addonName, addon = ...

-- Grab references to oft-called WoW API functions to avoid a table lookup each time.
local GetActiveCovenantID = C_Covenants.GetActiveCovenantID
local GetToyInfo = C_ToyBox.GetToyInfo
local GetItemNameByID = C_Item.GetItemNameByID

-- Initialize addon state.

addon.eligibleItems = {}
addon.eligibleSpells = {}
addon.eligibleToys = {}

-- Return the time the given item has left on cooldown, zero if none.
local function GetItemCooldownRemaining(itemId)
    local start, duration, _ = GetItemCooldown(itemId)
    return max(0, (start + duration) - GetTime())
end

-- Return the time the given spell has left on cooldown, zero if none.
local function GetSpellCooldownRemaining(spellId)
    local start, duration, _, _ = GetSpellCooldown(spellId)
    return max(0, (start + duration) - GetTime())
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
-- items. Preference is given to the hearthstone with the shortest cooldown. The
-- chosen hearthstone will be used in the generated macro. If no hearthstones
-- are available, set the macro to emit a message indicating that.
--
-- This function is sensitive to item cache information being available. The
-- item cache may not be populated at login, causing item info queries to return
-- nil values.
function addon:ChooseHearth()
    local name = nil
    local cooldown = nil

    if #self.eligibleToys > 0 then
        local toyId = RandomItem(self.eligibleToys)
        local toyName = select(2, GetToyInfo(toyId))
        if toyName then
            name = toyName
            cooldown = GetItemCooldownRemaining(toyId)
        end
    end

    if #self.eligibleItems > 0 then
        local itemId = RandomItem(self.eligibleItems)
        local itemCooldown = GetItemCooldownRemaining(itemId)
        if not cooldown or (itemCooldown < cooldown) then
            local itemName = GetItemNameByID(itemId)
            if itemName then
                name = itemName
                cooldown = itemCooldown
            end
        end
    end

    if #self.eligibleSpells > 0 then
        local spellId = RandomItem(self.eligibleSpells)
        local spellName = select(1, GetSpellInfo(spellId))
        local spellCooldown = GetSpellCooldownRemaining(spellId)
        if not cooldown or (spellCooldown < cooldown) then
            name = spellName
            cooldown = spellCooldown
        end
    end

    if name then
        self:_SetMacro("#showtooltip\n/cast " .. name)
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

    local name = select(1, GetMacroInfo(addonName))
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
        for slot = 1, C_Container.GetContainerNumSlots(bagId) do
            local itemId = C_Container.GetContainerItemID(bagId, slot)
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
    table.wipe(self.eligibleToys)
    local hasFavorites = false

    for _, toyId in pairs(self.HEARTHSTONE_TOY_ID) do
        hasFavorites = self:_MaybeAddToy(toyId, hasFavorites)
    end

    local covenantId = C_Covenants.GetActiveCovenantID()
    if covenantId ~= 0 then
        local toyId = self.COVENANT_HEARTHSTONE_TOY_ID[covenantId]
        self:_MaybeAddToy(toyId, hasFavorites)
    end
end

-- Add the to the list of eligible toys if the toy is not already in the list.
-- The first time a toy marked as a favorite is seen, the table will be wiped
-- before that toy is added to it. Only favorites will be added from then on.
--
-- Params:
--     toyId: The ID of the toy to add.
--     hasFavorites: True if a favorite has previously been added.
-- Returns:
--     True if a favorite was added.
function addon:_MaybeAddToy(toyId, hasFavorites)
    if PlayerHasToy(toyId) then
        local isFavorite = select(4, C_ToyBox.GetToyInfo(toyId))
        if isFavorite then
            if not hasFavorites then
                table.wipe(self.eligibleToys)
                hasFavorites = true
            end
            table.insert(self.eligibleToys, toyId)
        elseif not hasFavorites then
            table.insert(self.eligibleToys, toyId)
        end
    end

    return hasFavorites
end
