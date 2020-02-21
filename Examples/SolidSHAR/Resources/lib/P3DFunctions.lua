if P3D == nil then Alert("P3D Functions loaded with no P3D table present.") end
local P3D = P3D

local WrenchAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/WrenchAnimColl.p3d")}
local WrenchAnimCollAnimationIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local WrenchAnimCollSkeletonIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local WrenchAnimCollAnimCollIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

local PhoneAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/PhoneAnimColl.p3d")}
local PhoneAnimCollAnimationIDX = PhoneAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local PhoneAnimCollSkeletonIDX = PhoneAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local PhoneAnimCollAnimCollIDX = PhoneAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

function MakeModelSolid(Original, Path)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	local AddedWrenchAnimation = false
	local AddedPhoneAnimation = false
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Locator) do
		local LocatorChunk = P3D.LocatorP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
		if LocatorChunk.Type == 9 then
			local Type = LocatorChunk:GetType9Data()
			if Type == "SummonVehiclePhone" then
				if not AddedPhoneAnimation then
					RootChunk:AddChunk(PhoneAnimCollP3D:GetChunkAtIndex(PhoneAnimCollAnimationIDX))
					AddedPhoneAnimation = true
				end
				local skel = P3D.SkeletonP3DChunk:new{Raw = PhoneAnimCollP3D:GetChunkAtIndex(PhoneAnimCollSkeletonIDX)}
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. P3D.CleanP3DString(LocatorChunk.Name))
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				skelJoint.RestPose.M41 = LocatorChunk.Position.X
				skelJoint.RestPose.M42 = LocatorChunk.Position.Y - 1
				skelJoint.RestPose.M43 = LocatorChunk.Position.Z
				skel:SetChunkAtIndex(1, skelJoint:Output())
				
				local animColl = P3D.AnimCollP3DChunk:new{Raw = PhoneAnimCollP3D:GetChunkAtIndex(PhoneAnimCollAnimCollIDX)}
				animColl.Name = P3D.MakeP3DString(P3D.CleanP3DString(animColl.Name).. P3D.CleanP3DString(LocatorChunk.Name))
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
					local OldFrameController = P3D.OldFrameControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					OldFrameController.Name = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.Name).. P3D.CleanP3DString(LocatorChunk.Name))
					if OldFrameController.Name:sub(1, 4) == "PTRN" then
						OldFrameController.HierarchyName = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.HierarchyName).. P3D.CleanP3DString(LocatorChunk.Name))
					end
					animColl:SetChunkAtIndex(idx2, OldFrameController:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
					local CompositeDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CompositeDrawable.Name = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.Name).. P3D.CleanP3DString(LocatorChunk.Name))
					CompositeDrawable.SkeletonName = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.SkeletonName).. P3D.CleanP3DString(LocatorChunk.Name))
					animColl:SetChunkAtIndex(idx2, CompositeDrawable:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Collision_Object) do
					local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CollisionObject.Name = P3D.MakeP3DString(P3D.CleanP3DString(CollisionObject.Name).. P3D.CleanP3DString(LocatorChunk.Name))
					animColl:SetChunkAtIndex(idx2, CollisionObject:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Multi_Controller) do
					local MultiController = P3D.MultiControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					local MultiControllerTracks = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiController:GetChunkAtIndex(1)}
					for i=1,#MultiControllerTracks.Tracks do
						MultiControllerTracks.Tracks[i].Name = P3D.MakeP3DString(P3D.CleanP3DString(MultiControllerTracks.Tracks[i].Name).. P3D.CleanP3DString(LocatorChunk.Name))
					end
					MultiController:SetChunkAtIndex(1, MultiControllerTracks:Output())
					animColl:SetChunkAtIndex(idx2, MultiController:Output())
				end
				
				RootChunk:AddChunk(skel:Output())
				RootChunk:AddChunk(animColl:Output())
				modified = true
			elseif Settings.SolidWrenches and Type == "Wrench" then
				if not AddedWrenchAnimation then
					RootChunk:AddChunk(WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollAnimationIDX))
					AddedWrenchAnimation = true
				end
				local skel = P3D.SkeletonP3DChunk:new{Raw = WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollSkeletonIDX)}
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. P3D.CleanP3DString(LocatorChunk.Name))
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				skelJoint.RestPose.M41 = LocatorChunk.Position.X
				skelJoint.RestPose.M42 = LocatorChunk.Position.Y - 1
				skelJoint.RestPose.M43 = LocatorChunk.Position.Z
				skel:SetChunkAtIndex(1, skelJoint:Output())
				
				local animColl = P3D.AnimCollP3DChunk:new{Raw = WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollAnimCollIDX)}
				animColl.Name = P3D.MakeP3DString(P3D.CleanP3DString(animColl.Name).. P3D.CleanP3DString(LocatorChunk.Name))
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
					local OldFrameController = P3D.OldFrameControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					OldFrameController.Name = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.Name).. P3D.CleanP3DString(LocatorChunk.Name))
					if OldFrameController.Name:sub(1, 4) == "PTRN" then
						OldFrameController.HierarchyName = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.HierarchyName).. P3D.CleanP3DString(LocatorChunk.Name))
					end
					animColl:SetChunkAtIndex(idx2, OldFrameController:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
					local CompositeDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CompositeDrawable.Name = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.Name).. P3D.CleanP3DString(LocatorChunk.Name))
					CompositeDrawable.SkeletonName = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.SkeletonName).. P3D.CleanP3DString(LocatorChunk.Name))
					animColl:SetChunkAtIndex(idx2, CompositeDrawable:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Collision_Object) do
					local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CollisionObject.Name = P3D.MakeP3DString(P3D.CleanP3DString(CollisionObject.Name).. P3D.CleanP3DString(LocatorChunk.Name))
					animColl:SetChunkAtIndex(idx2, CollisionObject:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Multi_Controller) do
					local MultiController = P3D.MultiControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					local MultiControllerTracks = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiController:GetChunkAtIndex(1)}
					for i=1,#MultiControllerTracks.Tracks do
						MultiControllerTracks.Tracks[i].Name = P3D.MakeP3DString(P3D.CleanP3DString(MultiControllerTracks.Tracks[i].Name).. P3D.CleanP3DString(LocatorChunk.Name))
					end
					MultiController:SetChunkAtIndex(1, MultiControllerTracks:Output())
					animColl:SetChunkAtIndex(idx2, MultiController:Output())
				end
				
				RootChunk:AddChunk(skel:Output())
				RootChunk:AddChunk(animColl:Output())
				RootChunk:RemoveChunkAtIndex(idx)
				modified = true
			end
		end
	end
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
		if AnimDynaPhysChunk.Name ~= "l1z6_powerbox_Shape\0" and (Settings.SolidCrates or not (AnimDynaPhysChunk.Name:match("crate") or AnimDynaPhysChunk.Name:match("vending"))) and (not Settings.L4Z6Boards or AnimDynaPhysChunk.Name ~= "l4_tunnelfence_Shape") then
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