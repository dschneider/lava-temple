Lava = {}

function Lava:new(x, y, speed, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.x           = x
  object.y           = y
  object.scaling     = 6
  object.speed       = speed or 20
  object.image_data  = love.image.newImageData("media/images/entities/lava.png")
  object.image       = love.graphics.newImage("media/images/entities/lava.png")

  width  = object.image:getWidth()
  height = object.image:getHeight()
  x_res  = love.graphics.getWidth()
  y_res  = love.graphics.getHeight()

  object.width       = width * object.scaling
  object.height      = height * object.scaling
  object.lava_quad   = love.graphics.newQuad(object.x, object.y, x_res, y_res, width, height)
  object.top_edge    = object:getY()
  object.bottom_edge = object:getY() + 10
  object.glow_shader = GlowShader:new()

  object.image:setWrap("repeat", "repeat")

  return object
end

function Lava:draw()
  self.glow_shader:start()
  love.graphics.drawq(self.image, self.lava_quad, self.x, self.y, 0, self.scaling, self.scaling, 0, 0)
  love.graphics.setPixelEffect()
end

function Lava:update(dt)
  self.glow_shader:update(dt)
  self:updateEdges()

  if game_started then self:move(dt) end

  -- spread the smoke across the lava
  local position = self:getX()
  for key, smoke_effect in ipairs(effects.smoke) do
    smoke_effect:setPosition(position, self:getTopEdge() + 10)
    position = position + 120
  end
end

function Lava:intersects(player)
  return player:getBottomEdge() >= self:getY()
end

function Lava:move(dt)
  self.y = (self.y - self.speed * dt)
end

inherit(Lava, Base)