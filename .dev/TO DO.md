# Planned features that require more consideration

All of these features will be included in the mod in some form at some point, but may differ from the descriptions given here.

## Content

 - [x] A generic 'Saw' tool; needs to be able to cut both wood and metal, so probably should look like a hacksaw or tenon saw
 - [x] 'Needle and Thread' consumable for sewing things like bags and clothing. 30, 50 uses?
 - [x] 'Chisel' tool for shaping stone and wood and crafting decorative variants of nodes
 - [x] Options to disable all tools & consumables individually, by category, or all together
 - [x] Ability to separate intact toolbox back into constituent tools
 - [ ] 'Repair Kit' consumable that restores durability to tools when crafted together (disabled by default, enable_repair_kit function for other mods)

## Functionality

 - [x] Marker for tools that causes them to not break on their last use, and instead become unusable until repaired (or recharged, for power tools)
 - [x] Replace reuse_exception system with generic overrides system
 - [x] Ability to have non-crafttool tools be treated as a craft tool for single recipes
 - [ ] Definition field for consumables allowing their `inventory_image` texture to change via meta based on their remaining uses
 - [ ] Helper methods to reduce, increase, check uses of consumables
 - [x] Ability to play a sound(s) on craft