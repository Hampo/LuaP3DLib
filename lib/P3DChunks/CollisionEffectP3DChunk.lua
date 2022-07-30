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

local function new(self, Name, FlatEnd)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(FlatEnd) == "number", "Arg #2 (FlatEnd) must be a number")
	
	local Data = {
		Chunks = {},
		Name = Name,
		FlatEnd = FlatEnd
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionEffectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Effect)
getmetatable(P3D.CollisionEffectP3DChunk).__call = new
P3D.CollisionEffectP3DChunk.new = new
function P3D.CollisionEffectP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Unknown, chunk.Unknown2, chunk.SoundResourceDataName = string_unpack("<IIs1", chunk.ValueStr)
	
	return chunk
end

function P3D.CollisionEffectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local SoundResourceDataName = P3D.MakeP3DString(self.SoundResourceDataName)
	
	local headerLen = 12 + 4 + 4 + #SoundResourceDataName + 1
	return string_pack("<IIIIIs1", self.Identifier, headerLen, headerLen + #chunkData, self.Unknown, self.Unknown2, SoundResourceDataName) .. chunkData
end