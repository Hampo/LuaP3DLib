ModSandbox = {}
ModSandbox.Sandbox = {}


local function ToASCII(Str)
	if Str:sub(1, 3) == "\xEF\xBB\xBF" then return Str:sub(4) end
	if Str:sub(1, 2) ~= "\xFF\xFE" then return Str end
	Str = Str:sub(3)
	local Out = {}
	for i=1,#Str,2 do
		Out[#Out + 1] = Str:sub(i, i)
	end
	return table.concat(Out)
end
local EnvReadFile = ReadFile
local ReadFile = function(Path)
	local status, file = pcall(EnvReadFile, Path)
	if not status then return nil end
	file = ToASCII(file)
	return file
end

function ModSandbox.Sandbox:new(Data)
	if Data == nil then
		Data = {}
		setmetatable(Data, self)
		self.__index = self
		return Data
	end
	if not IsModEnabled(Data.ModName) then return nil end
	Data.ModPath = GetModPath(Data.ModName)
	Data.Env = {
	  EnvIsModSandbox = true,
	  _VERSION = _VERSION,
	  assert = assert,
	  collectgarbage = collectgarbage,
	  coroutine = { create = coroutine.create, resume = coroutine.resume, running = coroutine.running, status = coroutine.status, wrap = coroutine.wrap, yield = coroutine.yield },
	  debug = { debug = debug.debug, gethook = debug.gethook , getinfo = debug.getinfo, getlocal = debug.getlocal, getmetatable = debug.getmetatable, getregistry = debug.getregistry, getupvalue = debug.getupvalue, getuservalue = debug.getuservalue, sethook = debug.sethook, setlocal = debug.setlocal, setmetatable = debug.setmetatable, setupvalue = debug.setupvalue, traceback = debug.traceback, upvaluejoin = debug.upvaluejoin, upvalieid = debug.upvalueid },
	  error = error,
	  getmetatable = getmetatable,
	  ipairs = ipairs,
	  math = { abs = math.abs, acos = math.acos, asin = math.asin, atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos, cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor, fmod = math.fmod, frexp = math.frexp, huge = math.huge, ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max, maxinteger = math.maxinteger, min = math.min, mininteger = math.mininteger, modf = math.modf, pi = math.pi, pow = math.pow, rad = math.rad, random = math.random, randomseed = math.randomseed, sin = math.sin, sinh = math.sinh, sqrt = math.sqrt, tan = math.tan, tanh = math.tanh, tointeger = math.tointeger, type = math.type, ult = math.ult },
	  next = next,
	  os = { clock = os.clock, date = os.date, difftime = os.difftime, exit = function() end, setlocale = os.setlocale, time = os.time },
	  pairs = pairs,
	  pcall = pcall,
	  print = function() end,
	  rawequal = rawequal,
	  rawget = rawget,
	  rawlen = rawlen,
	  rawset = rawset,
	  select = select,
	  setmetatable = setmetatable,
	  string = { byte = string.byte, char = string.char, dump = string.dump, find = string.find, format = string.format, gmatch = string.gmatch, gsub = string.gsub, len = string.len, lower = string.lower, match = string.match, rep = string.rep, reverse = string.reverse, sub = string.sub, upper = string.upper, pack = string.pack, packsize = string.packsize, unpack = string.unpack },
	  table = { insert = table.insert, maxn = table.maxn, move = table.move, remove = table.remove, sort = table.sort, unpack = table.unpack, pack = table.pack, concat = table.concat },
	  tonumber = tonumber,
	  tostring = tostring,
	  type = type,
	  utf8 = { char = utf8.char, charpattern = utf8.charpattern, codepoint = utf8.codepoint, codes = utf8.codes, len = utf8.len, offset = utf8.offset },
	  xpcall = xpcall,
	  dofile = function(path)
			local loadedCode = load(Data:GetFile(path), path, "t", Data.Env)
			return loadedCode()
		end,
	  load = function(code, name, t) return load(code, name, t, Data.Env) end,
	  loadfile = function(path) return load(Data:GetFile(path), path, "t", Data.Env) end,
	  Alert = function() end, --Alert,
	  ComparePaths = ComparePaths,
	  Confirm = Confirm,
	  DirectoryGetEntries = DirectoryGetEntries,
	  DirectoryRecursiveCreate = DirectoryRecursiveCreate,
	  Exists = Exists,
	  FixSlashes = FixSlashes,
	  GetEnabledMods = GetEnabledMods,
	  GetFileExtension = GetFileExtension,
	  GetFileName = GetFileName,
	  GetLauncherVersion = GetLauncherVersion,
	  GetMainMod = GetMainMod,
	  GetModName = function() return Data.ModName end,
	  GetModPath = function(ModName) return GetModPath(ModName or Data.ModName) end,
	  GetModTitle = function(ModName) return GetModTitle(ModName or Data.ModName) end,
	  GetModVersion = function(ModName) return GetModVersion(ModName or Data.ModName) end,
	  GetPathParent = GetPathParent,
	  GetSetting = function(Setting, ModName) return GetSetting(Setting, ModName or Data.ModName) end,
	  GetSettings = function(ModName) return GetSettings(ModName or Data.ModName) end,
	  GetTime = GetTime,
	  IsHackLoaded = IsHackLoaded,
	  IsLegacyOutput = IsLegacyOutput,
	  IsModEnabled = IsModEnabled,
	  IsTesting = IsTesting,
	  ReadFile = ReadFile,
	  RemoveFileExtension = RemoveFileExtension,
	  WildcardMatch = WildcardMatch,
	  GetPath = function() return Data.CurrentPath end,
	  Output = function(str) Data.OutputTbl[#Data.OutputTbl + 1] = str end,
	  Redirect = function(str) Data.OutputTbl[#Data.OutputTbl + 1] = ReadFile(str) end
	}
	Data.Env._G = Data.Env
	self.__index = self
	return setmetatable(Data, self)
end

function ModSandbox.Sandbox:InitFromMainMod(OverwriteReadFile)
	local MainMod = nil
	GetEnabledMods(function(ModName)
		if ModName ~= GetModName() then
			local iniPath = GetModPath(ModName) .. "/Meta.ini"
			if Exists(iniPath, true, false) then
				local ini = ToASCII(ReadFile(iniPath))
				local isMiscellaneous = false
				for token in ini:gmatch("[^\r\n]+") do
					first = token:sub(1, 1)
					if first ~= ";" and first ~= "#" then
						if first == "[" then
							isMiscellaneous = token:lower():match("%[miscellaneous%]")
						elseif isMiscellaneous then
							parts = {}
							for part in token:gmatch("[^%s=]+") do
								parts[#parts + 1] = part
							end
							if #parts == 2 and parts[1]:lower() == "main" and parts[2] == "1" then
								MainMod = ModName
								return false
							end
						end
					end
				end
			end
		end
		return true
	end)
	if MainMod then
		local sandbox = ModSandbox.Sandbox:new{ModName = MainMod}
		sandbox:Init()
		if OverwriteReadFile then
			_ENV.ReadFile = function(Path)
				return sandbox:SimulatePathHandler(Path)
			end
		end
		return sandbox
	end
	return nil
end

function ModSandbox.Sandbox:GetFile(Path)
	local code = ReadFile(Path)
	return code
end

function ModSandbox.Sandbox:Init()
	print(GetModName(), "Loading sandbox for \"" .. self.ModName .. "\".")
	local startTime = GetTime()
	if Exists(self.ModPath .. "/CustomFiles.ini", true, false) then
		self.PathHandlers = {}
		self.PathHandlersN = 0
		self.PathRedirections = {}
		self.PathRedirectionsN = 0
		local ini = ReadFile(self.ModPath .. "/CustomFiles.ini")
		local isHandler = false
		local isRedirect = false
		local first
		local parts
		for token in ini:gmatch("[^\r\n]+") do
			first = token:sub(1, 1)
			if first ~= ";" and first ~= "#" then
				if first == "[" then
					isHandler = token:lower():match("%[pathhandlers%]")
					isRedirect = token:lower():match("%[pathredirections%]")
				elseif isHandler or isRedirect then
					parts = {}
					for part in token:gmatch("[^%s=]+") do
						parts[#parts + 1] = part
					end
					if #parts == 2 then
						if isHandler then
							self.PathHandlers["/GameData/" .. parts[1]:gsub("\\\\", "/")] = self.ModPath .. "/" .. parts[2]:gsub("\\\\", "/")
							self.PathHandlersN = self.PathHandlersN + 1
						else
							self.PathRedirections["/GameData/" .. parts[1]:gsub("\\\\", "/")] = (parts[2]:sub(-4):lower() == ".lua" and self.ModPath .. "/" or "/GameData/") .. parts[2]:gsub("\\\\", "/")
							self.PathRedirectionsN = self.PathRedirectionsN + 1
						end
					end
				end
			end
		end
	else
		self.PathHandlers = nil
		self.PathHandlersN = nil
		self.PathRedirections = nil
		self.PathRedirectionsN = nil
	end
	if Exists(self.ModPath .. "/CustomFiles.lua", true, false) then
		local code = self:GetFile(self.ModPath .. "/CustomFiles.lua")
		local cf = load(code, self.ModPath .. "/CustomFiles.lua", "t", self.Env)
		cf()
	end
	local endTime = GetTime()
	print(GetModName(), "Loaded sandbox for \"" .. self.ModName .. "\" in " .. (endTime - startTime) * 1000 .. "ms. Found " .. (self.PathHandlersN or "0") .. " handlers and " .. (self.PathRedirectionsN or "0") .. " redirections.")
end

function ModSandbox.Sandbox:SimulatePathHandler(Path, ReturnNil)
	print(GetModName(), "Simulating \"" .. Path .. "\" in mod \"" .. self.ModName .. "\".")
	self.CurrentPath = Path:sub(1, 10) == "/GameData/" and Path:sub(11) or Path
	if self.PathHandlers then
		for k,v in pairs(self.PathHandlers) do
			if WildcardMatch(k, Path, true, true) then
				self.OutputTbl = {}
				local handler = load(self:GetFile(v), nil, "t", self.Env)
				handler()
				if #self.OutputTbl == 0 then
					if ReturnNil then return nil end
					return ReadFile(Path)
				else
					return table.concat(self.OutputTbl)
				end
			end
		end
	end
	if self.PathRedirections then
		for k,v in pairs(self.PathRedirections) do
			if WildcardMatch(k, Path, true, true) then
				if v:sub(-4):lower() ~= ".lua" then
					Path = v
				end
			end
		end
	end
	self.CurrentPath = nil
	if ReturnNil then return nil end
	return ReadFile(Path)
end

function ModSandbox.Sandbox:ExecuteRelativeFile(Path)
	if Path:sub(1) ~= "/" then Path = "/" .. Path end
	local loadedCode = load(self:GetFile(self.ModPath .. Path), self.ModPath .. Path, "t", self.Env)
	return loadedCode()
end

function ModSandbox.Sandbox:SimulateLevel(level)
	local levelLoad = self:SimulatePathHandler("/GameData/scripts/missions/level0" .. level .. "/level.mfk")
	local levelInit = self:SimulatePathHandler("/GameData/scripts/missions/level0" .. level .. "/leveli.mfk")
	self.LastLoadedLevel = level
	return levelLoad, levelInit
end

function ModSandbox.Sandbox:SimulateMission(level, mission)
	if self.LastLoadedLevel ~= level then self:SimulateLevel(level) end
	local missionLoad = self:SimulatePathHandler("/GameData/scripts/missions/level0" .. level .. "/" .. mission .. "l.mfk")
	local missionInit = self:SimulatePathHandler("/GameData/scripts/missions/level0" .. level .. "/" .. mission .. "i.mfk")
	return missionLoad, missionInit
end