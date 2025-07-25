--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FollowCameraDataP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Index, Rotation, Elevation, Magnitude, TargetOffset)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number")
	assert(type(Rotation) == "number", "Arg #2 (Rotation) must be a number")
	assert(type(Elevation) == "number", "Arg #3 (Elevation) must be a number")
	assert(type(Magnitude) == "number", "Arg #4 (Magnitude) must be a number")
	assert(type(TargetOffset) == "table", "Arg #5 (TargetOffset) must be a table")
	
	local Data = {
		Chunks = {},
		Index = Index,
		Rotation = Rotation,
		Elevation = Elevation,
		Magnitude = Magnitude,
		TargetOffset = TargetOffset,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FollowCameraDataP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Follow_Camera_Data)
P3D.FollowCameraDataP3DChunk.new = new
function P3D.FollowCameraDataP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.TargetOffset = {}
	chunk.Index, chunk.Rotation, chunk.Elevation, chunk.Magnitude, chunk.TargetOffset.X, chunk.TargetOffset.Y, chunk.TargetOffset.Z = string_unpack("<Iffffff", chunk.ValueStr)
	
	return chunk
end

function P3D.FollowCameraDataP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4 + 4 + 4 + 12
	return string_pack("<IIIIffffff", self.Identifier, headerLen, headerLen + #chunkData, self.Index, self.Rotation, self.Elevation, self.Magnitude, self.TargetOffset.X, self.TargetOffset.Y, self.TargetOffset.Z) .. chunkData
end