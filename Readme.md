# CraftTools

A library for mod & game developers providing simple tools and reusable ingredients that automatically return and lose a bit of durability when crafted with, rather than disappearing like a normal ingredient. Also includes an API for registering new tools and consumables.

Optionally depends on `default` for recipes.

The toolbox and all recipes can be disabled, and the durability of all tools can be changed in the settings.

## Provided Items

The following hand tools are available:

 - 'Small Hammer': Intended to be used for shaping metal and crushing fragile objects like stone and ores.
 - 'Metal File': For working metal, wood, and other materials.
 - 'Hand Drill': For making holes in various materials including stone, wood, metal, etc.
 - 'Metal Cutters': For cutting sheet metal, wires, ropes & cables, and fabric.
 - 'Wrench': For configuring, repairing, and dismantling mechanical devices.
 - 'Knife': For any sort of slicing, carving, gouging, and stabbing. Also a fast, low damage melee weapon.
 - 'Hand Saw': For cutting wood and metal.
 - 'Chisel': For shaping wood and stone, and crafting variants of decorative nodes.

As well as the following reusable consumables:
 - 'Glue': Specially formulated K-Brand kelp superglue for binding and adhering all sorts of things.
 - 'Tape': Used to add tension and structural strength while also binding things together and sealing gaps.
 - 'Sandpaper': Used for finer smoothing and on harder materials than the file. There are three kinds (in order of increasing grit): flint, mese, and diamond.

There is also a 'Toolbox', which combines the functionality of all the hand tools other than the knife while having a little more durability than all of them put together.

## API

CraftTools provides an easy method for registering tools and consumables that use the same system as the provided ones. For tools, use the following function:

```lua
crafttools.register_tool(name, uses, def)
```

Where `name` is the itemname in the format `modname:item`, `uses` is the number of times the tool can be crafted with before breaking, and `def` is a normal tool item definition.
  Consumables are registered in the same way using the `crafttools.register_consumable` function which has the same parameter format as the function for registering tools. Keep in mind that the consumable definition is for a craftitem, not a tool, so tool-specific properties will be ignored.

If a tool definition contains the `wear_represents` field indicating that its' wear bar is used for something other than durability (like fuel or power charge) the tool will not break once fully worn out and will instead become unusable until recharged or refuelled. This feature can be used to create rechargeable power tools and the like, as well as tools where the wear bar represents the item being full of a substance such as a liquid. Keep in mind that some mods implementing repair systems will ignore `wear_represents` as it is an unofficial convention and not an engine rule.

If you want to create a recipe in which a craft tool or reusable consumable is completely used up in one craft, you can use this function:

```lua
crafttools.register_reuse_exception(tool, output)
```

This will cause any recipe containing the item `tool` as an ingredient with `output` as the output item to not return that tool or consumable to the grid after crafting. For the recipe to be craftable the tool item must be unused, i.e. at full durability and with no uses lost if a consumable. For example, this is used in the recipe for tape, where the glue is completely consumed in making the tape sticky, and in the recipe for the toolbox where all the tools are combined into it.
  There is presently no way to allow for a partially-used tool or consumable to be fully consumed. If this feature is requested it may be added later.

Aside from registering items as craft tools and reusable consumables, you can also mark an item to allow it to be automatically reused by giving it the `crafttools_tool_type` group, where 1 is a craft tool and 2 is a reusable consumable. You'll also need to define the `crafttools_tool_uses` group for both types, which determines how many times the item can be crafted with. This gives you a bit more control over the item's properties. Be aware that type 1 craft tools must be actual tools with wear, or the functionality will not work.

## What's the difference between craft tools and reusable consumables? When should I make an item a consumable instead of a tool?

Apart from the aesthetic difference of the wear bar VS the remaining uses counter and that tools make a breaking sound once fully used up, the primary functional distinction between craft tools and reusable consumables is that craft tools are registered as tool items in the engine, meaning they use the same wear/durability system as normal tools and can be repaired if another mod introduces some method of repairing tools. Reusable consumables don't use actual wear (and are not actually tools at all) and so they can't be repaired in any way.

Basically if you want your item to be repairable, it should be a craft tool, and if it gets used up and shouldn't be able to be repaired it should be a reusable consumable.

## Contributions

I will accept ideas for new tools/consumables to add to the mod and new functionality for the system itself via GitHub issues. Read `.dev/TO DO.md` and `.dev/IDEAS LIST.md` first to make sure your idea isn't already planned or being considered. Pull requests for translations and bug fixes can be made directly.

## Licensing

(C) Shqug 2026

The source code and data files of CraftTools are licensed under Apache 2.0. See `LICENSE.txt`.

The media files of CraftTools are licensed under CC BY-SA 4.0. See `MEDIA_LICENSE.txt`.
