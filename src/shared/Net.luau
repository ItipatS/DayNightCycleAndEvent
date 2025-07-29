local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNet = require(ReplicatedStorage.Packages.ByteNet)


return ByteNet.defineNamespace("Packets", function()
    return {
        DayNight = ByteNet.definePacket({
            value = ByteNet.struct({
                phase = ByteNet.string,
                duration = ByteNet.float32,
                totalDuration = ByteNet.float32,
                moonPhase = ByteNet.string,
            })
        }),
        Event = ByteNet.definePacket({
            value = ByteNet.array(ByteNet.struct({
                    id = ByteNet.int32,
                    name = ByteNet.string,
                    startTime = ByteNet.float32,
                    endTime = ByteNet.float32,
                    duration = ByteNet.float32,
                    source = ByteNet.string,
                    -- conditions can be added as needed
                }))
        })
    }
end)