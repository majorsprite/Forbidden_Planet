local Event = require "utils.event"
local Global = require "utils.global"
local Validate = require "utils.validate"

local current_messages = {}

Global.register({ current_messages = current_messages }, function(global)
  current_messages = global.current_messages
end)


local function chat(event)
  if not event then return end
  if not event.player_index then return end
  local player = game.players[event.player_index]
  if not Validate.player(player) then return end
  local surface = player.surface
  local message = event.message

  if message then
    if current_messages[player.name] then
      rendering.destroy(current_messages[player.name])
    end
    local id = rendering.draw_text({
      text = message, 
      surface = surface,
      target = player.character,
      target_offset = { 0, -3 },
      color = { r = player.color.r, g = player.color.g, b = player.color.b },
      time_to_live = 120,
      alignment = "center"
    })
    current_messages[player.name] = id
  end
end

Event.register("console_chat", chat)