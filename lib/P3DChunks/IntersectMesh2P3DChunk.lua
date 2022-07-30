--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_pack = table.pack
local table_unpack = table.unpack

local assert = assert
local type = type

local function new(self, SurfaceType)
	assert(type(SurfaceType) == "string", "Arg #1 (SurfaceType) must be a string")
	
	local Data = {
		Chunks = {},
		SurfaceType = SurfaceType
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.IntersectMesh2P3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Intersect_Mesh_2)
getmetatable(P3D.IntersectMesh2P3DChunk).__call = new
P3D.IntersectMesh2P3DChunk.new = new
function P3D.IntersectMesh2P3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.SurfaceType = string_unpack("<I", chunk.ValueStr)
	
	return chunk
end

function P3D.IntersectMesh2P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4
	return string_pack("<IIII", self.Identifier, headerLen, headerLen + #chunkData, self.SurfaceType) .. chunkData
end