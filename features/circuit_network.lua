local Event = require "utils.event"
local config = require "config"

local function init()
  local caverns_pole = game.surfaces["caverns"].find_entities_filtered({
    area = {config.circuit_network.location, config.circuit_network.location},
    name = "big-electric-pole",
    limit = 1
  })[1]
  local overworld_pole = game.surfaces["overworld"].find_entities_filtered({
    area = {config.circuit_network.location, config.circuit_network.location},
    name = "big-electric-pole",
    limit = 1
  })[1]

  caverns_pole.connect_neighbour({
    wire = defines.wire_type.green,
    target_entity = overworld_pole
  })
end

Event.on_init(init)