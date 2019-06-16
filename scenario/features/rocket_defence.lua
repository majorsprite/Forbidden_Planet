local Event = require "utils.event"
local Global = require "utils.global"
local Validate = require "utils.validate"
local config = require "config"

local entities = {}

Global.register({ entities = entities }, function(global)
  entities = global.entities
end)


local function init()
  local surface = game.surfaces[config.rocket_defence.surface]
  silo = surface.create_entity({ name = "rocket-silo", force = game.forces.player, position = config.rocket_defence.position })
  silo.minable = false
  entities["silo"] = silo
end

local function entity_died(event)
  local entity = event.entity
  if not Validate.entity(entity) then return end
  if entity.name ~= "rocket-silo" then return end
  game.print("rocket dead")
end

local function entity_damaged(event)
  local entity = event.entity
  if not Validate.entity(entity) then return end
  if entity.name ~= "rocket-silo" then return end
  local cause = event.cause
  if not Validate.entity(cause) then return end
  if cause.force ~= game.forces.player then return end
  entity.health = entity.health + event.final_damage_amount
end



Event.on_init(init)
Event.register("entity_damaged", entity_damaged)
Event.register("entity_died", entity_died)


commands.add_command("attack", "attack", function()
  if not entities["silo"] then return end
  local radius = 100
  local surface =  game.surfaces[config.rocket_defence.surface]
  local pos = { x = 0, y = 0 }

  for key, entity in pairs(surface.find_entities_filtered({ force="enemy", type = "unit"})) do
      if entity.position.x > pos.x - radius and entity.position.x < pos.x + radius
          and entity.position.y > pos.y - radius and entity.position.y < pos.y + radius then
            entity.set_command({
              type=defines.command.attack,
              target=silo,
              distraction=defines.distraction.by_enemy
          })
          
      end
  end

  game.print("attacking silo")
end)