require "helpers"

local myos = require("myos")
local love2d = require("love2d")

function love.run()
	--local config = love2d.configFromLoveProject("T:/IT/fluglotse")
	--local destination = "test"
	--pack(config, destination)
	local files = love.filesystem.getDirectoryItems("../")
	for k, file in pairs(files) do
		print(k .. ". " .. file) --outputs something like "1. main.lua"
	end
end

function packWindows(config, destination) 
	destination = destination or "."
	destination = myos.absolutePath(destination)
	
	print("Packing .love archive...")
	local archive = love2d.compileLove(config, destination)
		
	local architectures = {"win32", "win64"}
	for i=1,#architectures do 
		local architecture = architectures[i]
		
		print("Acquiring love " .. config.version .. " " .. architecture .. "...")
		local lovefolder = love2d.getLove(config.version, architecture)
		
		print("Combining love.exe and .love archive...")
		local combined = love2d.combineLove(lovefolder .. "/love.exe", archive, myos.absolutePath(myos.tempDir()) .. "/" .. config.name .. ".exe")
		
		local abslovefolder = myos.absolutePath(lovefolder)
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
		myos.removeFile(zipfile)
		
		print("Compressing results to " .. zipfile .. "...")
		local zip, unzip = findZipTool()
		zip(zipfile, ".", zipped)
		
		myos.removeFile(combined)
	end
end

function pack(config, destination)
	local default = {
		path = ".",
		name = "Love2dProject",
		version = nil,
		exclude = {".git", ".gitignore"}
	}
	extendTable(default, config)
	config = default
	
	--config.exclude[#config.exclude+1] = "/media/sounds/samples/"
	config.exclude[#config.exclude+1] = "/editor/main.lua"
	config.exclude[#config.exclude+1] = "/editor/map1.png"
	config.exclude[#config.exclude+1] = "CGN_hires.psd"
	
	packWindows(config, destination)
end


