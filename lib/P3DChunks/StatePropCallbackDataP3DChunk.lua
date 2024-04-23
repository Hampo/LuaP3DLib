--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.StatePropCallbackDataP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_reverse = string.reverse
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Name, EventEnum, OnFrame)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(EventEnum) == "number", "Arg #2 (EventEnum) must be a number.")
	assert(type(OnFrame) == "number", "Arg #3 (OnFrame) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		EventEnum = EventEnum,
		OnFrame = OnFrame,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.StatePropCallbackDataP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.State_Prop_Callback_Data)
P3D.StatePropCallbackDataP3DChunk.new = new
function P3D.StatePropCallbackDataP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.EventEnum, chunk.OnFrame = string_unpack(Endian .. "s1if", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.StatePropCallbackDataP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4
	return string_pack(self.Endian .. "IIIs1if", self.Identifier, headerLen, headerLen + #chunkData, Name, self.EventEnum, self.OnFrame) .. chunkData
end