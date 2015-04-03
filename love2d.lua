require "helpers"

local myos = require("myos")
local love2d = {}
	
function love2d.configFromLoveProject(path)
	local love_backup = love
	love = {}
	dofile(path .. "/conf.lua")
	local loveConfig = {window={}, modules={}}
	love.conf(loveConfig)
	love = love_backup
	return {
		path = path, 
		name = loveConfig.identity,
		version = loveConfig.version
	}
end

function love2d.getLove(version, environment)
	local destination = "love-binaries/love-" .. version .. "-" .. environment
	if not myos.folderExists(destination) then
		local filename = "love-binaries/love-" .. version .. "-" .. environment .. ".zip"
		if not myos.fileExists(filename) then
			local url = "https://bitbucket.org/rude/love/downloads/love-" .. version .. "-" .. environment .. ".zip"
			local result = httpGet(url, filename)
			if not result then 
				error("Could not download " .. url)	
			end
		end
		
		local zip, unzip = findZipTool()
		unzip(filename, destination)
	end
	return destination
end

function love2d.compileLove(config, destination)
	local zip, unzip = findZipTool()
	local files = filterDirectory(config.path, config.exclude)	
	destination = myos.absolutePath(destination) .. "/" .. config.name .. ".love"
	myos.removeFile(destination)
	zip(destination, config.path, files)
	return destination
end

function love2d.combineLove(executable, archive, destination) 
	local os = love.system.getOS()
	if os == "Windows" then
		myos.execute('copy /b "' .. executable:gsub("/", "\\") .. '"+"' .. archive:gsub("/", "\\") .. '" "' .. destination:gsub("/", "\\") .. '" > NUL')
	elseif os == "Linux" then
		myos.execute('cat "' .. executable .. '" "' .. archive .. '" > "' .. destination .. '" > /dev/null')
	else
		error("Cannot combine on this operating system.")
	end
	return destination
end

return love2d