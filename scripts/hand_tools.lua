
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

crafttools.register_tool('crafttools:knife', core.settings: get 'crafttools.knife_max_uses' or 200, {
	description = crafttools.gettext 'Knife',
	inventory_image = 'crafttools_knife.png',
	groups = {craft_tool_knife = 1}
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

if core.settings: get_bool('crafttools.enable_toolbox', true) then
	crafttools.register_tool('crafttools:toolbox', core.settings: get 'crafttools.toolbox_max_uses' or 1300, {
		description = crafttools.gettext 'Toolbox',
		inventory_image = 'crafttools_toolbox.png',
		groups = {
			craft_tool_file = 1,
			craft_tool_drill = 1,
			craft_tool_hammer = 1,
			craft_tool_cutters = 1,
			craft_tool_wrench = 1,
			craft_tool_knife = 1
		}
	})

	if enable_recipes then
		core.register_craft {
			type = 'shapeless',
			recipe = {
				'crafttools:file', 'crafttools:drill', 'crafttools:hammer',
				'crafttools:cutters', 'crafttools:wrench', 'crafttools:knife',
				'default:chest_locked'
			},
			output = 'crafttools:toolbox'
		}
		
		crafttools.register_reuse_exception('crafttools:file', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:drill', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:hammer', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:cutters', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:wrench', 'crafttools:toolbox')
		crafttools.register_reuse_exception('crafttools:knife', 'crafttools:toolbox')
	end
end