local P3DFile = P3D.P3DFile()
local ScaleMultiplier = Settings["L"..Level.."CharScaleMultiplier"]
local WalkerCameraDataChunk = P3D.WalkerCameraDataP3DChunk(9, 4.26 * ScaleMultiplier, 9 * ScaleMultiplier, 1.36, {X=0,Y=ScaleMultiplier,Z=0})
P3DFile:AddChunk(WalkerCameraDataChunk)
P3DFile:Output()