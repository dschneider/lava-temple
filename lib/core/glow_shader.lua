GlowShader = {}

function GlowShader:new(object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.pixel_effect = love.graphics.newPixelEffect [[
    extern number time;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
    {
      vec4 texcolor = Texel(texture, texture_coords);
      
      if (texcolor.r <= 100 && texcolor.r >= 0)
      {
        texcolor.r = texcolor.r + sin(time) / 3;
      }

      if (texcolor.g <= 100 && texcolor.g >= 0)
      {
        texcolor.g = texcolor.g + sin(time) / 20;
      }      

      return vec4(texcolor.rgb, texcolor.a);
    }
  ]]

  object.glow_speed = 0.9
  object.time = 0  

  return object
end

function GlowShader:update(dt)
  self.time = self.time + dt * self.glow_speed
  self.pixel_effect:send("time", self.time)
end

inherit(GlowShader, Shader)