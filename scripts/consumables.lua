
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