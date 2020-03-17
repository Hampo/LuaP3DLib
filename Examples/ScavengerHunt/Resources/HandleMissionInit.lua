local Path = "/GameData/" .. FixSlashes(GetPath(), false, true)
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");
File = File:gsub("SetStageTime%s*%(%s*%d*%s*%);", "")
File = File:gsub("AddStageTime%s*%(%s*%d*%s*%);", "")
File = File:gsub("SetInitialWalk%s*%(%s*%d*%s*%);", "")
local types = {["followdistance"] = true, ["timeout"] = true, ["outofvehicle"] = true}
File = File:gsub("AddCondition%s*%(%s*\"(.-)\"%s*%);.-CloseCondition%s*%(%s*%);", function(type)
	if types[type] then return "" end
end)
File = File:gsub("SetDestination%s*%(%s*\"(.-)\"%s*%);", function(arg)
	if not arg:find("\"") then return "SetDestination(\"" .. arg .. "\",\"carsphere\");" end
end)
File = File:gsub("AddCollectible%s*%(%s*\"(.-)\"%s*%);", function(arg)
	if not arg:find("\"") then return "AddCollectible(\"" .. arg .. "\",\"carsphere\");" end
end)
Output(File)