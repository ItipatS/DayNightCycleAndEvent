-- ModuleScript: AmbientService
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local FADE_TIME = 5 -- seconds

local Tracks = {
    Day = "rbxassetid://79717762075739",      -- Replace with your day ambient asset ID (e.g., birds)
    Night = "rbxassetid://94514418207961",    -- Replace with your night ambient asset ID (e.g., crickets)
    Rain = "rbxassetid://1843532200",     -- Rain ambient
    Market = "rbxassetid://1843532300",   -- Example: market crowd
    -- Add more as needed
}

local currentSound = nil
local currentTrackKey = nil

local function fadeOut(sound)
    if sound and sound.IsPlaying then
        local tween = TweenService:Create(sound, TweenInfo.new(FADE_TIME), {Volume = 0})
        tween:Play()
        tween.Completed:Wait()
        sound:Stop()
        sound:Destroy()
    end
end

local function fadeIn(trackId)
    local sound = Instance.new("Sound")
    sound.SoundId = trackId
    sound.Volume = 0
    sound.Looped = true
    sound.Parent = SoundService
    sound:Play()
    local tween = TweenService:Create(sound, TweenInfo.new(FADE_TIME), {Volume = 0.5})
    tween:Play()
    return sound
end

local function getEventAmbient(events)
    for _, event in ipairs(events) do
        if Tracks[event.name] then
            return event.name
        end
    end
    return nil
end

local function updateAmbient(phase, events)
    local trackKey = getEventAmbient(events) or phase
    print(phase, events, trackKey)
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