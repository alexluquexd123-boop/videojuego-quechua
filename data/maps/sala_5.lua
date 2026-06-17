local map = ...
local antorcha_conseguida = true 
local altar_1_encendido = false

-- =========================================================================
-- 🎛️ CONFIGURACIÓN AL INICIAR EL MAPA
-- =========================================================================
function map:on_started()
  -- 🚪 El puente del cofre empieza desactivado al entrar
  if map:get_entity("puente_cofre") then
    map:get_entity("puente_cofre"):set_enabled(false)
  end

  -- 🔥 El spray de fuego empieza apagado
  if map:get_entity("fuego_spray_6") then
    map:get_entity("fuego_spray_6"):set_enabled(false)
  end

  -- 🕵️ SENSADO DEL ALTAR (Muestra "Grab" en la interfaz al acercarse)
  local sensor_altar = map:get_entity("altar_1")
  if sensor_altar then
    function sensor_altar:on_activated()
      map:get_game():set_custom_command_effect("action", "grab")
    end
    function sensor_altar:on_left()
      map:get_game():set_custom_command_effect("action", nil)
    end
  end

  -- 🔒 BLOQUEO INICIAL DEL ARCO
  -- Forzamos a que el jugador NO tenga el arco al empezar esta sala
  local arco = map:get_game():get_item("bow")
  if arco then
    arco:set_variant(0) -- Variante 0 significa "no conseguido/desactivado"
  end
end

-- =========================================================================
-- 📄 ACCIONES DE TECLADO (INTERACCIÓN CON ESPACIO Y USO DEL ARCO)
-- =========================================================================
function map:on_key_pressed(key)
  local game = map:get_game()
  local hero = map:get_hero()
  local sensor_altar = map:get_entity("altar_1")

  if key == "space" then
    -- —— ACCIÓN: ENCENDER EL ALTAR 1 ——
    if sensor_altar then
      local heroe_en_altar = hero:overlaps(sensor_altar)
      
      if heroe_en_altar and not altar_1_encendido then
        if antorcha_conseguida then
          altar_1_encendido = true
          game:set_custom_command_effect("action", nil)
          
          -- 1. Activamos visualmente el fuego en el altar
          if map:get_entity("fuego_spray_6") then 
            map:get_entity("fuego_spray_6"):set_enabled(true)
          end
          
          -- 2. Activamos el puente del cofre inmediatamente
          if map:get_entity("puente_cofre") then
            map:get_entity("puente_cofre"):set_enabled(true)
          end
          
          -- 3. Efecto de sonido clásico
          sol.audio.play_sound("fire")
        end
        return true
      end
    end
  end

  -- 🏹 USAR EL ARCO CON LA TECLA "V"
  if key == "v" or key == "V" then
    local arco = game:get_item("bow")
    -- Ahora sí, solo disparará si la variante es mayor que 0 (activada por el cofre)
    if arco and arco:get_variant() > 0 and arco:get_amount() > 0 then
      hero:start_bow()
      arco:remove_amount(1)
    end
    return true
  end
end