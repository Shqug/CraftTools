
local enable_craft_sounds = core.settings: get_bool('crafttools.enable_craft_sounds', true)
local enable_break_sounds = core.settings: get_bool('crafttools.enable_break_sounds', true)

local craft_tool_description = core.colorize('#ff8c00', crafttools.gettext 'Crafting tool: reusable in recipes')
local consumable_description = core.colorize('#ff8c00', crafttools.gettext 'Multi-use crafting ingredient')

local tool_wear_color = {
	blend = 'linear',
	color_stops = {
		[0.0]  = '#150223',
		[0.25] = '#2a2630',
		[0.5]  = '#6f7681',
		[0.75] = '#a5bebc',
		[1.0]  = '#ffffff'
	}
}

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

-- Holds behaviour overrides based on itemname and recipe output
-- Valid override types are:
--> consume (flag): when true, item is fully consumed on craft
--> any_uses (flag): when true, recipe is allowed even when the item doesn't have enough uses
--> take_uses (int): the number of uses to consume. ignored if <consume> is true
--> unbreakable (bool): when true, the item will be left at 0 uses and the recipe will be disallowed for 0-use items. when set to false, disables inherent unbreakability. ignored if <consume> is true
--> replace (itemstack): after the crafttool breaks, it will be replaced by the provided itemstack or itemstring
crafttools.craft_behaviour_overrides = {}
crafttools.craft_behaviour_group_overrides = {}

local CraftTool_meta = {__index = {
	__tostring = function (self)
		return ItemStack(self.item): to_string()
	end,
	consume = function (self)
		self.overrides.consume = true
		return self
	end,
	any_uses = function (self)
		self.overrides.any_uses = true
		return self
	end,
	require_uses = function (self, count)
		self.overrides.min_uses = count
		return self
	end,
	take_uses = function (self, count)
		self.overrides.take_uses = count or 1
		return self
	end,
	unbreakable = function (self, val)
		if val == nil then val = true end
		self.overrides.unbreakable = val
		return self
	end,
	replace = function (self, item)
		self.overrides.replace = item or ''
		return self
	end,
	uses = function (self, count)
		self.overrides.uses = count or 1
		return self
	end,
	break_sound = function (self, sound)
		self.overrides.sound = self.overrides.sound or {}
		self.overrides.sound.breaks = sound
		return self
	end,
	craft_sound = function (self, sound)
		self.overrides.sound = self.overrides.sound or {}
		self.overrides.sound.crafts = sound
		return self
	end
}, __CraftTool = true}

-- Wrap an itemstack or itemstring as a crafttool ingredient, which holds information on overrides
function CraftTool (item)
	return setmetatable({item = item, overrides = {enabled = true}}, CraftTool_meta)
end

local function merge (a, b)
	local c = table.copy(a)
	
	for k, v in pairs(b) do
		c[k] = type(v) == 'table' and table.copy(v) or v
	end
	
	return c
end

local function get_overrides (input, output)
	local output = output: get_name()
	
	local overrides = crafttools.craft_behaviour_overrides[input] and crafttools.craft_behaviour_overrides[input][output] or {}
	
	local def = ItemStack(input): get_definition()
	if def.groups then
		for group, _ in pairs(def.groups) do
			if crafttools.craft_behaviour_group_overrides[group] and crafttools.craft_behaviour_group_overrides[group][output] then
				overrides = merge(overrides, crafttools.craft_behaviour_group_overrides[group][output])
			end
		end
	end
	
	return overrides
end

core.register_on_craft(function (crafted, player, old_craft_grid, craft_inv)
	for index, item in ipairs(old_craft_grid) do
		local def = item: get_definition()
		local itemname    = item: get_name()
		local tooltype    = core.get_item_group(itemname, 'crafttools_tool_type')
		local uses        = core.get_item_group(itemname, 'crafttools_tool_uses')
		local unbreakable = core.get_item_group(itemname, 'crafttools_tool_unbreakable') == 1
		
		local overrides = get_overrides(itemname, crafted)
		
		-- Non-crafttool tools are treated as crafttools if they have a defined override for this recipe
		if overrides.enabled and (tooltype == 0 or not tooltype) and def.type == 'tool' then
			tooltype = 1
			uses = def.tool_capabilities and def.tool_capabilities.groupcaps and overrides.uses or (
				def.tool_capabilities.groupcaps.cracky or
				def.tool_capabilities.groupcaps.choppy or
				def.tool_capabilities.groupcaps.crumbly or
				def.tool_capabilities.groupcaps.snappy
			)['uses'] or 1
		end
		
		if overrides.unbreakable ~= nil then
			unbreakable = overrides.unbreakable
		end
		
		if (not overrides.consume) and tooltype ~= 0 then
			if tooltype == 1 then -- A tool
				local wear = item: get_wear()
				wear = wear + (math.ceil(65535 / uses) * (overrides.take_uses or 1))
				
				if enable_craft_sounds and (overrides.sound or def.sound) then
					core.sound_play((overrides.sound and overrides.sound.crafts) or (def.sound and def.sound.crafts), {to_player = player: get_player_name()}, true)
				end
				
				if wear >= 65535 then
					if unbreakable then
						item: set_wear(65534)
						craft_inv: set_stack('craft', index, item)
					else
						if enable_break_sounds and (overrides.sound or def.sound or default) then
							core.sound_play((overrides.sound and overrides.sound.breaks) or (def.sound and def.sound.breaks) or {name = 'default_tool_breaks'}, {to_player = player: get_player_name()}, true)
						end
						if overrides.replace then
							craft_inv: set_stack('craft', index, overrides.replace)
						end
					end
				else
					item: set_wear(wear)
					craft_inv: set_stack('craft', index, item)
				end
			elseif tooltype == 2 then -- A multi-use consumable
				local meta = item: get_meta()
				local used = (meta: get_int 'crafttools_consumable_used') + (overrides.take_uses or 1)
				
				if enable_craft_sounds and (overrides.sound or def.sound) then
					core.sound_play((overrides.sound and overrides.sound.crafts) or (def.sound and def.sound.crafts), {to_player = player: get_player_name()}, true)
				end
				
				if used < uses then
					meta: set_string('count_meta', core.colorize(get_consumable_uses_color(uses, used), (uses - used) .. '/' .. uses))
					meta: set_int('crafttools_consumable_used', used)
					craft_inv: set_stack('craft', index, item)
				else
					if enable_break_sounds and (overrides.sound or def.sound) then
						core.sound_play((overrides.sound and overrides.sound.breaks) or (def.sound and def.sound.breaks), {to_player = player: get_player_name()}, true)
					end
					if overrides.replace then
						craft_inv: set_stack('craft', index, overrides.replace)
					else
						craft_inv: set_stack('craft', index, ItemStack())
					end
				end
			end
		else
			if overrides.replace then
				craft_inv: set_stack('craft', index, overrides.replace)
			end
		end
	end
end)

-- Only allow crafts when the required number of uses are available, unless overridden
core.register_craft_predict(function (crafted, player, old_craft_grid, craft_inv)
	for index, item in ipairs(old_craft_grid) do
		local itemname    = item: get_name()
		local tooltype    = core.get_item_group(itemname, 'crafttools_tool_type')
		local uses        = core.get_item_group(itemname, 'crafttools_tool_uses')
		local unbreakable = core.get_item_group(itemname, 'crafttools_tool_unbreakable') == 1
		
		local overrides = get_overrides(itemname, crafted)
		
		if overrides.unbreakable ~= nil then
			unbreakable = overrides.unbreakable
		end
		
		if overrides.min_uses and not overrides.any_uses then
			if tooltype == 1 then
				local wear = item: get_wear()
				
				if overrides.min_uses == -1 and wear ~= 0 then return '' end
				
				if (65536 - wear) < math.floor(65535 / uses) * overrides.min_uses then
					return ''
				end
			elseif tooltype == 2 then
				local meta = item: get_meta()
				local used = meta: get_int 'crafttools_consumable_used'
				
				if overrides.min_uses == -1 and used ~= 0 then return '' end
				
				if uses - used < overrides.min_uses then
					return ''
				end
			end
		end
		
		if tooltype == 1 then
			local wear = item: get_wear()
			if (unbreakable and wear == 65534) or (overrides.consume and wear > 0 and not overrides.any_uses) or not overrides.any_uses and (65536 - wear) < math.ceil(65535 / uses) * ((overrides.take_uses or 1) - 1) then
				return ''
			end
		elseif tooltype == 2 then
			local meta = item: get_meta()
			local used = meta: get_int 'crafttools_consumable_used'
			
			if (overrides.consume and used > 0 and not overrides.any_uses) or not overrides.any_uses and uses - used < (overrides.take_uses or 1) then
				return ''
			end
		end
	end
end)

-- Convert CraftTools to normal item ingredients and record their overrides
local old_register_craft = core.register_craft
function core.register_craft (def)
	if def.type == 'shapeless' or def.type == 'shaped' or not def.type then
		local output = ItemStack(def.output): get_name()
		local inputs = {}
		
		if type(def.recipe) == 'table' then
			for i, entry in ipairs(def.recipe) do
				if type(entry) == 'table' then
					local metatable = getmetatable(entry)
					if metatable and metatable == CraftTool_meta then
						inputs[ItemStack(entry.item): get_name()] = {}
						inputs[ItemStack(entry.item): get_name()][output] = entry.overrides
						
						def.recipe[i] = entry.item
					else
						for j, _entry in ipairs(entry) do
							local metatable = getmetatable(_entry)
							if metatable and metatable == CraftTool_meta then
								inputs[ItemStack(_entry.item): get_name()] = {}
								inputs[ItemStack(_entry.item): get_name()][output] = _entry.overrides
								
								def.recipe[i][j] = _entry.item
							end
						end
					end
				end
			end
		end
		
		for k, v in pairs(inputs) do
			if k: sub(1, 6) == 'group:' then
				local k = k: sub(7, -1)
				crafttools.craft_behaviour_group_overrides[k] = crafttools.craft_behaviour_group_overrides[k] and merge(crafttools.craft_behaviour_group_overrides[k], v) or v
			else
				crafttools.craft_behaviour_overrides[k] = crafttools.craft_behaviour_overrides[k] and merge(crafttools.craft_behaviour_overrides[k], v) or v
			end
		end
	end
	
	local success, msg = pcall(old_register_craft, def)
	
	if not success then
		error(msg, 2)
	end
end

function crafttools.register_tool (name, uses, def)
	def.description = (def.description or '') .. '\n' .. craft_tool_description
	def.wear_color = def.wear_color or tool_wear_color
	def.groups = def.groups or {}
	def.groups.crafttools_tool_type = 1
	def.groups.crafttools_tool_uses = uses
	if def.wear_represents ~= nil or uses == 0 then def.groups.crafttools_tool_unbreakable = 1 end
	def.groups.disable_repair = 1
	
	core.register_tool(':' .. name, def)
end

function crafttools.register_consumable (name, uses, def)
	def.description = (def.description or '') .. '\n' .. consumable_description
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
		meta: set_int('count_alignment', 5)
		meta: set_string('count_meta', core.colorize('#00ea08', uses .. '/' .. uses))
	end
	
	return item
end)