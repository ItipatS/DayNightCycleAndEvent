-- ModuleScript: MoonPhase
local MoonPhase = {}
local current = 1

local Phases = {
	[1] = "FullMoon",
	[2] = "WaningGibbous",
	[3] = "ThirdQuarter",
	[4] = "WaningCrescent",
	[5] = "NewMoon",
	[6] = "WaxingCrescent",
	[7] = "FirstQuarter",
	[8] = "WaxingGibbous",
}

function MoonPhase:Next()
	current += 1
	if current > 8 then
		current = 1
	end
	return Phases[current]
end

function MoonPhase:GetPhaseName()
	return Phases[current]
end

return MoonPhase
