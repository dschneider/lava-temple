Ruby = {}

function Ruby:new(world, x, y, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.x           = x
  object.y           = y
  object.scaling     = 1.5
  object.image       = love.graphics.newImage("media/images/entities/ruby.png")
  object.width       = object.image:getWidth() * object.scaling
  object.height      = object.image:getHeight() * object.scaling
  object.top_edge    = object:getY()
  object.bottom_edge = object:getY() + 10

  return object
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

inherit(Ruby, Base)
inherit(Ruby, ShadowCastable)