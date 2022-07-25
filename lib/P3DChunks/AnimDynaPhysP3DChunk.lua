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

local function new(self, Name, Unknown, RenderOrder)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Unknown) == "number", "Arg #2 (Unknown) must be a number")
	assert(type(RenderOrder) == "number", "Arg #3 (RenderOrder) must be a number")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Unknown = Unknown,
		RenderOrder = RenderOrder,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimDynaPhysP3DChunk = setmetatable(P3D.P3DChunk:newChildClass(P3D.Identifiers.Anim_Dyna_Phys), {__call = new})
P3D.AnimDynaPhysP3DChunk.new = new
function P3D.AnimDynaPhysP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Unknown, chunk.RenderOrder = string_unpack("<s1II", chunk.ValueStr)
	
	return chunk
end

function P3D.AnimDynaPhysP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4
	return string_pack("<IIIs1II", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Unknown, self.RenderOrder) .. chunkData
end