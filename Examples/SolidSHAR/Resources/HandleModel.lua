local Path = "/GameData/" .. GetPath()
if PreLoad or not Settings.NoCache then
	for k,v in pairs(Cache) do
		if ComparePaths(k, Path, true, true) then
			Output(v)
			return
		end
	end
end
if not PreLoad then
	local Original = MakeModelSolid(ReadFile(Path), Path)
	if not Settings.NoCache then Cache[Path] = Original end
	Output(Original)
end