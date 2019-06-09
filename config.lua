

global.config = {

  market = {
    enabled = false, 
    token = "raw-fish",
    data = {}
  },
  levels = { 

    enabled = true,
    reset = { 
      enabled = true, 
      price = { 
        enabled = true,
        token = "coin",
        amount = 25
      }
    },
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
      
      ["rock-huge"]       = 25, 
      ["rock-big"]        = 20, 
      ["sand-rock-big"]   = 25,

      ["small-biter"]     = 5,
      ["medium-biter"]    = 10,
      ["big-biter"]       = 100,
      ["behemoth-biter"]  = 500,
     } 
  },
  darkness_tracker = { enabled = true },
  chat_bubbles = { enabled = true },
}


return global.config