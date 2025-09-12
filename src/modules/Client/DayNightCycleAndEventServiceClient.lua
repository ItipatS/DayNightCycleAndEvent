--[=[
	@class DayNightCycleAndEventServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local DayNightCycleAndEventServiceClient = {}
DayNightCycleAndEventServiceClient.ServiceName = "DayNightCycleAndEventServiceClient"

function DayNightCycleAndEventServiceClient:Init(serviceBag: ServiceBag.ServiceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrServiceClient"))

	-- Internal
	self._serviceBag:GetService(require("DayNightCycleAndEventTranslator"))
end

return DayNightCycleAndEventServiceClient