--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.CollisionOrientedBoundingBoxP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, HalfExtents)
	assert(type(HalfExtents) == "table", "Arg #1 (HalfExtents) must be a table")
	
	local Data = {
		Chunks = {},
		HalfExtents = HalfExtents
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionOrientedBoundingBoxP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Oriented_Bounding_Box)
P3D.CollisionOrientedBoundingBoxP3DChunk.new = new
function P3D.CollisionOrientedBoundingBoxP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.HalfExtents = {}
	chunk.HalfExtents.X, chunk.HalfExtents.Y, chunk.HalfExtents.Z = string_unpack("<fff", chunk.ValueStr)
	
	return chunk
end

function P3D.CollisionOrientedBoundingBoxP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 12
	return string_pack("<IIIfff", self.Identifier, headerLen, headerLen + #chunkData, self.HalfExtents.X, self.HalfExtents.Y, self.HalfExtents.Z) .. chunkData
end