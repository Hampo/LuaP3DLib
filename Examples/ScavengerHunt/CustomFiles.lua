Settings = GetSettings()
local BaseDigits = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz!\"$%^&*()=+[]{}'#@~\\/?<>"
function basetonumber(value)
	local result = 0
	local b = BaseDigits:len()
	local valueLen = value:len()
	for i=1,valueLen do
		local c = value:sub(i, i)
		result = result * b
		local idx = BaseDigits:find(c, 1, true)
		if idx == nil then return nil end
		result = result + idx - 1
	end
	return result
end
function tobasestring(n)
	local b = BaseDigits:len()
	local t = {}
	repeat
		local d = (n % b) + 1
		n = n // b
		table.insert(t, 1, BaseDigits:sub(d,d))
	until n == 0
	return table.concat(t)
end
if Settings.SeedMode == 3 then
	print("Fixed seed input: " .. Settings.Seed)
	Seed = basetonumber(Settings.Seed)
	if Seed == nil then
		Settings.FixedSeed = false
		Alert("Invalid seed specified. Reverting to random seed.")
	end
end
if Settings.SeedMode >= 2 then
	Seed = Seed or math.random(math.maxinteger)
	math.randomseed(Seed)
	print("Scavenger Hunt using seed: " .. (Settings.FixedSeed and Settings.Seed or tobasestring(Seed)) .. " (" .. Seed .. ")")
end
Cache = {}
dofile(GetModPath() .. "/Resources/lib/P3D.lua")
dofile(GetModPath() .. "/Resources/lib/P3DFunctions.lua")
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
RoadPositions = {}
for i=1,7 do
	GetRoads(RoadPositions, i)
	local tbl = RoadPositions["L" .. i]
	local total = 0
	for j=1,#tbl do
		local road = tbl[j]
		total = total + road.Length
	end
	RoadPositions["L" .. i .. "Total"] = total
end
local endTime = GetTime()
print("Found " .. #RoadPositions.L1 .. " L1, " .. #RoadPositions.L2 .. " L2, " .. #RoadPositions.L3 .. " L3, " .. #RoadPositions.L4 .. " L4, " .. #RoadPositions.L5 .. " L5, " .. #RoadPositions.L6 .. " L6, " .. #RoadPositions.L7 .. " L7 in " .. (endTime - startTime) * 1000 .. "ms")

if Settings.SeedMode >= 2 then
	local FilePaths = {}
	local CustomFiles = ReadFile(GetModPath() .. "/CustomFiles.ini")
	local IsPathHandler = false
	for line in CustomFiles:gmatch("[^%s]+") do
		local first = line:sub(1, 1)
		if first ~= "#" and first ~= ";" then
			if first == "[" then
				IsPathHandler = line:sub(1, 14):lower() == "[pathhandlers]"
			elseif IsPathHandler then
				local Path, Handler = line:match("([^=]+)=([^=]+)")
				if Handler == "Resources/HandleModel.lua" then FilePaths[#FilePaths + 1] = "/GameData/" .. Path end
			end
		end
	end
	local startTime = GetTime()
	GetFiles(files, "/GameData/art", {".p3d"})
	table.sort(files)
	local filesN = #files
	local count = 0
	for i=1,filesN do
		local filePath = files[i]
		for i=1,#FilePaths do
			if WildcardMatch(filePath, FilePaths[i], true, true) then
				local modified, output = SetLocators(filePath)
				if modified then Cache[filePath] = output end
				break
			end
		end
		print("Processed file \"" .. GetFileName(filePath) .. "\" (" .. i .. "/" .. filesN .. ")")
	end
	local endTime = GetTime()
	print("Set locators in " .. (endTime - startTime) * 1000 .. "ms")
end