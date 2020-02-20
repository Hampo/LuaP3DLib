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
ModifierType = Settings.ModifierType
if ModifierType == 1 then
	Modifier = Settings.ModifyAmount
	if Modifier > 2147483647 then
		Modifier = Modifier - 4294967296
	end
	print("Using modifier: " .. Modifier)
elseif ModifierType == 2 then
	Percentage = Settings.PercentageAmount / 100
	print("Using percentage: " .. Settings.PercentageAmount .. "%")
elseif ModifierType == 3 then
	local Value = Settings.FixedColour
	Alpha = Value >> 24
	Red = (Value >> 16) & 0xFF
	Green = (Value >> 8) & 0xFF
	Blue = Value & 0xFF
	print("Using ARGB: " .. Alpha .. "," .. Red .. "," .. Green .. "," .. Blue)
end
PreLoad = Settings.PreLoadData
Cache = {}
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
		if WildcardMatch(filePath, "/GameData/Art/l*", true, true) or WildcardMatch(filePath, "/GameData/art/nis/gags/*", true, true) or WildcardMatch(filePath, "/GameData/art/frontend/scrooby/resource/pure3d/camset*", true, true) then
			local file, modified
			if ModifierType == 1 then
				file, modified = BrightenModel(ReadFile(filePath), Modifier, false)
			elseif ModifierType == 2 then
				file, modified = BrightenModel(ReadFile(filePath), Percentage, true)
			elseif ModifierType == 3 then
				file, modified = SetModelRGB(ReadFile(filePath), Alpha, Red, Green, Blue)
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