--[[
Lümos - A 2D Lighting Engine for LÖVE (love2d)

## Vector Class ##
## Represents a mathematical Vector ##

Written by Dennis Schneider <http://www.dennis-schneider.com>

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
]]--

Vector = {}

function Vector:new(x, y, object)
  object = object or {}   -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Vector here
  object.x = x
  object.y = y
  return object
end

function Vector:getX()
  return self.x
end

function Vector:getY()
  return self.y
end

function Vector:setX(x)
  self.x = x
end

function Vector:setY(y)
  self.y = y
end

function Vector:crossProduct(other_vector)
  return (self:getX() * other_vector:getY() - other_vector:getY() * self:getY())
end

function Vector:dotProduct(other_vector)
  return (self:getX() * other_vector:getX() + self:getY() * other_vector:getY())
end

function Vector:length()
  return math.sqrt(self:lengthSquared())
end

function Vector:lengthSquared()
  return (self:getX() * self:getX() + self:getY() * self:getY())
end
 
function Vector:normalize()
  -- First calculate the length of the vector ...
  local square_length = self:lengthSquared()
  
  if square_length == 0.0 then
    self:setX(0.0)
    self:setY(0.0)
    return self
  end

  -- ... then divide each of its components by its length
  self:setX(self:getX() / square_length)
  self:setY(self:getY() / square_length)
end

function Vector:distance(other_vector, distance_type)
  if distance_type == "number" then
    -- A vector does not generally have a fixed position. Thus the vectors 
    -- must be regarded as position vectors with respect to an origin
    distance_x = (self:getX() - other_vector:getX())
    distance_y = (self:getY() - other_vector:getY())
    return math.sqrt(distance_x * distance_x + distance_y * distance_y)
  elseif distance_type == "vector" then
    return Vector:new(self:getX() - other_vector:getX(), self:getY() - other_vector:getY())
  else
    print("Unknown distance type")
  end
end

function Vector.__add(vector, other_vector)
  return Vector:new(vector:getX() + other_vector:getX(), vector:getY() + other_vector:getY())
end

function Vector.__mul(vector, scale)
  return Vector:new(scale * vector:getX(), scale * vector:getY())
end

function Vector.__sub(vector, other_vector)
  return Vector:new(vector:getX() - other_vector:getX(), vector:getY() - other_vector:getY())
end

function Vector.__div(vector, number)
  return Vector:new(vector:getX() / number, vector:getY() / number)
end

function Vector.__unm(vector, other_vector)
end

function Vector.__pow(vector, other_vector)
end

function Vector.__eq(vector, other_vector)
end

function Vector.__lt(vector, other_vector)
end

function Vector.__le(vector, other_vector)
end