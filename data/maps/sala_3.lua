local map = ...
local antorcha_conseguida = false
local altar_ya_encendido = false

function map:on_started()
  -- 🚪 Forzamos que la puerta de salida esté cerrada al iniciar
  if map:get_entity("puerta_salida") then 
    map:get_entity("puerta_salida"):set_enabled(true) 
  end

  -- 🔥 Forzamos que tu fuego empiece apagado (por si acaso)
  if map:get_entity("fuego_spray") then
    map:get_entity("fuego_spray"):set_enabled(false)
  end

  -- 💡 TRAMPA CENTRAL: GEMA Y ESQUELETOS
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

  -- 🕵️ SENSOR DEL ALTAR
  local sensor = map:get_entity("zona_altar")
  if sensor then
    function sensor:on_activated()
      local game = map:get_game()
      if not altar_ya_encendido then
        game:set_custom_command_effect("action", "grab")
      end
    end
    
    function sensor:on_left()
      local game = map:get_game()
      game:set_custom_command_effect("action", nil)
    end
  end
end

-- ⌨️ INTERACCIÓN CON LA BARRA ESPACIADORA
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  local sensor = map:get_entity("zona_altar")
  
  local heroe_en_zona = sensor and hero:overlaps(sensor)
  
  if key == "space" and heroe_en_zona and not altar_ya_encendido then
    
    if antorcha_conseguida then
      altar_ya_encendido = true
      game:set_custom_command_effect("action", nil) -- Oculta el "Grab"
      
      -- 🔥 ACTIVAR EL FUEGO DEL MAPA (¡Cero códigos raros de sprites!)
      if map:get_entity("fuego_spray") then
        map:get_entity("fuego_spray"):set_enabled(true)
      end
      
      -- 🚪 ABRIR LA PUERTA DE SALIDA DESAPARECIÉNDOLA
      if map:get_entity("puerta_salida") then
        map:get_entity("puerta_salida"):set_enabled(false)
      end
      
      sol.audio.play_sound("shutter")
      print("¡Altar encendido y puerta abierta con éxito!")
      
    else
      print("Bloqueado: Te falta la antorcha (gema).")
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