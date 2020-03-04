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
local CoinAnimCollAnimationIDX = CoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local CoinAnimCollSkeletonIDX = CoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local CoinAnimCollAnimCollIDX = CoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

local OldCoinAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/OldCoinAnimColl.p3d")}
local OldCoinAnimCollAnimationIDX = OldCoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local OldCoinAnimCollSkeletonIDX = OldCoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local OldCoinAnimCollAnimCollIDX = OldCoinAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

local ShopAnimCollP3D = P3D.P3DChunk:new{Raw = ReadFile(GetModPath() .. "/Resources/p3d/ShopAnimColl.p3d")}
local ShopAnimCollAnimationIDX = ShopAnimCollP3D:GetChunkIndex(P3D.Identifiers.Animation)
local ShopAnimCollSkeletonIDX = ShopAnimCollP3D:GetChunkIndex(P3D.Identifiers.Skeleton)
local ShopAnimCollParticleSystemIDX = ShopAnimCollP3D:GetChunkIndex(P3D.Identifiers.Particle_System_2)
local ShopAnimCollParticleSystemFactoryIDX = ShopAnimCollP3D:GetChunkIndex(P3D.Identifiers.Particle_System_Factory)
local ShopAnimCollAnimCollIDX = ShopAnimCollP3D:GetChunkIndex(P3D.Identifiers.Anim_Coll)

local function RotationYaw(yaw)
	local result = {X=0,Y=0,Z=0,W=0}
	local halfYaw = yaw * 0.5
	
	local sinYaw = math.sin(halfYaw)
	local cosYaw = math.cos(halfYaw)
	
	result.X = 0
	result.Y = sinYaw
	result.Z = 0
	result.W = cosYaw * -1
	return result
end

local pi2 = math.pi * 2
function MakeModelSolid(Original, Path)
	local level = Path:match("l0(%d)") or Path:match("l(%d)") or Path:match("level0(%d)") or Path:match("level(%d)")
	level = level and tonumber(level) or 1
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	local AddedWrenchAnimation = false
	local AddedPhoneAnimation = false
	local AddedCardAnimation = false
	local AddedCoinAnimation = false
	local AddedShopAnimation = false
	local WrenchID = 1
	local PhoneID = 1
	local CardID = 1
	local CoinID = 1
	local OldCoinID = 1
	local ShopID = 1
	
	local OldCoinAnimation = nil
	local OldCoinSkeleton = nil
	local OldCoinAnimColl = nil
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Locator) do
		local LocatorChunk = P3D.LocatorP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
		if LocatorChunk.Type == 9 then
			local Type = LocatorChunk:GetType9Data()
			if Type == "SummonVehiclePhone" then
				if not AddedPhoneAnimation then
					local Chunk = PhoneAnimCollP3D:GetChunkAtIndex(PhoneAnimCollAnimationIDX)
					RootChunk:AddChunk(Chunk)
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
					local Chunk = CardAnimCollP3D:GetChunkAtIndex(CardAnimCollAnimationIDX)
					RootChunk:AddChunk(Chunk)
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
					local Chunk = WrenchAnimCollP3D:GetChunkAtIndex(WrenchAnimCollAnimationIDX)
					RootChunk:AddChunk(Chunk)
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
			elseif Settings.SolidShops and Type == "PurchaseSkin" then
				if not AddedShopAnimation then
					local Chunk = ShopAnimCollP3D:GetChunkAtIndex(ShopAnimCollAnimationIDX)
					RootChunk:AddChunk(Chunk)
					AddedShopAnimation = true
				end
				local skel = P3D.SkeletonP3DChunk:new{Raw = ShopAnimCollP3D:GetChunkAtIndex(ShopAnimCollSkeletonIDX)}
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. ShopID)
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				skelJoint.RestPose.M41 = LocatorChunk.Position.X
				skelJoint.RestPose.M42 = LocatorChunk.Position.Y
				skelJoint.RestPose.M43 = LocatorChunk.Position.Z
				skel:SetChunkAtIndex(1, skelJoint:Output())
				
				local particleSystem = P3D.ParticleSystem2P3DChunk:new{Raw = ShopAnimCollP3D:GetChunkAtIndex(ShopAnimCollParticleSystemIDX)}
				particleSystem.Name = P3D.MakeP3DString(P3D.CleanP3DString(particleSystem.Name).. ShopID)
				particleSystem.Unknown = P3D.MakeP3DString(P3D.CleanP3DString(particleSystem.Unknown).. ShopID)
				
				local particleSystemFactory = P3D.ParticleSystemFactoryP3DChunk:new{Raw = ShopAnimCollP3D:GetChunkAtIndex(ShopAnimCollParticleSystemFactoryIDX)}
				particleSystemFactory.Name = P3D.MakeP3DString(P3D.CleanP3DString(particleSystemFactory.Name).. ShopID)
				
				local animColl = P3D.AnimCollP3DChunk:new{Raw = ShopAnimCollP3D:GetChunkAtIndex(ShopAnimCollAnimCollIDX)}
				animColl.Name = P3D.MakeP3DString(P3D.CleanP3DString(animColl.Name).. ShopID)
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
					local OldFrameController = P3D.OldFrameControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					OldFrameController.Name = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.Name).. ShopID)
					if OldFrameController.Name:sub(1, 4) == "PTRN" or OldFrameController.Name:sub(1, 3) == "EFX" then
						OldFrameController.HierarchyName = P3D.MakeP3DString(P3D.CleanP3DString(OldFrameController.HierarchyName).. ShopID)
					end
					animColl:SetChunkAtIndex(idx2, OldFrameController:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
					local CompositeDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CompositeDrawable.Name = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.Name).. ShopID)
					CompositeDrawable.SkeletonName = P3D.MakeP3DString(P3D.CleanP3DString(CompositeDrawable.SkeletonName).. ShopID)
					for idx3 in CompositeDrawable:GetChunkIndexes(P3D.Identifiers.Composite_Drawable_Effect_List) do
						local EffectList = P3D.CompositeDrawableEffectListP3DChunk:new{Raw = CompositeDrawable:GetChunkAtIndex(idx3)}
						for idx4 in EffectList:GetChunkIndexes(P3D.Identifiers.Composite_Drawable_Effect) do
							local Effect = P3D.CompositeDrawableEffectP3DChunk:new{Raw = EffectList:GetChunkAtIndex(idx4)}
							Effect.Name = P3D.MakeP3DString(P3D.CleanP3DString(Effect.Name).. ShopID)
							EffectList:SetChunkAtIndex(idx4, Effect:Output())
						end
						CompositeDrawable:SetChunkAtIndex(idx3, EffectList:Output())
					end
					animColl:SetChunkAtIndex(idx2, CompositeDrawable:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Collision_Object) do
					local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					CollisionObject.Name = P3D.MakeP3DString(P3D.CleanP3DString(CollisionObject.Name).. ShopID)
					animColl:SetChunkAtIndex(idx2, CollisionObject:Output())
				end
				for idx2 in animColl:GetChunkIndexes(P3D.Identifiers.Multi_Controller) do
					local MultiController = P3D.MultiControllerP3DChunk:new{Raw = animColl:GetChunkAtIndex(idx2)}
					local MultiControllerTracks = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiController:GetChunkAtIndex(1)}
					for i=1,#MultiControllerTracks.Tracks do
						MultiControllerTracks.Tracks[i].Name = P3D.MakeP3DString(P3D.CleanP3DString(MultiControllerTracks.Tracks[i].Name).. ShopID)
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
				ShopID = ShopID + 1
			end
		elseif LocatorChunk.Type == 14 and Settings.SolidCoins then
			if Settings.SolidCoinsForceOld or IsOldVersion then
				local new = OldCoinAnimation == nil
				if new then
					OldCoinAnimation = P3D.AnimationP3DChunk:new{Raw = OldCoinAnimCollP3D:GetChunkAtIndex(OldCoinAnimCollAnimationIDX)}
					OldCoinSkeleton = P3D.SkeletonP3DChunk:new{Raw = OldCoinAnimCollP3D:GetChunkAtIndex(OldCoinAnimCollSkeletonIDX)}
					OldCoinAnimColl = P3D.AnimCollP3DChunk:new{Raw = OldCoinAnimCollP3D:GetChunkAtIndex(OldCoinAnimCollAnimCollIDX)}
				end
				
				local AnimationGroupListIDX = OldCoinAnimation:GetChunkIndex(P3D.Identifiers.Animation_Group_List)
				local AnimationGroupList = P3D.AnimationGroupListP3DChunk:new{Raw = OldCoinAnimation:GetChunkAtIndex(AnimationGroupListIDX)}
				local AnimationGroupIDX = AnimationGroupList:GetChunkIndex(P3D.Identifiers.Animation_Group)
				local AnimationGroup = P3D.AnimationGroupP3DChunk:new{Raw = AnimationGroupList:GetChunkAtIndex(AnimationGroupIDX)}
				AnimationGroup.Name = P3D.MakeP3DString("solidOldCoin_" .. OldCoinID)
				AnimationGroup.GroupId = OldCoinID
				local QuaternionIDX = AnimationGroup:GetChunkIndex(P3D.Identifiers.Compressed_Quaternion_Channel)
				local Quaternion = P3D.CompressedQuaternionChannelP3DChunk:new{Raw = AnimationGroup:GetChunkAtIndex(QuaternionIDX)}
				local start = math.random() * pi2
				Quaternion.Values[1] = RotationYaw(start)
				Quaternion.Values[2] = RotationYaw(pi2 / 3 * 2 + start)
				Quaternion.Values[3] = RotationYaw(pi2 / 3 + start)
				Quaternion.Values[4] = Quaternion.Values[1]
				AnimationGroup:SetChunkAtIndex(QuaternionIDX, Quaternion:Output())
				if new then
					AnimationGroupList:SetChunkAtIndex(AnimationGroupIDX, AnimationGroup:Output())
				else
					AnimationGroupList:AddChunk(AnimationGroup:Output())
				end
				OldCoinAnimation:SetChunkAtIndex(AnimationGroupListIDX, AnimationGroupList:Output())
				
				local SkeletonJointIDX = OldCoinSkeleton:GetChunkIndex(P3D.Identifiers.Skeleton_Joint)
				local SkeletonJoint = P3D.SkeletonJointP3DChunk:new{Raw = OldCoinSkeleton:GetChunkAtIndex(SkeletonJointIDX)}
				SkeletonJoint.Name = P3D.MakeP3DString("solidOldCoin_" .. OldCoinID)
				P3D.MatrixRotateY(SkeletonJoint.RestPose, math.deg(start))
				SkeletonJoint.RestPose.M41 = LocatorChunk.Position.X
				SkeletonJoint.RestPose.M42 = LocatorChunk.Position.Y
				SkeletonJoint.RestPose.M43 = LocatorChunk.Position.Z
				if new then
					OldCoinSkeleton:SetChunkAtIndex(SkeletonJointIDX, SkeletonJoint:Output())
					SkeletonJoint.Name = P3D.MakeP3DString("solidOldCoin")
					SkeletonJoint.RestPose = P3D.MatrixIdentity()
					OldCoinSkeleton:SetChunkAtIndex(1, SkeletonJoint:Output())
				else
					OldCoinSkeleton:AddChunk(SkeletonJoint:Output())
				end
				
				
				local CompDrawableIDX = OldCoinAnimColl:GetChunkIndex(P3D.Identifiers.Composite_Drawable)
				local CompDrawable = P3D.CompositeDrawableP3DChunk:new{Raw = OldCoinAnimColl:GetChunkAtIndex(CompDrawableIDX)}
				local CompDrawablePropListIDX = CompDrawable:GetChunkIndex(P3D.Identifiers.Composite_Drawable_Prop_List)
				local CompDrawablePropList = P3D.CompositeDrawablePropListP3DChunk:new{Raw = CompDrawable:GetChunkAtIndex(CompDrawablePropListIDX)}
				local CompDrawablePropIDX = CompDrawablePropList:GetChunkIndex(P3D.Identifiers.Composite_Drawable_Prop)
				local CompDrawableProp = P3D.CompositeDrawablePropP3DChunk:new{Raw = CompDrawablePropList:GetChunkAtIndex(CompDrawablePropIDX)}
				CompDrawableProp.Name = P3D.MakeP3DString(CoinMesh[level])
				CompDrawableProp.SkeletonJointID = OldCoinID
				if new then
					CompDrawablePropList:SetChunkAtIndex(CompDrawablePropIDX, CompDrawableProp:Output())
				else
					CompDrawablePropList:AddChunk(CompDrawableProp:Output())
				end
				CompDrawable:SetChunkAtIndex(CompDrawablePropListIDX, CompDrawablePropList:Output())
				OldCoinAnimColl:SetChunkAtIndex(CompDrawableIDX, CompDrawable:Output())
					
				local CollisionObjectIDX = OldCoinAnimColl:GetChunkIndex(P3D.Identifiers.Collision_Object)
				local CollisionObject = P3D.CollisionObjectP3DChunk:new{Raw = OldCoinAnimColl:GetChunkAtIndex(CollisionObjectIDX)}
				local CollisionVolumeIDX = CollisionObject:GetChunkIndex(P3D.Identifiers.Collision_Volume)
				local CollisionVolume = P3D.CollisionVolumeP3DChunk:new{Raw = CollisionObject:GetChunkAtIndex(CollisionVolumeIDX)}
				
				local SubCollisionVolume = P3D.CollisionVolumeP3DChunk:new{Raw = CollisionVolume:GetChunkAtIndex(2)}
				SubCollisionVolume.ObjectReferenceIndex = OldCoinID
				SubCollisionVolume.OwnerIndex = OldCoinID - 1
				if new then
					CollisionVolume:SetChunkAtIndex(2, SubCollisionVolume:Output())
				else
					CollisionVolume:AddChunk(SubCollisionVolume:Output())
				end
				
				CollisionObject:SetChunkAtIndex(CollisionVolumeIDX, CollisionVolume:Output())
				OldCoinAnimColl:SetChunkAtIndex(CollisionObjectIDX, CollisionObject:Output())
				
				OldCoinID = OldCoinID + 1
				RootChunk:RemoveChunkAtIndex(idx)
			else
				if not AddedCoinAnimation then
					local Chunk = CoinAnimCollP3D:GetChunkAtIndex(CoinAnimCollAnimationIDX)
					RootChunk:AddChunk(Chunk)
					AddedCoinAnimation = true
				end
				local skel = P3D.SkeletonP3DChunk:new{Raw = CoinAnimCollP3D:GetChunkAtIndex(CoinAnimCollSkeletonIDX)}
				skel.Name = P3D.MakeP3DString(P3D.CleanP3DString(skel.Name).. CoinID)
				local skelJoint = P3D.SkeletonJointP3DChunk:new{Raw = skel:GetChunkAtIndex(1)}
				P3D.MatrixRotateY(skelJoint.RestPose, math.random(0, 359))
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
					local CompositeDrawablePropList = P3D.CompositeDrawablePropListP3DChunk:new{Raw = CompositeDrawable:GetChunkAtIndex(2)}
					local CompositeDrawableProp = P3D.CompositeDrawablePropP3DChunk:new{Raw = CompositeDrawablePropList:GetChunkAtIndex(1)}
					CompositeDrawableProp.Name = P3D.MakeP3DString(CoinMesh[level])
					CompositeDrawablePropList:SetChunkAtIndex(1, CompositeDrawableProp:Output())
					CompositeDrawable:SetChunkAtIndex(2, CompositeDrawablePropList:Output())
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
			end			
		end
	end
	if OldCoinAnimColl ~= nil then
		RootChunk:AddChunk(OldCoinAnimation:Output())
		RootChunk:AddChunk(OldCoinSkeleton:Output())
		RootChunk:AddChunk(OldCoinAnimColl:Output())
		modified = true
	end
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Dyna_Phys) do
		local DynaPhysChunk = P3D.DynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
		DynaPhysChunk.ChunkType = P3D.Identifiers.Inst_Stat_Phys
		DynaPhysChunk.Name = P3D.MakeP3DString(P3D.CleanP3DString(DynaPhysChunk.Name) .. "Solid")
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