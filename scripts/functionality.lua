
local craft_tool_description = core.colorize('#ff8c00', crafttools.gettext 'Crafting tool: reusable in recipes')

local consumable_uses_colors = {
	{'#b61616', 0},
	{'#d8730e', 0.2},
	{'#e7b500', 0.45},
	{'#98cc09', 0.7},
	{'#00ea08', 0.9}
}

local function get_consumable_uses_color(uses, used)
	local percent = (1/uses)*(uses-used)
	
	local last_color = consumable_uses_colors[5][1]
	for _, v in pairs(consumable_uses_colors) do
		if percent >= v[2] then
			last_color = v[1]
		end
	end
	
	return last_color
end

-- A list of consumables/tools, and items which when given as the output of the recipe the consumable/tool will be consumed entirely
-- the consumable/tool must be unused in order to be accepted for recipes of this kind
crafttools.on_craft_exceptions = {}

core.register_on_craft(function (crafted, player, old_craft_grid, craft_inv)
	for index, item in ipairs(old_craft_grid) do
		local itemname    = item: get_name()
		local tooltype    = core.get_item_group(itemname, 'crafttools_tool_type')
		local uses        = core.get_item_group(itemname, 'crafttools_tool_uses')
		local unbreakable = core.get_item_group(itemname, 'crafttools_tool_unbreakable') == 1
		
		if not (crafttools.on_craft_exceptions[itemname] and crafttools.on_craft_exceptions[itemname][crafted: get_name()]) then
			if tooltype == 1 then -- A tool
				local wear = item: get_wear()
				wear = wear + math.ceil(65535 / uses)
				
				if wear >= 65535 then
					if unbreakable then
						item: set_wear(65534)
						craft_inv: set_stack('craft', index, item)
					else
						if default then core.sound_play({name = 'default_tool_breaks'}, {to_player = player: get_player_name()}, true) end
					end
				else
					item: set_wear(wear)
					craft_inv: set_stack('craft', index, item)
				end
			elseif tooltype == 2 then -- A multi-use consumable
				local meta = item: get_meta()
				local used = (meta: get_int 'crafttools_consumable_used') + 1
				
				if used < uses then
					meta: set_string('count_meta', core.colorize(get_consumable_uses_color(uses, used), (uses - used) .. '/' .. uses))
					meta: set_int('crafttools_consumable_used', used)
					craft_inv: set_stack('craft', index, item)
				end
			end
		end
	end
end)

-- Ensure only unused consumables & tools can be used in recipes that use the entire item
core.register_craft_predict(function (crafted, player, old_craft_grid, craft_inv)
	for index, item in ipairs(old_craft_grid) do
		local itemname    = item: get_name()
		local unbreakable = core.get_item_group(itemname, 'crafttools_tool_unbreakable') == 1
		
		if unbreakable and item: get_wear() >= 65534 then
			return ''
		end
		
		if crafttools.on_craft_exceptions[itemname] and crafttools.on_craft_exceptions[itemname][crafted: get_name()] then
			local meta = item: get_meta()
			local used = meta: get_int 'crafttools_consumable_used' or 0
			
			if used > 0 or item: get_wear() > 0 then
				return ''
			end
		end
	end
end)

local tool_wear_color = {
	blend = 'linear',
	color_stops = {
		[0.0] = '#150223',
		[0.25] = '#2a2630',
		[0.5] = '#6f7681',
		[0.75] = '#a5bebc',
		[1.0] = '#ffffff'
	}
}

function crafttools.register_tool (name, uses, def)
	def.description = (def.description or '') .. '\n' .. craft_tool_description
	def.wear_color = def.wear_color or tool_wear_color
	def.groups = def.groups or {}
	def.groups.crafttools_tool_type = 1
	def.groups.crafttools_tool_uses = uses
	if def.wear_represents ~= nil then def.groups.crafttools_tool_unbreakable = 1 end
	
	core.register_tool(':' .. name, def)
end

function crafttools.register_consumable (name, uses, def)
	def.description = (def.description or '') .. '\n' .. craft_tool_description
	def.groups = def.groups or {}
	def.groups.crafttools_tool_type = 2
	def.groups.crafttools_tool_uses = uses
	def.stack_max = 1
	
	core.register_craftitem(':' .. name, def)
end

-- Initially set count_meta and count_alignment for reusable consumables on craft
core.register_on_craft(function (item, player, old_craft_grid, craft_inv)
	local itemname = item: get_name()
	local tooltype = core.get_item_group(itemname, 'crafttools_tool_type')
	local uses     = core.get_item_group(itemname, 'crafttools_tool_uses')
	
	if tooltype == 2 then
		local meta = item: get_meta()
		meta: set_int('count_alignment', 7)
		meta: set_string('count_meta', core.colorize('#00ea08', uses .. '/' .. uses))
	end
	
	return item
end)

function crafttools.register_reuse_exception (consumable, output)
	local consumable_name = ItemStack(consumable): get_name()
	local output_name = ItemStack(output): get_name()
	
	crafttools.on_craft_exceptions[consumable_name] = crafttools.on_craft_exceptions[consumable_name] or {}
	crafttools.on_craft_exceptions[consumable_name][output_name] = true
end