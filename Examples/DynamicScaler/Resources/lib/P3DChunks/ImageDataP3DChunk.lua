--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.ImageDataP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, ImageData)
	assert(type(ImageData) == "string", "Arg #1 (ImageData) must be a string")
	
	local Data = {
		Chunks = {},
		ImageData = ImageData
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ImageDataP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Image_Data)
P3D.ImageDataP3DChunk.new = new
function P3D.ImageDataP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.ImageData = string_unpack("<s4", chunk.ValueStr)
	
	return chunk
end

function P3D.ImageDataP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + #self.ImageData + 4
	return string_pack("<IIIs4", self.Identifier, headerLen, headerLen + #chunkData, self.ImageData) .. chunkData
end