# Lua P3D Editor
This is a single Lua file you are able to add to mods in order to modify P3D files dynamically.

# Installation
1. Get the latest P3D.lua file from the lib folder.
2. Place the file in `/Resources/lib` of your mod.
3. Add `dofile(GetModPath() .. "/Resources/lib/P3D.lua")` to the `CustomFiles.lua` of your mod.
4. (Optional) Make an additional file called `P3DFunctions.lua` in the same lib folder to contain your P3D-related functions.
   * You will also need to do `dofile(GetModPath() .. "/Resources/lib/P3DFunctions.lua")` in `CustomFiles.lua`.
5. Add the following Authors to your `Meta.ini`:
```ini
[Author]
Name=Proddy
Website=https://github.com/Hampo/LuaP3DEditor
Notes=P3D Class System - P3D Functions
Group=LuaP3DEditor

[Author]
Name=EnAppelsin
Website=https://github.com/EnAppelsin
Notes=Original P3D Lua idea - P3D Functions
Group=LuaP3DEditor

[Author]
Name=Lucas Cardellini
Website=https://lucasstuff.com/
Notes=P3D Functions Performance Improvements
Group=LuaP3DEditor
```

# Examples
You can find some examples in the Examples folder.
