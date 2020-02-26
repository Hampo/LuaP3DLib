local Path = GetPath()
if WildcardMatch(Path, "art/l*.p3d", true, true) then
	dofile(GetModPath() .. "/Resources/HandleModel.lua")
elseif WildcardMatch(Path, "scripts/missions/level0?/m?sdi.mfk", true, true) then
	dofile(GetModPath() .. "/Resources/HandleSundayDrive.lua")
elseif IsSandbox and GetFileExtension(Path) ~= ".rcf" then
	local output = MainModSandbox:SimulatePathHandler("/GameData/" .. Path, true)
	if output then Output(output) end
end