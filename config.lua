global.config = {

  market = {
    enabled = false, 
    token = "raw-fish",
    data = {}
  },
  levels = { 

    enabled = true,
    max_upgrades = 10,
    reset = { 
      enabled = true, 
      price = { 
        enabled = true,
        token = "coin",
        amount = 25
      }
    },
    experience_drops_enabled = true,
    get_experience_to_level = function(level)
      local value = math.floor(250+(50 * (level ^ 3)) / 5)
      return value
    end,
    upgrades = { 
      ["Mining"]    = { enabled = true, bonus_per_level = 1 },
      ["Crafting"]  = { enabled = true, bonus_per_level = 0.25 },
      ["Inventory"] = { enabled = true, bonus_per_level = 10 },
      ["Health"]    = { enabled = true, bonus_per_level = 50 },
      ["Reach"]     = { enabled = true, bonus_per_level = 0.25 },
      ["Fortune"]   = { enabled = false, bonus_per_level = 1 }
     },
    level_rewards = {
      token = "coin",
      reward_for_level = 1,
      exceptions = { 
        [5]  =  10,
        [10] =  20,
        [15] =  30,
        [20] =  40,
        [25] =  50,
        [30] =  60,
        [35] =  70,
        [40] =  80,
        [45] =  90,
        [50] =  100,
      }
    },
    experience_rates = {
      --rocks
      ["rock-huge"]       = 25, 
      ["rock-big"]        = 20, 
      ["sand-rock-big"]   = 25,
      --biters
      ["small-biter"]     = 5^1,
      ["medium-biter"]    = 5^2,
      ["big-biter"]       = 5^3,
      ["behemoth-biter"]  = 5^4,
      --spitters
      ["small-spitter"]     = 6^1,
      ["medium-spitter"]    = 6^2,
      ["big-spitter"]       = 6^3,
      ["behemoth-spitter"]  = 6^4,
      --worms
      ["small-worm-turret"]     = 10^1,
      ["medium-worm-turret"]    = 10^2,
      ["big-worm-turret"]       = 10^3,
      ["behemoth-worm-turret"]  = 10^4,
      --nests
      ["biter-spawner"]   = 6^3,
      ["spitter-spawner"] = 6^3
     } 
  },
  mined_rewards = { 
    enabled = true,
    entities = {
      rocks = {
        entities = { 
          "rock-huge", 
          "rock-big",
          "sand-rock-big"
        },
        rewards = function() 
          return {name = "coin", count = 1} 
        end
      }
    }
   },
  darkness_tracker = { enabled = true },
  chat_bubbles = { enabled = true },
  player_elevator = {
    enabled = true,

    -- minimum time between teleports, to prevent going back and forth too quickly
    cooldown_ticks = 60 * 3,

    location = {-2, 0}
  },
  circuit_network = {
    enabled = true,
    location = {-6, 0}
  }
}


return global.config