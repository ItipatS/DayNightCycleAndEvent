local StarterPlayer = game:GetService("StarterPlayer")
-- ModuleScript: EventRenderer
local Net = require(StarterPlayer.StarterPlayerScripts.Client.clientNet)
local Lighting = game:GetService("Lighting")

type EventData = {
    name: string,
    startTime: number,
    endTime: number
}

local function applyEvents(data:EventData)
    local events = data.name and {data} or {}
    -- Example: Change lighting for Blood Moon event
    for _, event in ipairs(events) do
        if event.name == "BloodMoon" then
            Lighting.FogColor = Color3.fromRGB(180, 0, 50)
            Lighting.OutdoorAmbient = Color3.fromRGB(80, 0, 0)
        end
        -- Add more event visuals as needed
    end
end

return {
    applyEvents = applyEvents
} 