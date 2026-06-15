local map = ...

function map:on_started()
  local game = map:get_game()
  
  -- Asegurar que tienes la espada al entrar aquí
  if game:get_item("sword") then
    game:get_item("sword"):set_variant(1)
  end

  -- Dar munición de arco de forma interna al entrar a esta sala
  sol.timer.start(map, 50, function()
    local arco = game:get_item("bow")
    if arco then
      arco:set_variant(1)
      arco:set_amount(30) -- Te da 30 flechas para probar tus puzles
    end
  end)
end

-- ACTIVER LA TECLA V EN LA SALA 2
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  
  if key == "v" or key == "V" then
    local arco = game:get_item("bow")
    -- Si tienes flechas en tu inventario invisible, dispara
    if arco and arco:get_amount() > 0 then
      hero:start_bow()         -- Dispara mecánicamente
      arco:remove_amount(1)    -- Resta una flecha
    end
    return true
  end
end