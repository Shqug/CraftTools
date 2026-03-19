
local enable_recipes = core.settings: get_bool('crafttools.enable_default_recipes', true)

crafttools.register_tool('crafttools:file', core.settings: get 'crafttools.file_max_uses' or 150, {
	description = crafttools.gettext 'Metal File',
	inventory_image = 'crafttools_file.png',
	groups = {craft_tool_file = 1}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'', '', 'default:steel_ingot'},
			{'', 'default:bronze_ingot', ''},
			{'default:stick', '', ''}
		},
		output = 'crafttools:file'
	}
end

crafttools.register_tool('crafttools:drill', core.settings: get 'crafttools.drill_max_uses' or 200, {
	description = crafttools.gettext 'Hand Drill',
	inventory_image = 'crafttools_drill.png',
	groups = {craft_tool_drill = 1}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'default:bronze_ingot', 'default:stick', 'default:steel_ingot'},
			{'', '', 'default:stick'},
			{'group:craft_tool_file', 'default:steel_ingot', ''}
		},
		output = 'crafttools:drill'
	}
end

crafttools.register_tool('crafttools:hammer', core.settings: get 'crafttools.hammer_max_uses' or 250, {
	description = crafttools.gettext 'Small Hammer',
	inventory_image = 'crafttools_hammer.png',
	groups = {craft_tool_hammer = 1}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'group:craft_tool_drill', 'default:steel_ingot', 'default:bronze_ingot'},
			{'', 'default:stick', 'default:steel_ingot'},
			{'default:stick', '', ''}
		},
		output = 'crafttools:hammer'
	}
end

crafttools.register_tool('crafttools:cutters', core.settings: get 'crafttools.cutters_max_uses' or 250, {
	description = crafttools.gettext 'Metal Cutters',
	inventory_image = 'crafttools_cutters.png',
	groups = {craft_tool_cutters = 1}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'group:craft_tool_drill', 'default:steel_ingot', 'group:craft_tool_file'},
			{'default:stick', 'default:bronze_ingot', 'default:steel_ingot'},
			{'', 'default:stick', ''}
		},
		output = 'crafttools:cutters'
	}
end

crafttools.register_tool('crafttools:wrench', core.settings: get 'crafttools.wrench_max_uses' or 200, {
	description = crafttools.gettext 'Wrench',
	inventory_image = 'crafttools_wrench.png',
	groups = {craft_tool_wrench = 1}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'group:craft_tool_file', '', 'default:steel_ingot'},
			{'', 'default:steel_ingot', ''},
			{'default:steel_ingot', '', ''}
		},
		output = 'crafttools:wrench'
	}
end

local knife_uses = core.settings: get 'crafttools.knife_max_uses' or 200

crafttools.register_tool('crafttools:knife', knife_uses, {
	description = crafttools.gettext 'Knife',
	inventory_image = 'crafttools_knife.png',
	groups = {craft_tool_knife = 1},
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level = 0,
		groupcaps = {
			snappy = {times = {[2] = 1, [3] = 0.25}, uses = knife_uses, maxlevel = 1},
		},
		damage_groups = {fleshy = core.settings: get 'crafttools.knife_attack_damage' or 3}
	}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'group:craft_tool_file', '', 'default:steel_ingot'},
			{'default:bronze_ingot', 'default:steel_ingot', 'group:craft_tool_hammer'},
			{'default:stick', '', ''}
		},
		output = 'crafttools:knife'
	}
end

crafttools.register_tool('crafttools:saw', core.settings: get 'crafttools.saw_max_uses' or 250, {
	description = crafttools.gettext 'Hand Saw',
	inventory_image = 'crafttools_saw.png',
	groups = {craft_tool_saw = 1}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'default:steel_ingot', 'default:steel_ingot', ''},
			{'', 'default:bronze_ingot', 'group:craft_tool_hammer'},
			{'group:craft_tool_cutters', '', 'default:stick'}
		},
		output = 'crafttools:saw'
	}
end

crafttools.register_tool('crafttools:chisel', core.settings: get 'crafttools.chisel_max_uses' or 300, {
	description = crafttools.gettext 'Chisel',
	inventory_image = 'crafttools_chisel.png',
	groups = {craft_tool_chisel = 1}
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{'default:steel_ingot', 'group:craft_tool_file', ''},
			{'', 'default:bronze_ingot', ''},
			{'', '', 'default:stick'}
		},
		output = 'crafttools:chisel'
	}
end

if core.settings: get_bool('crafttools.enable_toolbox', true) then
	crafttools.register_tool('crafttools:toolbox', core.settings: get 'crafttools.toolbox_max_uses' or 1850, {
		description = crafttools.gettext 'Toolbox',
		inventory_image = 'crafttools_toolbox.png',
		groups = {
			craft_tool_file = 1,
			craft_tool_drill = 1,
			craft_tool_hammer = 1,
			craft_tool_cutters = 1,
			craft_tool_wrench = 1,
			craft_tool_saw = 1,
			craft_tool_chisel = 1
		}
	})

	if enable_recipes then
		core.register_craft {
			type = 'shapeless',
			recipe = {
				'crafttools:file', 'crafttools:drill', 'crafttools:hammer',
				'crafttools:cutters', 'default:chest_locked', 'crafttools:wrench',
				'crafttools:saw', 'crafttools:chisel'
				
			},
			output = 'crafttools:toolbox'
		}
		
		crafttools.register_reuse_exception('crafttools:file', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:drill', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:hammer', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:cutters', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:wrench', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:saw', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:chisel', 'crafttools:toolbox')
		
		core.register_craft {
			recipe = {
				{'crafttools:toolbox', '', 'default:steel_ingot'},
				{'default:bronze_ingot', 'default:steel_ingot', ''},
				{'default:stick', '', ''}
			},
			output = 'crafttools:knife'
		}
		
		core.register_craft {
			recipe = {
				{'crafttools:toolbox', 'default:steel_ingot', ''},
				{'default:stick', 'default:bronze_ingot', 'default:steel_ingot'},
				{'', 'default:stick', ''}
			},
			output = 'crafttools:cutters'
		}
		
		core.register_craft {
			recipe = {
				{'default:steel_ingot', 'default:steel_ingot', ''},
				{'', 'default:bronze_ingot', ''},
				{'crafttools:toolbox', '', 'default:stick'}
			},
			output = 'crafttools:saw'
		}
	end
end