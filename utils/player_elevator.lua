local Event = require "utils.event"
local Global = require "utils.global"
local Validate = require "utils.validate"

-- minimum time between teleports, to prevent going back and forth too quickly
local cooldown_ticks = 60*3
local last_teleport_times = {}

local function run(event)
  for _, player in pairs(game.connected_players) do
    if Validate.player(player) then
      if not last_teleport_times[player.name] then
        last_teleport_times[player.name] = 0
      end
      local time_since_teleport = game.tick - last_teleport_times[player.name]
      if time_since_teleport > cooldown_ticks then
        if player.surface.find_entity("player-port", player.position) then
          local target_surface = player.surface.name == "caverns" and "overworld" or "caverns"
          last_teleport_times[player.name] = game.tick
          player.teleport({-2, 0}, target_surface)
        end
      end
    end
  end
end

-- run often enough to catch a player if they just run across the port
Event.on_nth_tick(5, run)