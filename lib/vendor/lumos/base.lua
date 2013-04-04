--[[
Lümos - A 2D Lighting Engine for LÖVE (love2d)

## Base Class ##
## Contains all standard methods for returning positions etc. ##

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

Base = {}

function Base:new(object)
  if not love then print "This library requires Love2D 0.8.0"; return false; end

  object = object or {}   -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Base here
  return object
end

function Base:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, self.scaling, self.scaling, 0, 0)
end

function Base:setX(value)
  self.x = value
end

function Base:setY(value)
  self.y = value
end

function Base:getX()
  return self.x
end

function Base:getY()
  return self.y
end

function Base:getWidth()
  return self.width
end

function Base:getHeight()
  return self.height
end

function Base:getTopEdge()
  return self.top_edge
end

function Base:getRightEdge()
  return self.right_edge
end

function Base:getLeftEdge()
  return self.left_edge
end

function Base:getCenter()
  return self.x + self.width / 2
end

function Base:getBottomEdge()
  return self.bottom_edge
end

function Base:updateEdges()
  self.top_edge    = self:getY()
  self.bottom_edge = self:getY() + self:getHeight()
  self.left_edge   = self:getX()
  self.right_edge  = self:getX() + self:getWidth()
end