
crafttools = {
	VERSION = '010100',
	modpath = core.get_modpath 'crafttools',
	gettext = core.get_translator 'crafttools'
}

dofile(crafttools.modpath .. '/scripts/functionality.lua')
dofile(crafttools.modpath .. '/scripts/hand_tools.lua')
dofile(crafttools.modpath .. '/scripts/consumables.lua')
