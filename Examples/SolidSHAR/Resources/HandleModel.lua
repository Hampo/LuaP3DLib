local Path = "/GameData/" .. GetPath()
for k,v in pairs(Cache) do
	if ComparePaths(k, Path, true, true) then
		Output(v)
		return
	end
end
if not PreLoad then
	local Original = MakeModelSolid(ReadFile(Path), Path)
	Cache[Path] = Original
	Output(Original)
end