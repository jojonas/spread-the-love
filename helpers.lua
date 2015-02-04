require "myos"

function findZipTool()
	if detectOS() == "windows" then
		local programfiles = os.getenv("PROGRAMFILES"):gsub("\\", "/")
		
		local sevenzip = programfiles .. "/7-zip/7z.exe" 
		if fileExists(sevenzip) then
			return function(archive, root, files) 
				return (execute('cd "' .. root .. '" & "' .. sevenzip .. '"' .. " a -ssc -tzip -y -bd \"" .. archive .. "\" \"" .. table.concat(files, '" "') .. "\" > NUL") == 0)
			end, function(archive, destination) 
				return (execute('"' .. sevenzip .. '"' .. " e -y -bd -o\"" .. destination .. "\" \"" .. archive .. "\" > NUL") == 0)
			end
		end
	end
	error("Could not find any zip utility.")
end

function curlGet(url, destination)
	return ( os.execute("curl --silent --insecure --location --output " .. destination .. " " .. url) == 0 ) -- "insecure" does not check SSL certificates
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

function filterDirectory(directory, exclude)
	local results = {}
	
	local absroot = absolutePath(directory)
	local list = recursiveListAllFilesInDirectory(directory)
	for i=1,#list do
		local name = list[i]:gsub("\\", "/")
		local relative = name:sub(absroot:len()+1)
		
		local add = true
		for j=1,#exclude do 
			local item = exclude[j]
			if item:sub(1,1) == "/" then
				local pattern = relative:sub(0, item:len())
				if pattern == item then
					add = false
					break
				end
			end
		end
		for part in string.gmatch(relative, "[^/]+") do
			if not add then break end
			for j=1,#exclude do 
				if part == exclude[j] then
					add = false
					break
				end
			end
		end
		
		if add then
			results[#results+1] = relative:sub(2)
		end
	end
	return results
end
