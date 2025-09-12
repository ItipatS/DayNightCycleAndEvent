-- ModuleScript: EventDefinitions

type EventDef = {
    allowedPhases: { "Day" | "Night" },
    minInterval: number,      -- seconds
    minDuration: number,      -- seconds
    maxDuration: number,      -- seconds
    lastTriggered: number,    -- os.clock() time
}
type EventDefinitionsType = { [string]: EventDef }

local EventDefinitions:EventDefinitionsType = {
    ["LunarEclipse"] = {
        allowedPhases = {"Night"},
        minDuration = 60,
        maxDuration = 120,
        minInterval = 600,
        lastTriggered = 0,
    },
    ["SolarEclipse"] = {
        allowedPhases = {"Day"},
        minDuration = 45,
        maxDuration = 90,
        minInterval = 900,
        lastTriggered = 0,
    },
    ["Rain"] = {
        allowedPhases = {"Day", "Night"},
        minDuration = 30,
        maxDuration = 120,
        minInterval = 300,
        lastTriggered = 0,
    },
    ["BloodMoon"] = {
        allowedPhases = {"Night"},
        minDuration = 60,
        maxDuration = 180,
        minInterval = 1200,
        lastTriggered = 0,
    },
}

return EventDefinitions