if P3D == nil then Alert("P3D Functions loaded with no P3D table present.") end
local P3D = P3D
local LensFlare = IsHackLoaded("LensFlare")
local ROOT_CHUNKS = {P3D.Identifiers.Static_Entity, P3D.Identifiers.Inst_Stat_Phys, P3D.Identifiers.Dyna_Phys, P3D.Identifiers.Breakable_Object, P3D.Identifiers.World_Sphere, P3D.Identifiers.Inst_Stat_Entity}
function BrightenModel(Original, Amount, Percentage)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	for RootIdx, RootID in RootChunk:GetChunkIndexes(nil) do
		if ExistsInTbl(ROOT_CHUNKS, RootID) then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessRoot(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Mesh then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessMesh(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad_Group then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessOldBillboardQuadGroup(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessOldBillboardQuad(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Anim_Dyna_Phys then
			local AnimDynaPhysChunk = P3D.AnimDynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			for idx in AnimDynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Anim_Obj_Wrapper) do
				local AnimObjWrapperChunk = P3D.AnimObjWrapperP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx)}
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, BrightenModelProcessMesh(AnimObjWrapperChunk:GetChunkAtIndex(idx2), Amount, Percentage))
				end
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, BrightenModelProcessOldBillboardQuadGroup(AnimObjWrapperChunk:GetChunkAtIndex(idx2), Amount, Percentage))
				end
			end
			RootChunk:SetChunkAtIndex(RootIdx, AnimDynaPhysChunk:Output())
			modified = true
		elseif RootID == P3D.Identifiers.Light then
			local LightChunk = P3D.LightP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			local R, G, B = BrightenRGB(LightChunk.Colour.R, LightChunk.Colour.G, LightChunk.Colour.B, Amount, Percentage)
			LightChunk.Colour.R = R
			LightChunk.Colour.G = G
			LightChunk.Colour.B = B
			RootChunk:SetChunkAtIndex(RootIdx, LightChunk:Output())
			modified = true
		end
	end
	return RootChunk:Output(), modified
end
function BrightenModelProcessRoot(Original, Amount, Percentage)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
		RootChunk:SetChunkAtIndex(idx, BrightenModelProcessMesh(RootChunk:GetChunkAtIndex(idx), Amount, Percentage))
	end
	if LensFlare and RootChunk.ChunkType == P3D.Identifiers.World_Sphere then
		for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Lens_Flare) do
			local LensFlareChunk = P3D.LensFlareP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
				LensFlareChunk:SetChunkAtIndex(idx2, BrightenModelProcessOldBillboardQuadGroup(LensFlareChunk:GetChunkAtIndex(idx2), Amount, Percentage))
			end
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
				LensFlareChunk:SetChunkAtIndex(idx2, BrightenModelProcessMesh(LensFlareChunk:GetChunkAtIndex(idx2), Amount, Percentage))
			end
			RootChunk:SetChunkAtIndex(idx, LensFlareChunk:Output())
		end
	end
	return RootChunk:Output()
end
function BrightenModelProcessMesh(Original, Amount, Percentage)
	local MeshChunk = P3D.MeshP3DChunk:new{Raw = Original}
	for idx in MeshChunk:GetChunkIndexes(P3D.Identifiers.Old_Primitive_Group) do
		local OldPrimitiveGroupChunk = P3D.OldPrimitiveGroupP3DChunk:new{Raw = MeshChunk:GetChunkAtIndex(idx)}
		for idx2 in OldPrimitiveGroupChunk:GetChunkIndexes(P3D.Identifiers.Colour_List) do
			local ColourListChunk = P3D.ColourListP3DChunk:new{Raw = OldPrimitiveGroupChunk:GetChunkAtIndex(idx2)}
			for i=1,#ColourListChunk.Colours do
				local col = ColourListChunk.Colours[i]
				col.R, col.G, col.B = BrightenRGB(col.R, col.G, col.B, Amount, Percentage)
			end
			OldPrimitiveGroupChunk:SetChunkAtIndex(idx2, ColourListChunk:Output())
		end
		MeshChunk:SetChunkAtIndex(idx, OldPrimitiveGroupChunk:Output())
	end
	return MeshChunk:Output()
end
function BrightenModelProcessOldBillboardQuadGroup(Original, Amount, Percentage)
	local OldBillboardQuadGroupChunk = P3D.OldBillboardQuadGroupP3DChunk:new{Raw = Original}
	for idx in OldBillboardQuadGroupChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad) do
		OldBillboardQuadGroupChunk:SetChunkAtIndex(idx, BrightenModelProcessOldBillboardQuad(OldBillboardQuadGroupChunk:GetChunkAtIndex(idx), Amount, Percentage))
	end
	return OldBillboardQuadGroupChunk:Output()
end
function BrightenModelProcessOldBillboardQuad(Original, Amount, Percentage)
	local OldBillboardQuadChunk = P3D.OldBillboardQuadP3DChunk:new{Raw = Original}
	local R, G, B = BrightenRGB(OldBillboardQuadChunk.Colour.R, OldBillboardQuadChunk.Colour.G, OldBillboardQuadChunk.Colour.B, Amount, Percentage)
	OldBillboardQuadChunk.Colour.R = R
	OldBillboardQuadChunk.Colour.G = G
	OldBillboardQuadChunk.Colour.B = B
	return OldBillboardQuadChunk:Output()
end

function SetModelRGB(Original, A, R, G, B)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	for RootIdx, RootID in RootChunk:GetChunkIndexes(nil) do
		if ExistsInTbl(ROOT_CHUNKS, RootID) then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessRoot(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Mesh then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessMesh(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad_Group then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessOldBillboardQuadGroup(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessOldBillboardQuad(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Anim_Dyna_Phys then
			local AnimDynaPhysChunk = P3D.AnimDynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			for idx in AnimDynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Anim_Obj_Wrapper) do
				local AnimObjWrapperChunk = AnimObjWrapperP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx)}
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, SetModelRGBProcessMesh(AnimObjWrapperChunk:GetChunkAtIndex(idx2), A, R, G, B))
				end
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, SetModelRGBProcessOldBillboardQuadGroup(AnimObjWrapperChunk:GetChunkAtIndex(idx2), A, R, G, B))
				end
			end
			RootChunk:SetChunkAtIndex(RootIdx, AnimDynaPhysChunk:Output())
			modified = true
		elseif RootID == P3D.Identifiers.Light then
			local LightChunk = P3D.LightP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			LightChunk.Colour.A = A
			LightChunk.Colour.R = R
			LightChunk.Colour.G = G
			LightChunk.Colour.B = B
			RootChunk:SetChunkAtIndex(RootIdx, LightChunk:Output())
			modified = true
		end
	end
	return RootChunk:Output(), modified
end
function SetModelRGBProcessRoot(Original, A, R, G, B)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
		RootChunk:SetChunkAtIndex(idx, SetModelRGBProcessMesh(RootChunk:GetChunkAtIndex(idx), A, R, G, B))
	end
	if LensFlare and RootChunk.ChunkType == P3D.Identifiers.World_Sphere then
		for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Lens_Flare) do
			local LensFlareChunk = P3D.LensFlareP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
				LensFlareChunk:SetChunkAtIndex(idx2, SetModelRGBProcessOldBillboardQuadGroup(LensFlareChunk:GetChunkAtIndex(idx2), A, R, G, B))
			end
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
				LensFlareChunk:SetChunkAtIndex(idx2, SetModelRGBProcessMesh(LensFlareChunk:GetChunkAtIndex(idx2), A, R, G, B))
			end
			RootChunk:SetChunkAtIndex(idx, LensFlareChunk:Output())
		end
	end
	return RootChunk:Output()
end
function SetModelRGBProcessMesh(Original, A, R, G, B)
	local MeshChunk = P3D.MeshP3DChunk:new{Raw = Original}
	for idx in MeshChunk:GetChunkIndexes(P3D.Identifiers.Old_Primitive_Group) do
		local OldPrimitiveGroupChunk = OldPrimitiveGroupP3DChunk:new{Raw = MeshChunk:GetChunkAtIndex(idx)}
		for idx2 in OldPrimitiveGroupChunk:GetChunkIndexes(COLOUR_LIST_CHUNK) do
			local ColourListChunk = P3D.ColourListP3DChunk:new{Raw = OldPrimitiveGroupChunk:GetChunkAtIndex(idx2)}
			for i=1,#ColourListChunk.Colours do
				ColourListChunk.Colours[i].A = A
				ColourListChunk.Colours[i].R = R
				ColourListChunk.Colours[i].G = G
				ColourListChunk.Colours[i].B = B
			end
			OldPrimitiveGroupChunk:SetChunkAtIndex(idx2, ColourListChunk:Output())
		end
		MeshChunk:SetChunkAtIndex(idx, OldPrimitiveGroupChunk:Output())
	end
	return MeshChunk:Output()
end
function SetModelRGBProcessOldBillboardQuadGroup(Original, A, R, G, B)
	local OldBillboardQuadGroupChunk = P3D.OldBillboardQuadGroupP3DChunk:new{Raw = Original}
	for idx in OldBillboardQuadGroupChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad) do
		OldBillboardQuadGroupChunk:SetChunkAtIndex(idx, SetModelRGBProcessOldBillboardQuad(OldBillboardQuadGroupChunk:GetChunkAtIndex(idx), A, R, G, B))
	end
	return OldBillboardQuadGroupChunk:Output()
end
function SetModelRGBProcessOldBillboardQuad(Original, A, R, G, B)
	local OldBillboardQuadChunk = P3D.OldBillboardQuadP3DChunk:new{Raw = Original}
	OldBillboardQuadChunk.Colour.A = A
	OldBillboardQuadChunk.Colour.R = R
	OldBillboardQuadChunk.Colour.G = G
	OldBillboardQuadChunk.Colour.B = B
	return OldBillboardQuadChunk:Output()
end

local min = math.min
local max = math.max
local floor = math.floor
function BrightenRGB(r, g, b, Amount, Percentage)
	if Percentage then
		b = min(255, max(0, floor(b * Amount)))
		g = min(255, max(0, floor(g * Amount)))
		r = min(255, max(0, floor(r * Amount)))
	else
		b = min(255, max(0, b + Amount))
		g = min(255, max(0, g + Amount))
		r = min(255, max(0, r + Amount))
	end
	return r, g, b
end