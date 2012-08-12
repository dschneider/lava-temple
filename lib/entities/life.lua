Life = {}

function Life:new(x, y, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.x = x
  object.y = y
  object.scaling = 2.0
  object.image = love.graphics.newImage("media/images/entities/life.png")
  object.width = object.image:getWidth() * object.scaling
  object.height = object.image:getHeight() * object.scaling
  object.top_edge = object.y
  object.bottom_edge = object.y + 10

  return object
end

function Life:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, self.scaling, self.scaling, 0, 0)
end

function Life:getX()
  return self.x
end

function Life:getY()
  return self.y
end

function Life:getWidth()
  return self.width
end

function Life:getHeight()
  return self.height
end

function Life:getTopEdge()
  return self.top_edge
end