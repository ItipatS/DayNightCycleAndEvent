--!strict
local StarterPlayer = game:GetService("StarterPlayer")
local Net = require(StarterPlayer.StarterPlayerScripts.Client.clientNet)

type Phase = Net.DayPhase                      -- e.g. "Day" | "Night" | "Dawn" | "Dusk"          -- e.g. "Rain" | "Market" | ...
type Events= Net.EventPackage

type AmbientHandler = ({Phase:Phase, Event:Events?}) -> ()

local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local FADE_TIME = 5 -- seconds

local Tracks = {
    Day = "rbxassetid://79717762075739",      -- Replace with your day ambient asset ID (e.g., birds)
    Night = "rbxassetid://94514418207961",    -- Replace with your night ambient asset ID (e.g., crickets)
    -- Add more as needed
}

local currentSound:Sound = nil
local currentTrackKey = nil

local function fadeOut(sound:Sound)
    if sound and sound.IsPlaying then
        local tween = TweenService:Create(sound, TweenInfo.new(FADE_TIME), {Volume = 0})
        tween:Play()
        tween.Completed:Wait()
        sound:Stop()
        sound:Destroy()
    end
end

local function fadeIn(trackId: string): Sound
    local sound:Sound = Instance.new("Sound")
    sound.SoundId = trackId
    sound.Volume = 0
    sound.Looped = true
    sound.Parent = SoundService
    sound:Play()
    local tween = TweenService:Create(sound, TweenInfo.new(FADE_TIME), {Volume = 0.5})
    tween:Play()
    return sound
end

local function getEventAmbient(events: Events?)
    for _, event in ipairs(events) do
        if Tracks[event.name] then
            return event.name
        end
    end
    return nil
end

local updateAmbient: AmbientHandler = function(input)
    local phase:Phase = input.Phase
    local events = input.Events or {}

    local override = getEventAmbient(events)
    local trackKey = override or phase
    if trackKey == currentTrackKey then return end

    local trackId = Tracks[trackKey]
    if not trackId then return end

    local oldSound = currentSound
    currentSound = fadeIn(trackId)
    currentTrackKey = trackKey
    if oldSound then
        fadeOut(oldSound)
    end
end

return {
    updateAmbient = updateAmbient
}