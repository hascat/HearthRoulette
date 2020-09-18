local addonName, addon = ...

-- Path to the icon to use for the macro.
addon.MACRO_ICON_PATH = "Interface/icons/achievement_guildperk_hastyhearth.blp"
addon.MACRO_ICON_ID = GetFileIDFromPath(addon.MACRO_ICON_PATH)

-- Item ID for the standard hearthstone item.
addon.HEARTHSTONE_ITEM_ID = 6948

-- Toy ID numbers for the hearthstone-equivalent toys.
addon.HEARTHSTONE_TOY_ID = {
    142542, -- Tome of Town Portal
    172179, -- Eternal Traveler's Hearthstone
    166747, -- Brewfest Reveler's Hearthstone
    166746, -- Fire Eater's Hearthstone
    162793, -- Greatfather Winter's Hearthstone
    163045, -- Headless Horseman's Hearthstone
    168907, -- Holographic Digitalization Hearthstone
    165669, -- Lunar Edler's Hearthstone
    165802, -- Noble Gardener's Hearthstone
    165670, -- Peddlefeet's Lovely Hearthstone
}

-- Spell ID numbers for hearthstone-equivalent spells.
addon.HEARTHSTONE_SPELL_ID = {
    556, -- Astral Recall
}