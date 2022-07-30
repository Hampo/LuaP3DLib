local Path = GetPath()
local GamePath = "/GameData/" .. Path

local P3DFile = P3D.P3DFile(GamePath)

local ProjectChunk = P3DFile:GetChunk(P3D.Identifiers.Frontend_Project)
local PageChunk
for chunk in ProjectChunk:GetChunks(P3D.Identifiers.Frontend_Page) do
	if chunk.Name == "TVFrame.pag" then
		PageChunk = chunk
		break
	end
end

if PageChunk then
	local TextStyleChunk = P3D.FrontendTextStyleResourceP3DChunk:new("font1_14", 1, "fonts\\font1_14.p3d", "Tt2001m__14")
	PageChunk:AddChunk(TextStyleChunk, 1)
	
	local LayerChunk = PageChunk:GetChunk(P3D.Identifiers.Frontend_Layer)
	local Quote = math.random(#Quotes)
	print("Using quote ID: " .. Quote)
	local MultiTextChunk = P3D.FrontendMultiTextP3DChunk:new("Quote"..Quote, 17, {X = 220, Y = 75}, {X = 200, Y = 18}, {X = P3D.FrontendMultiTextP3DChunk.Justifications.Centre, Y = P3D.FrontendMultiTextP3DChunk.Justifications.Top}, {A=255,R=255,G=255,B=255}, 0, 0, "font1_14", 1, {A=192,R=0,G=0,B=0}, {X = 2, Y = -2}, 0)
	local TextChunk = P3D.FrontendStringTextBibleP3DChunk:new("srr2", "Quote"..Quote)
	MultiTextChunk:AddChunk(TextChunk)
	LayerChunk:AddChunk(MultiTextChunk)
	
	P3DFile:Output()
end