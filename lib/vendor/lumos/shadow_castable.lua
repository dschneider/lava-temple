--[[
Lümos - A 2D Lighting Engine for LÖVE (love2d)

## ShadowCastable Class ##
## Defines methods that are necessary for projecting shadows ##

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

ShadowCastable = {}

function ShadowCastable:new(object)
  if not love then print "This library requires Love2D 0.8.0"; return false; end

  object = object or {}   -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to ShadowCastable here
  return object
end

function ShadowCastable:getVertices()
  top_left_x = self:getTopLeftCorner():getX()
  top_left_y = self:getTopLeftCorner():getY()

  top_right_x = self:getTopRightCorner():getX()
  top_right_y = self:getTopRightCorner():getY()

  bottom_right_x = self:getBottomRightCorner():getX()
  bottom_right_y = self:getBottomRightCorner():getY()

  bottom_left_x = self:getBottomLeftCorner():getX()
  bottom_left_y = self:getBottomLeftCorner():getY()

  return { top_left_x, top_left_y,
           top_right_x, top_right_y,
           bottom_right_x, bottom_right_y,
           bottom_left_x, bottom_left_y }
end

function ShadowCastable:getVerticesAsVectors()
  return { self:getTopLeftCorner(), 
           self:getTopRightCorner(),
           self:getBottomRightCorner(),
           self:getBottomLeftCorner() }
end

function ShadowCastable:getTopLeftCorner()
  return Vector:new(self:getX(), self:getY())
end

function ShadowCastable:getTopRightCorner()
  return Vector:new(self:getX() + self:getWidth(), self:getY())
end

function ShadowCastable:getBottomRightCorner()
  return Vector:new(self:getX() + self:getWidth(), self:getY() + self:getHeight())
end

function ShadowCastable:getBottomLeftCorner()
  return Vector:new(self:getX(), self:getY() + self:getHeight())
end

function ShadowCastable:calculateEdges()
  self.edges = {}
  for i = 1,#self.vertices do
    k = i == #self.vertices and 1 or i + 1
    self.edges[i] = Edge(self.vertices[i], self.vertices[k])
  end
end

function ShadowCastable:calculateVertices(vertices)
  self.vertices = {}
  for i,v in ipairs(vertices) do
    self.vertices[i] = v:clone()
  end  
end