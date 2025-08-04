-- ModuleScript: EventRenderer
local Lighting = game:GetService("Lighting")

local function applyEvents(events)
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