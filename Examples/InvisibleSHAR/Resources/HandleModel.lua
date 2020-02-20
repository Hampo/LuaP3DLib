local Path = "/GameData/" .. GetPath()
if WildcardMatch(Path, "/GameData/art/chars/*_m.p3d", true, true) and not Settings.IncludeChars then return end
if WildcardMatch(Path, "/GameData/art/cars/*", true, true) and not Settings.IncludeCars then return end
if WildcardMatch(Path, "/GameData/art/frontend/scrooby/resource/pure3d/l?hudmap.p3d", true, true) and not Settings.IncludeMinimap then return end
for k,v in pairs(Cache) do
	if ComparePaths(k, Path, true, true) then
		Output(v)
		return
	end
end
if not PreLoad then
	local Original = ReadFile(Path)
	if WildcardMatch(Path, "/GameData/art/chars/*_m.p3d", true, true) then
		Original = MakeCharacterInvisible(Original)
	else
		Original = MakeModelInvisible(Original)
	end
	Cache[Path] = Original
	Output(Original)
end