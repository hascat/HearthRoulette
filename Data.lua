local addonName, addon = ...

-- Path to the icon to use for the macro.
addon.MACRO_ICON_PATH = "Interface/icons/achievement_guildperk_hastyhearth.blp"
addon.MACRO_ICON_ID = GetFileIDFromPath(addon.MACRO_ICON_PATH)

-- Item ID for the Dalaran Hearthstone toy
addon.DALARAN_TOY_ID = 140192

-- Item ID for the Garrison Hearthstone toy
addon.GARRISON_TOY_ID = 110560

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
    162973, -- Greatfather Winter's Hearthstone
    163045, -- Headless Horseman's Hearthstone
    165669, -- Lunar Edler's Hearthstone
    165670, -- Peddlefeet's Lovely Hearthstone
    165802, -- Noble Gardener's Hearthstone
    166746, -- Fire Eater's Hearthstone
    166747, -- Brewfest Reveler's Hearthstone
    168907, -- Holographic Digitalization Hearthstone
    172179, -- Eternal Traveler's Hearthstone
    188952, -- Dominated Hearthstone
    190237, -- Broker Translocation Matrix
    193588, -- Timewalker's Hearthstone
    200630, -- Ohn'ir Windsage's Hearthstone
    206195, -- Path of the Naaru
    208704, -- Deepdweller's Earth Hearthstone
    209035, -- Hearthstone of the Flame
}

addon.COVENANT_HEARTHSTONE_TOY_ID = {
    [1] = 184353, -- Kyrian Hearthstone
    [2] = 183716, -- Venthyr Sinstone
    [3] = 180290, -- Night Fae Hearthstone
    [4] = 182773, -- Necrolord Hearthstone
}

-- Spell ID numbers for hearthstone-equivalent spells.
addon.HEARTHSTONE_SPELL_ID = {
    556, -- Astral Recall
}
