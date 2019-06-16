local Event = require "utils.event"
local config = require "config"
local Global = require "utils.global"
local Validate = require "utils.validate"
local sizeof = require "utils.sizeof"
local Color = require "utils.color"
local Schedule = require "utils.schedule"
require "utils.math"

local rock_rewards = config.mined_rewards.entities.rocks.rewards
local rocks = config.mined_rewards.entities.rocks

local fortune = {}

Global.register({ fortune = fortune }, function (global)
  fortune = fortune
end)


local function is_entity_rock(entity) 
  for _, rock in pairs(rocks.entities) do
    if entity.name == rock then return true end
  end
  return false
end

local function player_mined(event)

  
  local player = game.players[event.player_index]
  local entity = event.entity
  
  if not Validate.player(player) then return end
  if not Validate.entity(entity) then return end
  
  if not is_entity_rock(entity) then return end


  

  local fortune_level = fortune[player.name] or 0
  local fortune = fortune_level > 0 and fortune_level * (1+config.levels.upgrades["Fortune"].bonus_per_level) or 1
  
  local num_rewards = math.random(sizeof(rock_rewards))

  for i = 0, num_rewards do
    local item_name = math.random_bias(rock_rewards)
    local item = rock_rewards[item_name]
    local count = math.random(item.min * fortune, item.max * fortune)
    player.insert({name = item_name, count = count})
  end

end

local function player_upgraded(event)
  local player = game.players[event.player_index]
  local upgrade = event.upgrade
  local level = event.level

  if upgrade ~= "Fortune" then return end
  fortune[player.name] = level
end

local function player_reset_stats(event)
  local player = game.players[event.player_index]
  fortune[player.name] = 0
end

Event.register("player_mined_entity", player_mined)
Event.register("player_mined_entity", player_mined)
Event.register("player_upgraded_stats", player_upgraded)
Event.register("player_reset_stats", player_reset_stats)