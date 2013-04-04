Platform = {}

function Platform:new(world, x, y, platform_type, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {}
  setmetatable(object, self)
  self.__index = self

  object.x           = x
  object.y           = y
  object.scaling     = 1.5
  object.image       = love.graphics.newImage("media/images/entities/platform_" .. platform_type .. ".png")
  object.width       = object.image:getWidth() * object.scaling
  object.height      = object.image:getHeight() * object.scaling
  object.top_edge    = object:getY()
  object.bottom_edge = object:getY() + 15

  return object
end

function Platform:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, self.scaling, self.scaling, 0, 0)

  if Settings.debug then
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.rectangle("line", self.x, self.top_edge, self.width, 0.1)
    love.graphics.rectangle("line", self.x, self.bottom_edge, self.width, 0.1)
  end
end

function Platform:getEdges()
  return self.edges
end

function Platform:intersects(player)
  return player:getCenter() <= (self:getX() + self:getWidth()) and
    player:getCenter() > self:getX() and
    player:getBottomEdge() > self.top_edge and
    player:getBottomEdge() < self.bottom_edge
end

inherit(Platform, Base)
inherit(Platform, ShadowCastable)