--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Version)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	
	local Data = {
		Chunks = {},
		Version = Version,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimationGroupListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Animation_Group_List)
P3D.AnimationGroupListP3DChunk.new = new
function P3D.AnimationGroupListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version = string_unpack("<I", chunk.ValueStr)
	
	return chunk
end

function P3D.AnimationGroupListP3DChunk:__tostring()
	local chunks = {}
	local chunkN = #self.Chunks
	for i=1,chunkN do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4
	return string_pack("<IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, chunkN) .. chunkData
end