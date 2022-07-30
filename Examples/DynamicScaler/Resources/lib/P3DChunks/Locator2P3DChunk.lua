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

local function new(self, Name, Data2)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Data2) == "string", "Arg #2 (Data) must be a string")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Data = Data2
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.Locator2P3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Locator_2)
P3D.Locator2P3DChunk.new = new
function P3D.Locator2P3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local pos
	chunk.Name, pos = string_unpack("<s1", chunk.ValueStr)
	chunk.Data = chunk.ValueStr:sub(pos)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.Locator2P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + #self.Data
	return string_pack("<IIIs1", self.Identifier, headerLen, headerLen + #chunkData, Name) .. self.Data .. chunkData
end