# HearthRoulette

This addon creates a "HearthRoulette" macro which will use a random
hearthstone-equivalent toy, spell, or item. The macro is updated with a new
random selection each time it is used.

## Selection Process

The selection is made from the toys, items, and spells available to the player.
The shortest cooldown of these groups will be preferred. If none of these are on
cooldown, toys take precedence over items, which take precedence over spells.

### Toys

The random selection will be made from one of the following toys:

- [Brewfest Reveler's Hearthstone](https://www.wowhead.com/item=166747/brewfest-revelers-hearthstone)
- [Broker Translocation Matrix](https://www.wowhead.com/item=190237/broker-translocation-matrix)
- [Dark Portal](https://www.wowhead.com/item=93672/dark-portal)
- [Dominated Hearthstone](https://www.wowhead.com/item=188952/dominated-hearthstone)  
- [Enlightened Hearthstone](https://www.wowhead.com/item=190196/enlightened-hearthstone)  
- [Eternal Traveler's Hearthstone](https://www.wowhead.com/item=172179/eternal-travelers-hearthstone)
- [Ethereal Portal](https://www.wowhead.com/item=54452/ethereal-portal)
- [Fire Eater's Hearthstone](https://www.wowhead.com/item=166746/fire-eaters-hearthstone)
- [Greatfather Winter's Hearthstone](https://www.wowhead.com/item=162973/greatfather-winters-hearthstone)
- [Headless Horseman's Hearthstone](https://www.wowhead.com/item=163045/headless-horsemans-hearthstone)
- [Holographic Digitalization Hearthstone](https://www.wowhead.com/item=168907/holographic-digitalization-hearthstone)
- [Lunar Elder's Hearthstone](https://www.wowhead.com/item=165669/lunar-elders-hearthstone)
- [Noble Gardener's Hearthstone](https://www.wowhead.com/item=165802/noble-gardeners-hearthstone)
- [Peddlefeet's Lovely Hearthstone](https://www.wowhead.com/item=165670/peddlefeets-lovely-hearthstone)
- [Timewalker's Hearthstone](https://www.wowhead.com/item=193588/timewalkers-hearthstone)  
- [The Innkeeper's Daughter](https://www.wowhead.com/item=64488/the-innkeepers-daughter)

In addition, if the player is pledged to one of the Shadowlands Covenants, the
covenant hearthstone toy (if owned) will be added to the set of toys to choose from:

- [Kyrian Hearthstone](https://www.wowhead.com/item=184353/kyrian-hearthstone)
- [Necrolord Hearthstone](https://www.wowhead.com/item=182773/necrolord-hearthstone)
- [Night Fae Hearthstone](https://www.wowhead.com/item=180290/night-fae-hearthstone)
- [Venthyr Sinstone](https://www.wowhead.com/item=183716/venthyr-sinstone-wip)

If any of the above toys are marked as favorites, the random selection will be
made only from those toys marked as favorites.

### Items

If the player does not possess any of the above toys, the random selection will
be made from one of the following items, if the player has them available:

- [Astonishingly Scarlet Slippers](https://www.wowhead.com/item=142298/astonishingly-scarlet-slippers)
- [Hearthstone](https://www.wowhead.com/item=6948/hearthstone)
- [Ruby Slippers](https://www.wowhead.com/item=28585/ruby-slippers)

### Spells

If the player is a Shaman, the following spell will be cast if the all of the
above are on cooldown or are unavailable:

- [Astral Recall](https://www.wowhead.com/spell=556/astral-recall)

## Contact

Feel free to report issues or leave comments anywhere this addon can be found:

- [CurseForge](https://curseforge.com/wow/addons/hearthroulette)
- [GitHub](https://github.com/hascat/HearthRoulette)
- [WowInterface](https://wowinterface.com/downloads/fileinfo.php?id=25681)
