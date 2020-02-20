local Path = "/GameData/" .. GetPath()
for k,v in pairs(Cache) do
	if ComparePaths(k, Path, true, true) then
		
		Output(v)
		return
	end
end
if not PreLoad then
	local Original = ReadFile(Path)
	if ModifierType == 1 then
		Original = BrightenModel(Original, Modifier, false)
	elseif ModifierType == 2 then
		Original = BrightenModel(Original, Percentage, true)
	elseif ModifierType == 3 then
		Original = SetModelRGB(Original, Alpha, Red, Green, Blue)
	end
	Cache[Path] = Original
	Output(Original)
end