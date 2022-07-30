if SRR2 ~= nil then
	Output(SRR2)
	return
end

local Path = GetPath()
local GamePath = "/GameData/" .. Path

local P3DFile = P3D.P3DFile(GamePath)
local BibleChunk = P3DFile:GetChunk(P3D.Identifiers.Frontend_Text_Bible)
if not BibleChunk then return end

local lang
if GetGameLanguage then
	lang = GetGameLanguage()
end

for chunk in BibleChunk:GetChunks(P3D.Identifiers.Frontend_Language) do
	if lang == nil or chunk.Language == lang then
		for i=1,#Quotes do
			chunk:AddValue("Quote" .. i, Quotes[i])
		end
	end
end

SRR2 = tostring(P3DFile)
Output(SRR2)