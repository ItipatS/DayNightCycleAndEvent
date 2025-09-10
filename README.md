# 🌗 Day-Night Cycle & Dynamic Event System for Roblox

game link 

https://www.roblox.com/games/125022717347718/HarvestTycoon-Alpha

This module provides a complete **day-night cycle** and **environmental event system** for Roblox games, designed to bring immersive, dynamic worlds to life. It handles lighting, ambient sound, background music, and rare special events like **Solar Eclipses**, **Blood Moons**, and **Rain** — all synchronized across server and clients.

## Demo Video
<a href="(https://youtu.be/TtI_wA-DBR0)" target="_blank" rel="noopener noreferrer">
  <img src="https://img.youtube.com/vi/TtI_wA-DBR0/hqdefault.jpg" alt="Watch the video">
</a>

---

## 🎮 Features

- ⏳ **Configurable Day/Night Length**: Adjustable durations for day and night (in minutes).
- 🌕 **Moon Phases**: Auto-cycles through 8 moon phases (Full Moon to New Moon).
- ⚡ **Random Events**: Supports events like:
  - `LunarEclipse`
  - `SolarEclipse`
  - `Rain`
  - `BloodMoon`  
  Each with:
  - Allowed time phase
  - Min/max duration
  - Cooldown interval
  - Random trigger chance
- 🎨 **Dynamic Visuals**:
  - Smooth transitions for fog, lighting, and skybox
  - Moon texture changes with phases
- 🔊 **Adaptive Audio**:
  - Ambient sound changes by time/event
  - Background music with fade transitions
- 🔁 **Client Syncing**:
  - All players receive real-time updates of current phase and active events

---

## 🧩 System Architecture

### 🔧 Core Scripts

| File | Purpose |
|------|---------|
| `init.lua` | Main server logic for day/night cycle and random event triggering |
| `MoonPhase.lua` | Moon phase progression logic |
| `EventDefinitions.lua` | Configs for event rules (duration, cooldown, trigger conditions) |

### 🖥️ Client-side

| File | Purpose |
|------|---------|
| `DayNightRenderer.lua` | Changes Lighting and sky appearance smoothly |
| `EventRenderer.lua` | Applies visuals for active events (e.g., Blood Moon tint) |

### 🔊 Audio

| File | Purpose |
|------|---------|
| `AmbientService.lua` | Fades ambient SFX (e.g., crickets, rain) based on time/event |
| `BGMService.lua` | Fades background music based on time/event |

-

## 🔧 Configuration

You can easily tweak durations and event rules:

```lua
-- EvenrtManager.init.lua
local settings = {
  dayDuration = 0.5,   -- minutes
  nightDuration = 0.5, -- minutes
}
```

```lua
-- EventDefinitions.lua
["Rain"] = {
  allowedPhases = {"Day", "Night"},
  minDuration = 30,
  maxDuration = 120,
  minInterval = 300,
}
```

---

## 🧪 Example Usage

**Server (Auto Sync)**

```lua
Players.PlayerAdded:Connect(function(player)
    Net.DayNight.sendTo(getTimeState(), player)
    Net.Event.sendTo(getEventState(), player)
end)
```

**Client (Update Visuals)**

```lua
Net.DayNight.on(function(state)
    DayNightRenderer.applyDayNight(state.phase, state.moonPhase, state.duration, state.totalDuration)
end)

Net.Event.on(function(events)
    EventRenderer.applyEvents(events)
    AmbientService.updateAmbient(state.phase, events)
    BGMService.updateBGM(state.phase, events)
end)
```

---

## 🧠 Ideal Use Cases

- Open-world RPGs
- Survival games
- Story-driven games needing atmosphere
- Dynamic weather and event-driven maps

---
