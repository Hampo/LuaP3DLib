--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
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

local function new(self, ParameterName, Value)
	assert(type(ParameterName) == "string", "Arg #1 (ParameterName) must be a string")
	assert(type(Value) == "table", "Arg #2 (Value) must be a table")
	
	local Data = {
		Chunks = {},
		ParameterName = ParameterName,
		Value = Value
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.GameAttributeVectorParameterP3DChunk = setmetatable(P3D.P3DChunk:newChildClass(P3D.Identifiers.Game_Attribute_Vector_Parameter), {__call = new})
P3D.GameAttributeVectorParameterP3DChunk.new = new
function P3D.GameAttributeVectorParameterP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Value = {}
	chunk.ParameterName, chunk.Value.X, chunk.Value.Y, chunk.Value.Z = string_unpack("<s1fff", chunk.ValueStr)
	
	return chunk
end

function P3D.GameAttributeVectorParameterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local ParameterName = P3D.MakeP3DString(self.ParameterName)
	
	local headerLen = 12 + #ParameterName + 1 + 12
	return string_pack("<IIIs1fff", self.Identifier, headerLen, headerLen + #chunkData, ParameterName, self.Value.X, self.Value.Y, self.Value.Z) .. chunkData
end