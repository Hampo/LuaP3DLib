--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.Locator3P3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Name, Version, Position)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Position) == "table", "Arg #3 (Position) must be a table")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		Position = Position
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.Locator3P3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Locator_3)
P3D.Locator3P3DChunk.new = new
function P3D.Locator3P3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Position = {}
	chunk.Name, chunk.Version, chunk.Position.X, chunk.Position.Y, chunk.Position.Z = string_unpack("<s1Ifff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.Locator3P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 12
	return string_pack("<IIIs1Ifff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Position.X, self.Position.Y, self.Position.Z) .. chunkData
end