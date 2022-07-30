local Path = GetPath()
Level = tonumber(Path:match("level0(%d)"))
local MFK

if Settings.ScaleChars and Settings["L"..Level.."CharScaleMultiplier"] > 1 then
	MFK = MFK or MFKLexer.Lexer:Parse(ReadFile(GetGamePath(Path)))
	MFK:AddFunction("LoadP3DFile", {"art\\missions\\level01\\walkercam.p3d"})
end

if Settings.ScaleProps then
	MFK = MFK or MFKLexer.Lexer:Parse(ReadFile(GetGamePath(Path)))
	MFK:AddFunction("LoadP3DFile", {"art\\missions\\level01\\cards.p3d"})
end

if MFK then
	MFK:Output()
end