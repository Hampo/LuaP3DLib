if Settings.SkipLocks then
	local Path = "/GameData/" .. GetPath()
	local Original = ReadFile(Path):gsub("//.-([\r\n])", "%1")
	Output(Original:gsub("AddStage%s*%(\"locked\".-%s*%);(.-)CloseStage%s*%(%s*%);%s*AddStage%s*%([^\n]-%s*%);.-CloseStage%s*%(%s*%);", "AddStage();%1CloseStage();", 1)) --Shamelessly stolen from rando
end