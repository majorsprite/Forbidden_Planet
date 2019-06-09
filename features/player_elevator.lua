local Event = require "utils.event"
local Global = require "utils.global"
local Validate = require "utils.validate"
local config = require "config"

local last_teleport_times = {}
Global.register({ last_teleport_times = last_teleport_times }, function (global)
  last_teleport_times = global.last_teleport_times
end)

local function run(event)
  for _, player in pairs(game.connected_players) do
    if Validate.player(player) then
      if not last_teleport_times[player.name] then
        last_teleport_times[player.name] = 0
      end
      local time_since_teleport = game.tick - last_teleport_times[player.name]
      if time_since_teleport > config.player_elevator.cooldown_ticks then
        if player.surface.find_entity("player-port", player.position) then
          local target_surface = player.surface.name == "caverns" and "overworld" or "caverns"
          last_teleport_times[player.name] = game.tick
          player.teleport(config.player_elevator.location, target_surface)
        end
      end
    end
  end
end

-- run often enough to catch a player if they just run across the port
Event.on_nth_tick(5, run)