-- Código de la Sala 9
local map = ...
local game = map:get_game()

-- Esto se ejecuta inmediatamente al entrar a la sala
function map:on_started()
  -- TRUCO DE INICIO: Te damos el arco y 30 flechas para poder testear la sala directamente
  local arco = game:get_item("bow")
  if arco then
    arco:set_variant(1)
    arco:set_amount(30) -- Te da la munición necesaria
  end

  -- ESTADO INICIAL: Los 15 pinchos empiezan subidos (bloqueando el paso)
  for i = 1, 15 do
    local pincho = map:get_entity("pinchos_puente_" .. i)
    if pincho ~= nil then
      pincho:set_enabled(true)
    end
  end
end

-- DETECTAR TECLA V: Usamos tu función personalizada "start_bow()"
function map:on_key_pressed(key)
  local hero = map:get_hero()
  local arco = game:get_item("bow")

  if key == "v" or key == "V" then
    -- Verificamos que tengas el arco y que te queden flechas
    if arco and arco:get_amount() > 0 then
      hero:start_bow() -- Tu animación y disparo real del juego
      arco:remove_amount(1) -- Resta una flecha
      return true
    end
  end
end

-- ==========================================================
-- MECANISMO DE LA PALANCA (Configurada como Botón "Activado al principio")
-- ==========================================================

-- Como el botón empieza "Activado" para que sea visible,
-- al recibir el flechazo se DESACTIVA (on_inactivated). ¡Aquí bajamos los pinchos!
function palanca_puente:on_inactivated()
  for i = 1, 15 do
    local pincho = map:get_entity("pinchos_puente_" .. i)
    if pincho ~= nil then
      pincho:set_enabled(false) -- Bajan los 15 pinchos de golpe
    end
  end
  sol.audio.play_sound("switch")
end

-- Si le vuelves a pegar y se vuelve a activar
function palanca_puente:on_activated()
  for i = 1, 15 do
    local pincho = map:get_entity("pinchos_puente_" .. i)
    if pincho ~= nil then
      pincho:set_enabled(true) -- Vuelven a subir los pinchos
    end
  end
  sol.audio.play_sound("switch")
end