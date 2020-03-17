if Settings.SeedMode == 1 then return end
local Path = "/GameData/" .. GetPath()

if Cache.Ingame then
	Output(Cache.Ingame)
	return
end

local Chunk = P3D.P3DChunk:new{Raw = ReadFile(Path)}
local ProjectIDX = Chunk:GetChunkIndex(P3D.Identifiers.Frontend_Project)
local ProjectChunk = P3D.FrontendProjectP3DChunk:new{Raw = Chunk:GetChunkAtIndex(ProjectIDX)}
local PageIDX = nil
local PageChunk = nil
for idx in ProjectChunk:GetChunkIndexes(P3D.Identifiers.Frontend_Page) do
	PageChunk = P3D.FrontendPageP3DChunk:new{Raw = ProjectChunk:GetChunkAtIndex(idx)}
	if P3D.CleanP3DString(PageChunk.Name) == "Pause.pag" then
		PageIDX = idx
		break
	end
end
if PageIDX then
	local LayerIDX = PageChunk:GetChunkIndex(P3D.Identifiers.Frontend_Layer)
	local LayerChunk = P3D.FrontendLayerP3DChunk:new{Raw = PageChunk:GetChunkAtIndex(LayerIDX)}
	local MultiTextChunkIDX = LayerChunk:GetChunkIndex(P3D.Identifiers.Frontend_Multi_Text)
	local MultiTextChunk = P3D.FrontendMultiTextP3DChunk:new{Raw = LayerChunk:GetChunkAtIndex(MultiTextChunkIDX)}
	MultiTextChunk.PositionY = 450
	local StringChunkIDX = MultiTextChunk:GetChunkIndex(P3D.Identifiers.Frontend_String_Text_Bible)
	local StringChunk = P3D.FrontendStringTextBibleP3DChunk:new{Raw = MultiTextChunk:GetChunkAtIndex(StringChunkIDX)}
	StringChunk.StringId = P3D.MakeP3DString("ScavengerSeed")
	MultiTextChunk:SetChunkAtIndex(StringChunkIDX, StringChunk:Output())
	LayerChunk:SetChunkAtIndex(MultiTextChunkIDX, MultiTextChunk:Output())
	PageChunk:SetChunkAtIndex(LayerIDX, LayerChunk:Output())
	ProjectChunk:SetChunkAtIndex(PageIDX, PageChunk:Output())
	Chunk:SetChunkAtIndex(ProjectIDX, ProjectChunk:Output())
	Cache.Ingame = Chunk:Output()
	Output(Cache.Ingame)
end