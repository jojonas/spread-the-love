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
end

