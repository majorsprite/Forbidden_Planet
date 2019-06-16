local Validate = {}


function Validate.player(player) 
  if not player then return false end
  if not player.valid then return false end
  if not player.character then return false end
  if not player.connected then return false end
  if not game.players[player.name] then return false end
  return true
end

function Validate.element(element) 
  if not element then return false end
  if not element.valid then return false end

  return true
end

function Validate.entity(entity) 
  if not entity then return false end
  if not entity.valid then return false end
  return true
end


return Validate