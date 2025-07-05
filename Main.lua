local Scripts = {
	{
		PlacesIds = {2753915549, 4442272183, 7449423635},
		UrlPath = "AlekPaphawin.lua"
	},
	{
		PlacesIds = {10260193230},
		UrlPath = "Narawich.lua"
	},
	{
		PlacesIds = {1234567890},
		UrlPath = "JesPhalat.lua"
	},
	{
		PlacesIds = {9876543210},
		UrlPath = "Chinatip.lua"
	}
}

local fetcher, urls = {}, {}

local _ENV = (getgenv or getrenv or getfenv)()

urls.Owner = "https://raw.githubusercontent.com/AlekJessScriptman/BloxtinUzothe/"
urls.Repository = urls.Owner .. "main/"
urls.Utils = urls.Repository .. "Utils/"
urls.UI = urls.Repository .. "UI/"

do
	local last_exec = _ENV.rz_execute_debounce
	if last_exec and (tick() - last_exec) <= 5 then return nil end
	_ENV.rz_execute_debounce = tick()
end

do
	local executor = syn or fluxus or krnl
	local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)

	if not _ENV.rz_added_teleport_queue and type(queueteleport) == "function" then
		local ScriptSettings = {...}
		local SettingsCode = ""

		_ENV.rz_added_teleport_queue = true

		local Success, EncodedSettings = pcall(function()
			return game:GetService("HttpService"):JSONEncode(ScriptSettings)
		end)

		if Success and EncodedSettings then
			SettingsCode = "unpack(game:GetService('HttpService'):JSONDecode('" .. EncodedSettings .. "'))"
		end

		pcall(queueteleport, ("loadstring(game:HttpGet('%smainloader.lua'))(%s)"):format(urls.Repository, SettingsCode))
	end
end

do
	if _ENV.rz_error_message then _ENV.rz_error_message:Destroy() end

	local identifyexecutor = identifyexecutor or function() return "Unknown" end

	local function CreateMessageError(Text)
		_ENV.loadedFarm = nil
		_ENV.OnFarm = false

		local Message = Instance.new("Message", workspace)
		Message.Text = string.gsub(Text, urls.Owner, "")
		_ENV.rz_error_message = Message

		error(Text, 2)
	end

	local function formatUrl(Url)
		for key, path in urls do
			if Url:find("{" .. key .. "}") then
				return Url:gsub("{" .. key .. "}", path)
			end
		end
		return Url
	end

	function fetcher.get(Url)
		local success, response = pcall(function()
			return game:HttpGet(formatUrl(Url))
		end)

		if success then return response
		else CreateMessageError(`[Loader] [{identifyexecutor()}] Failed URL: {Url}\n>>{response}<<`)
		end
	end

	function fetcher.load(Url: string, extra: string?)
		local raw = fetcher.get(Url) .. (extra or "")
		local runFunc, err = loadstring(raw)
		if type(runFunc) ~= "function" then
			CreateMessageError(`[Loader] Syntax Error: {Url}\n>>{err}<<`)
		else
			return runFunc
		end
	end
end

local function IsPlace(Script)
	return Script.PlacesIds and table.find(Script.PlacesIds, game.PlaceId)
end

for _, Script in Scripts do
	if IsPlace(Script) then
		return fetcher.load("{Repository}Games/" .. Script.UrlPath)(fetcher, ...)
	end
end
