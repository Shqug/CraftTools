# Planned features that require more consideration

All of these features will be included in the mod in some form at some point, but may differ from the descriptions given here.

## Content

 - [x] A generic 'Saw' tool; needs to be able to cut both wood and metal, so probably should look like a hacksaw or tenon saw
 - [ ] 'Needle and Thread' consumable for sewing things like bags and clothing. 30, 50 uses?
 - [x] 'Chisel' tool for shaping stone and wood and crafting decorative variants of nodes
 - [ ] Options to disable all tools & consumables individually, by category, or all together & programmatic way for other mods to switch them off

## Functionality

 - [x] Marker for tools that causes them to not break on their last use, and instead become unusable until repaired (or recharged, for power tools)
 - [ ] IMPORTANT switch to metadata marker on item in recipe to control behaviour when crafted with, rather than checking input/output
 - [ ] System for defining the specific amount of uses to take from a tool/consumable in a given recipe
 - [ ] Definition field for consumables allowing their `inventory_image` texture to change via meta based on their remaining uses
 - [ ] Ability to have non-crafttool tools be treated as a craft tool for single recipes
 - [ ] Helper methods to reduce, increase, check uses of consumables