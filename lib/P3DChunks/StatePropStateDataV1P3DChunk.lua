--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.StatePropStateDataV1P3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, AutoTransition, OutState, OutFrame)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(AutoTransition) == "number", "Arg #2 (AutoTransition) must be a number.")
	assert(type(OutState) == "number", "Arg #3 (OutState) must be a number.")
	assert(type(OutFrame) == "number", "Arg #4 (OutFrame) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		AutoTransition = AutoTransition,
		OutState = OutState,
		OutFrame = OutFrame,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.StatePropStateDataV1P3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.State_Prop_State_Data_V1)
P3D.StatePropStateDataV1P3DChunk.new = new
function P3D.StatePropStateDataV1P3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local numDrawables, numFrameControllers, numEvents, numCallbacks
	chunk.Name, chunk.AutoTransition, chunk.OutState, numDrawables, numFrameControllers, numEvents, numCallbacks, chunk.OutFrame = string_unpack(Endian .. "s1IIIIIIf", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.StatePropStateDataV1P3DChunk:GetNumDrawables()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.State_Prop_Visibilities_Data then
			n = n + 1
		end
	end
	return n
end

function P3D.StatePropStateDataV1P3DChunk:GetNumFrameControllers()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.State_Prop_Frame_Controller_Data then
			n = n + 1
		end
	end
	return n
end

function P3D.StatePropStateDataV1P3DChunk:GetNumEvents()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.State_Prop_Event_Data then
			n = n + 1
		end
	end
	return n
end

function P3D.StatePropStateDataV1P3DChunk:GetNumCallbacks()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.State_Prop_Callback_Data then
			n = n + 1
		end
	end
	return n
end

function P3D.StatePropStateDataV1P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIs1IIIIIIf", self.Identifier, headerLen, headerLen + #chunkData, Name, self.AutoTransition, self.OutState, self:GetNumDrawables(), self:GetNumFrameControllers(), self:GetNumEvents(), self:GetNumCallbacks(), self.OutFrame) .. chunkData
end