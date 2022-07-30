# Lua P3D Lib (Previously Lua P3D Editor)
This is a Lua library you are able to add to mods in order to modify P3D files dynamically.

# Installation
1. Download the latest `P3D.zip` from <https://github.com/Hampo/LuaP3DLib/releases>.
2. Extract the contents to the `/Resources/lib` folder of your mod.
3. Add `dofile(GetModPath() .. "/Resources/lib/P3D2.lua")` to the `CustomFiles.lua` of your mod.
4. Add `P3D.LoadChunks(GetModPath() .. "/Resources/lib/P3DChunks")` after the previous line in `CustomFiles.lua`.
5. (Optional) Make an additional file called `P3DFunctions.lua` in the same lib folder to contain your P3D-related functions.
   * You will also need to do `dofile(GetModPath() .. "/Resources/lib/P3DFunctions.lua")` in `CustomFiles.lua`.
6. Add the following Authors to your `Meta.ini`:
```ini
[Author]
Name=Proddy
Website=https://github.com/Hampo/LuaP3DLib
Notes=P3D Class System
Group=LuaP3DLib

[Author]
Name=EnAppelsin
Website=https://github.com/EnAppelsin
Notes=Original P3D Lua idea
Group=LuaP3DLib

[Author]
Name=Lucas Cardellini
Website=https://lucasstuff.com/
Notes=P3D Chunk Structures
Group=LuaP3DLib
```

# Examples
You can find complete mods in the `Examples` folder.

## Code examples

### Loading a P3DFile
```
local Path = GetPath()
local GamePath = "/GameData/" .. Path

local P3DFile = P3D.P3DFile(GamePath)
-- P3DFile now has `:GetChunk`, `:GetChunks`, `:GetChunkIndexed`, `:GetChunksIndexed`, `:AddChunk`, `RemoveChunk`

-- After modifications
P3DFile:Output()
```

### Changing a value in all chunks of type
```
for chunk in P3DFile:GetChunks(P3D.Identifiers.Locator) do -- You can find a full list of Identifiers in `P3D2.lua`
	chunk.Position.X = chunk.Position.X + 20
end
```

### Removing all chunks of type
```
for chunk in P3DFile:GetChunks(P3D.Identifiers.Locator) do -- You can find a full list of Identifiers in `P3D2.lua`
	P3D:RemoveChunk(chunk)
end
```

### Full example
```
local Path = GetPath()
local GamePath = "/GameData/" .. Path

local P3DFile = P3D.P3DFile(GamePath)
for chunk in P3DFile:GetChunks(P3D.Identifiers.Locator) do -- You can find a full list of Identifiers in `P3D2.lua`
	P3D:RemoveChunk(chunk)
end

P3DFile:Output()
```