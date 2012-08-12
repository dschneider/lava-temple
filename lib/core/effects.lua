effects = {}

local image = love.graphics.newImage("media/images/effects/cloud.png")
effects.jump = love.graphics.newParticleSystem(image, 1000)
effects.jump:setEmissionRate(50)
effects.jump:setSizes(0.2, 0.2)
effects.jump:setSpeed(100, 100)
effects.jump:setGravity(500, 500)
effects.jump:setLifetime(0.1)
effects.jump:setParticleLife(0.7)
effects.jump:setDirection(300)
effects.jump:setSpread(1)
effects.jump:stop()

-- create layer of smoke
effects.smoke = {}
for i = 1, 10 do table.insert(effects.smoke, love.graphics.newParticleSystem(image, 1000)) end

for key, smoke_effect in ipairs(effects.smoke) do
  smoke_effect:setBufferSize(500)
  smoke_effect:setEmissionRate(300)
  smoke_effect:setSizes(3.5, 1.0)
  smoke_effect:setSpeed(100, 200)
  smoke_effect:setGravity(62, 62)
  smoke_effect:setLifetime(45)
  smoke_effect:setParticleLife(1.0)
  smoke_effect:setDirection(11)
  smoke_effect:setSpread(3)
  smoke_effect:setColors(220, 100, 100, 15)
end

function effects:draw()
  love.graphics.draw(self.jump, 0, 0)
  for key, smoke_effect in ipairs(self.smoke) do love.graphics.draw(smoke_effect, 0, 0) end
end

function effects:update(dt)
  self.jump:update(dt)

  -- update all smoke effects TODO: IMPROVE THIS (applyToSmoke with dynamic method call?)
  for key, value in ipairs(self.smoke) do value:update(dt / 2) end
end