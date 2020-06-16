function ExistsInTbl(haystack, needle)
	for i=1,#haystack do
		if haystack[i] == needle then
			return true
		end
	end
	return false
end

Settings = GetSettings()
dofile(GetModPath() .. "/Resources/lib/P3D.lua")
dofile(GetModPath() .. "/Resources/lib/P3DFunctions.lua")
PreLoad = Settings.PreLoadData
Cache = {}
if Settings.ModSandbox and not EnvIsModSandbox then
	dofile(GetModPath() .. "/Resources/lib/ModSandbox.lua")
	MainModSandbox = ModSandbox.Sandbox:InitFromMainMod(true)
	IsSandbox = MainModSandbox ~= nil
end
if PreLoad then
	Alert("Pre-loading files. Please wait.")
	local files = {}
	local function GetFiles(tbl, dir, extensions)
		if dir:sub(-1) ~= "/" then dir = dir .. "/" end
		DirectoryGetEntries(dir, function(name, directory)
			if directory then
				if name:sub(-1) ~= "/" then name = name .. "/" end
				GetFiles(tbl, dir .. name, extensions)
			elseif extensions then
				for i = 1, #extensions do
					local extension = extensions[i]
					if GetFileExtension(name) == extension then
						tbl[#tbl + 1] = FixSlashes(dir .. name, false, true)
						break
					end
				end
			else
				tbl[#tbl + 1] = FixSlashes(dir .. name, false, true)
			end
			return true
		end)
	end
	local startTime = GetTime()
	GetFiles(files, "/GameData/art", {".p3d"})
	local filesN = #files
	local count = 0
	for i=1,filesN do
		local filePath = files[i]
		if ((filePath == "/GameData/art/cards.p3d" or filePath == "/GameData/art/wrench.p3d") and Settings.IncludeCards) or WildcardMatch(filePath, "/GameData/art/missions/level0?/level.p3d", true, true) or WildcardMatch(filePath, "/GameData/Art/l*", true, true) or WildcardMatch(filePath, "/GameData/art/nis/gags/*", true, true) or (WildcardMatch(filePath, "/GameData/art/cars/*", true, true) and Settings.IncludeCars) or (WildcardMatch(filePath, "/GameData/art/chars/*_m.p3d", true, true) and Settings.IncludeChars) or (WildcardMatch(filePath, "/GameData/art/frontend/scrooby/resource/pure3d/l?hudmap.p3d", true, true) and Settings.IncludeMinimap) or WildcardMatch(filePath, "/GameData/art/frontend/scrooby/resource/pure3d/camset*", true, true) then
			local file, modified
			if WildcardMatch(filePath, "/GameData/art/chars/*_m.p3d", true, true) then
				file, modified = MakeCharacterInvisible(ReadFile(filePath))
			else
				file, modified = MakeModelInvisible(ReadFile(filePath))
			end
			if modified then
				count = count + 1
				Cache[filePath] = file
			end
		end
		print("Processed file \"" .. GetFileName(filePath) .. "\" (" .. i .. "/" .. filesN .. ")")
	end
	local endTime = GetTime()
	Alert(count .. " files cached in " .. (endTime - startTime) .. " seconds.")
	print("Cached " .. count .. " files.")
end