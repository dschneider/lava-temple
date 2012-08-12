Shader = {}

function Shader:new(x, y, scale_x, scale_y, rotation, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  return object
end

function Shader:start()
  love.graphics.setPixelEffect(self.pixel_effect)
end

function Shader:stop()
  love.graphics.setPixelEffect()
end

function Shader:update(dt)
end