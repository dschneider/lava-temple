Whip = {}

function Whip:new(object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {}
  setmetatable(object, self)
  self.__index = self

  object.name = "whip"

  return object
end

function Whip:getName()
  return self.name
end
