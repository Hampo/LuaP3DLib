if P3D == nil then Alert("P3D Functions loaded with no P3D table present.") end
local P3D = P3D

local WrenchAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/WrenchAnimColl.p3d")}
local WrenchAnimCollAnimationIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local WrenchAnimCollSkeletonIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local WrenchAnimCollParticleSystemIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Particle_System_2)
local WrenchAnimCollParticleSystemFactoryIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Particle_System_Factory)
local WrenchAnimCollAnimCollIDX = WrenchAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

local PhoneAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/PhoneAnimColl.p3d")}
local PhoneAnimCollAnimationIDX = PhoneAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local PhoneAnimCollSkeletonIDX = PhoneAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local PhoneAnimCollAnimCollIDX = PhoneAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

local CardAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/CardAnimColl.p3d")}
local CardAnimCollAnimationIDX = CardAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local CardAnimCollSkeletonIDX = CardAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local CardAnimCollParticleSystemIDX = CardAnimCollP3D:GetChunkIndex(P3D.Identifiers.Particle_System_2)
local CardAnimCollParticleSystemFactoryIDX = CardAnimCollP3D:GetChunkIndex(P3D.Identifiers.Particle_System_Factory)
local CardAnimCollAnimCollIDX = CardAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

local CoinAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/CoinAnimColl.p3d")}
local CoinAnimDynaPhysIDX = CoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Dyna_Phys)
local CoinAnimCollAnimationIDX = CoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local CoinAnimCollSkeletonIDX = CoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local CoinAnimCollAnimCollIDX = CoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

function MakeModelSolid(Original, Path)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	local AddedWrenchAnimation = false
	local AddedPhoneAnimation = false
	local AddedCardAnimation = false
	local AddedCoinAnimation = false
	local WrenchID = 1
	local PhoneID = 1
	local CardID = 1
	local CoinID = 1
	local CoinAnimDynaPhys = nil
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
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. PhoneID)
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				skelJoint.RestPose.M41 = LocatorChunk.Position.X
				skelJoint.RestPose.M42 = LocatorChunk.Position.Y - 1
				skelJoint.RestPose.M43 = LocatorChunk.Position.Z
				skel:SetChunkAtIndex(1, skelJoint:Output())
				
				local animColl = P3D.AnimCollP3DChunk:new{Raw = PhoneAnimCollP3D:GetChunkAtIndex(PhoneAnimCollAnimCollIDX)}
				animColl.Name = P3D.MakeP3DString(P3D.CleanP3DString(animColl.Name).. PhoneID)
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
					local OldFrameController = P3D.OldFrameControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					OldFrameController.Name = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.Name).. PhoneID)
					if OldFrameController.Name:sub(1, 4) == "PTRN" then
						OldFrameController.HierarchyName = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.HierarchyName).. PhoneID)
					end
					animColl:SetChunkAtIndex(idx2, OldFrameController:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
					local CompositeDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CompositeDrawable.Name = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.Name).. PhoneID)
					CompositeDrawable.SkeletonName = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.SkeletonName).. PhoneID)
					animColl:SetChunkAtIndex(idx2, CompositeDrawable:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Collision_Object) do
					local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CollisionObject.Name = P3D.MakeP3DString(P3D.CleanP3DString(CollisionObject.Name).. PhoneID)
					animColl:SetChunkAtIndex(idx2, CollisionObject:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Multi_Controller) do
					local MultiController = P3D.MultiControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					local MultiControllerTracks = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiController:GetChunkAtIndex(1)}
					for i=1,#MultiControllerTracks.Tracks do
						MultiControllerTracks.Tracks[i].Name = P3D.MakeP3DString(P3D.CleanP3DString(MultiControllerTracks.Tracks[i].Name).. PhoneID)
					end
					MultiController:SetChunkAtIndex(1, MultiControllerTracks:Output())
					animColl:SetChunkAtIndex(idx2, MultiController:Output())
				end
				
				RootChunk:AddChunk(skel:Output())
				RootChunk:AddChunk(animColl:Output())
				modified = true
				PhoneID = PhoneID + 1
			elseif Settings.SolidCards and Type == "CollectorCard" then
				if not AddedCardAnimation then
					RootChunk:AddChunk(CardAnimCollP3D:GetChunkAtIndex(CardAnimCollAnimationIDX))
					AddedCardAnimation = true
				end
				local skel = P3D.SkeletonP3DChunk:new{Raw = CardAnimCollP3D:GetChunkAtIndex(CardAnimCollSkeletonIDX)}
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. CardID)
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				skelJoint.RestPose.M41 = LocatorChunk.Position.X
				skelJoint.RestPose.M42 = LocatorChunk.Position.Y
				skelJoint.RestPose.M43 = LocatorChunk.Position.Z
				skel:SetChunkAtIndex(1, skelJoint:Output())
				
				local particleSystem = P3D.ParticleSystem2P3DChunk:new{Raw = CardAnimCollP3D:GetChunkAtIndex(CardAnimCollParticleSystemIDX)}
				particleSystem.Name = P3D.MakeP3DString(P3D.CleanP3DString(particleSystem.Name).. CardID)
				particleSystem.Unknown = P3D.MakeP3DString(P3D.CleanP3DString(particleSystem.Unknown).. CardID)
				
				local particleSystemFactory = P3D.ParticleSystemFactoryP3DChunk:new{Raw = CardAnimCollP3D:GetChunkAtIndex(CardAnimCollParticleSystemFactoryIDX)}
				particleSystemFactory.Name = P3D.MakeP3DString(P3D.CleanP3DString(particleSystemFactory.Name).. CardID)
				
				local animColl = P3D.AnimCollP3DChunk:new{Raw = CardAnimCollP3D:GetChunkAtIndex(CardAnimCollAnimCollIDX)}
				animColl.Name = P3D.MakeP3DString(P3D.CleanP3DString(animColl.Name).. CardID)
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
					local OldFrameController = P3D.OldFrameControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					OldFrameController.Name = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.Name).. CardID)
					if OldFrameController.Name:sub(1, 4) == "PTRN" or OldFrameController.Name:sub(1, 3) == "EFX" then
						OldFrameController.HierarchyName = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.HierarchyName).. CardID)
					end
					animColl:SetChunkAtIndex(idx2, OldFrameController:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
					local CompositeDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CompositeDrawable.Name = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.Name).. CardID)
					CompositeDrawable.SkeletonName = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.SkeletonName).. CardID)
					for idx3 in CompositeDrawable:GetChunkIndexes(P3D.Identifiers.Composite_Drawable_Effect_List) do
						local EffectList = P3D.CompositeDrawableEffectListP3DChunk:new{Raw = CompositeDrawable:GetChunkAtIndex(idx3)}
						for idx4 in EffectList:GetChunkIndexes(P3D.Identifiers.Composite_Drawable_Effect) do
							local Effect = P3D.CompositeDrawableEffectP3DChunk:new{Raw = EffectList:GetChunkAtIndex(idx4)}
							Effect.Name = P3D.MakeP3DString(P3D.CleanP3DString(Effect.Name).. CardID)
							EffectList:SetChunkAtIndex(idx4, Effect:Output())
						end
						CompositeDrawable:SetChunkAtIndex(idx3, EffectList:Output())
					end
					animColl:SetChunkAtIndex(idx2, CompositeDrawable:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Collision_Object) do
					local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CollisionObject.Name = P3D.MakeP3DString(P3D.CleanP3DString(CollisionObject.Name).. CardID)
					animColl:SetChunkAtIndex(idx2, CollisionObject:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Multi_Controller) do
					local MultiController = P3D.MultiControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					local MultiControllerTracks = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiController:GetChunkAtIndex(1)}
					for i=1,#MultiControllerTracks.Tracks do
						MultiControllerTracks.Tracks[i].Name = P3D.MakeP3DString(P3D.CleanP3DString(MultiControllerTracks.Tracks[i].Name).. CardID)
					end
					MultiController:SetChunkAtIndex(1, MultiControllerTracks:Output())
					animColl:SetChunkAtIndex(idx2, MultiController:Output())
				end
				
				RootChunk:AddChunk(skel:Output())
				RootChunk:AddChunk(particleSystemFactory:Output())
				RootChunk:AddChunk(particleSystem:Output())
				RootChunk:AddChunk(animColl:Output())
				RootChunk:RemoveChunkAtIndex(idx)
				modified = true
				CardID = CardID + 1
			elseif Settings.SolidWrenches and Type == "Wrench" then
				if not AddedWrenchAnimation then
					RootChunk:AddChunk(WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollAnimationIDX))
					AddedWrenchAnimation = true
				end
				local skel = P3D.SkeletonP3DChunk:new{Raw = WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollSkeletonIDX)}
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. WrenchID)
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				skelJoint.RestPose.M41 = LocatorChunk.Position.X
				skelJoint.RestPose.M42 = LocatorChunk.Position.Y - 1
				skelJoint.RestPose.M43 = LocatorChunk.Position.Z
				skel:SetChunkAtIndex(1, skelJoint:Output())
				
				local particleSystem = P3D.ParticleSystem2P3DChunk:new{Raw = WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollParticleSystemIDX)}
				particleSystem.Name = P3D.MakeP3DString(P3D.CleanP3DString(particleSystem.Name).. WrenchID)
				particleSystem.Unknown = P3D.MakeP3DString(P3D.CleanP3DString(particleSystem.Unknown).. WrenchID)
				
				local particleSystemFactory = P3D.ParticleSystemFactoryP3DChunk:new{Raw = WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollParticleSystemFactoryIDX)}
				particleSystemFactory.Name = P3D.MakeP3DString(P3D.CleanP3DString(particleSystemFactory.Name).. WrenchID)
				
				local animColl = P3D.AnimCollP3DChunk:new{Raw = WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollAnimCollIDX)}
				animColl.Name = P3D.MakeP3DString(P3D.CleanP3DString(animColl.Name).. WrenchID)
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
					local OldFrameController = P3D.OldFrameControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					OldFrameController.Name = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.Name).. WrenchID)
					if OldFrameController.Name:sub(1, 4) == "PTRN" or OldFrameController.Name:sub(1, 3) == "EFX" then
						OldFrameController.HierarchyName = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.HierarchyName).. WrenchID)
					end
					animColl:SetChunkAtIndex(idx2, OldFrameController:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
					local CompositeDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CompositeDrawable.Name = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.Name).. WrenchID)
					CompositeDrawable.SkeletonName = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.SkeletonName).. WrenchID)
					for idx3 in CompositeDrawable:GetChunkIndexes(P3D.Identifiers.Composite_Drawable_Effect_List) do
						local EffectList = P3D.CompositeDrawableEffectListP3DChunk:new{Raw = CompositeDrawable:GetChunkAtIndex(idx3)}
						for idx4 in EffectList:GetChunkIndexes(P3D.Identifiers.Composite_Drawable_Effect) do
							local Effect = P3D.CompositeDrawableEffectP3DChunk:new{Raw = EffectList:GetChunkAtIndex(idx4)}
							Effect.Name = P3D.MakeP3DString(P3D.CleanP3DString(Effect.Name).. WrenchID)
							EffectList:SetChunkAtIndex(idx4, Effect:Output())
						end
						CompositeDrawable:SetChunkAtIndex(idx3, EffectList:Output())
					end
					animColl:SetChunkAtIndex(idx2, CompositeDrawable:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Collision_Object) do
					local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CollisionObject.Name = P3D.MakeP3DString(P3D.CleanP3DString(CollisionObject.Name).. WrenchID)
					animColl:SetChunkAtIndex(idx2, CollisionObject:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Multi_Controller) do
					local MultiController = P3D.MultiControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					local MultiControllerTracks = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiController:GetChunkAtIndex(1)}
					for i=1,#MultiControllerTracks.Tracks do
						MultiControllerTracks.Tracks[i].Name = P3D.MakeP3DString(P3D.CleanP3DString(MultiControllerTracks.Tracks[i].Name).. WrenchID)
					end
					MultiController:SetChunkAtIndex(1, MultiControllerTracks:Output())
					animColl:SetChunkAtIndex(idx2, MultiController:Output())
				end
				
				RootChunk:AddChunk(skel:Output())
				RootChunk:AddChunk(particleSystemFactory:Output())
				RootChunk:AddChunk(particleSystem:Output())
				RootChunk:AddChunk(animColl:Output())
				RootChunk:RemoveChunkAtIndex(idx)
				modified = true
				WrenchID = WrenchID + 1
			end
		elseif LocatorChunk.Type == 14 and Settings.SolidCoins then
			if CoinID < 20 then
				if not AddedCoinAnimation then
					RootChunk:AddChunk(CoinAnimCollP3D:GetChunkAtIndex(CoinAnimCollAnimationIDX))
					AddedCoinAnimation = true
				end
				local skel = P3D.SkeletonP3DChunk:new{Raw = CoinAnimCollP3D:GetChunkAtIndex(CoinAnimCollSkeletonIDX)}
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. CoinID)
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				P3D.MatrixRotateY(skelJoint.RestPose, math.random(0, 179))
				skelJoint.RestPose.M41 = LocatorChunk.Position.X
				skelJoint.RestPose.M42 = LocatorChunk.Position.Y
				skelJoint.RestPose.M43 = LocatorChunk.Position.Z
				skel:SetChunkAtIndex(1, skelJoint:Output())
				
				local animColl = P3D.AnimCollP3DChunk:new{Raw = CoinAnimCollP3D:GetChunkAtIndex(CoinAnimCollAnimCollIDX)}
				animColl.Name = P3D.MakeP3DString(P3D.CleanP3DString(animColl.Name).. CoinID)
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
					local OldFrameController = P3D.OldFrameControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					OldFrameController.Name = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.Name).. CoinID)
					if OldFrameController.Name:sub(1, 4) == "PTRN" then
						OldFrameController.HierarchyName = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.HierarchyName).. CoinID)
					end
					animColl:SetChunkAtIndex(idx2, OldFrameController:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
					local CompositeDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CompositeDrawable.Name = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.Name).. CoinID)
					CompositeDrawable.SkeletonName = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.SkeletonName).. CoinID)
					animColl:SetChunkAtIndex(idx2, CompositeDrawable:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Collision_Object) do
					local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CollisionObject.Name = P3D.MakeP3DString(P3D.CleanP3DString(CollisionObject.Name).. CoinID)
					animColl:SetChunkAtIndex(idx2, CollisionObject:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Multi_Controller) do
					local MultiController = P3D.MultiControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					local MultiControllerTracks = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiController:GetChunkAtIndex(1)}
					for i=1,#MultiControllerTracks.Tracks do
						MultiControllerTracks.Tracks[i].Name = P3D.MakeP3DString(P3D.CleanP3DString(MultiControllerTracks.Tracks[i].Name).. CoinID)
					end
					MultiController:SetChunkAtIndex(1, MultiControllerTracks:Output())
					animColl:SetChunkAtIndex(idx2, MultiController:Output())
				end
				
				RootChunk:AddChunk(skel:Output())
				RootChunk:AddChunk(animColl:Output())
				RootChunk:RemoveChunkAtIndex(idx)
				modified = true
				CoinID = CoinID + 1
			else
				local new = CoinAnimDynaPhys == nil
				if new then CoinAnimDynaPhys = P3D.AnimDynaPhysP3DChunk:new{Raw = CoinAnimCollP3D:GetChunkAtIndex(CoinAnimDynaPhysIDX)} end
				local instanceIDX = CoinAnimDynaPhys:GetChunkIndex(P3D.Identifiers.Instance_List)
				local InstanceList = P3D.InstanceListP3DChunk:new{Raw = CoinAnimDynaPhys:GetChunkAtIndex(instanceIDX)}
				
				local scenegraphIDX = InstanceList:GetChunkIndex(P3D.Identifiers.Scenegraph)
				local Scenegraph = P3D.ScenegraphP3DChunk:new{Raw = InstanceList:GetChunkAtIndex(scenegraphIDX)}
				
				local oldScenegraphRootIDX = Scenegraph:GetChunkIndex(P3D.Identifiers.Old_Scenegraph_Root)
				local OldScenegraphRoot = P3D.OldScenegraphRootP3DChunk:new{Raw = Scenegraph:GetChunkAtIndex(oldScenegraphRootIDX)}
				
				local oldScenegraphBranchIDX = OldScenegraphRoot:GetChunkIndex(P3D.Identifiers.Old_Scenegraph_Branch)
				local OldScenegraphBranch = P3D.OldScenegraphBranchP3DChunk:new{Raw = OldScenegraphRoot:GetChunkAtIndex(oldScenegraphBranchIDX)}
				
				local oldScenegraphTransformIDX = OldScenegraphBranch:GetChunkIndex(P3D.Identifiers.Old_Scenegraph_Transform)
				local OldScenegraphTransform = P3D.OldScenegraphTransformP3DChunk:new{Raw = OldScenegraphBranch:GetChunkAtIndex(oldScenegraphTransformIDX)}
				
				local oldScenegraphTransform2IDX = OldScenegraphTransform:GetChunkIndex(P3D.Identifiers.Old_Scenegraph_Transform)
				local OldScenegraphTransform2 = P3D.OldScenegraphTransformP3DChunk:new{Raw = OldScenegraphTransform:GetChunkAtIndex(oldScenegraphTransform2IDX)}
				P3D.MatrixRotateY(OldScenegraphTransform2.Transform, math.random(0, 179))
				OldScenegraphTransform2.Transform.M41 = LocatorChunk.Position.X
				OldScenegraphTransform2.Transform.M42 = LocatorChunk.Position.Y
				OldScenegraphTransform2.Transform.M43 = LocatorChunk.Position.Z
				
				if new then
					OldScenegraphTransform:SetChunkAtIndex(oldScenegraphTransform2IDX, OldScenegraphTransform2:Output())
				else
					OldScenegraphTransform:AddChunk(OldScenegraphTransform2:Output())
				end
				OldScenegraphBranch:SetChunkAtIndex(oldScenegraphTransformIDX, OldScenegraphTransform:Output())
				OldScenegraphRoot:SetChunkAtIndex(oldScenegraphBranchIDX, OldScenegraphBranch:Output())
				Scenegraph:SetChunkAtIndex(oldScenegraphRootIDX, OldScenegraphRoot:Output())
				InstanceList:SetChunkAtIndex(scenegraphIDX, Scenegraph:Output())
				CoinAnimDynaPhys:SetChunkAtIndex(instanceIDX, InstanceList:Output())
				RootChunk:RemoveChunkAtIndex(idx)
			end
		end
	end
	if CoinAnimDynaPhys ~= nil then
		RootChunk:AddChunk(CoinAnimDynaPhys:Output())
		modified = true
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
			RootChunk:SetChunkAtIndex(idx, AnimDynaPhysChunk:Output())
			modified = true
		end
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