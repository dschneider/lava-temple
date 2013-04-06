Inventory = {}

function Inventory:new(object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {}
  setmetatable(object, self)
  self.__index = self

  object.slots        = {}
  object.slots.number = 5

  table.insert(object.slots, Whip:new())

  object.active_item = object.slots[1]

  return object
end

function Inventory:selectItem(number)
  self.active_item = self.slots[number]
end

function Inventory:activeItem()
  return self.active_item
end
