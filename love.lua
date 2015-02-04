require "helpers"

love = {} 
	
function configFromLoveProject(path)
	dofile(path .. "/conf.lua")
	local loveConfig = {window={}, modules={}}
	love.conf(loveConfig)
	return {
		path = path, 
		name = loveConfig.identity,
		version = loveConfig.version
	}
end

function getLove(version, environment)
	local destination = "love-binaries/love-" .. version .. "-" .. environment
	if not folderExists(destination) then
		local filename = "love-binaries/love-" .. version .. "-" .. environment .. ".zip"
		if not fileExists(filename) then
			local url = "https://bitbucket.org/rude/love/downloads/love-" .. version .. "-" .. environment .. ".zip"
			local result = curlGet(url, filename)
			if not result then 
				error("Could not download " .. url)	
			end
		end
		
		local zip, unzip = findZipTool()
		unzip(filename, destination)
	end
	return destination
end

function compileLove(config, destination)
	local zip, unzip = findZipTool()
	local files = filterDirectory(config.path, config.exclude)	
	destination = absolutePath(destination) .. "/" .. config.name .. ".love"
	removeFile(destination)
	zip(destination, config.path, files)
	return destination
end

function combineLove(executable, archive, destination) 
	local os = detectOS()
	if os == "windows" then
		execute('copy /b "' .. executable:gsub("/", "\\") .. '"+"' .. archive:gsub("/", "\\") .. '" "' .. destination:gsub("/", "\\") .. '" > NUL')
	elseif os == "linux" then
		execute('cat "' .. executable .. '" "' .. archive .. '" > "' .. destination .. '" > /dev/null')
	else
		error("Cannot combine on this operating system.")
	end
	return destination
end
