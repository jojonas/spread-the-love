require "helpers"
require "love"

function packWindows(config, destination) 
	destination = destination or "."
	destination = absolutePath(destination)
	
	print("Packing .love archive...")
	local archive = compileLove(config, destination)
		
	local architectures = {"win32", "win64"}
	for i=1,#architectures do 
		local architecture = architectures[i]
		
		print("Acquiring love " .. architecture .. "...")
		local lovefolder = getLove(config.version, architecture)
		
		print("Combining love.exe and .love archive...")
		local combined = combineLove(lovefolder .. "/love.exe", archive, absolutePath(tempDir()) .. "/" .. config.name .. ".exe")
		
		local abslovefolder = absolutePath(lovefolder)
		local zipped = {combined, 
				abslovefolder .. "/SDL2.dll", 
				abslovefolder .. "/OpenAL32.dll", 
				abslovefolder .. "/license.txt",
				abslovefolder .. "/DevIL.dll", 
				abslovefolder .. "/love.dll", 
				abslovefolder .. "/lua51.dll", 
				abslovefolder .. "/mpg123.dll", 
				abslovefolder .. "/msvcp110.dll", 
				abslovefolder .. "/msvcr110.dll"
			}
		
		
		local zipfile = destination .. "/" .. config.name .. "-" .. architecture .. ".zip"
		removeFile(zipfile)
		
		print("Compressing results to " .. zipfile .. "...")
		local zip, unzip = findZipTool()
		zip(zipfile, ".", zipped)
		
		removeFile(combined)
	end
end

function pack(config)
	local default = {
		path = ".",
		name = "Love2dProject",
		version = nil,
		exclude = {".git", ".gitignore"}
	}
	extendTable(default, config)
	config = default
	
	config.exclude[#config.exclude+1] = "/media/sounds/samples/"
	
	packWindows(config, "test")

	
	--getLove(config.version, "win64")
	--getLove(config.version, "win32")
	--local list = filterDirectory(config.path, {".git", ".gitignore", "/media/sounds/samples"})
	--for i=1,#list do
	--	print(list[i])
	--end
end


local config = configFromLoveProject("T:/IT/GGJ2015/ggj2015")
pack(config)

