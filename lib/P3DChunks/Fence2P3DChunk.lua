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

local function new(self, Start, End, Normal)
	assert(type("Start") == "table", "Arg #1 (Start) must be a table")
	assert(type("End") == "table", "Arg #2 (End) must be a table")
	assert(type("Normal") == "table", "Arg #3 (Normal) must be a table")
	
	local Data = {
		Chunks = {},
		Start = Start,
		End = End,
		Normal = Normal
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.Fence2P3DChunk = setmetatable(P3D.P3DChunk:newChildClass(P3D.Identifiers.Fence_2), {__call = new})
P3D.Fence2P3DChunk.new = new
function P3D.Fence2P3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Start = {}
	chunk.End = {}
	chunk.Normal = {}
	chunk.Start.X, chunk.Start.Y, chunk.Start.Z, chunk.Start.X, chunk.Start.Y, chunk.Start.Z, chunk.Start.X, chunk.Start.Y, chunk.Start.Z = string_unpack("<fffffffff", chunk.ValueStr)
	
	return chunk
end

function P3D.Fence2P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 12 + 12 + 12
	return string_pack("<IIIfffffffff", self.Identifier, headerLen, headerLen + #chunkData, self.Start.X, self.Start.Y, self.Start.Z, self.Start.X, self.Start.Y, self.Start.Z, self.Start.X, self.Start.Y, self.Start.Z) .. chunkData
end