function execute(cmd) 
	return os.execute('"' .. cmd .. '"') -- on windows, os.execute(cmd) = "cmd.exe /C " .. cmd
end

function findZipTool()
	if detectOS() == "windows" then
		local programfiles = os.getenv("PROGRAMFILES"):gsub("\\", "/")
		
		local sevenzip = programfiles .. "/7-zip/7z.exe" 
		if fileExists(sevenzip) then
			return function(archive, files) 
				return (execute('"' .. sevenzip .. '"' .. " a -tzip -y -bd \"" .. archive .. "\" \"" .. table.concat(files, " ") .. "\"") == 0)
			end, function(archive, destination) 
				print('"' .. sevenzip .. '"' .. " e -y -bd -o\"" .. destination .. "\" \"" .. archive .. "\"")
				return (execute('"' .. sevenzip .. '"' .. " e -y -bd -o\"" .. destination .. "\" \"" .. archive .. "\"") == 0)
			end
		end
	end
	error("Could not find any zip utility.")
end

function curlGet(url, destination)
	return ( os.execute("curl --silent --insecure --location --output " .. destination .. " " .. url) == 0 ) -- "insecure" does not check SSL certificates
end

function detectOS()
	if os.getenv("WINDIR") then 
		return "windows" 
	elseif os.getenv("OSTYPE") == "linux" then
		return "linux"
	else
		return "unknown"
	end
end

function fileExists(name) -- hacky!
	if type(name) ~= "string" then return false end
	local f = io.open(name, "r")
	if f~=nil then 
		io.close(f)
		return true
	else
		return false
	end
end

function folderExists(name) -- hacky!
	return (os.rename(name, name) and not fileExists(name))
end

function extendTable(destination, source)
	for key, value in pairs(source) do
		destination[key] = value
	end
end

function tableToLua(object, tab, level)
	tab = tab or "\t"
	level = level or 1
	local retval = "{ \n"
	for key, value in pairs(object) do
		retval = retval .. string.rep(tab, level) .. key .. " = "
		if type(value) == "table" then
			retval = retval .. tableToLua(value, level+1)
		elseif type(value) == "string" then
			retval = retval .. "\"" .. value .. "\""
		else
			retval = retval .. tostring(value)
		end
		retval = retval .. ", \n"
	end
	retval = retval .. string.rep(tab, level-1) .. "}"
	return retval
end

