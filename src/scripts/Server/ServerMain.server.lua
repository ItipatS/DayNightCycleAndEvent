--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService.DayNightCycleAndEvent:FindFirstChild("LoaderUtils", true).Parent
local require = require(loader).bootstrapGame(ServerScriptService.DayNightCycleAndEvent)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("DayNightCycleAndEventService"))
serviceBag:Init()
serviceBag:Start()