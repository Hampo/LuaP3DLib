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
CoinMesh = {"coinShape_000", "coinShape_000", "coinShape_000", "coinShape_000", "coinShape_000", "coinShape_000", "coinShape_000"}
if AreChainedPathHandlersEnabled and AreChainedPathHandlersEnabled() then
	for i=1,7 do
		local loadStatus, levelLoad = pcall(ReadFile, "/GameData/scripts/missions/level0" .. i .. "/level.mfk")
		if loadStatus and levelLoad then
			local initStatus, levelInit = pcall(ReadFile, "/GameData/scripts/missions/level0" .. i .. "/leveli.mfk")
			if initStatus and levelInit then
				local mesh = levelInit:match("SetCoinDrawable%s*%(%s*\"(.-)\"")
				if mesh then
					CoinMesh[i] = mesh
				end
			end
		end
	end
elseif Settings.ModSandbox and not EnvIsModSandbox then
	dofile(GetModPath() .. "/Resources/lib/ModSandbox.lua")
	MainModSandbox = ModSandbox.Sandbox:InitFromMainMod(true)
	IsSandbox = MainModSandbox ~= nil
	if IsSandbox then
		for i=1,7 do
		local load, init = MainModSandbox:SimulateLevel(i)
		local mesh = init:match("SetCoinDrawable%s*%(%s*\"(.-)\"")
			if mesh then
				CoinMesh[i] = mesh
			end
		end
	end
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
		if WildcardMatch(filePath, "/GameData/Art/l*", true, true) then
			local file, modified = MakeModelSolid(ReadFile(filePath), filePath)
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
if GetLauncherVersion then
	local function GetVersionParts(Version)
		local tbl = {}
		for part in Version:gmatch("[^%.]+") do
		   tbl[#tbl + 1] = tonumber(part)
		end
		return tbl
	end
	local function CompareVersion(Version1, Version2)
		local Part1, Part2
		for i=1, math.max(#Version1, #Version2) do
			Part1 = Version1[i] or 0
			Part2 = Version2[i] or 0
			
			if Part1 < Part2 then return -1 end
			if Part1 > Part2 then return 1 end
		end
		return 0
	end
	IsOldVersion = CompareVersion(GetVersionParts(GetLauncherVersion()), {1, 23, 10}) < 0
else
	IsOldVersion = true
end
print((Settings.SolidCoinsForceOld or IsOldVersion) and "Using one Anim Coll for coins" or "Using multiple Anim Colls for coins")