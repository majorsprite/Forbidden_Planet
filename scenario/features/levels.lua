local Event = require "utils.event"
local config = require "config"
local Global = require "utils.global"
local Validate = require "utils.validate"
local sizeof = require "utils.sizeof"
local Gui = require "utils.gui"
local Color = require "utils.color"
local count_occupied_inventory_slots = require "utils.count_occupied_inventory_slots"
require "utils.math"

local levels = { }

Global.register({ levels = levels }, function (global) 
  levels = global.levels
end)

Event.create_custom_event("on_player_upgraded_stats")
Event.create_custom_event("on_player_reset_stats")


local max_upgrades = config.levels.max_upgrades
local upgrades = config.levels.upgrades
local get_experience_to_level = config.levels.get_experience_to_level
local experience_drops_enabled = config.levels.experience_drops_enabled



local function do_level_up(player, entity)

  local experience_rate = config.levels.experience_rates[entity.name]
  local level = levels[player.name].level
  local experience_to_level = get_experience_to_level(level + 1)
  if not experience_rate then return end

  local current_experience = levels[player.name].experience
  local new_experience = current_experience + experience_rate
  levels[player.name].experience = new_experience

  if experience_drops_enabled then
    player.surface.create_entity({
      name = "flying-text",
      position = player.position,
      text = string.format("+%d xp", experience_rate),
      color = Color.dodgerblue()
    })
  end

  while new_experience >= experience_to_level do
    levels[player.name].level = levels[player.name].level + 1
    levels[player.name].talent_points = levels[player.name].talent_points + 1

    local level_reward = config.levels.level_rewards
    local token = level_reward.token
    local reward_for_level = level_reward.reward_for_level
    local exception = level_reward.exceptions[levels[player.name].level]
    
    local insert = {
      name = token,
      count = exception or reward_for_level
    }
    player.print({"info.level_up_message", levels[player.name].level, exception or reward_for_level, token})
    player.insert(insert)
    experience_to_level = get_experience_to_level(levels[player.name].level + 1)
  end
end

local function player_mined(event)
  local player = game.players[event.player_index]
  local entity = event.entity

  if not Validate.player(player) then return end
  if not Validate.entity(entity) then return end
  
  do_level_up(player, entity)
  
  
end

local function update_player_bonuses(player, upgrade, level)

  if upgrade == "Mining" then
    player.character_mining_speed_modifier = config.levels.upgrades["Mining"].bonus_per_level * level
  elseif upgrade == "Crafting" then
    player.character_crafting_speed_modifier = config.levels.upgrades["Crafting"].bonus_per_level * level
  elseif upgrade == "Inventory" then
    player.character_inventory_slots_bonus = config.levels.upgrades["Inventory"].bonus_per_level * level
  elseif upgrade == "Health" then
    player.character_health_bonus = config.levels.upgrades["Health"].bonus_per_level * level
  elseif upgrade == "Reach" then
    player.character_resource_reach_distance_bonus = config.levels.upgrades["Reach"].bonus_per_level * level
  elseif upgrade == "Speed" then
    player.character_running_speed_modifier = config.levels.upgrades["Speed"].bonus_per_level * level
  end

end

local function entity_died(event)
  local entity = event.entity
  local cause = event.cause

  if not Validate.entity(entity) then return end
  if not cause then return end
  if cause.name ~= "character" then return end
  local player = cause.player
  if not Validate.player(player) then return end

  do_level_up(player, entity)
end

local function player_respawned(event)
  local player = game.players[event.player_index]
  if not Validate.player(player) then return end

  for upgrade, data in pairs(upgrades) do
    if not data.enabled then goto continue end
    update_player_bonuses(player, upgrade, levels[player.name].upgrades[upgrade])
    ::continue::
  end

end

local function entity_damaged(event)
  local entity_is_turret = false
  local turrets = {
    "small-worm-turret",
    "medium-worm-turret",
    "big-worm-turret",
    "behemoth-worm-turret",
  }

  local entity = event.entity
  local cause = event.cause

  if not Validate.entity(entity) then return end
  if not cause then return end
  if cause.name ~= "character" then return end
  local player = cause.player
  if not Validate.player(player) then return end

  for _, name in pairs(turrets) do
    if name == entity.name then 
      entity_is_turret = true
      break
     end
  end

  if not entity_is_turret then return end

  if entity.health <= 0 then
    do_level_up(player, entity)
  end

end

local function get_point_string(level)

  if level > 0 then
    return (string.rep("■", level) .. string.rep("□", max_upgrades - level))
  else
    return string.rep("□", max_upgrades)
  end
end

local function player_created(event)

  local player = game.players[event.player_index]
  
  local button = player.gui.top.add{ type = "button", caption = "level: 1", name = "level_gui_open_button"}

  local player_upgrades = {}

  for upgrade, enabled in pairs(upgrades) do
    player_upgrades[upgrade] = 0
  end
  
  levels[player.name] = { 
    button = button,
    upgrades = player_upgrades, 
    level = 1,
    experience = 0, 
    talent_points = 100
  }


end

local function reset_talents(player)
  for upgrade, data in pairs(upgrades) do
    if not data.enabled then goto continue end
    levels[player.name].upgrades[upgrade] = 0
    if upgrade == "Inventory" then
      update_player_bonuses(player, upgrade, 0)
    else
      update_player_bonuses(player, upgrade, 1)
    end
    ::continue::
  end
  levels[player.name].talent_points = levels[player.name].level
end

local function update_gui()

  for _, player in pairs(game.connected_players) do
    if not Validate.player(player) then goto continue end
    if not levels[player.name] then goto continue end

    if levels[player.name].elements then
      for name, value in pairs(levels[player.name].elements) do
        if not Validate.element(value) then goto continue end
        value.caption = get_point_string(levels[player.name].upgrades[name])
        ::continue::
      end 
    end

    local button = levels[player.name].button
    if Validate.element(button) then
      local level_string = string.format("Level: %d", levels[player.name].level)
      if button.caption ~= level_string then
        button.caption = level_string
      end
    end

    local experience_label = levels[player.name].experience_label
    if Validate.element(experience_label) then
      experience_label.caption = string.format("%d/%d",levels[player.name].experience, get_experience_to_level(levels[player.name].level + 1))
    end

    local talent_points_label = levels[player.name].talent_points_label
    if Validate.element(talent_points_label) then
      talent_points_label.caption = string.format("Talent Points: %d", levels[player.name].talent_points)
    end

    local progress_bar = levels[player.name].progress_bar
    if Validate.element(progress_bar) then
      local lvl = levels[player.name].level
      local exp = levels[player.name].experience
      local from = get_experience_to_level(lvl)
      local to = get_experience_to_level(lvl + 1)
      local value
      if lvl == 1 then
        value = math.map(exp, 0, to, 0, 1)
      else
        value = math.map(exp, from, to, 0, 1)
      end
      progress_bar.value = value
    end

    ::continue::
  end
end

local function gui_closed(event)
  local player = game.players[event.player_index]
  local type = event.gui_type
  
  if type == defines.gui_type.custom then
    local frame = levels[player.name].frame
    if not frame or not Validate.element(frame) then return end
    frame.destroy()
    levels[player.name].frame = nil
    levels[player.name].elements = nil
    levels[player.name].experience_label = nil
    levels[player.name].progress = nil
    levels[player.name].talent_points_label = nil
  end
end

local function gui_click(event)

  local player = game.players[event.player_index]
  local element = event.element

  if not Validate.player(player) then return end
  if not Validate.element(element) then return end

  local i,j = string.find(element.name, "level_gui_button_")
  if i then
    local upgrade_name = string.sub(element.name, j + 1, string.len(element.name))
    local upgrade = levels[player.name].upgrades[upgrade_name]
    local talent_points = levels[player.name].talent_points
    if upgrade >= max_upgrades then return end
    if talent_points == 0 then return end
    levels[player.name].upgrades[upgrade_name] = upgrade + 1
    update_player_bonuses(player, upgrade_name, levels[player.name].upgrades[upgrade_name])
    levels[player.name].talent_points = talent_points - 1
    Event.trigger("on_player_upgraded_stats", { player_index = player.index, upgrade = upgrade_name, level = levels[player.name].upgrades[upgrade_name] })
  elseif element.name == "level_gui_open_button" then
    if levels[player.name].frame then 
      player.opened = nil
    return end

    local frame = player.gui.left.add{ type = "frame", direction = "vertical" }
    frame.style.minimal_width = 250
    local table = frame.add{ type = "table", column_count = 2}
    Gui.header(table, "Talents")
    local reset_enabled = config.levels.reset.enabled
    local reset_price_enabled = config.levels.reset.price.enabled
    local reset_price = config.levels.reset.price.amount
    local reset_token = config.levels.reset.price.token
    local tooltip = "Resets Talents."

    if reset_price_enabled then
      tooltip = tooltip .. string.format("\nPrice: %d [item=%s]", reset_price, reset_token)
    end

    local reset_button = table.add{
      type = "button", 
      caption = "⟲",
      tooltip = tooltip,
      name = "level_gui_reset_button"
    }
    --reset_button.style = "tool_button"
    reset_button.style.width = 25
    reset_button.style.height = 25
    reset_button.style.padding = 0
    reset_button.style.font = "default"

    if not reset_enabled then
      reset_button.enabled = false
    end
    
  
    local temp = {}
  
    local table = frame.add{ type = "table", column_count = 3 }
    local player_upgrades = {}
    
    for upgrade, data in pairs(upgrades) do
      if not data.enabled then goto continue end
    
      local name = table.add{ type = "label", caption = string.format("%s:", upgrade) }
      local dots = table.add{ type = "label", caption = "" }
      local add = table.add{ type = "button", caption = "+", name = string.format("level_gui_button_%s",upgrade)}
    
      dots.style.height = 25
      dots.style.vertical_align = "center"
      dots.style.horizontal_align = "right"
    
      add.style.width = 25
      add.style.height = 25
      add.style.padding = 0
      add.style.font = "default"
    
      name.style.vertical_align = "center"
      name.style.height = 25
      
      temp[upgrade] = dots
      player_upgrades[upgrade] = 0  
      ::continue::
    end


    Gui.spacer(frame, 10)
    Gui.header(frame, "Experience")
    local progress_bar = Gui.bar(frame, Color.lime())
    local experience_label = Gui.label(frame, "", "center")
    local talent_points_label = Gui.header(frame, "talent Points: 1", "center")
    levels[player.name].elements = temp
    levels[player.name].frame = frame
    levels[player.name].experience_label = experience_label
    levels[player.name].progress_bar = progress_bar
    levels[player.name].talent_points_label = talent_points_label
    player.opened = frame
  elseif element.name == "level_gui_reset_button" then
    if not config.levels.reset.enabled then return end

    local inventory = player.get_main_inventory()  
    local occupied_slots = count_occupied_inventory_slots(inventory)
  

    if occupied_slots > 80 then  
      player.print({"info.clear_inventory_before_resetting_talents", occupied_slots})
      return
    end

    if config.levels.reset.price.enabled then
      local inventory = player.get_main_inventory()
      local token = config.levels.reset.price.token
      local player_tokens = inventory.get_item_count(token)
      local amount = config.levels.reset.price.amount
      if player_tokens < amount then
        player.print({"info.talent_reset_insufficient_funds", token, amount})
        return
      end
      player.remove_item({ name = token, count = amount })
      reset_talents(player)
    else
      reset_talents(player)
    end
    Event.trigger("on_player_reset_stats", { player_index = player.index })
  end
end

commands.add_command("levels", "usage /levels or /levels <name>\nLists the levels by a player or players", function(event)
  local player = game.players[event.player_index]
  if not Validate.player(player) then return end
  local params = event.parameter
  if not params then
    for _, p in pairs(game.connected_players) do
      player.print(p.name, p.color)
      player.print(string.format("%10s %s","Level:" ,levels[p.name].level))
      player.print(string.format("%15s %s","Experience:", levels[p.name].experience))
    end
  else
    local target_player = game.players[params]
    if not Validate.player(target_player) then return end
    player.print(target_player.name, target_player.color)
    player.print(string.format("%10s %s","Level:" ,levels[target_player.name].level))
    player.print(string.format("%15s %s","Experience:", levels[target_player.name].experience))
  end
end)



Event.register("tick", update_gui)
Event.register("player_created", player_created)
Event.register("player_mined_entity", player_mined)
Event.register("player_respawned", player_respawned)
Event.register("entity_died", entity_died)
Event.register("entity_damaged", entity_damaged)
Event.register("gui_click", gui_click)
Event.register("gui_closed", gui_closed)

