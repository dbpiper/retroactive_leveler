# retroactive_leveler

A retroactive leveling mod for Morrowind (OpenMW) that scans for usage of Madd Leveler or Phi's Carefree Leveling mods and applies their effects retroactively to characters leveled with vanilla.

Retroactive Leveler is a script-only mod for OpenMW that scans your load order for either Madd Leveler or Phis Carefree Leveling, reads your character’s current skill values, and computes the attribute bonuses you would have earned under that system. On first load it automatically applies any missing attribute points so you don’t have to start a new game or crunch console commands.

The mod converts every five points of skill increase into the corresponding attribute boost for Madd Leveler or applies the optimal +5 per level allocation for Carefree Leveling, then sends the adjustments directly to your stats. It runs once when your save is loaded, logs each bump to openmw.log, requires only a single init.lua script in pure Lua, and works on any existing character without extra dependencies.

To install, unzip retroactive_leveler.zip.
Then, in the OpenMW Launcher, go to Data Directories → Append → select the
retroactive_leveler
folder, and in Content Files simply check
retroactive_leveler.esp
. Requires OpenMW 0.48 or newer and either Madd Leveler – Base.esp or Carefree Leveling enabled. On load you’ll see log lines like “Bumped Endurance by 3” and your attributes will now reflect the retroactive gains.

## Changelog

- v1.0.0 initial release
