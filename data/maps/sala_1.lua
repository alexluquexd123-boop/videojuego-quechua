local map = ...

function map:on_started()
  local game = map:get_game()
  local hero = map:get_hero()
  
  -- Forzar la espada al iniciar
  if game:get_item("sword") then
    game:get_item("sword"):set_variant(1)
  end

  -- Dar munición inicial Y LUEGO HACER EL TELEPORT DEL TRUCO
  sol.timer.start(map, 50, function()
    local bombas = game:get_item("bomb")
    if bombas then
      bombas:set_variant(1)
      bombas:set_amount(10)
      game:set_item_assigned(1, bombas) -- Equipar bombas en el HUD
    end
    
    local arco = game:get_item("bow")
    if arco then
      arco:set_variant(1)
      arco:set_amount(30) -- Dar 30 flechas
    end

    -- 🚀 EL TELEPORT: Espera 50 milisegundos y te manda directo a la sala 2
    hero:teleport("sala_9", "entrada_sala_9") --cambiar el nombre  de la sala y el del teleport azul--
  end)
end

-- Esto mantiene activada la tecla V en la sala 1 por si acaso
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  
  if key == "v" or key == "V" then
    local arco = game:get_item("bow")
    if arco and arco:get_amount() > 0 then
      hero:start_bow()         
      arco:remove_amount(1)    
    end
    return true
  end
end