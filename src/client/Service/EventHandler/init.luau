local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Net)

local DayNightRenderer = require(script.DayNightRenderer)
local EventRenderer = require(script.EventRenderer)
local BGMService = require(script.Parent.SoundHandler.BGMService)
local AmbientService = require(script.Parent.SoundHandler.AmbientService)

Net.DayNight.listen(function(Data)
    print("DayNight Data", Data)
    local phase = Data.phase
    local moon = Data.moonPhase
    local duration = Data.duration
    local totalDuration = Data.totalDuration
    local events = Data.events or {}

    BGMService.updateBGM(phase, events)
    AmbientService.updateAmbient(phase, events)

    DayNightRenderer.applyDayNight(phase, moon, duration, totalDuration)
end)
Net.Event.listen(function(Events)
    print("Events Data", Events)
    BGMService.updateBGM({}, Events)
    AmbientService.updateAmbient({}, Events)
    EventRenderer.applyEvents(Events)
end)
return {} 