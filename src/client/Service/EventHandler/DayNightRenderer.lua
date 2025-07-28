-- ModuleScript: DayNightRenderer
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local tweenRef

local MoonTextures = {
    ["Full Moon"] = "rbxassetid://17684523086"
    --[[["Full Moon"] = "rbxassetid://127888319954388",
	["Waning Gibbous"] = "rbxassetid://108881093429414",
	["Third Quarter"] = "rbxassetid://133433888402620",
	["Waning Crescent"] = "rbxassetid://139584287151993",
	["New Moon"] = "", -- empty means hidden
	["Waxing Crescent"] = "rbxassetid://112842280165115",
	["First Quarter"] = "rbxassetid://106163991759573",
	["Waxing Gibbous"] = "rbxassetid://100225689841931",]]--
}

local PhasePresets = {
    Day = {
        start = 6,
        target = 18,
        outdoor = Color3.fromRGB(140, 140, 140),
        fog = Color3.fromRGB(149, 195, 208),
        fogEnd = 750,
    },
    Night = {
        start = 18,
        target = 6,
        outdoor = Color3.fromRGB(60, 60, 60),
        fog = Color3.fromRGB(25, 25, 25),
        fogEnd = 250,
    },
}

local function tween(duration, goal)
    if tweenRef then
        tweenRef:Cancel()
    end
    tweenRef = TweenService:Create(
        Lighting,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut
        ), goal
    )
    tweenRef:Play()
end

local function applyDayNight(phaseType, moonPhase, duration, totalDuration)
    local config = PhasePresets[phaseType]
    if not config then return end

    if tweenRef then
        tweenRef:Cancel()
    end
    Lighting.OutdoorAmbient = config.outdoor
    Lighting.FogColor = config.fog
    Lighting.FogEnd = config.fogEnd

    totalDuration = (totalDuration or 10) * 60 -- fallback for debug
    duration = (duration or 10) * 60 -- fallback for debug
    
    local progress = 1 - (duration / totalDuration)
    local startTime = config.start
    local endTime = config.target
    local currentTime = startTime + (endTime - startTime) * progress
    Lighting.ClockTime = currentTime

    if phaseType == "Day" then
        tween(totalDuration, {ClockTime = endTime})
    elseif phaseType == "Night" then
        local halfNight = totalDuration/2
        tween(halfNight, {ClockTime = 24})
        task.wait(halfNight)
        Lighting.ClockTime = 24
        tween(halfNight, {ClockTime = endTime})
    end

    if Lighting:FindFirstChild("Sky") then
        Lighting.Sky.MoonTextureId = MoonTextures[moonPhase] or ""
    end
end

return {
    applyDayNight = applyDayNight
} 