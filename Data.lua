local addonName, addon = ...

-- Path to the icon to use for the macro.
addon.MACRO_ICON_PATH = "Interface/icons/achievement_guildperk_hastyhearth.blp"
addon.MACRO_ICON_ID = GetFileIDFromPath(addon.MACRO_ICON_PATH)

-- Item ID numbers for the hearthstone and hearthstone-equivalent items.
addon.HEARTHSTONE_ITEM_ID = {
	6948, -- Hearthstone
	28585, -- Ruby Slippers
	142298, -- Astonishingly Scarlet Slippers
}

-- Toy ID numbers for the hearthstone-equivalent toys.
addon.HEARTHSTONE_TOY_ID = {
    54452, -- Ethereal Portal
    64488, -- The Innkeeper's Daughter
    93672, -- Dark Portal
    142542, -- Tome of Town Portal
    162793, -- Greatfather Winter's Hearthstone
    163045, -- Headless Horseman's Hearthstone
    165669, -- Lunar Edler's Hearthstone
    165670, -- Peddlefeet's Lovely Hearthstone
    165802, -- Noble Gardener's Hearthstone
    166746, -- Fire Eater's Hearthstone
    166747, -- Brewfest Reveler's Hearthstone
    168907, -- Holographic Digitalization Hearthstone
    172179, -- Eternal Traveler's Hearthstone
    180290, -- Night Fae Hearthstone
    182773, -- Necrolord Hearthstone
    183716, -- Venthyr Sinstone
    184353, -- Kyrian Hearthstone
}

-- Spell ID numbers for hearthstone-equivalent spells.
addon.HEARTHSTONE_SPELL_ID = {
    556, -- Astral Recall
}