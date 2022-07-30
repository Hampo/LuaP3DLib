local Path = GetPath()

local IsCar = WildcardMatch(Path, "art/cars/*.p3d", true, true)
local IsMenu = WildcardMatch(Path, "art/frontend/scrooby/resource/pure3d/*.p3d", true, true)
local IsChar = WildcardMatch(Path, "art/chars/*.p3d", true, true) or IsMenu or WildcardMatch(Path, "art/l0?_fx.p3d", true, true)

if not Settings.ScaleCars and IsCar then
	return
end

if not Settings.ScaleChars and IsChar then
	return
end

local ExcludedFiles = {
	["huskA.p3d"] = true,
	["common.p3d"] = true,
	["npd_m.p3d"] = true,
	["npd_a.p3d"] = true,
	["nps_m.p3d"] = true,
	["nps_a.p3d"] = true,
	["ndr_m.p3d"] = true,
	["ndr_a.p3d"] = true,
}
local FileName = GetFileName(Path)
if ExcludedFiles[FileName] then
	print("NOT Scaling: " .. Path)
	return
end

print("Scaling: " .. Path)
local GamePath = GetGamePath(Path)
local P3DFile = P3D.P3DFile(GamePath)
local ScaleMultiplier
if IsChar then
	ScaleMultiplier = Settings["L"..Level.."CharScaleMultiplier"]
elseif IsCar then
	ScaleMultiplier = Settings["L"..Level.."CarScaleMultiplier"]
end
if IsMenu then
	ScaleMultiplier = math.min(ScaleMultiplier, 2)
end

if ScaleMultiplier > 1 and IsCar then
	for chunk in P3DFile:GetChunks(P3D.Identifiers.Follow_Camera_Data) do
		chunk.Distance = chunk.Distance * ScaleMultiplier
		chunk.Look.X = chunk.Look.X * ScaleMultiplier
		chunk.Look.Y = chunk.Look.Y * ScaleMultiplier
		chunk.Look.Z = chunk.Look.Z * ScaleMultiplier
	end
end

local function ProcessOldBillboardQuadGroup(OldBillboardQuadGroupChunk)
	for chunk in OldBillboardQuadGroupChunk:GetChunks(P3D.Identifiers.Old_Billboard_Quad) do
		chunk.Width = chunk.Width * ScaleMultiplier
		chunk.Height = chunk.Height * ScaleMultiplier
		chunk.Distance = chunk.Distance * ScaleMultiplier
		
		chunk.Translation.X = chunk.Translation.X * ScaleMultiplier
		chunk.Translation.Y = chunk.Translation.Y * ScaleMultiplier
		chunk.Translation.Z = chunk.Translation.Z * ScaleMultiplier
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Old_Billboard_Quad_Group) do
	ProcessOldBillboardQuadGroup(chunk)
end

local function ProcessOldPrimitiveGroup(OldPrimitiveGroupChunk)
	local chunk = OldPrimitiveGroupChunk:GetChunk(P3D.Identifiers.Position_List)
	if chunk then
		for i=1,#chunk.Positions do
			local position = chunk.Positions[i]
			position.X = position.X * ScaleMultiplier
			position.Y = position.Y * ScaleMultiplier
			position.Z = position.Z * ScaleMultiplier
		end
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Old_Primitive_Group) do
	ProcessOldPrimitiveGroup(chunk)
end

local function ProcessMesh(MeshChunk)
	for chunk in MeshChunk:GetChunks(P3D.Identifiers.Old_Primitive_Group) do
		ProcessOldPrimitiveGroup(chunk)
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Mesh) do
	ProcessMesh(chunk)
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Skin) do
	for chunk2 in chunk:GetChunks(P3D.Identifiers.Old_Primitive_Group) do
		ProcessOldPrimitiveGroup(chunk2)
	end
end

local function ProcessSkeleton(SkeletonChunk)
	for chunk in SkeletonChunk:GetChunks(P3D.Identifiers.Skeleton_Joint) do
		chunk.RestPose.M41 = chunk.RestPose.M41 * ScaleMultiplier
		chunk.RestPose.M42 = chunk.RestPose.M42 * ScaleMultiplier
		chunk.RestPose.M43 = chunk.RestPose.M43 * ScaleMultiplier
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Skeleton) do
	ProcessSkeleton(chunk)
end

local function ProcessCollisionVolume(CollisionVolumeChunk)
	for chunk in CollisionVolumeChunk:GetChunks(P3D.Identifiers.Collision_Volume) do
		ProcessCollisionVolume(chunk)
	end
	
	for chunk in CollisionVolumeChunk:GetChunks(P3D.Identifiers.Collision_Oriented_Bounding_Box) do
		chunk.HalfExtents.X = chunk.HalfExtents.X * ScaleMultiplier
		chunk.HalfExtents.Y = chunk.HalfExtents.Y * ScaleMultiplier
		chunk.HalfExtents.Z = chunk.HalfExtents.Z * ScaleMultiplier
		
		for chunk2 in chunk:GetChunks(P3D.Identifiers.Collision_Vector) do
			chunk2.Vector.X = chunk2.Vector.X * ScaleMultiplier
			chunk2.Vector.Y = chunk2.Vector.Y * ScaleMultiplier
			chunk2.Vector.Z = chunk2.Vector.Z * ScaleMultiplier
		end
	end
	
	for chunk in CollisionVolumeChunk:GetChunks(P3D.Identifiers.Collision_Sphere) do
		chunk.Radius = chunk.Radius * ScaleMultiplier
		
		for chunk2 in chunk:GetChunks(P3D.Identifiers.Collision_Vector) do
			chunk2.Vector.X = chunk2.Vector.X * ScaleMultiplier
			chunk2.Vector.Y = chunk2.Vector.Y * ScaleMultiplier
			chunk2.Vector.Z = chunk2.Vector.Z * ScaleMultiplier
		end
	end
end

local function ProcessCollisionObject(CollisionObjectChunk)
	for chunk in CollisionObjectChunk:GetChunks(P3D.Identifiers.Collision_Volume) do
		ProcessCollisionVolume(chunk)
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Collision_Object) do
	ProcessCollisionObject(chunk)
end

local function ProcessPhysicsObject(PhysicsObjectChunk)
	PhysicsObjectChunk.Volume = PhysicsObjectChunk.Volume * ScaleMultiplier
	
	for chunk in PhysicsObjectChunk:GetChunks(P3D.Identifiers.Physics_Joint) do
		chunk.Volume = chunk.Volume * ScaleMultiplier
		
		for chunk2 in chunk:GetChunks(P3D.Identifiers.Physics_Vector) do
			chunk2.Vector.X = chunk2.Vector.X * ScaleMultiplier
			chunk2.Vector.Y = chunk2.Vector.Y * ScaleMultiplier
			chunk2.Vector.Z = chunk2.Vector.Z * ScaleMultiplier
		end
		
		for chunk2 in chunk:GetChunks(P3D.Identifiers.Physics_Inertia_Matrix) do
			chunk2.Matrix.XX = chunk2.Matrix.XX * ScaleMultiplier
			chunk2.Matrix.XY = chunk2.Matrix.XY * ScaleMultiplier
			chunk2.Matrix.XZ = chunk2.Matrix.XZ * ScaleMultiplier
			chunk2.Matrix.YY = chunk2.Matrix.YY * ScaleMultiplier
			chunk2.Matrix.YZ = chunk2.Matrix.YZ * ScaleMultiplier
			chunk2.Matrix.ZZ = chunk2.Matrix.ZZ * ScaleMultiplier
		end
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Physics_Object) do
	ProcessPhysicsObject(chunk)
end

local Vector3Params = {
	["TRAN"] = true,
	["TRA\0"] = true,
}
local Vector2Params = {
	["TRAN"] = true,
	["TRA\0"] = true,
}
local Vector1Params = {
	["TRAN"] = true,
	["TRA\0"] = true,
}
local Float1Params = {
	["DRA\0"] = true,
	["SIZ\0"] = true,
	["SIZV"] = true,
	["WDT\0"] = true,
	["HGT\0"] = true,
	["DIST"] = true,
}
local function ProcessAnimation(AnimationChunk)
	for chunk in AnimationChunk:GetChunks(P3D.Identifiers.Animation_Group_List) do
		for chunk2 in chunk:GetChunks(P3D.Identifiers.Animation_Group) do
			for chunk3 in chunk2:GetChunks(P3D.Identifiers.Vector_3D_OF_Channel) do
				if Vector3Params[chunk3.Param] then
					for i=1,#chunk3.Values do
						local value = chunk3.Values[i]
						value.X = value.X * ScaleMultiplier
						value.Y = value.Y * ScaleMultiplier
						value.Z = value.Z * ScaleMultiplier
					end
				end
			end
			
			for chunk3 in chunk2:GetChunks(P3D.Identifiers.Vector_2D_OF_Channel) do
				if Vector2Params[chunk3.Param] then
					chunk3.Constants.X = chunk3.Constants.X * ScaleMultiplier
					chunk3.Constants.Y = chunk3.Constants.Y * ScaleMultiplier
					chunk3.Constants.Z = chunk3.Constants.Z * ScaleMultiplier
					for i=1,#chunk3.Values do
						local value = chunk3.Values[i]
						value.X = value.X * ScaleMultiplier
						value.Y = value.Y * ScaleMultiplier
					end
				end
			end
			
			for chunk3 in chunk2:GetChunks(P3D.Identifiers.Vector_1D_OF_Channel) do
				if Vector1Params[chunk3.Param] then
					chunk3.Constants.X = chunk3.Constants.X * ScaleMultiplier
					chunk3.Constants.Y = chunk3.Constants.Y * ScaleMultiplier
					chunk3.Constants.Z = chunk3.Constants.Z * ScaleMultiplier
					for i=1,#chunk3.Values do
						chunk3.Values[i] = chunk3.Values[i] * ScaleMultiplier
					end
				end
			end
			
			for chunk3 in chunk2:GetChunks(P3D.Identifiers.Float_1_Channel) do
				if Float1Params[chunk3.Param] then
					for i=1,#chunk3.Values do
						chunk3.Values[i] = chunk3.Values[i] * ScaleMultiplier
					end
				end
			end
		end
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Animation) do
	ProcessAnimation(chunk)
end

local function ProcessParticleSystemFactory(ParticleSystemFactoryChunk)
	for chunk in ParticleSystemFactoryChunk:GetChunks(P3D.Identifiers.Old_Sprite_Emitter) do
		for chunk2 in chunk:GetChunks(P3D.Identifiers.Old_Base_Emitter) do
			for i=1,#chunk2.Chunks do
				local chunk3 = chunk2.Chunks[i]
				for chunk4 in chunk3:GetChunks(P3D.Identifiers.Animation) do
					ProcessAnimation(chunk4)
				end
			end
		end
	end
end

for chunk in P3DFile:GetChunks(P3D.Identifiers.Particle_System_Factory) do
	ProcessParticleSystemFactory(chunk)
end

P3DFile:Output()