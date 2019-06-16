local config = require "maps.forbidden_planet.config"
local Event = require "utils.event"
local Global = require "utils.global"
local Schedule = require "utils.schedule"
local distance = require "utils.distance"
local Perlin = require "utils.perlin"
local Simplex = require "utils.simplex"
local generate_entities = require "utils.generate_entities"
local Validate = require "utils.validate"
local sizeof = require "utils.sizeof"
local global_config = require "config"
require "utils.math"



local surface_name = "caverns"

local rock_table = config.map_gen.rocks
local dirt_table = config.map_gen.tiles.dirt
local water_table = config.map_gen.tiles.water
local grass_table = config.map_gen.tiles.grass
local tree_table = config.map_gen.trees

Perlin:setSeed(config.map_gen.seed)
Simplex:setSeed(config.map_gen.seed)

local function init_surface(surface)

  surface.map_gen_settings = {
    default_enable_all_autoplace_controls = false,
    starting_points = {{x = 0,y = 0}},
    starting_area = 0.25,
    seed = config.map_gen.seed,
    property_expression_names = {
      aux = 1,
      moisture  = 0.2, 
      temperature = 50,
      cliffiness = 0
    }
  }
  surface.freeze_daytime = 1
  surface.daytime = 1
  surface.min_brightness = 0.04
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
  surface.request_to_generate_chunks({0,0}, 2)
  if global_config.player_elevator.enabled then
    init_teleport(surface)
  end
end

local function is_entity_rock(entity) 

  for _, rock in pairs(rock_table) do
    if entity.name == rock then return true end
  end

  return false
end

local function get_noise_for(x, y)




  local o1 = Simplex:noise(x / 50, y / 50)
  local o2 = Simplex:noise(x / 15, y / 15)
  local ore = o1 * 0.9 + o2 * 0.1


  local l1 = Simplex:noise(x / 250, y / 200)
  local l2 = Simplex:noise(x / 20, y / 20)
  local large = l1 * 0.99 + l2 * 0.01

  local s1 = Simplex:noise(x / 100, y / 100)
  local s2 = Simplex:noise(x / 10, y / 10)
  local small = s1 * 0.98 + s2 * 0.02
  
  local p1 = Simplex:noise(x / 25, y / 25)
  local p2 = Simplex:noise(x / 13, y / 13)
  local path = p1 * 0.95 + p2 * 0.5


  local w1 = Simplex:noise(x / 38, y / 38)
  local w2 = Simplex:noise(x / 10, y / 10)
  local water = w1 * 0.9 + w2 * 0.1

  return { small = small, large = large, path = path, ore = ore, water = water }
end



local function flood_fill(x, y, surface) 


  --surface.request_to_generate_chunks({x, y}, 1)
  --surface.force_generate_chunk_requests()
  
  local entities = {}  
  for pos_y = y - 1, y + 1 do
    for pos_x = x - 1, x + 1 do
      if pos_y == y and pos_x == x then goto continue end
      local pos = { x = pos_x, y = pos_y }

      

      local noise_vaules = get_noise_for(pos.x, pos.y)
      local ore = noise_vaules.ore
      local large = noise_vaules.large
      local small = noise_vaules.small
      local path = noise_vaules.path
      local water = noise_vaules.water
  
      local current_tile = surface.get_tile(pos)
      local check_tile = config.debug and "lab-dark-2" or "out-of-map"
      local rock = rock_table[math.random(#rock_table)]
      if current_tile.name == check_tile then 
        local tile
        if water > 0.85 and ore < 0.75 then 
          tile = water_table[math.random(#water_table)]
        else
          tile = dirt_table[math.random(#dirt_table)]
        end
        surface.set_tiles({{ name = tile, position = pos }})

        if water > 0.85 and ore < 0.75 then 
          flood_fill(pos.x, pos.y, surface)
        end
        
        if small > 0.8  then 

          if math.random() < 0.01 then
            local tree = tree_table[math.random(#tree_table)]
            surface.create_entity({ name = tree, position = pos })
          end
          
          flood_fill(pos.x, pos.y, surface)

        elseif large > 0.8 then


          if math.random() < 0.05 then
            local tree = tree_table[math.random(#tree_table)]
            surface.create_entity({ name = tree, position = pos })
          end

          flood_fill(pos.x, pos.y, surface)

        elseif path > 0.5 and path < 0.9 and (small < 0  and large < 0.85) then

          if math.random() < 0.01 then
            local tree = tree_table[math.random(#tree_table)]
            surface.create_entity({ name = tree, position = pos })
          end
          flood_fill(pos.x, pos.y, surface) 
        else
          if not current_tile.name:find("water") then
            surface.create_entity({ name = rock, position = pos })
          end
        end

        if ore > 0.75 then
          local close = surface.find_entities_filtered{ position = pos, radius = 5, type = "resource", limit = 1 }
          local name = (close[1]) and close[1].name or math.random_bias(config.map_gen.resources)
          local richness = config.map_gen.resources[name].richness
          local richness_distance_factor = config.map_gen.resources[name].richness_distance_factor
          local dist = distance({0,0}, {pos_x, pos_y})
          richness_distance_factor = richness_distance_factor + (dist * 0.1)
          local amount = math.random((400 * richness_distance_factor) * richness, (400 * richness_distance_factor) * richness * 1.2)
          if name == "crude-oil" and close[1] then goto dont_spawn end
          surface.create_entity({ name = name, position = pos, amount = amount } )
          ::dont_spawn::
        end 

        


      end

      

      ::continue::
    end
  end

  --surface.regenerate_decorative(nil, {{ x = xx - 1, y = yy - 1 }})
end




local function chunk_generated(event)
  if event.surface.name ~= surface_name then return end
  local surface = event.surface
  local area = event.area
  local tiles = {}
  local entities = {}

  
  for py = 1, 32 do
    for px = 1, 32 do
      local x = px + area.left_top.x
      local y = py + area.left_top.y
      local position = { x, y }
      local dist = distance({0,0}, position)
      
      local tile = config.debug and "lab-dark-2" or "out-of-map"
      
      if dist < config.map_gen.spawn_radius then
        tile = "dirt-1"
        if dist > config.map_gen.spawn_radius - 1 then
          table.insert(entities,{ name = "rock-huge", position = position })
        end
      end
      
      if config.debug  then

        local noise_vaules = get_noise_for(x, y)
        local ore = noise_vaules.ore
        local large = noise_vaules.large
        local small = noise_vaules.small
        local path = noise_vaules.path
        local water = noise_vaules.water
        

        
        if small > 0.8 then
          tile = "sand-1"
        end
        
        if large > 0.8 then
          tile = "grass-1"
        end
        
        if path > 0.5 and path < 0.9 then
          tile = "dirt-1"
        end

        if water > 0.85 then
          tile = "water"
        end
        
        
        surface.set_tiles({{ name = tile, position = position }})
        if ore > 0.75 then
          local close = surface.find_entities_filtered{ position = position, radius =5.5, type = "resource", limit = 1 }
          local name = (close[1]) and close[1].name or math.random_bias(config.map_gen.resources)
          surface.create_entity({ name = name, position = position } )
        end
        
      else
        surface.set_tiles({{ name = tile, position = position }})
      end

      
    end
  end
  generate_entities(entities, surface)

end

local function darkness(surface, position)
  
  local lamps = surface.find_entities_filtered({ 
    position = position, 
    name = "small-lamp", 
    radius = 15
  })

  for _, lamp in pairs(lamps) do

    local enemies_in_light = surface.find_entities_filtered({ 
      position = lamp.position, 
      force = "enemy",
      radius = 15
    })

    for _, enemy in pairs(enemies_in_light) do
      if enemy.valid then
        enemy.destroy()
      end
    end

  end
end

local function player_mined(event)
  local player = game.players[event.player_index]
  local entity = event.entity

  if not Validate.player(player) then return end
  if not Validate.entity(entity) then return end
  if not is_entity_rock(entity) then return end
  local x = entity.position.x
  local y = entity.position.y
  local surface = entity.surface

  event.buffer.clear()
  flood_fill(x, y, surface)
end

local function entity_died(event)
  local entity = event.entity
  local loot = event.loot

  if not Validate.entity(entity) then return end
  if not is_entity_rock(entity) then return end

  if loot then loot.clear() end
  local surface = entity.surface
  local x = entity.position.x
  local y = entity.position.y
  flood_fill(x, y, surface)
end 




Event.on_init(init)
Event.register("chunk_generated", chunk_generated)
Event.register("player_mined_entity", player_mined)
Event.register("entity_died", entity_died)

