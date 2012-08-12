--[[
Lümos - A 2D Lighting Engine for LÖVE (love2d)

## Light Class ##
## Represents a light source ##

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

-- the current library path
local LIBRARY_PATH = (...):match("(.-)[^%.]+$")
require (LIBRARY_PATH .. 'base')
require (LIBRARY_PATH .. 'vector')

-- the current folder
local CURRENT_FOLDER = LIBRARY_PATH:gsub("[.]", "/")

Light = {}

function Light:new(x, y, range, luminosity, object)
  if not love then print "This library requires Love2D 0.8.0"; return false; end
  object = object or {}   -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Light here

  -- The default range is set to 320 pixels
  local default_range = 320

  -- Coordinates
  object.x = x
  object.y = y

  -- range in pixels
  object.range = range or default_range

  -- maximum range in pixels - the other range value can change
  object.maximum_range = object.range

  -- 255 is the full luminosity / alpha value
  object.luminosity = luminosity or 255
  object.color = color or { 255, 255, 255 }

  -- Light mask, light image and height and width taken from the image
  object.image = love.graphics.newImage(CURRENT_FOLDER .. "images/light.png")
  object.mask = love.graphics.newImage(CURRENT_FOLDER .. "images/light_mask.png")
  object.height = object.image:getHeight()
  object.width = object.image:getWidth()

  object:updateEdges()

  return object
end

function Light:updateEdges()
  self.top_edge = self.y - self.height / 2
  self.bottom_edge = self.y + self.height / 2
  self.right_edge = self.x + self.width / 2
  self.left_edge = self.x - self.width / 2
end

function Light:setX(x)
  self.x = x
end

function Light:setY(y)
  self.y = y
end

function Light:draw()
  local range_factor = self:calculateRangeFactor()
  self:drawLightMask()
  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.luminosity)
  love.graphics.draw(self.image, self.x, self.y, 0, range_factor, range_factor, self.width / 2, self.height / 2)
end

function Light:update()
  self:updateEdges()

  -- let the light flicker
  self:flicker()
end

function Light:flicker()
  self.range = math.random(self.maximum_range - 20, self.maximum_range)
end

function Light:getRange()
  return self.range
end

function Light:calculateRangeFactor()
  -- we have to calculate down the range pixel value to a value between 0 and 1
  return self.range / self.maximum_range
end

function Light:drawLightMask()
  local r,g,b,a = love.graphics.getColor()
  local range_factor = self:calculateRangeFactor()
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.draw(self.mask, self.x, self.y, 0, range_factor, range_factor, self.width / 2, self.height / 2)
  self:drawFogOfWar()
  love.graphics.setColor(r, g, b, a)
end

function Light:drawFogOfWar()
  -- the fog of war needs to move with the player and should only
  -- be calculated on the visible area of the screen.
  -- the position of the fog is thus depending on the camera position
  local tile_size = 100
  local maximum_width = camera:getX() + love.graphics.getWidth()
  local maximum_height = camera:getY() + love.graphics.getHeight()
  local minimum_width = camera:getX() + 0
  local minimum_height = camera:getY() + -1000

  for x = minimum_width, maximum_width, tile_size do
    for y = minimum_height, maximum_height, tile_size do
      -- draw rectangles
      -- only draw fog of war if not in light radius
      local fog_in_light = false

      if x + 120 <= self.right_edge and x - 10 >= self.left_edge
        and y + 20 >= self.top_edge and y - 30 <= self.bottom_edge then
        fog_in_light = true
      else
        fog_in_light = false
      end

      if not fog_in_light then
        love.graphics.rectangle('fill', x, y, tile_size, tile_size)
      end

    end
  end
end

function Light:assembleShadowVertices(shadow_caster, distance_vector, distance_factor, scaling_factor)
  local vertices = {}
  for _, given_vector in ipairs(shadow_caster:getVerticesAsVectors()) do
    --create a new vector by taking the edge point vector and adding the distance vector
    --divided by a specific amount
    local new_vector = given_vector + (distance_vector / 7) * distance_factor
    
    --draw polygon from given_vector to new_vector
    table.insert(vertices, new_vector:getX() * scaling_factor)
    table.insert(vertices, new_vector:getY() * scaling_factor)
  end
  return vertices
end

function Light:isInRangeOf(distance_to_shadow_caster)
  return (self.range >= distance_to_shadow_caster)
end

function Light:drawShadow(shadow_caster, distance_vector, distance_factor, scaling_factor)
  -- save currently used colors
  r, g, b, a = love.graphics.getColor()

  -- set shadow color to transparent black and draw shadow as polygon
  love.graphics.setColor(0, 0, 0, 150)
  love.graphics.polygon('fill', self:assembleShadowVertices(shadow_caster, distance_vector, distance_factor, scaling_factor))

  -- return to previously used colors
  love.graphics.setColor(r, g, b, a)
end

function Light:castShadow(shadow_caster)
  -- positions of light and shadow caster
  local light_position = Vector:new(self:getX(), self:getY())
  local shadow_caster_position = Vector:new(shadow_caster:getX(), shadow_caster:getY())

  -- the distance between shadow caster and light as a vector
  local distance_vector = shadow_caster_position:distance(light_position, "vector")

  -- the distance between shadow caster and light as a number
  local distance_to_shadow_caster = shadow_caster_position:distance(light_position, "number")

  -- the distance factor determines the distance between shadow and wall
  local distance_factor = distance_to_shadow_caster / 200

  -- the scaling factor determines how largely a shadow is projected on the wall
  local scaling_factor = 1 + (distance_factor / 100)

  -- only draw the shadow if the shadow caster is in the light's range
  if not self:isInRangeOf(distance_to_shadow_caster) then return false end
  self:drawShadow(shadow_caster, distance_vector, distance_factor, scaling_factor) 
end

-- Inherit from Base class
inherit(Light, Base)