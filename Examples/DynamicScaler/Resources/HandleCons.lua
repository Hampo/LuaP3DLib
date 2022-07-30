local Path = GetPath()
if Path:find("huskA.con", 1, true) then
	return
end
print("Setting scale in: " .. Path)
local GamePath = GetGamePath(Path)
local MFKFile = ReadFile(GamePath):gsub("//.-([\r\n])", "%1")
local MFK = MFKLexer.Lexer:Parse(MFKFile)
local ScaleMultiplier = Settings.ScaleCars and Settings["L"..Level.."CarScaleMultiplier"] or 1
local CharScaleMultiplier = Settings.ScaleChars and Settings["L"..Level.."CharScaleMultiplier"] or 1

if Settings.ScaleCarPassengers and ScaleMultiplier ~= CharScaleMultiplier then
	local SetScale = false
	for i=1,#MFK.Functions do
		local func = MFK.Functions[i]
		if func.Name:lower() == "setcharacterscale" then
			local value = tonumber(func.Arguments[1])
			
			value = value * (ScaleMultiplier / CharScaleMultiplier)
			func.Arguments[1] = value
			
			SetScale = true
			break
		end
	end
	if not SetScale then
		MFK:AddFunction("SetCharacterScale", {ScaleMultiplier / CharScaleMultiplier})
	end
end

if ScaleMultiplier ~= 1 then
	local CommandsToMultiply = {
		["setmass"] = true,
		["setsuspensionlimit"] = true,
		["setsuspensionyoffset"] = true,
		["setcmoffsetx"] = true,
		["setcmoffsety"] = true,
		["setcmoffsetz"] = true,
		["setweebleoffset"] = true,
		["setwheelierange"] = true,
		["setwheelieoffsety"] = true,
		["setwheelieoffsetz"] = true,
		["sethitpoints"] = true,
	}

	local CommandsToDivide = {
		["setnormalsteering"] = true,
		["setslipsteering"] = true,
		["setslipsteeringnoebrake"] = true,
	}
	
	local SetShadow = false
	local BaseFrontX = 1.2
	local BaseFrontY = 2.0
	local BaseMidFrontX = 1.2
	local BaseMidFrontY = 0.2
	local BaseMidBackX = 1.2
	local BaseMidBackY = -0.2
	local BaseBackX = 1.2
	local BaseBackY = -2.0
	
	for i=1,#MFK.Functions do
		local func = MFK.Functions[i]
		local name = func.Name:lower()
		if CommandsToMultiply[name] then
			local value = tonumber(func.Arguments[1])
			
			value = value * ScaleMultiplier
			
			func.Arguments[1] = value
		elseif CommandsToDivide[name] then
			local value = tonumber(func.Arguments[1])
			
			value = value / ScaleMultiplier
			
			func.Arguments[1] = value
		elseif name == "setmaxwheelturnangle" then
			local value = tonumber(func.Arguments[1])
			
			value = value * (ScaleMultiplier > 1 and (ScaleMultiplier / 2) or ScaleMultiplier)
			
			func.Arguments[1] = value
		elseif name == "setshadowadjustments" then
			local FrontX = tonumber(func.Arguments[1])
			local FrontY = tonumber(func.Arguments[2])
			local MidFrontX = tonumber(func.Arguments[3])
			local MidFrontY = tonumber(func.Arguments[4])
			local MidBackX = tonumber(func.Arguments[5])
			local MidBackY = tonumber(func.Arguments[6])
			local BackX = tonumber(func.Arguments[7])
			local BackY = tonumber(func.Arguments[8])
			
			local RealFrontX = BaseFrontX + FrontX
			local RealFrontY = BaseFrontY + FrontY
			local RealMidFrontX = BaseMidFrontX + MidFrontX
			local RealMidFrontY = BaseMidFrontY + MidFrontY
			local RealMidBackX = BaseMidBackX + MidBackX
			local RealMidBackY = BaseMidBackY + MidBackY
			local RealBackX = BaseBackX + BackX
			local RealBackY = BaseBackY + BackY
			
			local NewFrontX = RealFrontX * ScaleMultiplier - BaseFrontX
			local NewFrontY = RealFrontY * ScaleMultiplier - BaseFrontY
			local NewMidFrontX = RealMidFrontX * ScaleMultiplier - BaseMidFrontX
			local NewMidFrontY = RealMidFrontY * ScaleMultiplier - BaseMidFrontY
			local NewMidBackX = RealMidBackX * ScaleMultiplier - BaseMidBackX
			local NewMidBackY = RealMidBackY * ScaleMultiplier - BaseMidBackY
			local NewBackX = RealBackX * ScaleMultiplier - BaseBackX
			local NewBackY = RealBackY * ScaleMultiplier - BaseBackY
			
			func.Arguments[1] = NewFrontX
			func.Arguments[2] = NewFrontY
			func.Arguments[3] = NewMidFrontX
			func.Arguments[4] = NewMidFrontY
			func.Arguments[5] = NewMidBackX
			func.Arguments[6] = NewMidBackY
			func.Arguments[7] = NewBackX
			func.Arguments[8] = NewBackY
			
			SetShadow = true
		end
	end
	
	if not SetShadow then
		local NewFrontX = BaseFrontX * ScaleMultiplier - BaseFrontX
		local NewFrontY = BaseFrontY * ScaleMultiplier - BaseFrontY
		local NewMidFrontX = BaseMidFrontX * ScaleMultiplier - BaseMidFrontX
		local NewMidFrontY = BaseMidFrontY * ScaleMultiplier - BaseMidFrontY
		local NewMidBackX = BaseMidBackX * ScaleMultiplier - BaseMidBackX
		local NewMidBackY = BaseMidBackY * ScaleMultiplier - BaseMidBackY
		local NewBackX = BaseBackX * ScaleMultiplier - BaseBackX
		local NewBackY = BaseBackY * ScaleMultiplier - BaseBackY
		
		MFK:AddFunction("SetShadowAdjustments", {NewFrontX, NewFrontY, NewMidFrontX, NewMidFrontY, NewMidBackX, NewMidBackY, NewBackX, NewBackY})
	end
end

MFK:Output()