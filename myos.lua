local myos = {}

function myos.execute(cmd) 
	-- print("EXEC: " .. cmd)
	return os.execute('"' .. cmd .. '"') -- on windows, os.execute(cmd) = "cmd.exe /C " .. cmd
end

function myos.tempDir()
	return os.getenv("TEMP") or os.getenv("TEMPDIR") or "/tmp"
end

function myos.exists(name) 
	return os.rename(name, name)
end

function myos.fileExists(name) -- hacky!
	if type(name) ~= "string" then return false end
	local f = io.open(name, "r")
	if f~=nil then 
		io.close(f)
		return true
	else
		return false
	end
end

function myos.removeFile(name)
	if love.system.getOS() == "Windows" then
		myos.execute('del "' .. name:gsub("/", "\\") .. '" > NUL 2>&1')
	end
end

function myos.folderExists(name) -- hacky!
	return (myos.exists(name) and not myos.fileExists(name))
end

function myos.absolutePath(directory)
	if love.system.getOS() == "Windows" then
		local cmd = "cd /D " .. '"' .. directory:gsub("/", "\\") .. '" & chdir'
		return io.popen(cmd):read()
	else
		error("Directory listing not implemented for this operating system.")
	end	
end

function myos.recursiveListAllFilesInDirectory(directory) 
	local list = {}
	if love.system.getOS() == "Windows" then
		for name in io.popen("dir /A-D /B /S " .. '"' .. directory .. '"'):lines() do
			list[#list+1] = name
		end
	else
		error("Directory listing not implemented for this operating system.")
	end	
	return list
end

return myos