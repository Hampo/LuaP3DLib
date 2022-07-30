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

local function new(self, Version, ShaderName, PrimitiveType, VertexType, NumVertices, NumIndices, NumMatrices)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(ShaderName) == "string", "Arg #2 (ShaderName) must be a string.")
	assert(type(PrimitiveType) == "number", "Arg #3 (PrimitiveType) must be a number.")
	assert(type(VertexType) == "number", "Arg #4 (VertexType) must be a number.")
	assert(type(NumVertices) == "number", "Arg #5 (NumVertices) must be a number.")
	assert(type(NumIndices) == "number", "Arg #6 (NumIndices) must be a number.")
	assert(type(NumMatrices) == "number", "Arg #7 (NumMatrices) must be a number.")

	local Data = {
		Chunks = {},
		Version = {},
		ShaderName = {},
		PrimitiveType = {},
		VertexType = {},
		NumVertices = {},
		NumIndices = {},
		NumMatrices = {},
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldPrimitiveGroupP3DChunk = setmetatable(P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Primitive_Group), {__call = new})
P3D.OldPrimitiveGroupP3DChunk.new = new
P3D.OldPrimitiveGroupP3DChunk.PrimitiveTypes = {
	TriangleList = 0,
	TriangleStrip = 1,
	LineList = 2,
	LineStrip = 3
}
P3D.OldPrimitiveGroupP3DChunk.VertexTypes = {
	UVs = 1 << 0,
	UVs2 = 1 << 1,
	UVs3 = 1 << 2,
	UVs4 = 1 << 3,
	Normals = 1 << 4,
	Colours = 1 << 5,
	Matrices = 1 << 6,
	Weights = 1 << 7,
	Unknown = 1 << 8,
}
function P3D.OldPrimitiveGroupP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.ShaderName, chunk.PrimitiveType, chunk.VertexType, chunk.NumVertices, chunk.NumIndices, chunk.NumMatrices = string_unpack("<Is1IIIII", chunk.ValueStr)

	return chunk
end

function P3D.OldPrimitiveGroupP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local ShaderName = P3D.MakeP3DString(self.ShaderName)
	
	local headerLen = 12 + 4 + #ShaderName + 1 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIIs1IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, ShaderName, self.PrimitiveType, self.VertexType, self.NumVertices, self.NumIndices, self.NumMatrices) .. chunkData
end