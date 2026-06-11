local item = ...

function item:on_started()
  self:set_savegame_variable("possession_bow")
  self:set_amount_savegame_variable("amount_bow")
  self:set_max_amount(30)
  -- NO lo hacemos asignable para que el HUD no busque su dibujo roto
end