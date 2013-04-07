Ruby = Class:extend()
Ruby:extend(Ruby, Base)
--Ruby:extend(Ruby, ShadowCastable)

function Ruby:init(world, x, y, object)
  self.x           = x
  self.y           = y
  self.scaling     = 1.5
  self.image       = love.graphics.newImage("media/images/entities/ruby.png")
  self.width       = self.image:getWidth() * self.scaling
  self.height      = self.image:getHeight() * self.scaling
  self.top_edge    = self:getY()
  self.bottom_edge = self:getY() + 10
end

function Ruby:moveTo(object)
  x_movement = (self.x - object:getX())
  y_movement = (self.y - object:getY())
  self.x = (self.x - x_movement * 0.1)
  self.y = (self.y - y_movement * 0.1)
end

function Ruby:isNear(object)
  return (self:getX() <= (object:getX() + 30) and
    self:getX() >= (object:getX() - 30)) and
    (self:getY() <= (object:getY() + 30) and
    self:getY() >= (object:getY() - 30))
end

function Ruby:intersects(player)
   return (self:getX() <= (player:getX() + 10) and
    self:getX() >= (player:getX() - 10)) and
    (self:getY() <= (player:getY() + 10) and
    self:getY() >= (player:getY() - 10))
end