local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Net)

local DayNightRenderer = require(script.DayNightRenderer)
local EventRenderer = require(script.EventRenderer)
local BGMService = require(script.Parent.SoundHandler.BGMService)
local AmbientService = require(script.Parent.SoundHandler.AmbientService)

Net.DayNightAndEvent.listen(function(payload)
    print("DayNight Data", payload)
    local phase = payload.phase
    local moon = payload.moonPhase
    local duration = payload.duration
    local totalDuration = payload.totalDuration
    local events = payload.events or {}

    BGMService.updateBGM(phase, events)
    AmbientService.updateAmbient(phase, events)

    DayNightRenderer.applyDayNight(phase, moon, duration, totalDuration)
    EventRenderer.applyEvents(events)

end)

return {} 