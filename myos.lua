function execute(cmd) 
	-- print("EXEC: " .. cmd)
	return os.execute('"' .. cmd .. '"') -- on windows, os.execute(cmd) = "cmd.exe /C " .. cmd
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

function tempDir()
	return os.getenv("TEMP") or os.getenv("TEMPDIR") or "/tmp"
end

function exists(name) 
	return os.rename(name, name)
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

function removeFile(name)
	if detectOS() == "windows" then
		execute('del "' .. name:gsub("/", "\\") .. '" > NUL 2>&1')
	end
end

function folderExists(name) -- hacky!
	return (exists(name) and not fileExists(name))
end

function absolutePath(directory)
	if detectOS() == "windows" then
		local cmd = "cd /D " .. '"' .. directory:gsub("/", "\\") .. '" & chdir'
		return io.popen(cmd):read()
	else
		error("Directory listing not implemented for this operating system.")
	end	
end

function recursiveListAllFilesInDirectory(directory) 
	local list = {}
	if detectOS() == "windows" then
		for name in io.popen("dir /A-D /B /S " .. '"' .. directory .. '"'):lines() do
			list[#list+1] = name
		end
	else
		error("Directory listing not implemented for this operating system.")
	end	
	return list
end