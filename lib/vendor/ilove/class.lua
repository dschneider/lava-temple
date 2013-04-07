Class = {}

function Class:new(...)
  if not love then print "This library requires Love2D"; return false; end

  -- metatable will pass through all calls to Class.
  local metatable = { __index = self }
  local object    = setmetatable({}, metatable)
  if object.init then object:init(...) end

  return object
end

function Class:extend(child, parent)
  if child and parent then
    -- metatable will pass through all calls to the parent class.
    local metatable = { __index = parent }
    return setmetatable(child, metatable)
  else
    return self
  end
end