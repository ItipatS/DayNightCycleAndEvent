--[[
	@class ClientMain
]]
local loader = game:GetService("ReplicatedStorage"):WaitForChild("DayNightCycleAndEvent"):WaitForChild("loader")
local require = require(loader).bootstrapGame(loader.Parent)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("DayNightCycleAndEventServiceClient"))
serviceBag:Init()
serviceBag:Start()