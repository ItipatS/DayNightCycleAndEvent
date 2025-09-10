-- ServerScriptService: EventManager (formerly DayNightAndEvent)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Net = require(ReplicatedStorage.Net)
local EventDefinitions = require(script.EventDefinitions)
local MoonPhase = require(script.MoonPhase)

local EventManager = {}

local activeEvents = {}
local eventIdCounter = 0
-- Random event scheduler
local randomEventCheckInterval = 60 -- seconds (in-game hour)
local timeSinceLastCheck = 0

-- State for day/night cycle
local settings = {
    dayDuration = .5,   -- minutes
    nightDuration = .5, -- minutes
}
local currentPhase = "Day"         -- "Day" or "Night"
local durationLeft = settings.dayDuration
local currentMoonPhase = MoonPhase:GetPhaseName()

local function getTimeState()
    local totalDuration = (currentPhase == "Day") and settings.dayDuration or settings.nightDuration
    return {
        phase = currentPhase,
        duration = durationLeft,
        totalDuration = totalDuration,
        moonPhase = currentMoonPhase,
    }
end

local function getEventState()
    return activeEvents
end

function EventManager:GetCurrentState()
    return getTimeState()
end

function EventManager:GetActiveEvents()
    return activeEvents
end

function EventManager:TriggerEvent(eventName, duration, conditions, source)
    eventIdCounter += 1
    local now = os.clock()
    local event = {
        id = eventIdCounter,
        name = eventName,
        startTime = now,
        endTime = now + duration,
        duration = duration,
        conditions = conditions,
        source = source,
    }
    table.insert(activeEvents, event)
    EventManager._markEventDirty()
    return event.id
end

function EventManager:RemoveEvent(eventId)
    for i, event in ipairs(activeEvents) do
        if event.id == eventId then
            table.remove(activeEvents, i)
            EventManager._markEventDirty()
            break
        end
    end
end

function EventManager:Update()
    local now = os.clock()
    local changed = false
    for i = #activeEvents, 1, -1 do
        if activeEvents[i].endTime <= now then
            table.remove(activeEvents, i)
            changed = true
        end
    end
    if changed then
        EventManager._markEventDirty()
    end
end

-- Dirty flag and last payload for event-based networking
local timeDirty = true
local eventDirty = false
local lastTime = nil
local lastEvent = nil

function EventManager._markTimeDirty()
    timeDirty = true
end

function EventManager._markEventDirty()
    eventDirty = true
end

local function shallowEventListEqual(a, b)
    if #a ~= #b then return false end
    for i, ev in ipairs(a) do
        if not b[i] or ev.id ~= b[i].id or ev.name ~= b[i].name then
            return false
        end
    end
    return true
end

local function sendIfChanged()
    if not timeDirty and not eventDirty then return end
    local timeState = getTimeState()
    local eventState = getEventState()
    local timeChanged = false
    local eventChanged = false
    
    if not lastTime or
       timeState.phase ~= lastTime.phase or
       timeState.moonPhase ~= lastTime.moonPhase then
        timeChanged = true
    elseif not lastEvent or
            not shallowEventListEqual(eventState, lastEvent) then
                eventChanged = true
    end
    if timeChanged then
        for _, player in ipairs(Players:GetPlayers()) do
            Net.DayNight.sendTo(timeState, player)
        end
        lastTime = timeState
        timeDirty = false
    elseif eventChanged then
        for _, player in ipairs(Players:GetPlayers()) do
            Net.Event.sendTo(eventState, player)
        end
        lastEvent = eventState
        eventDirty = false
    end
end


local function tryTriggerRandomEvent()
    local now = os.clock()
    for eventName, def in pairs(EventDefinitions) do
        -- Check phase
        local allowed = false
        for _, phase in ipairs(def.allowedPhases) do
            if phase == currentPhase then
                allowed = true
                break
            end
        end
        if not allowed then continue end
        -- Check interval
        if now - def.lastTriggered < def.minInterval then continue end
        -- Check if already active
        local alreadyActive = false
        for _, event in ipairs(activeEvents) do
            if event.name == eventName then
                alreadyActive = true
                break
            end
        end
        if alreadyActive then continue end
        -- Roll chance (5%)
        if math.random() < 0.15 then
            local duration = math.random(def.minDuration, def.maxDuration)
            EventManager:TriggerEvent(eventName, duration, {phase = currentPhase}, "random")
            def.lastTriggered = now
        end
    end
end

-- Main update loop
RunService.Heartbeat:Connect(function(dt)
    durationLeft -= dt / 60 -- dt is in seconds, durationLeft is in minutes
    timeSinceLastCheck += dt
    EventManager:Update()
    if timeSinceLastCheck >= randomEventCheckInterval then
        tryTriggerRandomEvent()
        timeSinceLastCheck = 0
    end
    if durationLeft <= 0 then
        -- Switch phase
        if currentPhase == "Day" then
            currentPhase = "Night"
            durationLeft = settings.nightDuration
            currentMoonPhase = "Full Moon" --MoonPhase:Next() -- Advance moon phase at night start
        else
            currentPhase = "Day"
            durationLeft = settings.dayDuration
        end
        EventManager._markTimeDirty()
    end
    sendIfChanged()
end)

Players.PlayerAdded:Connect(function(player)
    Net.DayNight.sendTo(getTimeState(), player)
    Net.Event.sendTo(getEventState(), player)
end)

return EventManager