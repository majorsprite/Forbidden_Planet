local Event = require "utils.event"
local Global = require "utils.global"
local Validate = require "utils.validate"
local Schedule = require "utils.schedule"
local distance = require "utils.distance"
local config = require "maps.forbidden_planet.config"



local darkness = {}


Global.register({ darkness = darkness }, function(global)
  darkness = global.darkness
end)


local function player_created(event)
  local player = game.players[event.player_index]
  local button = player.gui.top.add{ type = "button", caption = "Threat: 0", name = "darkness_threat_open_button" }

  darkness[player.name] = {
    threat = 0,
    button = button
  }

  player.character.disable_flashlight()
end

local function do_darkness_checks()
  for _, player in pairs(game.connected_players) do
    
    if not Validate.player(player) then goto continue end
    local dist = distance({0,0}, player.position) 
    local player_threat = darkness[player.name].threat
    local button =  darkness[player.name].button

    if Validate.element(button) then
      button.caption = string.format("Threat: %.2f", player_threat)
    end

    if player.surface.name ~= "caverns" then
      darkness[player.name].threat = 0
       goto continue 
    end

    if dist < config.map_gen.spawn_radius * 2 then 
      darkness[player.name].threat = 0
      goto continue 
    end


    
    if player_threat >= 1 then
      goto continue
    end
    

    local lamp = player.surface.find_entities_filtered({ 
      position = player.position, 
      name = "small-lamp", 
      radius = 12,
      limit = 1
    })[1]

    if not lamp then 
      local rand =  math.random(1, 10) * 0.005
      darkness[player.name].threat = darkness[player.name].threat +rand
      if darkness[player.name].threat >= 1 then darkness[player.name].threat = 1 end
    else
      if lamp.energy > 50 and lamp.get_or_create_control_behavior().disabled == false then
        darkness[player.name].threat = 0
      end
    end
    ::continue::
  end
end

local function tick()
  
end


Event.register("player_created", player_created)
Event.register("tick", tick)
Event.on_nth_tick(60 * 2, function()
  Schedule.add(do_darkness_checks, {})
end)