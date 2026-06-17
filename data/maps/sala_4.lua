local map = ...
local antorcha_conseguida = true -- Modo diseño activado para pruebas rápidas
local altar_2_encendido = false
local altar_3_encendido = false
local altar_4_encendido = false
local altar_5_encendido = false
local altar_6_encendido = false

-- =========================================================================
-- 🎛️ CONFIGURACIÓN AL INICIAR EL MAPA
-- =========================================================================
function map:on_started()
  -- 🚪 Forzamos que los puentes empiecen cerrados al iniciar
  if map:get_entity("puente_1") then
    map:get_entity("puente_1"):set_enabled(false)
  end
  if map:get_entity("puente_2") then
    map:get_entity("puente_2"):set_enabled(false)
  end

  -- 🔥 Forzamos que todos los sprays de fuego empiecen apagados
  if map:get_entity("fuego_spray_2") then map:get_entity("fuego_spray_2"):set_enabled(false) end
  if map:get_entity("fuego_spray_3") then map:get_entity("fuego_spray_3"):set_enabled(false) end
  if map:get_entity("fuego_spray_4") then map:get_entity("fuego_spray_4"):set_enabled(false) end
  if map:get_entity("fuego_spray_5") then map:get_entity("fuego_spray_5"):set_enabled(false) end
  if map:get_entity("fuego_spray_6") then map:get_entity("fuego_spray_6"):set_enabled(false) end

  -- 🗿 Aseguramos que los pilares bloqueen el paso al principio
  if map:get_entity("pilar_1") then map:get_entity("pilar_1"):set_enabled(true) end
  if map:get_entity("pilar_2") then map:get_entity("pilar_2"):set_enabled(true) end

  -- =========================================================================
  -- 🕵️ SENSADO DE LOS ALTARES (Muestra el botón interactivo "Grab")
  -- =========================================================================
  local lista_altares = { "zona_altar_2", "zona_altar_3", "zona_altar_4", "zona_altar_5", "zona_altar_6" }
  for _, nombre_altar in ipairs(lista_altares) do
    local sensor = map:get_entity(nombre_altar)
    if sensor then
      function sensor:on_activated()
        map:get_game():set_custom_command_effect("action", "grab")
      end
      function sensor:on_left()
        map:get_game():set_custom_command_effect("action", nil)
      end
    end
  end
end

-- =========================================================================
-- 📄 INTERACCIÓN CON LA BARRA ESPACIADORA Y TECLAS
-- =========================================================================
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  
  local sensor_2 = map:get_entity("zona_altar_2")
  local sensor_3 = map:get_entity("zona_altar_3")
  local sensor_4 = map:get_entity("zona_altar_4")
  local sensor_5 = map:get_entity("zona_altar_5")
  local sensor_6 = map:get_entity("zona_altar_6")

  if key == "space" then

    -- —— ACCION PARA EL ALTAR 2 ——
    if sensor_2 then
      local heroe_en_zona_2 = hero:overlaps(sensor_2)
      if heroe_en_zona_2 and not altar_2_encendido then
        if antorcha_conseguida then
          altar_2_encendido = true
          game:set_custom_command_effect("action", nil)
          
          if map:get_entity("fuego_spray_2") then map:get_entity("fuego_spray_2"):set_enabled(true) end
          if map:get_entity("puente_1") then map:get_entity("puente_1"):set_enabled(true) end
          
          local _, _, altar_layer = sensor_2:get_position()
          map:create_enemy({ breed = "skelfos", x = 296, y = 136, layer = altar_layer, direction = 3 })
          map:create_enemy({ breed = "skelfos", x = 296, y = 184, layer = altar_layer, direction = 1 })
          sol.audio.play_sound("stone_obstacle")
        end
        return true
      end
    end

    -- —— ACCION PARA EL ALTAR 3 ——
    if sensor_3 then
      local heroe_en_zona_3 = hero:overlaps(sensor_3)
      if heroe_en_zona_3 and not altar_3_encendido then
        if antorcha_conseguida then
          altar_3_encendido = true
          game:set_custom_command_effect("action", nil)
          
          if map:get_entity("fuego_spray_3") then map:get_entity("fuego_spray_3"):set_enabled(true) end

          local _, _, altar_layer = sensor_3:get_position()

          if map:get_entity("pilar_1") then
            map:get_entity("pilar_1"):remove()
            map:create_enemy({ breed = "skelfos", x = 168, y = 136, layer = altar_layer, direction = 3 })
          end
          if map:get_entity("pilar_2") then
            map:get_entity("pilar_2"):remove()
            map:create_enemy({ breed = "skelfos", x = 168, y = 184, layer = altar_layer, direction = 1 })
          end
          
          sol.audio.play_sound("stone_obstacle")
        end
        return true
      end
    end

    -- —— ACCION PARA EL ALTAR 4 ——
    if sensor_4 then
      local heroe_en_zona_4 = hero:overlaps(sensor_4)
      if heroe_en_zona_4 and not altar_4_encendido then
        if antorcha_conseguida then
          altar_4_encendido = true
          game:set_custom_command_effect("action", nil)
          
          if map:get_entity("fuego_spray_4") then map:get_entity("fuego_spray_4"):set_enabled(true) end
          if map:get_entity("puente_2") then map:get_entity("puente_2"):set_enabled(true) end
          
          sol.audio.play_sound("stone_obstacle")
        end
        return true
      end
    end

    -- —— ACCION PARA EL ALTAR 5 (Elimina roble_1) ——
    if sensor_5 then
      local heroe_en_zona_5 = hero:overlaps(sensor_5)
      if heroe_en_zona_5 and not altar_5_encendido then
        if antorcha_conseguida then
          altar_5_encendido = true
          game:set_custom_command_effect("action", nil)
          
          if map:get_entity("fuego_spray_5") then map:get_entity("fuego_spray_5"):set_enabled(true) end
          
          -- Desaparece el objeto roble_1 del mapa
          if map:get_entity("roble_1") then
            map:get_entity("roble_1"):remove()
          end
          
          sol.audio.play_sound("stone_obstacle")
        end
        return true
      end
    end

    -- —— ACCION PARA EL ALTAR 6 (Elimina roble_2) ——
    if sensor_6 then
      local heroe_en_zona_6 = hero:overlaps(sensor_6)
      if heroe_en_zona_6 and not altar_6_encendido then
        if antorcha_conseguida then
          altar_6_encendido = true
          game:set_custom_command_effect("action", nil)
          
          if map:get_entity("fuego_spray_6") then map:get_entity("fuego_spray_6"):set_enabled(true) end
          
          -- Desaparece el objeto roble_2 del mapa
          if map:get_entity("roble_2") then
            map:get_entity("roble_2"):remove()
          end
          
          sol.audio.play_sound("stone_obstacle")
        end
        return true
      end
    end

  end

  -- 🏹 ARCO
  if key == "v" or key == "V" then
    local arco = game:get_item("bow")
    if arco and arco:get_amount() > 0 then
      hero:start_bow()
      arco:remove_amount(1)
    end
    return true
  end
end