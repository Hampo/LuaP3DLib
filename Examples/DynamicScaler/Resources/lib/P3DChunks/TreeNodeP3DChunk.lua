--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.TreeNodeP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, NumChildren, ParentOffset)
	assert(type(NumChildren) == "number", "Arg #1 (NumChildren) must be a number.")
	assert(type(ParentOffset) == "number", "Arg #2 (ParentOffset) must be a number.")

	local Data = {
		Chunks = {},
		NumChildren = NumChildren,
		ParentOffset = ParentOffset,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.TreeNodeP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Tree_Node)
P3D.TreeNodeP3DChunk.new = new
function P3D.TreeNodeP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.NumChildren, chunk.ParentOffset = string_unpack("<Ii", chunk.ValueStr)

	return chunk
end

function P3D.TreeNodeP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4
	return string_pack("<IIIIi", self.Identifier, headerLen, headerLen + #chunkData, self.NumChildren, self.ParentOffset) .. chunkData
end