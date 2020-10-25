return {
	LrSdkVersion = 3.0,
	LrToolkitIdentifier = 'net.chibiegg.lightroom.socketsample',
	LrPluginName = "Lightroom Socket Sample",
	VERSION = { major=0, minor=1, revision=0, build="initial", },

	-- Add the menu item to the Library menu.
	
	LrLibraryMenuItems = {
	    {
		    title = LOC "$$$/SocketSample/CustomDialog=Socket Sample Custom Dialog",
		    file = "ShowCustomDialog.lua",
		},
	},
}
