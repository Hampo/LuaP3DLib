Settings = GetSettings()

if not Settings.ScaleCars and not Settings.ScaleChars and not Settings.ScaleProps then
	Alert("What is wrong with you? If you're going to enable Dynamic Scaler, choose something to scale.")
	os.exit()
end

dofile(GetModPath() .. "/Resources/lib/P3D2.lua")
P3D.LoadChunks(GetModPath() .. "/Resources/lib/P3DChunks")
dofile(GetModPath() .. "/Resources/lib/MFKLexer.lua")

function GetGamePath(Path)
	Path = FixSlashes(Path,false,true)
	if Path:sub(1,1) ~= "/" then Path = "/GameData/"..Path end
	return Path
end

Level = 1

if Settings.RandomScales then
	if Settings.RandomMinCarScale >= Settings.RandomMaxCarScale then
		Alert("The minimum car scale must be smaller than the maximum car scale.")
		os.exit()
	end
	
	if Settings.RandomMinCharScale >= Settings.RandomMaxCharScale then
		Alert("The minimum character scale must be smaller than the maximum character scale.")
		os.exit()
	end
	
	if Settings.RandomMinPropScale >= Settings.RandomMaxPropScale then
		Alert("The minimum prop scale must be smaller than the maximum prop scale.")
		os.exit()
	end
	
	local function LogRandomFloat(min, max) -- Credit: EnAppelsin
		local mins = math.log(min)
		local range = math.log(max) - mins
		return math.exp(math.random() * range + mins)
	end
	for i=1,7 do
		Settings["L"..i.."CarScaleMultiplier"] = LogRandomFloat(Settings.RandomMinCarScale, Settings.RandomMaxCarScale)
		Settings["L"..i.."CharScaleMultiplier"] = LogRandomFloat(Settings.RandomMinCharScale, Settings.RandomMaxCharScale)
		Settings["L"..i.."PropScaleMultiplier"] = LogRandomFloat(Settings.RandomMinPropScale, Settings.RandomMaxPropScale)
	end
	for i=1,7 do
		print("Level: " .. i, "Car: " .. Settings["L"..i.."CarScaleMultiplier"], "Character: " .. Settings["L"..i.."CharScaleMultiplier"], "Prop: " .. Settings["L"..i.."PropScaleMultiplier"])
	end
end

Quotes = {
	"\"My boyfriend is in hospital with appendicitis\nand this mod is still the worst thing\nto happen to me this week\"\n- Clifforus",
	"\n\n\"What have you done?\"\n- Clifforus",
	"\n\n\"It's like watching Robot Wars\"\n-Shibarianne",
	"\n\n\"This is gonna be even worse than imagined\"\n-Badgerbar",
	"\n\"Proddy you should get a mini-me\nafter you finish this evil mod\"\n-Badgerbar",
	"\"Some things are going to be big\nSome things are going to be tiny\nBut everything is going to be goofy\"\n-Badgerbar",
	"\n\"I'm going to enjoy the suffering\nthat other people will have\"\n-Badgerbar",
}