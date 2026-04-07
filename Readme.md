# CraftTools

A library for mod & game developers providing simple tools and reusable ingredients that automatically return and lose a bit of durability when crafted with, rather than disappearing like a normal ingredient. Also includes an API for registering new tools and consumables.

Optionally depends on `default` for recipes.

All tools and consumables and their recipes can be disabled by category or individually, and the durability of all tools can be changed in the settings.

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

CraftTools has an extensive API for creating new tools and consumables, and overriding crafttool behaviour on a per-recipe basis. The mod API documentation can now be found in `API.md` in the mod/repository root directory.

## Contributions

I will accept ideas for new tools/consumables to add to the mod and new functionality for the system itself via GitHub issues. Read `.dev/TO DO.md` and `.dev/IDEAS LIST.md` first to make sure your idea isn't already planned or being considered. Pull requests for translations and bug fixes can be made directly.

## Licensing

(C) Shqug 2026

The source code and data files of CraftTools are licensed under Apache 2.0. See `LICENSE.txt`.

The media files of CraftTools are licensed under CC BY-SA 4.0. See `MEDIA_LICENSE.txt`.
