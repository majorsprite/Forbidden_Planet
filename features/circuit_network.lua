local Event = require "utils.event"
local config = require "config"

local function init()

  local entity = "constant-combinator"
  local overworld = game.surfaces["overworld"].create_entity{ name = entity, position = config.circuit_network.location, force = game.forces.neutral}
  local caverns = game.surfaces["caverns"].create_entity{ name = entity, position = config.circuit_network.location, force = game.forces.neutral}

  rendering.draw_text{
      text = "Circuit Network",
      surface = overworld.surface,
      target = overworld,
      target_offset = {0, -0.4},
      color = { r = 1, g = 1, b = 0},
      alignment = "center"
  }
  
  rendering.draw_text{
    text = "Circuit Network",
    surface = caverns.surface,
    target = caverns,
    target_offset = {0, -0.4},
    color = { r = 1, g = 1, b = 0},
    alignment = "center"
  }


  overworld.minable = false
  overworld.destructible = false
  caverns.minable = false
  caverns.destructible = false

  

  overworld.connect_neighbour({
    wire = defines.wire_type.green,
    target_entity = caverns
  })
  overworld.connect_neighbour({
    wire = defines.wire_type.red,
    target_entity = caverns
  })

end

Event.on_init(init)