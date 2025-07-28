-- ModuleScript: MoonPhase
local MoonPhase = {}
local current = 1

local Phases = {
	[1] = "Full Moon",
	[2] = "Waning Gibbous",
	[3] = "Third Quarter",
	[4] = "Waning Crescent",
	[5] = "New Moon",
	[6] = "Waxing Crescent",
	[7] = "First Quarter",
	[8] = "Waxing Gibbous",
}

function MoonPhase:Next()
	current += 1
	if current > 8 then current = 1 end
	return Phases[current]
end

function MoonPhase:GetPhaseName()
	return Phases[current]
end

return MoonPhase
