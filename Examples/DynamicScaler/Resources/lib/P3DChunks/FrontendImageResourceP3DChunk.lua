--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FrontendImageResourceP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Name, Version, Filename)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Filename) == "string", "Arg #3 (Filename) must be a string")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		Filename = Filename,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendImageResourceP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_Image_Resource)
P3D.FrontendImageResourceP3DChunk.new = new
function P3D.FrontendImageResourceP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.Filename = string_unpack("<s1Is1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.Filename = P3D.CleanP3DString(chunk.Filename)
	
	return chunk
end

function P3D.FrontendImageResourceP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local Filename = P3D.MakeP3DString(self.Filename)
	
	local headerLen = 12 + #Name + 1 + 4 + #Filename + 1
	return string_pack("<IIIs1Is1", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, Filename) .. chunkData
end