--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.Vector3DOFChannelP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Version, Param, Frames, Values)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Param) == "string", "Arg #2 (Param) must be a string")
	assert(type(Frames) == "table", "Arg #3 (Frames) must be a table")
	assert(type(Values) == "table", "Arg #4 (Values) must be a table")
	assert(#Frames == #Values, "Arg #3 (Frames) and Arg #4 (Values) must be of the same length")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Param = Param,
		Frames = Frames,
		Values = Values
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.Vector3DOFChannelP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Vector_3D_OF_Channel)
P3D.Vector3DOFChannelP3DChunk.new = new
function P3D.Vector3DOFChannelP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, chunk.Param, num, pos = string_unpack("<Ic4I", chunk.ValueStr)
	
	chunk.Frames = {string_unpack("<" .. string_rep("H", num), chunk.ValueStr, pos)}
	pos = chunk.Frames[num + 1]
	chunk.Frames[num + 1] = nil
	
	chunk.Values = {}
	for i=1,num do
		local value = {}
		value.X, value.Y, value.Z, pos = string_unpack("<fff", chunk.ValueStr, pos)
		chunk.Values[i] = value
	end
	
	return chunk
end

function P3D.Vector3DOFChannelP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local num = #self.Frames
	local values = {}
	for i=1,num do
		values[i] = self.Frames[i]
	end
	for i=1,num do
		local value = self.Values[i]
		values[num + i] = string_pack("<fff", value.X, value.Y, value.Z)
	end
	
	local headerLen = 12 + 4 + 4 + 4 + num * 2 + num * 12
	return string_pack("<IIIIc4I" .. string_rep("H", num) .. string_rep("c12", num), self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.Param, num, table_unpack(values)) .. chunkData
end