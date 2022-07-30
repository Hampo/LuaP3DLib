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

local function new(self, Name, CellCount, Minimum, Maximum)
	assert(type("Name") == "string", "Arg #1 (Name) must be a string")
	assert(type("CellCount") == "table", "Arg #2 (CellCount) must be a table")
	assert(type("Minimum") == "table", "Arg #3 (Minimum) must be a table")
	assert(type("Maximum") == "table", "Arg #4 (Maximum) must be a table")
	
	local Data = {
		Chunks = {},
		Name = Name,
		CellCount = CellCount,
		Minimum = Minimum,
		Maximum = Maximum
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.GridP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Grid)
getmetatable(P3D.GridP3DChunk).__call = new
P3D.GridP3DChunk.new = new
function P3D.GridP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.CellCount = {}
	chunk.Minimum = {}
	chunk.Maximum = {}
	chunk.Name, chunk.CellCount.X, chunk.CellCount.Y, chunk.Minimum.X, chunk.Minimum.Y, chunk.Minimum.Z, chunk.Maximum.X, chunk.Maximum.Y, chunk.Maximum.Z = string_unpack("<s1IIffffff", chunk.ValueStr)
	
	return chunk
end

function P3D.GridP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + 8 + 12 + 12
	return string_pack("<IIIs1IIffffff", self.Identifier, headerLen, headerLen + #chunkData, self.Name, self.CellCount.X, self.CellCount.Y, self.Minimum.X, self.Minimum.Y, self.Minimum.Z, self.Maximum.X, self.Maximum.Y, self.Maximum.Z) .. chunkData
end