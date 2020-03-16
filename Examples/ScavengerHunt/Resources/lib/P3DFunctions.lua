if P3D == nil then Alert("P3D Functions loaded with no P3D table present.") end
local P3D = P3D

function SetLocators(filePath)
	if not Exists(filePath, true, false) then return nil end
	local level = filePath:lower():match("art/l(%d)") or filePath:lower():match("level0(%d)")
	if RoadPositions["L" .. level] == nil then return false, nil end
	local modified = false
	local output = nil
	local tbl = RoadPositions["L" .. level]
	local P3DFile = P3D.P3DChunk:new{Raw = ReadFile(filePath)}
	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Locator) do
		local LocatorChunk = P3D.LocatorP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
		if LocatorChunk.Type == 0 then
			local Event = LocatorChunk:GetType0Data()
			if Event == 2 then
				local RoadLength = math.random() * RoadPositions["L" .. level .. "Total"]
				local Road = nil
				for i=1,#tbl do
					RoadLength = RoadLength - tbl[i].Length
					Road = tbl[i]
					if RoadLength <= 0 then break end
				end
				local RandX = math.random()
				local RandY = math.random()
				
				local x1 = Road.BottomRight.X * RandX
				local y1 = Road.BottomRight.Y * RandX
				local z1 = Road.BottomRight.Z * RandX
				
				local x2 = Road.TopLeft.X + (Road.TopRight.X - Road.TopLeft.X) * RandX
				local y2 = Road.TopLeft.Y + (Road.TopRight.Y - Road.TopLeft.Y) * RandX
				local z2 = Road.TopLeft.Z + (Road.TopRight.Z - Road.TopLeft.Z) * RandX
				
				local x = Road.BottomLeft.X + x1 + (x2 - x1) * RandY
				local y = Road.BottomLeft.Y + y1 + (y2 - y1) * RandY
				local z = Road.BottomLeft.Z + z1 + (z2 - z1) * RandY
				
				local pos = {X =x, Y = y, Z = z}
				LocatorChunk.Position = pos
				local TriggerVolumeIDX = LocatorChunk:GetChunkIndex(P3D.Identifiers.Trigger_Volume)
				if TriggerVolumeIDX then
					local TriggerVolumeChunk = P3D.TriggerVolumeP3DChunk:new{Raw = LocatorChunk:GetChunkAtIndex(TriggerVolumeIDX)}
					TriggerVolumeChunk.HalfExtents.Y = TriggerVolumeChunk.HalfExtents.Y + 2
					if TriggerVolumeChunk.IsRect == 0 then
						TriggerVolumeChunk.HalfExtents.X = TriggerVolumeChunk.HalfExtents.X + 2
						TriggerVolumeChunk.HalfExtents.Z = TriggerVolumeChunk.HalfExtents.Z + 2
					end
					TriggerVolumeChunk.Matrix.M41 = pos.X
					TriggerVolumeChunk.Matrix.M42 = pos.Y
					TriggerVolumeChunk.Matrix.M43 = pos.Z
					LocatorChunk:SetChunkAtIndex(TriggerVolumeIDX, TriggerVolumeChunk:Output())				
				end
				P3DFile:SetChunkAtIndex(idx, LocatorChunk:Output())
				modified = true
			end
		end
	end
	if modified then output = P3DFile:Output() end
end

function GetRoads(RoadPositions, Level)
	if not RoadPositions["L" .. Level] then RoadPositions["L" .. Level] = {} end
	local tbl = RoadPositions["L" .. Level]
	local P3DFile = P3D.P3DChunk:new{Raw = ReadFile("/GameData/art/L" .. Level .. "_TERRA.p3d")}
	local RoadSegments = {}
	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Road_Data_Segment) do
		local RoadDataSegmentChunk = P3D.RoadDataSegmentP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
		local item = {}
		item.Position = RoadDataSegmentChunk.Position
		item.Position2 = RoadDataSegmentChunk.Position2
		item.Position3 = RoadDataSegmentChunk.Position3
		RoadSegments[RoadDataSegmentChunk.Name] = item
	end
	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Road) do
		local RoadChunk = P3D.RoadP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
		for SegmentIdx in RoadChunk:GetChunkIndexes(P3D.Identifiers.Road_Segment) do
			local RoadSegmentChunk = P3D.RoadSegmentP3DChunk:new{Raw = RoadChunk:GetChunkAtIndex(SegmentIdx)}
			if RoadSegments[RoadSegmentChunk.Name] then
				local RoadSegmentData = RoadSegments[RoadSegmentChunk.Name]
				local Road = {}
				Road.TopLeft = RoadSegmentData.Position
				Road.TopRight = RoadSegmentData.Position2
				Road.BottomLeft = {X = RoadSegmentChunk.Transform.M41, Y = RoadSegmentChunk.Transform.M42, Z = RoadSegmentChunk.Transform.M43}
				Road.BottomRight = RoadSegmentData.Position3
				
				local x1 = Road.BottomRight.X * 0.5
				local y1 = Road.BottomRight.Y * 0.5
				local z1 = Road.BottomRight.Z * 0.5
				
				local x2 = Road.TopLeft.X + (Road.TopRight.X - Road.TopLeft.X) * 0.5
				local y2 = Road.TopLeft.Y + (Road.TopRight.Y - Road.TopLeft.Y) * 0.5
				local z2 = Road.TopLeft.Z + (Road.TopRight.Z - Road.TopLeft.Z) * 0.5
				
				Road.Length = math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
				tbl[#tbl + 1] = Road
			end
		end
	end
end