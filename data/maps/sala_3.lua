local map = ...
local antorcha_conseguida = false
local altar_ya_encendido = false

function map:on_started()
  -- 🚪 Forzamos que las puertas estén cerradas al iniciar
  if map:get_entity("puerta_salida") then
    map:get_entity("puerta_salida"):set_enabled(true)
  end
  
  if map:get_entity("puerta_entrada") then
    map:get_entity("puerta_entrada"):set_enabled(true)
  end

  -- 🪵 Troncos de la izquierda: Empiezan ACTIVADOS (Bloqueando)
  if map:get_entity("tronco_1") then
    map:get_entity("tronco_1"):set_enabled(true)
  end
  if map:get_entity("tronco_2") then
    map:get_entity("tronco_2"):set_enabled(true)
  end

  -- 🪵 Troncos de la derecha (Salida): Empiezan DESACTIVADOS (Paso libre al inicio)
  if map:get_entity("tronco_3") then
    map:get_entity("tronco_3"):set_enabled(false)
  end
  if map:get_entity("tronco_4") then
    map:get_entity("tronco_4"):set_enabled(false)
  end

  -- 🔥 Forzamos que tu fuego empiece apagado
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
end

-- 🧙‍♂️ SENSOR DEL ALTAR
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

-- ⌨️ INTERACCIÓN CON LA BARRA ESPACIADORA Y TECLAS
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  local sensor = map:get_entity("zona_altar")

  local heroe_en_zona = sensor and hero:overlaps(sensor)

  -- ACCIÓN DEL ALTAR
  if key == "space" and heroe_en_zona and not altar_ya_encendido then
    if antorcha_conseguida then
      altar_ya_encendido = true
      game:set_custom_command_effect("action", nil) -- Oculta el "Grab"

      -- 🔥 ACTIVAR EL FUEGO DEL MAPA
      if map:get_entity("fuego_spray") then
        map:get_entity("fuego_spray"):set_enabled(true)
      end

      -- 🪵 TRONCOS DE LA IZQUIERDA: Desaparecen
      if map:get_entity("tronco_1") then
        map:get_entity("tronco_1"):set_enabled(false)
      end
      if map:get_entity("tronco_2") then
        map:get_entity("tronco_2"):set_enabled(false)
      end
      
      -- 🪵 TRONCOS DE LA DERECHA (SALIDA): ¡Aparecen de golpe!
      if map:get_entity("tronco_3") then
        map:get_entity("tronco_3"):set_enabled(true)
      end
      if map:get_entity("tronco_4") then
        map:get_entity("tronco_4"):set_enabled(true)
      end

      -- 🚪 ABRIR LA PUERTA DE SALIDA DESAPARECIÉNDOLA
      -- Nota: Aunque la puerta desaparezca por código, los troncos 3 y 4 bloquearán físicamente al jugador.
      if map:get_entity("puerta_salida") then
        map:get_entity("puerta_salida"):set_enabled(false)
      end

      sol.audio.play_sound("shutter")
      print("¡Altar encendido! Los troncos 3 y 4 han aparecido para bloquear la salida.")
    else
      print("Bloqueado: Te falta la antorcha (gema).")
    end
    return true
  end

  -- 🏹 MANTENER LA TECLA V PARA EL ARCO
  if key == "v" or key == "V" then
    local arco = game:get_item("bow")
    if arco and arco:get_amount() > 0 then
      hero:start_bow()
      arco:remove_amount(1)
    end
    return true
  end
end