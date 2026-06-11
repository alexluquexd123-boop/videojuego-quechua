-- Main Lua script of the quest.
-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

require("scripts/features")
require("scripts/multi_events")

-- Edit scripts/menus/initial_menus_config.lua to add or change menus before starting a game.
local initial_menus_config = require("scripts/menus/initial_menus_config")
local initial_menus = {}

-- This function is called when Solarus starts.
function sol.main:on_started()

  sol.main.load_settings()
  math.randomseed(os.time())

  -- FORZAR INICIO LIMPIO EN SALA_1 (Adiós error first_map)
  if sol.game.exists("save1.dat") then
    local game = sol.game.load("save1.dat")
    if game:get_map_id() == "first_map" then
      sol.game.delete("save1.dat") -- Borramos el guardado corrupto del mapa viejo
    end
  end

  -- Show the initial menus.
  if #initial_menus_config == 0 then
    return
  end

  for _, menu_script in ipairs(initial_menus_config) do
    initial_menus[#initial_menus + 1] = require(menu_script)
  end

  local on_top = false  -- To keep the debug menu on top.
  sol.menu.start(sol.main, initial_menus[1], on_top)

  for i, menu_index in ipairs(initial_menus) do
    function menu_index:on_finished()
      if sol.main.get_game() ~= nil then
        -- A game is already running (probably quick start with a debug key).
        return
      end
      local next_menu = initial_menus[i + 1]
      if next_menu ~= nil then
        sol.menu.start(sol.main, next_menu)
      end
    end
  end

end