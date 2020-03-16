if Settings.SeedMode == 1 then return end
local Path = "/GameData/" .. GetPath()

-- The game reads the SRR2 4 times at the start for some bizarre reason
-- Only shuffle things once just in case
if Cache.SRR2 ~= nil then
	Output(Cache.SRR2)
	return
end

local Value = "Scavenger Hunt Version: " .. GetModVersion() .. "\nLauncher Version: " .. GetLauncherVersion() .. "\nSeed: " .. (Settings.FixedSeed and Settings.Seed or tobasestring(Seed))

local Chunk = P3D.P3DChunk:new{Raw = ReadFile(Path)}
local BibleIdx = Chunk:GetChunkIndex(P3D.Identifiers.Frontend_Text_Bible)
if not BibleIdx then return end
local BibleChunk = P3D.FrontendTextBibleP3DChunk:new{Raw = Chunk:GetChunkAtIndex(BibleIdx)}
for idx in BibleChunk:GetChunkIndexes(P3D.Identifiers.Frontend_Language) do
	local LanguageChunk = P3D.FrontendLanguageP3DChunk:new{Raw = BibleChunk:GetChunkAtIndex(idx)}
	LanguageChunk:AddValue("ScavengerHunt", Value)
	BibleChunk:SetChunkAtIndex(idx, LanguageChunk:Output())
end
Chunk:SetChunkAtIndex(BibleIdx, BibleChunk:Output())
Cache.SRR2 = Chunk:Output()
Output(Cache.SRR2)