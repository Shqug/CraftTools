
local enable_recipes = core.settings: get_bool('crafttools.enable_default_recipes', true)

if core.settings: get_bool('crafttools.file_enabled', true) then
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
end

if core.settings: get_bool('crafttools.drill_enabled', true) then
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
end

if core.settings: get_bool('crafttools.hammer_enabled', true) then
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
end

if core.settings: get_bool('crafttools.cutters_enabled', true) then
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
end

if core.settings: get_bool('crafttools.wrench_enabled', true) then
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
end

if core.settings: get_bool('crafttools.knife_enabled', true) then
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
end

if core.settings: get_bool('crafttools.saw_enabled', true) then
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
end

if core.settings: get_bool('crafttools.chisel_enabled', true) then
	crafttools.register_tool('crafttools:chisel', core.settings: get 'crafttools.chisel_max_uses' or 500, {
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
end

if core.settings: get_bool('crafttools.enable_toolbox', true) then
	crafttools.register_tool('crafttools:toolbox', 1000, {
		description = crafttools.gettext 'Toolbox',
		inventory_image = 'crafttools_toolbox.png',
		groups = {
			craft_tool_file = 1,
			craft_tool_drill = 1,
			craft_tool_hammer = 1,
			craft_tool_cutters = 1,
			craft_tool_wrench = 1,
			craft_tool_saw = 1
		}
	})
	
	if enable_recipes then
		core.register_craft {
			type = 'shapeless',
			recipe = {
				CraftTool 'group:craft_tool_file': consume(), CraftTool 'group:craft_tool_drill': consume(), CraftTool 'group:craft_tool_hammer': consume(),
				CraftTool 'group:craft_tool_cutters': consume(), CraftTool 'group:craft_tool_wrench': consume(), CraftTool 'group:craft_tool_saw': consume(),
				'default:chest'
				
			},
			output = 'crafttools:toolbox'
		}
		
		core.register_craft {
			recipe = {
				{CraftTool 'crafttools:toolbox': take_uses(2), '', 'default:steel_ingot'},
				{'default:bronze_ingot', 'default:steel_ingot', ''},
				{'default:stick', '', ''}
			},
			output = 'crafttools:knife'
		}
		
		core.register_craft {
			recipe = {
				{CraftTool 'crafttools:toolbox': take_uses(2), 'default:steel_ingot', ''},
				{'default:stick', 'default:bronze_ingot', 'default:steel_ingot'},
				{'', 'default:stick', ''}
			},
			output = 'crafttools:cutters'
		}
		
		core.register_craft {
			recipe = {
				{'default:steel_ingot', 'default:steel_ingot', ''},
				{'', 'default:bronze_ingot', ''},
				{CraftTool 'crafttools:toolbox': take_uses(2), '', 'default:stick'}
			},
			output = 'crafttools:saw'
		}
	end
	
	core.register_craft_predict(function (crafted, player, old_craft_grid, craft_inv)
		if crafted: get_name() == 'crafttools:toolbox' then
			for index, item in ipairs(old_craft_grid) do
				if item: get_name() == 'crafttools:toolbox' then return '' end
				local unbreakable = core.get_item_group(itemname, 'crafttools_tool_unbreakable') == 1
				if unbreakable then return '' end
			end
		end
	end)
	
	core.register_on_craft(function (crafted, player, old_craft_grid, craft_inv)
		if crafted: get_name() == 'crafttools:toolbox' then
			local stored_items = {}
			local stored_item_descriptions = {}
			local combined_uses = 0
			
			for index, item in ipairs(old_craft_grid) do
				local itemname = item: get_name()
				local tooltype    = core.get_item_group(itemname, 'crafttools_tool_type')
				local uses        = core.get_item_group(itemname, 'crafttools_tool_uses')
				
				if tooltype == 1 then
					table.insert(stored_items, item: to_string())
					table.insert(stored_item_descriptions, item: get_short_description())
					combined_uses = combined_uses + uses
				end
			end
			
			local meta = crafted: get_meta()
			local stored_string = core.serialize(stored_items)
			meta: set_string('crafttools:toolbox_stored', stored_string)
			meta: set_int('crafttools:uses_override', math.floor(combined_uses * 1.1))
			local separator = '\n\t' .. core.get_color_escape_sequence('#ffcc00') .. '· '
			meta: set_string('description', core.registered_items['crafttools:toolbox'].description .. separator .. table.concat(stored_item_descriptions, separator) .. core.get_color_escape_sequence('#ffffff'))
		end
	end)
end

if core.settings: get_bool('crafttools.toolbox_allow_splitting', true) then
	core.register_craftitem('crafttools:toolbox_uncraft_placeholder', {groups={not_in_creative_inventory = 1}})
	
	local input_stack = ItemStack 'crafttools:toolbox'
	input_stack: get_meta(): set_string('description', input_stack: get_description() .. '\n' .. core.colorize('#ff3c00', crafttools.gettext 'Tools will be returned to the inventory'))
	
	core.register_craft {
		type = 'shapeless',
		recipe = {CraftTool(input_stack: to_string()): require_uses(-1): consume()},
		output = 'crafttools:toolbox_uncraft_placeholder'
	}
	
	core.register_craft_predict(function (crafted, player, old_craft_grid, craft_inv)
		if crafted: get_name() == 'crafttools:toolbox_uncraft_placeholder' then
			return 'default:chest'
		end
	end)
	
	core.register_on_craft(function (crafted, player, old_craft_grid, craft_inv)
		if crafted: get_name() == 'crafttools:toolbox_uncraft_placeholder' then
			local toolbox_index
			
			for index, item in ipairs(old_craft_grid) do
				if item: get_name() == 'crafttools:toolbox' then
					toolbox_index = index
					break
				end
			end
			
			local toolbox = old_craft_grid[toolbox_index]
			local meta = toolbox: get_meta()
			local stored_items = core.deserialize(meta: get_string 'crafttools:toolbox_stored')
			
			if stored_items and #stored_items ~= 0 then
				for _, item in pairs(stored_items) do
					craft_inv: add_item('craft', item)
				end
			end
			
			return 'default:chest'
		end
	end)
end
