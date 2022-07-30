if not Settings.ScaleChars then
	return
end

local ScaleMultiplier = Settings["L"..Level.."CharScaleMultiplier"]
if ScaleMultiplier <= 1 then
	return
end

local Path = GetPath()
local GamePath = GetGamePath(Path)
local MFKFile = ReadFile(GamePath)
local MFK = MFKLexer.Lexer:Parse(MFKFile)

local changed = false
for i=#MFK.Functions,1,-1 do
	local func = MFK.Functions[i]
	if func.Name:lower() == "addambientcharacter" then
		local rad = tonumber(func.Arguments[3])
		if rad and rad ~= 0 then
			rad = rad * ScaleMultiplier
			func.Arguments[3] = rad
			changed = true
		end
	elseif func.Name:lower() == "addpurchasecarreward" then
		local rad = tonumber(func.Arguments[5])
		if rad and rad ~= 0 then
			rad = rad * ScaleMultiplier
			func.Arguments[5] = rad
			changed = true
		end
	end
end

if changed then
	MFK:Output()
end