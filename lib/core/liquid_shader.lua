LiquidShader = {}

function LiquidShader:new(object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.pixel_effect = love.graphics.newPixelEffect [[
    extern vec2 center; // Center of shockwave
    extern number time; // effect elapsed time
    extern vec3 shockParams; // 100.0, 8, 100
    
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
    {
      number dis = distance(texture_coords,center);
      if ((dis <= (time + shockParams.z)) &&
             (dis >= (time - shockParams.z)))
        {
          number diff = (dis - time);
          number powDiff = 1.0 - pow(abs(diff*shockParams.x),shockParams.y);
          number diffTime = diff * powDiff;
          vec2 diffUV = normalize(texture_coords - center);
          texture_coords=texture_coords + diffUV * diffTime;
        }
      
      return Texel(texture, texture_coords);
    }
  ]]

  object.time = 0

  return object
end

function LiquidShader:update(dt)
  self.time = self.time + dt
  self.pixel_effect:send("time", self.time)
  self.pixel_effect:send("center", {0.5, 0.5})
  self.pixel_effect:send("shockParams", {10,0.1,0.1})  
end

inherit(LiquidShader, Shader)