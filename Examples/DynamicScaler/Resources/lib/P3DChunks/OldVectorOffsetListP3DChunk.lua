--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldVectorOffsetListP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Version, Offsets, Param)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Offsets) == "table", "Arg #2 (Offsets) must be a table")
	assert(type(Param) == "string", "Arg #3 (Param) must be a string")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Offsets = Offsets,
		Param = Param,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldVectorOffsetListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Vector_Offset_List)
P3D.OldVectorOffsetListP3DChunk.new = new
function P3D.OldVectorOffsetListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, num, chunk.Param, pos = string_unpack("<IIc4", chunk.ValueStr)
	
	chunk.Offsets = {}
	for i=1,num do
		local offset = {}
		offset.X, offset.Y, offset.Z, pos = string_unpack("<fff", chunk.ValueStr, pos)
		chunk.Offsets[i] = offset
	end
	
	return chunk
end

function P3D.OldVectorOffsetListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local offsetsN = #self.Offsets
	local offsets = {}
	for i=1,offsetsN do
		local offset = self.Offsets[i]
		offsets[i] = string_pack("<fff", offset.X, offset.Y, offset.Z)
	end
	local offsetsData = table_concat(offsets)
	
	local headerLen = 12 + 4 + 4 + 4 + offsetsN * 12
	return string_pack("<IIIIIc4", self.Identifier, headerLen, headerLen + #chunkData, self.Version, offsetsN, self.Param) .. offsetsData .. chunkData
end