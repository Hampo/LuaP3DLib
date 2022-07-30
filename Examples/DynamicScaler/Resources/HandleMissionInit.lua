if not Settings.ScaleChars then
	return
end

local Path = GetPath()
local GamePath = GetGamePath(Path)
local MFKFile = ReadFile(GamePath)
local MFK = MFKLexer.Lexer:Parse(MFKFile)
local ScaleMultiplier = Settings["L"..Level.."CharScaleMultiplier"]

local changed = false
for i=#MFK.Functions,1,-1 do
	local func = MFK.Functions[i]
	if func.Name:lower() == "settalktotarget" then
		local yOffset = func.Arguments[3] and tonumber(func.Arguments[3]) or 0
		yOffset = yOffset * ScaleMultiplier + 1.7 * (ScaleMultiplier - 1)
		func.Arguments[3] = yOffset
		
		if ScaleMultiplier > 1 then
			local trigRad = func.Arguments[4] and tonumber(func.Arguments[4]) or 1.3
			trigRad = trigRad * ScaleMultiplier
			func.Arguments[4] = trigRad
		end
		
		changed = true
	end
end

if changed then
	MFK:Output()
end