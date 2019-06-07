local config = require "config"

require "map" -- edit this file to chagne the map :)

if config.market.enabled then
  require "features.market"
end


