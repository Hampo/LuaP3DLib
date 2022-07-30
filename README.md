# Lua P3D Lib (Previously Lua P3D Editor)
This is a single Lua file you are able to add to mods in order to modify P3D files dynamically.

# Installation
1. Download the latest `P3D.zip` from <https://github.com/Hampo/LuaP3DLib/releases>.
2. Extract the contents to the `/Resources/lib` folder of your mod.
3. Add `dofile(GetModPath() .. "/Resources/lib/P3D2.lua")` to the `CustomFiles.lua` of your mod.
4. Add `P3D.LoadChunks(GetModPath() .. "/Resources/lib/P3DChunks")` after the previous line.
5. (Optional) Make an additional file called `P3DFunctions.lua` in the same lib folder to contain your P3D-related functions.
   * You will also need to do `dofile(GetModPath() .. "/Resources/lib/P3DFunctions.lua")` in `CustomFiles.lua`.
6. Add the following Authors to your `Meta.ini`:
```ini
[Author]
Name=Proddy
Website=https://github.com/Hampo/LuaP3DEditor
Notes=P3D Class System
Group=LuaP3DEditor

[Author]
Name=EnAppelsin
Website=https://github.com/EnAppelsin
Notes=Original P3D Lua idea
Group=LuaP3DEditor

[Author]
Name=Lucas Cardellini
Website=https://lucasstuff.com/
Notes=P3D Chunk Structures
Group=LuaP3DEditor
```

# Examples
You can find some examples in the Examples folder.
