

global.config = {

  market = {
    enabled = false, 
    token = "raw-fish",
    data = {}
  },
  levels = { 

    enabled = true,
    get_experience_to_level = function(level)
      -- Change this formula to edit level rates
      local val = 0
      for i = 1, level do
        val = val + math.floor((20*i^2.8*1^2*i)*0.15)+200
      end
      return val
    end,
    upgrades = { 
      ["Mining"]    = { enabled = true, bonus_per_level = 1 },
      ["Crafting"]  = { enabled = true, bonus_per_level = 0.25 },
      ["Inventory"] = { enabled = true, bonus_per_level = 10 },
      ["Health"]    = { enabled = true, bonus_per_level = 50 },
      ["Reach"]     = { enabled = true, bonus_per_level = 0.25 },
      ["Fortune"]   = { enabled = false, bonus_per_level = 1 }
     },
    experience_rates = {
      ["rock-huge"] = 50, 
      ["rock-big"] = 40, 
      ["sand-rock-big"] = 50,
      ["small-biter"] = 10
     } 
  },
  darkness_tracker = { enabled = true },
  chat_bubbles = { enabled = true },
}


return global.config