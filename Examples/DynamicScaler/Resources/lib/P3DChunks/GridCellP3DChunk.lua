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

local function new(self, Cell, Entities)
	assert(type("Cell") == "table", "Arg #1 (Cell) must be a table")
	assert(type("Entities") == "table", "Arg #2 (Entities) must be a table")
	
	local Data = {
		Chunks = {},
		Cell = Cell,
		Entities = Entities,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.GridCellP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Grid_Cell)
P3D.GridCellP3DChunk.new = new
function P3D.GridCellP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Cell = {}
	chunk.Cell.X, chunk.Cell.Y, num, pos = string_unpack("<III", chunk.ValueStr)
	
	local Entities = {}
	for i=1,num do
		local Entity = {}
		
		Entity.Transform = {}
		Entity.Type, Entity.Name, Entity.Unknown, Entity.Index, Entity.Transform.M11, Entity.Transform.M12, Entity.Transform.M13, Entity.Transform.M14, Entity.Transform.M21, Entity.Transform.M22, Entity.Transform.M23, Entity.Transform.M24, Entity.Transform.M31, Entity.Transform.M32, Entity.Transform.M33, Entity.Transform.M34, Entity.Transform.M41, Entity.Transform.M42, Entity.Transform.M43, Entity.Transform.M44, pos = string_unpack("<Is1s1Iffffffffffffffff", chunk.ValueStr, pos)
		Entity.Name = P3D.CleanP3DString(Entity.Name)
		Entity.Unknown = P3D.CleanP3DString(Entity.Unknown)
		
		Entities[i] = Entity
	end
	chunk.Entities = Entities
	
	return chunk
end

function P3D.GridCellP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local entities = {}
	local entitiesN = #self.Entities
	for i=1,entitiesN do
		local Entity = self.Entities[i]
		local EntName = P3D.MakeP3DString(Entity.Name)
		local EntUnknown = P3D.MakeP3DString(Entity.Unknown)
		entities[i] = string_pack("<Is1s1Iffffffffffffffff", Entity.Type, EntName, EntUnknown, Entity.Index, Entity.Transform.M11, Entity.Transform.M12, Entity.Transform.M13, Entity.Transform.M14, Entity.Transform.M21, Entity.Transform.M22, Entity.Transform.M23, Entity.Transform.M24, Entity.Transform.M31, Entity.Transform.M32, Entity.Transform.M33, Entity.Transform.M34, Entity.Transform.M41, Entity.Transform.M42, Entity.Transform.M43, Entity.Transform.M44)
	end
	local entitiesData = table_concat(entities)
	
	local headerLen = 12 + 4 + 4 + 4 + #entitiesData
	return string_pack("<IIIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Cell.X, self.Cell.Y, entitiesN) .. entitiesData .. chunkData
end