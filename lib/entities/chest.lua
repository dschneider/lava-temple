Chest = {}

function Chest:new(world, x, y, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.x           = x
  object.y           = y
  object.scaling     = 2.0
  object.image       = love.graphics.newImage("media/images/entities/chest.png")
  object.width       = object.image:getWidth() * object.scaling
  object.height      = object.image:getHeight() * object.scaling
  object.top_edge    = object.y
  object.bottom_edge = object.y + 10

  return object
end

inherit(Chest, Base)
inherit(Chest, ShadowCastable)