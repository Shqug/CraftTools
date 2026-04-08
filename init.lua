
crafttools = {
	VERSION = '020000',
	modpath = core.get_modpath 'crafttools',
	gettext = core.get_translator 'crafttools'
}

dofile(crafttools.modpath .. '/scripts/functionality.lua')

if core.settings: get_bool ('crafttools.enable_items', true) then
	if core.settings: get_bool ('crafttools.enable_hand_tools', true) then
		dofile(crafttools.modpath .. '/scripts/hand_tools.lua')
	end
	
	if core.settings: get_bool ('crafttools.enable_consumables', true) then
		dofile(crafttools.modpath .. '/scripts/consumables.lua')
	end
	
	if core.settings: get_bool ('crafttools.enable_repair_kit', false) then
		dofile(crafttools.modpath .. '/scripts/repair_kit.lua')
	end
end