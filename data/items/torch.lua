-- Lua script of item torch.
local item = ...
local game = item:get_game()

function item:on_started()
  -- Le dice al motor que guarde la variante en la partida
  item:set_save_by_variant(true)
end

-- Dejamos este evento vacío por ahora para asegurar que NO rompa el juego
function item:on_map_changed(map)
  -- Ya no llamamos a get_variant() directamente aquí para evitar conflictos al iniciar
end