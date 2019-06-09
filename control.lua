local config = require "config"

require "map" -- edit this file to chagne the map :)


if config.levels.enabled then
  require "features.levels"
end

if config.market.enabled then
  require "features.market"
end

if config.chat_bubbles.enabled then
  require "features.chat_bubbles"
end

if config.player_elevator.enabled then
  require "features.player_elevator"
end
