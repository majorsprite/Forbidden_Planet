local config = {
  debug = false,
  darkness_tracker = { enabled = true },
  map_gen = {
    seed = 9876,
    spawn_radius = 10,
    rocks = {"rock-huge", "rock-big", "sand-rock-big"},
    trees = {"dead-dry-hairy-tree", "dead-tree-desert", "dead-grey-trunk", "dry-hairy-tree", "dry-tree"},
    tiles = {
      dirt = { "dirt-4", "dirt-5", "dirt-6", "dirt-7" },
      grass = { "grass-2", "grass-4" },
      water = { "deepwater-green", "water-green" }
    },
    resources = {
      ["coal"]        = { bias = 15, size = 1, richness = 1, richness_distance_factor = 1.01 },
      ["iron-ore"]    = { bias = 10,  size = 1, richness = 1, richness_distance_factor = 1.01 },
      ["copper-ore"]  = { bias = 6,  size = 1, richness = 1, richness_distance_factor = 1.01 },
      ["stone"]       = { bias = 4,  size = 1, richness = 1, richness_distance_factor = 1.01 },
      ["crude-oil"]   = { bias = 1,  size = 1, richness = 1, richness_distance_factor = 1.01 },
      ["uranium-ore"] = { bias = 1,  size = 1, richness = 1, richness_distance_factor = 1.01 },
    } 
  }
}




return config