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

if config.circuit_network.enabled then
  require "features.circuit_network"
end

if config.mined_rewards.enabled then
  require "features.mined_rewards"
end

if config.darkness_threat.enabled then
  require "features.darkness_threat"
end
if config.rocket_defence.enabled then
  require "features.rocket_defence"
end
