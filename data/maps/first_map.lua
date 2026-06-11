local map = ...

function map:on_started()
  local game = map:get_game()
  local hero = map:get_hero()
  
  -- Teletransporte directo por coordenadas (X = 200, Y = 200) sin buscar banderitas
  hero:teleport("sala_1", nil)
  hero:set_position(200, 200)
end