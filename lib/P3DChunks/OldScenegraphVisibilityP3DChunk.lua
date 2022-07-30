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

local function new(self, Name, IsVisible)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(IsVisible) == "number", "Arg #2 (IsVisible) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		IsVisible = IsVisible,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldScenegraphVisibilityP3DChunk = setmetatable(P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Scenegraph_Visibility), {__call = new})
P3D.OldScenegraphVisibilityP3DChunk.new = new
function P3D.OldScenegraphVisibilityP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num
	chunk.Name, num, chunk.IsVisible = string_unpack("<s1II", chunk.ValueStr)

	return chunk
end

function P3D.OldScenegraphVisibilityP3DChunk:__tostring()
	local chunks = {}
	local chunksN = #self.Chunks
	for i=1,chunksN do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4
	return string_pack("<IIIs1II", self.Identifier, headerLen, headerLen + #chunkData, Name, chunksN, self.IsVisible) .. chunkData
end