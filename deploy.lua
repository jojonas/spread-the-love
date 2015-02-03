require "helpers"
require "love"

function pack(config)
	local default = {
		path = ".",
		name = "Love2dProject",
		version = nil
	}
	extendTable(default, config)
	config = default
	
	local zip, unzip = findZipTool()
	
	zip("test.love", config.path)
	
	--getLove(config.version, "win64")
	--getLove(config.version, "win32")
end


local config = configFromLoveProject("T:/IT/GGJ2015/ggj2015")
pack(config)

