--[[
CREDITS:
	Proddy#7272				- P3D Class System
	EnAppelsin#9506			- Original P3D Lua Idea
	luca$ Cardellini#5473	- P3D Chunk Structures
]]

P3D = {}
P3D.Identifiers = {
	Anim = 0x3F0000C, -- Done
	Animated_Object = 0x20001, -- Done
	Animated_Object_Animation = 0x20002, -- Done
	Animated_Object_Factory = 0x20000, -- Done
	Animation = 0x121000, -- Done
	Animation_Channel_Count = 0x121007, -- TODO
	Animation_Group = 0x121001, -- Done
	Animation_Group_List = 0x121002, -- Done
	Animation_Header = 0x121006, -- TODO
	Animation_Size = 0x121004, -- Done
	Animation_Sync_Frame = 0x121402, -- TODO
	Anim_Coll = 0x3F00008, -- Done
	Anim_Dyna_Phys = 0x3F0000E, -- Done
	Anim_Dyna_Phys_Wrapper = 0x3F0000F, -- Done
	Anim_Obj_Wrapper = 0x3F00010, -- Done
	ATC = 0x3000602, -- Done
	Billboard_Quad_Group = 0x17006, -- TODO
	Black_Magic = 0x1025, -- Done
	Boolean_Channel = 0x121108, -- Done
	Bounding_Box = 0x10003, -- Done
	Bounding_Sphere = 0x10004, -- Done
	Breakable_Object = 0x3001000, -- Done
	Camera = 0x2200, -- Done
	Channel_Interpolation_Mode = 0x121110, -- Done
	Collision_Axis_Aligned_Bounding_Box = 0x7010006, -- Done
	Collision_Cylinder = 0x7010003, -- Done
	Collision_Effect = 0x3000600, -- Done
	Collision_Object = 0x7010000, -- Done
	Collision_Object_Attribute = 0x7010023, -- Done
	Collision_Oriented_Bounding_Box = 0x7010004, -- Done
	Collision_Sphere = 0x7010002, -- Done
	Collision_Vector = 0x7010007, -- Done
	Collision_Volume = 0x7010001, -- Done
	Collision_Volume_Owner = 0x7010021, -- Done
	Collision_Volume_Owner_Name = 0x7010022, -- Done
	Collision_Wall = 0x7010005, -- Done
	Colour_Channel = 0x121109, -- Done
	Colour_List = 0x10008, -- Done
	Composite_Drawable = 0x4512, -- Done
	Composite_Drawable_2 = 0x123000, -- TODO
	Composite_Drawable_Effect = 0x4518, -- Done
	Composite_Drawable_Effect_List = 0x4517, -- Done
	Composite_Drawable_Primitive = 0x123001, -- TODO
	Composite_Drawable_Prop = 0x4516, -- Done
	Composite_Drawable_Prop_List = 0x4514, -- Done
	Composite_Drawable_Skin = 0x4515, -- Done
	Composite_Drawable_Skin_List = 0x4513, -- Done
	Composite_Drawable_Sort_Order = 0x4519, -- Done
	Compressed_Quaternion_Channel = 0x121111, -- Done
	Dyna_Phys = 0x3F00002, -- Done
	Entity_Channel = 0x121107, -- Done
	Export_Info = 0x7030, -- Done
	Export_Info_Named_Integer = 0x7032, -- Done
	Export_Info_Named_String = 0x7031, -- Done
	Expression = 0x21000, -- TODO
	Expression_Group = 0x21001, -- TODO
	Expression_Mixer = 0x21002, -- TODO
	Fence = 0x3F00007, -- TODO
	Fence_2 = 0x3000000, -- TODO
	Float_1_Channel = 0x121100, -- TODO
	Float_2_Channel = 0x121101, -- TODO
	Follow_Camera_Data = 0x3000100, -- TODO
	Frame_Controller = 0x121201, -- TODO
	Frontend_Group = 0x18004, -- TODO
	Frontend_Image_Resource = 0x18100, -- TODO
	Frontend_Language = 0x1800E, -- TODO
	Frontend_Layer = 0x18003, -- TODO
	Frontend_Multi_Sprite = 0x18006, -- TODO
	Frontend_Multi_Text = 0x18007, -- TODO
	Frontend_Page = 0x18002, -- TODO
	Frontend_Polygon = 0x18009, -- TODO
	Frontend_Project = 0x18000, -- TODO
	Frontend_Pure3D_Object = 0x18008, -- TODO
	Frontend_Pure3D_Resource = 0x18101, -- TODO
	Frontend_Screen = 0x18001, -- TODO
	Frontend_String_Hard_Coded = 0x1800C, -- TODO
	Frontend_String_Text_Bible = 0x1800B, -- TODO
	Frontend_Text_Bible = 0x1800D, -- TODO
	Frontend_Text_Bible_Resource = 0x18105, -- TODO
	Frontend_Text_Style_Resource = 0x18104, -- TODO
	Game_Attr = 0x12000, -- TODO
	Game_Attribute_Integer_Parameter = 0x12001, -- TODO
	Grid = 0x1000, -- TODO
	Grid_Cell = 0x1001, -- TODO
	History = 0x7000, -- TODO
	Image = 0x19001, -- TODO
	Image_2 = 0x3510, -- TODO
	Image_Data = 0x19002, -- TODO
	Image_Data_2 = 0x3511, -- TODO
	Index_List = 0x1000A, -- TODO
	Instance_List = 0x3000008, -- Done
	Inst_Particle_System = 0x3001001, -- TODO
	Inst_Stat_Entity = 0x3F00009, -- Done
	Inst_Stat_Phys = 0x3F0000A, -- Done
	Integer_Channel = 0x12110E, -- TODO
	Intersect = 0x3F00003, -- TODO
	Intersection = 0x3000004, -- TODO
	Intersect_Mesh = 0x1008, -- TODO
	Intersect_Mesh_2 = 0x1009, -- TODO
	Lens_Flare = 0x3F0000D, -- TODO
	Light = 0x13000, -- TODO
	Light_Direction = 0x13001, -- TODO
	Light_Group = 0x2380, -- TODO
	Light_Position = 0x13002, -- TODO
	Light_Shadow = 0x13004, -- TODO
	Locator = 0x3000005, -- Done
	Locator_2 = 0x1003, -- Done
	Locator_3 = 0x14000, -- TODO
	Locator_Counts = 0x1023, -- TODO
	Locator_Matrix = 0x300000C, -- TODO
	Matrix_List = 0x1000B, -- TODO
	Matrix_Palette = 0x1000D, -- TODO
	Mesh = 0x10000, -- TODO
	Mesh_Stats = 0x1001D, -- TODO
	Multi_Controller = 0x48A0, -- TODO
	Multi_Controller_2 = 0x121202, -- TODO
	Multi_Controller_Tracks = 0x48A1, -- TODO
	Normal_List = 0x10006, -- TODO
	Old_Base_Emitter = 0x15805, -- TODO
	Old_Billboard_Display_Info = 0x17003, -- TODO
	Old_Billboard_Perspective_Info = 0x17004, -- TODO
	Old_Billboard_Quad = 0x17001, -- TODO
	Old_Billboard_Quad_Group = 0x17002, -- TODO
	Old_Emitter_Animation = 0x15809, -- TODO
	Old_Expression_Offsets = 0x10018, -- TODO
	Old_Frame_Controller = 0x121200, -- TODO
	Old_Generator_Animation = 0x1580A, -- TODO
	Old_Offset_List = 0x1000E, -- TODO
	Old_Particle_Animation = 0x15808, -- TODO
	Old_Particle_Instancing_Info = 0x1580B, -- TODO
	Old_Primitive_Group = 0x10002, -- TODO
	Old_Scenegraph_Branch = 0x120102, -- TODO
	Old_Scenegraph_Drawable = 0x120107, -- TODO
	Old_Scenegraph_Light_Group = 0x120109, -- TODO
	Old_Scenegraph_Root = 0x120101, -- TODO
	Old_Scenegraph_Sort_Order = 0x12010A, -- TODO
	Old_Scenegraph_Transform = 0x120103, -- TODO
	Old_Scenegraph_Visibility = 0x120104, -- TODO
	Old_Sprite_Emitter = 0x15806, -- TODO
	Old_Vector_Offset_List = 0x121301, -- TODO
	Old_Vertex_Anim_Key_Frame = 0x121304, -- TODO
	Packed_Normal_List = 0x10010, -- TODO
	Particle_Point_Generator = 0x15B00, -- TODO
	Particle_System = 0x15000, -- Done
	--Particle_System = 0x1580C, -- TODO
	Particle_System_2 = 0x15801, -- TODO
	Particle_System_Factory = 0x15800, -- TODO
	Path = 0x300000B, -- TODO
	Ph = 0xC111, -- TODO
	Physics_Inertia_Matrix = 0x7011001, -- TODO
	Physics_Joint = 0x7011020, -- TODO
	Physics_Object = 0x7011000, -- TODO
	Physics_Vector = 0x7011002, -- TODO
	Ph_Axis_Aligned_Bounding_Box = 0xC007, -- TODO
	Ph_Cylinder = 0xC004, -- TODO
	Ph_Inertia_Matrix = 0xC001, -- TODO
	Ph_Oriented_Bounding_Box = 0xC005, -- TODO
	Ph_Sphere = 0xC003, -- TODO
	Ph_Vector = 0xC010, -- TODO
	Ph_Volume = 0xC002, -- TODO
	Position_List = 0x10005, -- TODO
	Primitive_Group = 0x10020, -- TODO
	Primitive_Group_Memory_Image_Index = 0x10013, -- TODO
	Primitive_Group_Memory_Image_Vertex = 0x10012, -- TODO
	Primitive_Group_Memory_Image_Vertex_Description = 0x10014, -- TODO
	Quaternion_Channel = 0x121105, -- TODO
	Render_Status = 0x10017, -- TODO
	Road = 0x3000003, -- TODO
	Road_2 = 0x1005, -- Done
	Road_Data_Segment = 0x3000009, -- Done
	Road_Segment = 0x3000002, -- TODO
	Root = 0xFF443350, -- TODO
	Scenegraph = 0x120100, -- Done
	Scenegraph_Branch = 0x12010C, -- TODO
	Scenegraph_Drawable = 0x12010F, -- TODO
	Scenegraph_Root = 0x12010B, -- TODO
	Scenegraph_Transform = 0x12010D, -- TODO
	Set = 0x3000110, -- TODO
	Shader = 0x11000, -- TODO
	Shader_Colour_Parameter = 0x11005, -- TODO
	Shader_Float_Parameter = 0x11004, -- TODO
	Shader_Integer_Parameter = 0x11003, -- TODO
	Shader_Texture_Parameter = 0x11002, -- TODO
	Skeleton = 0x4500, -- TODO
	Skeleton_2 = 0x23000, -- Done
	Skeleton_Joint = 0x4501, -- TODO
	Skeleton_Joint_2 = 0x23001, -- Done
	Skeleton_Joint_Bone_Preserve = 0x4504, -- TODO
	Skeleton_Joint_Mirror_Map = 0x4503, -- TODO
	Skeleton_Limb = 0x23003, -- TODO
	Skeleton_Partition = 0x23002, -- TODO
	Skin = 0x10001, -- TODO
	Sort_Order = 0x122000, -- TODO
	Spline = 0x3000007, -- TODO
	Sprite = 0x19005, -- TODO
	Sprite_Particle_Emitter = 0x15900, -- TODO
	State_Prop_Callback_Data = 0x8020005, -- TODO
	State_Prop_Data_V1 = 0x8020000, -- TODO
	State_Prop_Event_Data = 0x8020004, -- TODO
	State_Prop_Frame_Controller_Data = 0x8020003, -- TODO
	State_Prop_State_Data_V1 = 0x8020001, -- TODO
	State_Prop_Visibilities_Data = 0x8020002, -- TODO
	Static_Entity = 0x3F00000, -- Done
	Static_Phys = 0x3F00001, -- Done
	Surface_Type_List = 0x300000E, -- TODO
	Texture = 0x19000, -- TODO
	Texture_2 = 0x3500, -- TODO
	Texture_Animation = 0x3520, -- Done
	Texture_Font = 0x22000, -- TODO
	Texture_Glyph_List = 0x22001, -- TODO
	Tree = 0x3F00004, -- TODO
	Tree_Node = 0x3F00005, -- TODO
	Tree_Node_2 = 0x3F00006, -- TODO
	Trigger_Volume = 0x3000006, -- Done
	Trigger_Volume_2 = 0x1004, -- Done
	UV_List = 0x10007, -- TODO
	Vector_1D_OF_Channel = 0x121102, -- TODO
	Vector_2D_OF_Channel = 0x121103, -- TODO
	Vector_3D_OF_Channel = 0x121104, -- TODO
	Vertex_Compression_Hint = 0x10021, -- TODO
	Vertex_Shader = 0x10011, -- TODO
	Walker_Camera_Data = 0x3000101, -- TODO
	Weight_List = 0x1000C, -- TODO
	World_Sphere = 0x3F0000B, -- TODO
}
P3D.IdentifiersLookup = {}
P3D.IdentifierIds = {}
local IdentifierIdsN = 0
for k,v in pairs(P3D.Identifiers) do
	IdentifierIdsN = IdentifierIdsN + 1
	P3D.IdentifierIds[IdentifierIdsN] = v
	if P3D.IdentifiersLookup[v] then print(k) end
	P3D.IdentifiersLookup[v] = k
end

P3D.ChunkClasses = {}

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_pack = table.pack
local table_unpack = table.unpack

local assert = assert
local type = type

function P3D.MakeP3DString(str)
	if str == nil then return nil end
	local diff = #str & 3
	if diff ~= 0 then
		str = str .. string_rep("\0", 4 - diff)
	end
	return str
end

function P3D.CleanP3DString(str)
	if str == nil then return nil end
	local strLen = str:len()
	if strLen == 0 then return str end
	local null = str:find("\0", 1, true)
	if null == nil then return str end
	return str:sub(1, null-1)
end

local function DecompressBlock(Source, Length, SourceIndex)
	local Written = 0
	SourceIndex = SourceIndex or 1
	local DestTbl = {}
	local DestinationPos = 1
	while Written < Length do
		local Unknown
		Unknown, SourceIndex = string_unpack("<B", Source, SourceIndex)
		if Unknown <= 15 then
			if Unknown == 0 then
				local Unknown2
				Unknown2, SourceIndex = string_unpack("<B", Source, SourceIndex)
				if Unknown2 == 0 then
					local Unknown3 = 0
					repeat
						Unknown3, SourceIndex = string_unpack("<B", Source, SourceIndex)
						Unknown = Unknown + 255
					until Unknown3 ~= 0
				end
				Unknown = Unknown + Unknown2
				DestTbl[DestinationPos], DestTbl[DestinationPos + 1], DestTbl[DestinationPos + 2], DestTbl[DestinationPos + 3], DestTbl[DestinationPos + 4], DestTbl[DestinationPos + 5], DestTbl[DestinationPos + 6], DestTbl[DestinationPos + 7], DestTbl[DestinationPos + 8], DestTbl[DestinationPos + 9], DestTbl[DestinationPos + 10], DestTbl[DestinationPos + 11], DestTbl[DestinationPos + 12], DestTbl[DestinationPos + 13], DestTbl[DestinationPos + 14], SourceIndex = string_unpack("<c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1", Source, SourceIndex)
				DestinationPos = DestinationPos + 15
				Written = Written + 15
			end
			repeat
				DestTbl[DestinationPos], SourceIndex = string_unpack("<c1", Source, SourceIndex)
				DestinationPos = DestinationPos + 1
				Written = Written + 1
				Unknown = Unknown - 1
			until Unknown <= 0
		else
			local Unknown2 = Unknown % 16
			if Unknown2 == 0 then
				local Unknown3 = 15
				local Unknown4
				Unknown4, SourceIndex = string_unpack("<B", Source, SourceIndex)
				if Unknown4 == 0 then
					local Unknown5
					repeat
						Unknown5, SourceIndex = string_unpack("<B", Source, SourceIndex)
						Unknown3 = Unknown3 + 255
					until Unknown4 ~= 0
				end
				Unknown2 = Unknown2 + Unknown4 + Unknown3
			end
			local Unknown3
			Unknown3, SourceIndex = string_unpack("<B", Source, SourceIndex)
			local Unknown6 = DestinationPos - (math.floor(Unknown / 16) | (16 * Unknown3))
			local Unknown5 = math.floor(Unknown2 / 4)
			repeat
				DestTbl[DestinationPos] = DestTbl[Unknown6]
				DestTbl[DestinationPos + 1] = DestTbl[Unknown6 + 1]
				DestTbl[DestinationPos + 2] = DestTbl[Unknown6 + 2]
				DestTbl[DestinationPos + 3] = DestTbl[Unknown6 + 3]
				Unknown6 = Unknown6 + 4
				DestinationPos = DestinationPos + 4
				Unknown5 = Unknown5 - 1
			until Unknown5 <= 0
			local Unknown7 = Unknown2 % 4
			while Unknown7 > 0 do
				DestTbl[DestinationPos] = DestTbl[Unknown6]
				DestinationPos = DestinationPos + 1
				Unknown6 = Unknown6 + 1
				Unknown7 = Unknown7 - 1
			end
			Written = Written + Unknown2
		end
	end
	return table_concat(DestTbl), DestinationPos
end

-- Decompress a compressed P3D
local function Decompress(File, UncompressedLength)
	local DecompressedLength = 0
	local pos = 9
	local UncompressedTbl = {}
	local CompressedLength, UncompressedBlock
	while DecompressedLength < UncompressedLength do
		CompressedLength, UncompressedBlock, pos = string_unpack("<II", File, pos)
		UncompressedTbl[#UncompressedTbl + 1] = DecompressBlock(File, UncompressedBlock, pos)
		pos = pos + CompressedLength
		DecompressedLength = DecompressedLength + UncompressedBlock
	end
	return table_concat(UncompressedTbl)
end

local function ProcessSubChunks(Parent, Contents, Pos, EndPos)
	Parent.Chunks = Parent.Chunks or {}
	while Pos < EndPos do
		local Identifier, HeaderLength, Length = string_unpack("<III", Contents, Pos)
		
		local class = P3D.ChunkClasses[Identifier] or P3D.P3DChunk
		local Chunk = class:parse(Contents, Pos + 12, HeaderLength - 12, Identifier)
		
		ProcessSubChunks(Chunk, Contents, Pos + HeaderLength, Pos + Length)
		
		Parent.Chunks[#Parent.Chunks + 1] = Chunk
		Pos = Pos + Length
	end
end

local FileSignature = 0xFF443350
local CompressedFileSignature = 0x5A443350
local function LoadP3DFile(self, Path)
	local Data = {}
	if Path == nil then
		Data.Chunks = {}
	else
		local success, contents = pcall(ReadFile, Path)
		assert(success, "Failed to read file at '" .. Path .. "': " .. contents)
		
		assert(#contents >= 12, "Specified file too short")
		
		local Identifier, HeaderLength, Length, Pos = string_unpack("<III", contents)
		if Identifier == CompressedFileSignature then
			contents = Decompress(contents, HeaderLength)
			Identifier, HeaderLength, Length, Pos = string_unpack("<III", contents)
		end
		assert(Identifier == FileSignature, "Specified file isn't a P3D")
		
		ProcessSubChunks(Data, contents, Pos, Length)
	end
	self.__index = self
	return setmetatable(Data, self)
end

local function AddChunk(self, Chunk, Index)
	assert(type(Chunk) == "table" and Chunk.Identifier, "Arg #1 (Chunk) must be a valid chunk")
	assert(Index == nil or (type(Index) == "number" and Index <= #self.Chunks), "Arg #2 (Index) must be a number smaller than the chunk count")
	
	if Index then
		table.insert(self.Chunks, Index, Chunk)
	else
		self.Chunks[#self.Chunks + 1] = Chunk
	end
end

local function SetChunk(self, Chunk, Index)
	assert(type(Chunk) == "table" and Chunk.Identifier, "Arg #1 (Chunk) must be a valid chunk")
	assert(type(Index) == "number" and Index <= #self.Chunks, "Arg #2 (Index) must be a number smaller than the chunk count")
	
	self.Chunks[Index] = Chunk
end

local function RemoveChunk(self, ChunkOrIndex)
	local t = type(ChunkOrIndex)
	if t == "number" then
		assert(ChunkOrIndex <= #self.Chunks, "Arg #1 (Index) must be below chunk count")
		table.remove(self.Chunks, ChunkOrIndex)
	elseif t == "table" then
		assert(ChunkOrIndex.Identifier, "Arg #1 (Chunk) must be a valid chunk")
		for i=1,#self.Chunks do
			if self.Chunks[i] == ChunkOrIndex then
				table.remove(self.Chunks, i)
				return
			end
		end
	else
		error("Arg #1 (ChunkOrIndex) must be a number or a valid chunk")
	end
end

local function GetChunks(self, Identifier, Backwards)
	assert(Identifier == nil or type(Identifier) == "number", "Arg #1 (Identifier) must be a number")
	
	local chunks = self.Chunks
	local chunkN = #chunks
	
	if Backwards then
		local n = chunkN
		return function()
			while n > 0 do
				local Chunk = chunks[n]
				n = n - 1
				if Identifier == nil or Chunk.Identifier == Identifier then
					return Chunk
				end
			end
			return nil
		end
	else
		local n = 1
		return function()
			while n <= chunkN do
				local Chunk = chunks[n]
				n = n + 1
				if Identifier == nil or Chunk.Identifier == Identifier then
					return Chunk
				end
			end
			return nil
		end
	end
end

local function GetChunksIndexed(self, Identifier, Backwards)
	assert(Identifier == nil or type(Identifier) == "number", "Arg #1 (Identifier) must be a number")
	
	local chunks = self.Chunks
	local chunkN = #chunks
	
	if Backwards then
		local n = chunkN
		return function()
			while n > 0 do
				local Chunk = chunks[n]
				n = n - 1
				if Identifier == nil or Chunk.Identifier == Identifier then
					return n + 1, Chunk
				end
			end
			return nil
		end
	else
		local n = 1
		return function()
			while n <= chunkN do
				local Chunk = chunks[n]
				n = n + 1
				if Identifier == nil or Chunk.Identifier == Identifier then
					return n - 1, Chunk
				end
			end
			return nil
		end
	end
end

P3D.P3DFile = setmetatable({load = LoadP3DFile, new = LoadP3DFile, AddChunk = AddChunk, SetChunk = SetChunk, RemoveChunk = RemoveChunk, GetChunks = GetChunks, GetChunksIndexed = GetChunkIndexed}, {__call = LoadP3DFile})

function P3D.P3DFile:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	return string_pack("<III", FileSignature, 12, 12 + #chunkData) .. chunkData
end

function P3D.P3DFile:Output()
	Output(tostring(self))
end

P3D.P3DChunk = {AddChunk = AddChunk, SetChunk = SetChunk, RemoveChunk = RemoveChunk, GetChunksIndexed = GetChunkIndexed}
function P3D.P3DChunk:parse(Contents, Pos, DataLength, Identifier)
	local Data = {}
	
	Data.Identifier = Identifier
	if DataLength > 0 then
		Data.ValueStr = Contents:sub(Pos, Pos + DataLength - 1)
	else
		Data.ValueStr = ""
	end
	
	self.__index = self
	return setmetatable(Data, self)
end

function P3D.P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	local headerLen = 12 + #self.ValueStr
	return string_pack("<III", self.Identifier, headerLen, headerLen + #chunkData) .. self.ValueStr .. chunkData
end

function P3D.P3DChunk:newChildClass(Identifier)
	assert(type(Identifier) == "number", "Identifier must be a number")
	self.__index = self
	local class = setmetatable({Identifier = Identifier, parentClass = self}, self)
	P3D.ChunkClasses[Identifier] = class
	return class
end

function P3D.GetIdentifiersWithClasses()
	local identifiers = {}
	local n = 0
	for k in pairs(P3D.ChunkClasses) do
		n = n + 1
		identifiers[n] = k
	end
	return identifiers, n
end

function P3D.LoadChunks(Path)
	assert(type(Path) == "string", "Path must be a string")
	assert(Exists(Path, false, true), 'Could not find directory with path "' .. Path .. '"')
	
	local files = 0
	DirectoryGetEntries(Path, function(File, IsDirectory)
		if IsDirectory then
			return true
		end
		
		if GetFileExtension(File):lower() == ".lua" then
			dofile(string.format("%s/%s", Path, File))
			files = files + 1
		end
		
		return true
	end)
	
	local classes = P3D.GetIdentifiersWithClasses()
	print(string.format("Loaded %d files. Chunk classes: %d/%d", files, #classes, IdentifierIdsN))
	return files, classes
end

return P3D