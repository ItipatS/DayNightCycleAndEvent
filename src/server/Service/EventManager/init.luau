--!strict
-- ServerScriptService: EventManager
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Net = require(ServerScriptService.Server.serverNet)

local EventDefinitions = require(script.EventDefinitions)
local MoonPhase = require(script.MoonPhase)

type Phase = Net.DayPhase
type DayNightData = Net.DayNightData
type Events = Net.EventPackage
local activeEvents:Events = {}

local eventIdCounter:number = 0

-- State for day/night cycle
local settings = {
    dayDuration = .5,   -- minutes
    nightDuration = .5, -- minutes
}
local currentPhase:Phase = "Day"        -- "Day" or "Night"
local durationLeft:number = settings.dayDuration
local currentMoonPhase:Net.MoonPhase = MoonPhase:GetPhaseName()

-- Dirty flag and last payload for event-based networking
local timeDirty = true
local eventDirty = false

local function markTimeDirty() timeDirty = true end
local function markEventDirty() eventDirty = true end

-- Helpers
local function totalDurationThisPhaseSec(): number
	return (currentPhase == "Day") and settings.dayDuration or settings.nightDuration
end

local function getTimeState():DayNightData
    return {
        Phase = currentPhase,
        Duration = durationLeft,
        TotalDuration = totalDurationThisPhaseSec(),
        Moon = currentMoonPhase,
    }
end

local function getEventState():Events
    return activeEvents
end

local function TriggerEvent(eventName:string, duration:number, source:string):number
    eventIdCounter += 1
    local id = eventIdCounter

    local now = os.clock()
    local event = {
        Name = eventName,
        StartTime = now,
        EndTime = now + duration,
        Duration = duration,
        Source = source,
    }
    activeEvents[id] = event
    markEventDirty()
    return id
end

local function RemoveEvent(eventId:number)
    if activeEvents[eventId] ~= nil then
        activeEvents[eventId] = nil
        markEventDirty()
    end
end

local function Update()
    local now = os.clock()
    local changed = false
    for id, ev in pairs(activeEvents) do
        if ev.EndTime <= now then   -- NOTE: 'EndTime' (capital E) to match what you set
            activeEvents[id] = nil
            changed = true
        end
    end
    if changed then
        markEventDirty()
    end
end

local function sendIfChanged()
    if timeDirty then
		Net.DayNight.FireAll(getTimeState())
		timeDirty = false
	end
	if eventDirty then
        print(activeEvents)
		-- Send the whole map; if this becomes heavy, add a Blink EventDelta later
		Net.Event.FireAll(activeEvents)
		eventDirty = false
	end
end

-- Random event scheduler
local randomEventCheckInterval = 60 -- seconds (in-game hour)
local timeSinceLastCheck = 0

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
        if not allowed then
            continue
        end

        -- Check interval
        if now - def.lastTriggered < def.minInterval then
            continue
        end

        -- Check if already active
        local alreadyActive = false
        for _, event in ipairs(activeEvents) do
            if event.name == eventName then
                alreadyActive = true
                break
            end
        end

        -- Roll chance (15%)
        if math.random() < 0.15 then
            local duration = math.random(def.minDuration, def.maxDuration)
            TriggerEvent(eventName, duration, "random")
            def.lastTriggered = now
        end
    end
end

-- Main update loop
local function HeartBeatUpdate(dt)

    durationLeft -= dt / 60 -- dt is in seconds, durationLeft is in minutes
    timeSinceLastCheck += dt

    Update()

    if timeSinceLastCheck >= randomEventCheckInterval then
        tryTriggerRandomEvent()
        timeSinceLastCheck = 0
    end

    if durationLeft <= 0 then
        -- Switch phase
        if currentPhase == "Day" then
            currentPhase = "Night"
            durationLeft = settings.nightDuration
            currentMoonPhase = "FullMoon" --MoonPhase:Next() -- Advance moon phase at night start
        else
            currentPhase = "Day"
            durationLeft = settings.dayDuration
        end
        markTimeDirty()
    end
    
    sendIfChanged()
end

local function PlayerAdded(player)
    Net.DayNight.Fire(player, getTimeState())
    Net.Event.Fire(player, getEventState())
end

return {
    HeartBeatUpdate = HeartBeatUpdate,
    PlayerAdded = PlayerAdded,
    TriggerEvent = TriggerEvent,
    RemoveEvent = RemoveEvent,
    GetTimeState = getTimeState,
    GetEventState = getEventState,
}