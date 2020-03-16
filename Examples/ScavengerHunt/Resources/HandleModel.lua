local Path = "/GameData/" .. FixSlashes(GetPath(), false, true)
if Settings.SeedMode >= 2 then
	if Cache[Path] then Output(Cache[Path]) end
else
	local modified, output = SetLocators(Path)
	if modified then Output(output) end
end