local Path = "/GameData/" .. FixSlashes(GetPath(), false, true)
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");
File = File:gsub("SetStageTime%s*%(%s*%d*%s*%);", "")
File = File:gsub("AddStageTime%s*%(%s*%d*%s*%);", "")
File = File:gsub("AddCondition%s*%(%s*\"timeout\"%s*%);.-CloseCondition%s*%(%s*%);", "")
File = File:gsub("AddCondition%s*%(%s*\"outofvehicle\"%s*%);.-CloseCondition%s*%(%s*%);", "")
File = File:gsub("SetDestination%s*%(%s*\"(.-)\"%s*%);", function(arg)
	if not arg:find("\"") then return "SetDestination(\"" .. arg .. "\",\"carsphere\");" end
end)
File = File:gsub("AddCollectible%s*%(%s*\"(.-)\"%s*%);", function(arg)
	if not arg:find("\"") then return "AddCollectible(\"" .. arg .. "\",\"carsphere\");" end
end)
Output(File)