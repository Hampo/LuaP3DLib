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

local function new(self, Version, ShaderName, PrimitiveType, NumVertices, NumIndices, NumMatrices)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(ShaderName) == "string", "Arg #2 (ShaderName) must be a string.")
	assert(type(PrimitiveType) == "number", "Arg #3 (PrimitiveType) must be a number.")
	assert(type(NumVertices) == "number", "Arg #4 (NumVertices) must be a number.")
	assert(type(NumIndices) == "number", "Arg #5 (NumIndices) must be a number.")
	assert(type(NumMatrices) == "number", "Arg #6 (NumMatrices) must be a number.")

	local Data = {
		Chunks = {},
		Version = {},
		ShaderName = {},
		PrimitiveType = {},
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
	UVs = 1,
	UVs2 = 2,
	UVs3 = 3,
	UVs4 = 4,
	UVs5 = 5,
	UVs6 = 6,
	UVs7 = 7,
	UVs8 = 8,
	Normals = 1 << 4,
	Colours = 1 << 5,
	Specular = 1 << 6,
	Matrices = 1 << 7,
	Weights = 1 << 8,
	Position = 1 << 13,
}
function P3D.OldPrimitiveGroupP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num
	chunk.Version, chunk.ShaderName, chunk.PrimitiveType, num, chunk.NumVertices, chunk.NumIndices, chunk.NumMatrices = string_unpack("<Is1IIIII", chunk.ValueStr)

	return chunk
end

function P3D.OldPrimitiveGroupP3DChunk:GetVertexType()
	local vertexType = 0
	
	local uvN = 0
	for i=1,#self.Chunks do
		local identifier = self.Chunks[i].Identifier
		if identifier == P3D.Identifiers.UV_List then
			uvN = uvN + 1
		elseif identifier == P3D.Identifiers.Packed_Normal_List or identifier == P3D.Identifiers.Normal_List then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Normals
		elseif identifier == P3D.Identifiers.Colour_List then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Colours
		elseif identifier == P3D.Identifiers.Matrix_List or identifier == P3D.Identifiers.Matrix_Palette then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Matrices
		elseif identifier == P3D.Identifiers.Weight_List then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Weights
		elseif identifier == P3D.Identifiers.Position_List then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Position
		end
	end
	if uvN > 0 then
		if uvN == 1 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs
		elseif uvN == 2 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs2
		elseif uvN == 3 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs3
		elseif uvN == 4 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs4
		elseif uvN == 5 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs5
		elseif uvN == 6 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs6
		elseif uvN == 7 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs7
		elseif uvN == 8 then
			vertexType = vertexType | P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs8
		else
			error("Too manu UVs")
		end
	end
	
	return vertexType
end

function P3D.OldPrimitiveGroupP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local ShaderName = P3D.MakeP3DString(self.ShaderName)
	
	local headerLen = 12 + 4 + #ShaderName + 1 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIIs1IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, ShaderName, self.PrimitiveType, self:GetVertexType(), self.NumVertices, self.NumIndices, self.NumMatrices) .. chunkData
end