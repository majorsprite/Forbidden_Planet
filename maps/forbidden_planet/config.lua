local config = {
  debug = false,
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
      ["coal"]        = { bias = 15, richness = 1, richness_distance_factor = 1.01 },
      ["iron-ore"]    = { bias = 10, richness = 1, richness_distance_factor = 1.01 },
      ["copper-ore"]  = { bias = 6, richness = 1, richness_distance_factor = 1.01 },
      ["stone"]       = { bias = 4, richness = 1, richness_distance_factor = 1.01 },
      ["crude-oil"]   = { bias = 1, richness = 1, richness_distance_factor = 1.01 },
      ["uranium-ore"] = { bias = 1, richness = 1, richness_distance_factor = 1.01 },
    } 
  }
}




return config