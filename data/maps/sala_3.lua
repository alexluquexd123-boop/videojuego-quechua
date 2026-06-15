local map = ...
local antorcha_conseguida = false 
local altar_ya_encendido = false 

function map:on_started()
  
  -- 🕯️ TRAPMA CENTRAL: GEMA Y ESQUELETOS (SIN SONIDOS)
  sol.timer.start(map, 200, function()
    if not map:has_entity("antorcha_trampa") and not antorcha_conseguida then
      antorcha_conseguida = true 
      
      -- Invocar los 4 esqueletos en sus puestos
      map:create_enemy({ breed = "skelfos", x = 248, y = 104, layer = 0, direction = 3 })
      map:create_enemy({ breed = "skelfos", x = 344, y = 104, layer = 0, direction = 3 })
      map:create_enemy({ breed = "skelfos", x = 248, y = 232, layer = 0, direction = 3 })
      map:create_enemy({ breed = "skelfos", x = 344, y = 232, layer = 0, direction = 3 })
      
      return false 
    end
    return true 
  end)

  -- 🕵️ SENSOR DEL ALTAR (Asegúrate de que se llame: zona_altar)
  local sensor = map:get_entity("zona_altar")
  if sensor then
    -- Al pisar el sensor se activa el globo azul flotante de "Grab"
    function sensor:on_activated()
      local game = map:get_game()
      if not altar_ya_encendido then
        game:set_custom_command_effect("action", "grab")
      end
    end

    -- Al bajarse del sensor se oculta el globo
    function sensor:on_left()
      local game = map:get_game()
      game:set_custom_command_effect("action", nil)
    end
  end
end

-- ⌨️ ACTIVACIÓN CON LA BARRA ESPACIADORA (SPACEBAR)
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  local sensor = map:get_entity("zona_altar")

  local heroe_en_zona = sensor and hero:overlaps(sensor)

  -- Al presionar barra espaciadora sobre el sensor activo
  if key == "space" and heroe_en_zona and not altar_ya_encendido then
    
    if antorcha_conseguida then
      altar_ya_encendido = true
      game:set_custom_command_effect("action", nil) -- Oculta el globito "Grab"
      
      -- 🔥 CREACIÓN DEL FUEGO ANIMADO (Campos de tamaño arreglados)
      local fuego = map:create_custom_entity({
        x = 96,          
        y = 212,         
        layer = 1,       
        width = 16,    -- 🛠️ CORRECCIÓN: Evita el error de 'width expected'
        height = 16,   -- 🛠️ CORRECCIÓN: Evita el error de 'height expected'
        direction = 0
      })
      
      -- Asigna tu sprite animado definitivo
      fuego:create_sprite("fuego_altar") 
      
      print("¡Altar encendido con éxito!")
      
    else
      print("Bloqueado: No tienes la antorcha (gema) para activar esto.")
    end
    
    return true
  end

  -- Mantener la tecla V para el arco
  if key == "v" or key == "V" then
    local arco = game:get_item("bow")
    if arco and arco:get_amount() > 0 then
      hero:start_bow()         
      arco:remove_amount(1)    
    end
    return true
  end
end