--[=[
	@class DayNightCycleAndEventService
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local DayNightCycleAndEventService = {}
DayNightCycleAndEventService.ServiceName = "DayNightCycleAndEventService"

function DayNightCycleAndEventService:Init(serviceBag: ServiceBag.ServiceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrService"))

	-- Internal
	self._serviceBag:GetService(require("DayNightCycleAndEventTranslator"))
end

return DayNightCycleAndEventService