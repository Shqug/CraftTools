
# CraftTools API Documentation

## Defining Tools

New CraftTools can be created using the `crafttools.register_tool` function. It takes three arguments: `name`, `uses`, and `definition`. `name` is a normal itemname in the `modname:itemname` format. `uses` is an integer number determining how many times the tool can (normally) be crafted with, either before it breaks or becomes unusable. `definition` is a standard tool item definition, with a description, inventory image, groups, etc.

If a crafttool's definition contains the `wear_represents` field, it will be treated as 'unbreakable', resulting in it not being destroyed once at 0 uses remaining and instead becoming useless until repaired, recharged, refuelled, or so on. The mechanics for refilling the uses of the tool are up to you, if you choose to use this feature.

If the definition contains a `sound` field, `sound.breaks` will be checked first before using the basic tool breaking sound from `default`. You can use this to specify a custom breaking sound for when the crafttool is fully used up. Additionally, a `sound.crafts` SoundSpec can be used to play a sound every time the tool is used in a crafting recipe. These sounds will only be played to the player doing the crafting.

## Defining Reusable Consumables

Reusable consumables are defined in much the same way as crafttools, using the `crafttools.register_consumable` function. It has the same parameters as `crafttools.register_tool`. Consumables are not registered as tool items, so they have no actual wear or other tool-specific definition fields. The `unbreakable` property thus also does not apply to consumables. Consumables do not have a breaking sound by default, but one can be defined, as can a crafting sound.

## Using Tools and Consumables in Recipes

To use standard tools/consumables in crafting recipes, you only need to input them as an ingredient in the same way you would any other item and they will perform their special behaviour automatically on craft. For example, to create a recipe to turn cobblestone into gravel using the Small Hammer, you would write the following recipe definition:

```lua:
core.register_craft {
	type = 'shapeless',
	recipe = {'crafttools:hammer', 'default:cobble'},
	output = 'default:gravel'
}
```

However, it's more convenient for you and the player if you use groups to specify the tools that can be used:

```lua:
core.register_craft {
	type = 'shapeless',
	recipe = {'group:craft_tool_hammer', 'default:cobble'},
	output = 'default:gravel'
}
```

The above recipe allows the use of both the hammer and the toolbox, and any item you give  the `craft_tool_hammer` group.

## Per-Recipe Behaviour Overrides

Sometimes the basic crafttool functionality isn't quite what you need, so you can customize the behaviour of individual crafttools and consumables on a per-recipe basis using Overrides.
In order to use overrides, you first need to wrap the tool or consumable's itemstack or itemstring in a `CraftTool` ingredient wrapper. This can be achieved by calling `CraftTool(my_itemstack)`, or more simply `CraftTool 'modname:itemname'` (which will be used going forward to describe the available behaviour overrides). This returns a `CraftTool` object, which contains several useful methods for modifying the properties of a tool or consumable on a case-by-case basis. Every method of the object returns the object itself, so you can chain multiple of them in a row.

In order to use `CraftTool` objects in a recipe you don't need to do anything special. The following is a valid recipe definition:

```lua
core.register_craft {
	type = 'shapeless',
	recipe = {CraftTool 'group:craft_tool_hammer', 'default:cobble'},
	output = 'default:gravel'
}
```

This recipe has no special behaviour compared to the normal features of a crafttool, and will act for all intents and purposes as a completely normal crafting recipe.

The following methods are available for `CraftTool` objects:

 - `CraftTool 'mymod:item': consume()`: Flags the item as to be completely consumed, and disallows the recipe from being crafted if the item's uses are not completely full (exception, see `any_uses`). Consumed items do not play a breaking sound. This is used in the recipes for tape and the toolbox.
 - `CraftTool 'mymod:item': take_uses(uses)`: Defines how many uses should be taken from the tool or consumable. If the item has less remaining than this amount, the recipe will not be craftable (exception, see `any_uses`). This is used in the recipes for sandpaper.
 - `CraftTool 'mymod:item': unbreakable(bool)`: Sets the tool as either unbreakable or breakable depending on the boolean value supplied. If no value is supplied, default to `true`. Normally-unbreakable tools can be made temporarily breakable by passing `false`.
 - `CraftTool 'mymod:item': any_uses()`: Flags the item to allow the recipe to succeed regardless of the number of remaining uses. Over-overrides the craft cancellation of other overrides.
 - `CraftTool 'mymod:item': replace(itemstack)`: Causes the item to be replaced by a different item once consumed or fully used up. Compatible with `:consume()`, and not compatible with `:unbreakable()`.
 - `CraftTool 'mymod:item': break_sound(soundspec)`: Overrides the sound played when the tool or consumable breaks/is used up.
 - `CraftTool 'mymod:item': craft_sound(soundspec)`: Overrides the sound played when the tool or consumable is crafted with.

An example of their use might look like this:

```lua
core.register_craft {
	type = 'shapeless',
	recipe = {CraftTool 'group:craft_tool_hammer': take_uses(5): any_uses(): unbreakable(), 'default:cobble'},
	output = 'default:gravel'
}
```

The above example will result in a recipe which takes 3 uses from the hammer at a time instead of one, will still work when only one or two uses remain, and will not allow the hammer to break fully and will be uncraftable once the hammer has no remaining uses.

## Using Non-CraftTool Tools as CraftTools

By wrapping a normal item in a `CraftTool` object, you can use the aforementioned methods on it just like with a crafttool. The majority of these only make sense for tools, and there are special cases for non-crafttool tool items to be used like this. By default, one of the tool's digging group's uses values will be used as the maximum crafting uses of the tool. In order of decreasing priority, the groups used will be `cracky`, `choppy`, `crumbly`, and `snappy`. If you want to specify a custom number of craft uses for a tool, the `:uses(count)` method allows you to do so only for tools that are not registered crafttools.

For example, this recipe will allow using the steel pickaxe to break cobble into gravel, with 20 uses (the default from the cracky groupcap):

```lua
core.register_craft {
	type = 'shapeless',
	recipe = {CraftTool 'default:pick_steel', 'default:cobble'},
	output = 'default:gravel'
}
```

And this will allow the same, but with 50 uses:

```lua
core.register_craft {
	type = 'shapeless',
	recipe = {CraftTool 'default:pick_steel': uses(50), 'default:cobble'},
	output = 'default:gravel'
}
```

Note that `:uses()` is ignored for regular crafttools.

You can also use `:replace()` on both tool and non-tool items, rather than the engine's `replacements` field in recipe definitions. This only really makes sense for non-stacking items, as the stack passed to `:replace()` will completely overwrite the input item, including its' count.

## What's the difference between craft tools and reusable consumables? When should I make an item a consumable instead of a tool?

Apart from the aesthetic difference of the wear bar VS the remaining uses counter and that tools make a breaking sound once fully used up, the primary functional distinction between craft tools and reusable consumables is that craft tools are registered as tool items in the engine, meaning they use the same wear/durability system as normal tools and can be repaired if another mod introduces some method of repairing tools. Reusable consumables don't use actual wear (and are not actually tools at all) and so they can't be repaired in any way.

Basically if you want your item to be repairable, it should be a craft tool, and if it gets used up and shouldn't be able to be repaired it should be a reusable consumable.