
local enable_recipes = core.settings: get_bool('crafttools.enable_default_recipes', true)
local repair_crafttools_only = core.settings: get_bool('crafttools.repair_kit_crafttools_only', false)
local repair_ratio = core.settings: get 'crafttools.repair_kit_repair_amount' or 0.25

crafttools.register_consumable('crafttools:repair_kit', core.settings: get 'crafttools.repair_kit_max_uses' or 12, {
	description = crafttools.gettext 'Repair Kit' .. '\n' .. core.colorize('#ff8c00', crafttools.gettext('Combine with a tool to repair it by @1%', 100 * repair_ratio)),
	inventory_image = 'crafttools_repair_kit.png'
})

if enable_recipes then
	core.register_craft {
		recipe = {
			{CraftTool 'crafttools:sandpaper_1': consume(), CraftTool 'crafttools:glue': consume(), CraftTool 'crafttools:tape': consume()},
			{'default:tin_ingot', 'default:copper_ingot', 'farming:string'}
		},
		output = 'crafttools:repair_kit'
	}
end

core.register_craft_predict(function (crafted, player, old_craft_grid, craft_inv)
	local has_kit = false
	local has_tool = false
	local tool_index = 0
	
	for index, item in ipairs(old_craft_grid) do
		local itemname = item: get_name()
		local itemdef  = item: get_definition()
		
		if itemname == 'crafttools:repair_kit' then
			if has_kit then return '' end
			
			has_kit = true
		end
		
		if itemdef.type == 'tool' and not has_tool then
			if repair_crafttools_only then
				local tooltype = core.get_item_group(itemname, 'crafttools_tool_type')
				
				if tooltype ~= 1 then return '' end
				has_tool = true
				tool_index = index
			else
				has_tool = true
				tool_index = index
			end
		end
	end
	
	if has_kit and has_tool then
		local tool = old_craft_grid[tool_index]
		
		local wear = tool: get_wear()
		
		if wear == 0 then return '' end
		
		wear = math.max(0, wear - (repair_ratio * 65536))
		
		local new_tool = ItemStack(tool)
		new_tool: set_wear(wear)
		
		return new_tool
	end
end)

core.register_on_craft(function (crafted, player, old_craft_grid, craft_inv)
	local has_kit = false
	local has_tool = false
	local tool_index = 0
	
	for index, item in ipairs(old_craft_grid) do
		local itemname = item: get_name()
		local itemdef  = item: get_definition()
		
		if itemname == 'crafttools:repair_kit' then
			if has_kit then return '' end
			
			has_kit = true
		end
		
		if itemdef.type == 'tool' and not has_tool then
			if repair_crafttools_only then
				local tooltype = core.get_item_group(itemname, 'crafttools_tool_type')
				
				if tooltype ~= 1 then return '' end
				has_tool = true
				tool_index = index
			else
				has_tool = true
				tool_index = index
			end
		end
	end
	
	if has_kit and has_tool then
		local tool = old_craft_grid[tool_index]
		
		local wear = tool: get_wear()
		wear = math.max(0, wear - (repair_ratio * 65536))
		
		local new_tool = ItemStack(tool)
		new_tool: set_wear(wear)
		
		craft_inv: set_stack('craft', tool_index, ItemStack())
		
		return new_tool
	end
end)