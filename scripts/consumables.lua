
local enable_recipes = core.settings: get_bool('crafttools.enable_default_recipes', true)

crafttools.register_consumable('crafttools:glue', core.settings: get 'crafttools.glue_max_uses' or 20, {
	description = crafttools.gettext 'Glue',
	inventory_image = 'crafttools_glue.png'
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'', 'default:paper', ''},
			{'default:sand_with_kelp', 'default:sand_with_kelp', 'default:sand_with_kelp'},
			{'', 'default:tin_ingot', ''}
		},
		output = 'crafttools:glue'
	}
end

crafttools.register_consumable('crafttools:tape', core.settings: get 'crafttools.tape_max_uses' or 30, {
	description = crafttools.gettext 'Tape',
	inventory_image = 'crafttools_tape.png'
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'default:paper', 'default:paper', 'default:stick'},
			{'default:paper', 'crafttools:glue', 'default:paper'},
			{'default:paper', 'default:paper', 'default:paper'}
		},
		output = 'crafttools:tape'
	}
	
	crafttools.register_reuse_exception('crafttools:glue', 'crafttools:tape')
end

crafttools.register_consumable('crafttools:sandpaper_1', core.settings: get 'crafttools.sandpaper_1_max_uses' or 25, {
	description = crafttools.gettext 'Flint Sandpaper',
	inventory_image = 'crafttools_sandpaper_1.png'
})

if enable_recipes then
	core.register_craft {
		type = 'shapeless',
		recipe = {
			'crafttools:glue', 'group:craft_tool_hammer',
			'default:flint', 'default:flint',
			'default:paper', 'default:paper'
		},
		output = 'crafttools:sandpaper_1'
	}
end

crafttools.register_consumable('crafttools:sandpaper_2', core.settings: get 'crafttools.sandpaper_2_max_uses' or 90, {
	description = crafttools.gettext 'Mese Sandpaper',
	inventory_image = 'crafttools_sandpaper_2.png'
})

if enable_recipes then
	core.register_craft {
		type = 'shapeless',
		recipe = {
			'crafttools:glue', 'group:craft_tool_hammer',
			'default:mese_crystal', 'default:mese_crystal',
			'default:paper', 'default:paper'
		},
		output = 'crafttools:sandpaper_2'
	}
end

crafttools.register_consumable('crafttools:sandpaper_3', core.settings: get 'crafttools.sandpaper_3_max_uses' or 240, {
	description = crafttools.gettext 'Diamond Sandpaper',
	inventory_image = 'crafttools_sandpaper_3.png'
})

if enable_recipes then
	core.register_craft {
		type = 'shapeless',
		recipe = {
			'crafttools:glue', 'group:craft_tool_hammer',
			'default:diamond', 'default:diamond',
			'default:paper', 'default:paper'
		},
		output = 'crafttools:sandpaper_3'
	}
end