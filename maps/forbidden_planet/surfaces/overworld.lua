local Event = require "utils.event"
local surface_name = "overworld"
local global_config = require "config"

local function init_surface(surface)
  surface.map_gen_settings = {
  autoplace_controls = {
      ["coal"] = { frequency = 1, size = 0.2, richness = 0.05 },
      ["copper-ore"] = { frequency = 1, size = 0.2, richness = 0.05 },
      ["crude-oil"] = { frequency = 1, size = 0.2, richness = 0.05 },
      ["iron-ore"] = { frequency = 1, size = 0.2, richness = 0.05 },
      ["stone"] = { frequency = 1, size = 0.2, richness = 0.05 },
      ["trees"] = { frequency = "none" },
      ["uranium-ore"] = { frequency = 0.1, size = 0.2, richness = 0.05 },
      ["enemy-base"] = { frequency = 15, size = 2, richness = 2 },
    },
    water = 0.1,
    starting_area = 0.7,
    width = 2000000,
    height = 2000000,
    property_expression_names = {
      moisture = 0,
      aux = 0.5,
      temperature = 25,
      cliffiness = 0,
    },
    seed = 95692
  }
  return surface
end

local function init_teleport(surface)
    local port = surface.create_entity{ name = "player-port", position = {-2, 0}, force = game.forces.neutral}
    rendering.draw_text{
        text = "Elevator",
        surface = surface,
        target = port,
        target_offset = {0, -0.4},
        color = { r = 1, g = 1, b = 0},
        alignment = "center"
    }
    port.minable = false
    port.destructible = false
end

local function init()
    local surface = game.create_surface(surface_name)
    init_surface(surface)
    if global_config.player_elevator.enabled then
        init_teleport(surface)
    end
end

Event.on_init(init)