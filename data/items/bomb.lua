local item = ...

function item:on_started()
  self:set_savegame_variable("possession_bomb")
  self:set_amount_savegame_variable("amount_bomb")
  self:set_max_amount(10)
  self:set_assignable(true) 
end

function item:on_using()
  local map = self:get_map()
  local hero = map:get_hero()
  
  local x, y, layer = hero:get_position()
  map:create_bomb({
    x = x,
    y = y,
    layer = layer
  })
  
  self:remove_amount(1)
  self:set_finished()
end