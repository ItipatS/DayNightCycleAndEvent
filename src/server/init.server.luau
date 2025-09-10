local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local EventManager = require(script.Service.EventManager)

RunService.Heartbeat:Connect(function(dt)
    EventManager.HeartBeatUpdate(dt)
end)

Players.PlayerAdded:Connect(function(player)
    EventManager.PlayerAdded(player)
end)