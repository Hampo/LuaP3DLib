--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.ATCP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Entries)
	assert(type(Entries) == "table", "Arg #1 (Entries) must be a table")
	
	local Data = {
		Chunks = {},
		Entries = Entries
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ATCP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.ATC)
P3D.ATCP3DChunk.new = new
function P3D.ATCP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local count, pos = string_unpack("<I", chunk.ValueStr)
	
	local Entries = {}
	for i=1,count do
		local entry = {}
		entry.SoundResourceDataName, entry.Particle, entry.BreakableObject, entry.Friction, entry.Mass, entry.Elasticity, pos = string_unpack("<s1s1s1fff", chunk.ValueStr, pos)
		entry.SoundResourceDataName = P3D.CleanP3DString(entry.SoundResourceDataName)
		entry.Particle = P3D.CleanP3DString(entry.Particle)
		entry.BreakableObject = P3D.CleanP3DString(entry.BreakableObject)
		Entries[i] = entry
	end
	chunk.Entries = Entries
	
	return chunk
end

function P3D.ATCP3DChunk:AddEntry(SourceResourceDataName, Particle, BreakableObject, Friction, Mass, Elasticity)
	assert(type(SourceResourceDataName) == "string", "Arg #1 (SourceResourceDataName) must be a string")
	assert(type(Particle) == "string", "Arg #2 (Particle) must be a string")
	assert(type(BreakableObject) == "string", "Arg #3 (BreakableObject) must be a string")
	assert(type(Friction) == "number", "Arg #4 (Friction) must be a number")
	assert(type(Mass) == "number", "Arg #5 (Mass) must be a number")
	assert(type(Elasticity) == "number", "Arg #6 (Elasticity) must be a number")
	
	local newIndex = #self.Entries
	local newEntry = {
		SoundResourceDataName = SoundResourceDataName,
		Particle = Particle,
		BreakableObject = BreakableObject,
		Friction = Friction,
		Mass = Mass,
		Elasticity = Elasticity
	}
	self.Entries[newIndex + 1] = newEntry
	
	-- Note: Returns 0-based index as that's what the game expects for reference
	return newIndex, newEntry
end

function P3D.ATCP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local entryCount = #self.Entries
	local entries = {}
	for i=1,entryCount do
		local entry = self.Entries[i]
		entries[i] = string_pack("<s1s1s1fff", P3D.MakeP3DString(entry.SoundResourceDataName), P3D.MakeP3DString(entry.Particle), P3D.MakeP3DString(entry.BreakableObject), entry.Friction, entry.Mass, entry.Elasticity)
	end
	local entryData = table_concat(entries)
	
	local headerLen = 12 + 4 + #entryData
	return string_pack("<IIII", self.Identifier, headerLen, headerLen + #chunkData, entryCount) .. entryData .. chunkData
end