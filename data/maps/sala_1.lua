local map = ...

function map:on_started()
  local game = map:get_game()
  
  -- Forzar la espada
  if game:get_item("sword") then
    game:get_item("sword"):set_variant(1)
  end

  -- Dar munición inicial e inventario
  sol.timer.start(map, 50, function()
    -- Dar y equipar bombas en el HUD (Slot 1)
    local bombas = game:get_item("bomb")
    if bombas then
      bombas:set_variant(1)
      bombas:set_amount(10)
      game:set_item_assigned(1, bombas)
    end
    
    -- Dar arco en el inventario interno (escondido del HUD)
    local arco = game:get_item("bow")
    if arco then
      arco:set_variant(1)
      arco:set_amount(30)
    end
  end)
end

-- DETECTOR MÁGICO: El mapa escucha si presionas la V y dispara la flecha directamente
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  
  if key == "v" or key == "V" then
    local arco = game:get_item("bow")
    -- Si tienes el arco y te quedan flechas, dispara
    if arco and arco:get_amount() > 0 then
      hero:start_bow()         -- Dispara la flecha mecánicamente
      arco:remove_amount(1)    -- Resta una flecha de tu contador interno
    end
    return true -- Le avisa al juego que ya procesamos esta tecla
  end
end

function map:on_opening_transition_finished()
end