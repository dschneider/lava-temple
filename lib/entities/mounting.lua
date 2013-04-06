Mounting = {}

function Mounting:new(world, x, y, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {}
  setmetatable(object, self)
  self.__index = self

  object.x       = x
  object.y       = y
  object.scaling = 1
  object.image   = love.graphics.newImage("media/images/entities/mounting.png")
  object.width   = object.image:getWidth() * object.scaling
  object.height  = object.image:getHeight() * object.scaling
  object.body    = love.physics.newBody(physics_world, object.x, object.y, "static")
  object.shape   = love.physics.newRectangleShape(object.width, object.height)
  object.fixture = love.physics.newFixture(object.body, object.shape)

  return object
end

function Mounting:intersectsWithMouse()
  local x, y = love.mouse.getPosition()

  print((x <= self:getX() + 30) and (x >= self:getX() - 30))
  print((y <= self:getY() + 30) and (y >= self:getY() - 30))

  return true
end

inherit(Mounting, Base)
