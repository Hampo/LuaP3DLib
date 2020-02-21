if P3D == nil then Alert("P3D Functions loaded with no P3D table present.") end
local P3D = P3D
function MakeModelSolid(Original, Path)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Dyna_Phys) do
		local DynaPhysChunk = P3D.DynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
		DynaPhysChunk.ChunkType = P3D.Identifiers.Inst_Stat_Phys
		if (not Settings.L6Z4Glass or not Path:match("l6z4")) and (not Settings.L5R2Glass or not Path:match("l5r2")) and (not Settings.L4Z4Glass or not Path:match("l4z4")) then
			for idx2 in DynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Physics_Object) do
				DynaPhysChunk:RemoveChunkAtIndex(idx2)
			end
			for idx2 in DynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Collision_Effect) do
				local CollisionEffectChunk = P3D.CollisionEffectP3DChunk:new{Raw = DynaPhysChunk:GetChunkAtIndex(idx2)}
				CollisionEffectChunk.Classtype = 7
				DynaPhysChunk:SetChunkAtIndex(idx2, CollisionEffectChunk:Output())
			end
			RootChunk:SetChunkAtIndex(idx, DynaPhysChunk:Output())
			modified = true
		end
	end
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Anim_Dyna_Phys) do
		local AnimDynaPhysChunk = P3D.AnimDynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
		if AnimDynaPhysChunk.Name ~= "l1z6_powerbox_Shape\0" and (Settings.SolidCrates or not (AnimDynaPhysChunk.Name:match("crate") or AnimDynaPhysChunk.Name:match("vending"))) and (Settings.L4Z6Boards or not AnimDynaPhysChunk.Name = "l4_tunnelfence_Shape") then
			for idx2 in AnimDynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Anim_Obj_Wrapper) do
				local AnimObjWrapperChunk = P3D.AnimObjWrapperP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx2)}
				for idx3 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.State_Prop_Data_V1) do
					local StatePropDataV1Chunk = P3D.StatePropDataV1P3DChunk:new{Raw = AnimObjWrapperChunk:GetChunkAtIndex(idx3)}
					for idx4 in StatePropDataV1Chunk:GetChunkIndexes(P3D.Identifiers.State_Prop_State_Data_V1) do
						local StatePropStateDataV1Chunk = P3D.StatePropStateDataV1P3DChunk:new{Raw = StatePropDataV1Chunk:GetChunkAtIndex(idx4)}
						for idx5 in StatePropStateDataV1Chunk:GetChunkIndexes(P3D.Identifiers.State_Prop_Event_Data) do
							StatePropStateDataV1Chunk:RemoveChunkAtIndex(idx5)
						end
						StatePropDataV1Chunk:SetChunkAtIndex(idx4, StatePropStateDataV1Chunk:Output())
					end
					AnimObjWrapperChunk:SetChunkAtIndex(idx3, StatePropDataV1Chunk:Output())
				end
				AnimDynaPhysChunk:SetChunkAtIndex(idx2, AnimObjWrapperChunk:Output())
			end
			for idx2 in AnimDynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Collision_Effect) do
				local CollisionEffectChunk = P3D.CollisionEffectP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx2)}
				CollisionEffectChunk.Classtype = 7
				AnimDynaPhysChunk:SetChunkAtIndex(idx2, CollisionEffectChunk:Output())
			end
		end
		RootChunk:SetChunkAtIndex(idx, AnimDynaPhysChunk:Output())
		modified = true
	end
	if Settings.SolidWasps then
		for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.State_Prop_Data_V1) do
			local StatePropDataV1Chunk = P3D.StatePropDataV1P3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
			for idx2 in StatePropDataV1Chunk:GetChunkIndexes(P3D.Identifiers.State_Prop_State_Data_V1) do
				local StatePropStateDataV1Chunk = P3D.StatePropStateDataV1P3DChunk:new{Raw = StatePropDataV1Chunk:GetChunkAtIndex(idx2)}
				for idx3 in StatePropStateDataV1Chunk:GetChunkIndexes(P3D.Identifiers.State_Prop_Event_Data) do
					StatePropStateDataV1Chunk:RemoveChunkAtIndex(idx3)
				end
				StatePropDataV1Chunk:SetChunkAtIndex(idx2, StatePropStateDataV1Chunk:Output())
			end
			RootChunk:SetChunkAtIndex(idx, StatePropDataV1Chunk:Output())
			modified = true
		end
	end
	return RootChunk:Output(), modified
end