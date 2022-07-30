if Settings.ScaleProps then
	CardChunks = {}
	local P3DFile = P3D.P3DFile(GetGamePath(GetPath()))
	for i=1,#P3DFile.Chunks do
		CardChunks[i] = P3DFile.Chunks[i]
	end
	P3DFile():Output()
end