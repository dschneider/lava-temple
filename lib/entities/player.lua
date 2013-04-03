Player = {}

function Player:new(x, y, name, color, origin, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  -- TODO: create in extra font class where all fonts are saved
  name_font = love.graphics.newFont("media/fonts/PressStart2P.ttf", 14)

  object.name = name or "default"
  object.color = color or "blue"

  -- origin is used to determine whether player is the local player
  -- or has joined through a multiplayer game
  object.origin = origin or "local"

  object.x = x
  object.y = y

  object.x_velocity = 0
  object.y_velocity = 0
  object.state = "front"

  object.jumping = false
  object.scaling = 1.5

  object.jump_velocity = -600
  object.run_speed = 500

  object.lives = 5
  object.rubies = 0

  object.gravity = 1800

  object.height = 32 * object.scaling
  object.width = 27 * object.scaling

  object.light = Light:new(object.x, object.y, 320, 255)

  object:updateEdges()

  object.images = {}
  object.images.front = love.graphics.newImage("media/images/player_front.png")
  object.images.jump = love.graphics.newImage("media/images/player_stand_right.png")
  object.images.stand_left = love.graphics.newImage("media/images/player_stand_left.png")
  object.images.stand_right = love.graphics.newImage("media/images/player_stand_right.png")
  object.images.run_right_animation =  love.graphics.newImage("media/images/player_run_right_anim.png")
  object.images.run_left_animation =  love.graphics.newImage("media/images/player_run_left_anim.png")

  object.animations = {}
  object.animations.run_right = newAnimation(object.images.run_right_animation, 27, 32, 0.1, 0)
  object.animations.run_right.setMode("loop")
  object.animations.run_left = newAnimation(object.images.run_left_animation, 27, 32, 0.1, 0)
  object.animations.run_left.setMode("loop")

  return object
end

function Player:drawName()
  love.graphics.setFont(name_font)
  local r, g, b, a = love.graphics.getColor()
  if self.color == "red" then
    love.graphics.setColor(255, 0, 0)
  elseif self.color == "blue" then
    love.graphics.setColor(0, 0, 255)
  end
  love.graphics.print(self.name, self.x - self.width + 5, self.y - self.height + 15)
  love.graphics.setColor(r, g, b, a)
  love.graphics.setFont(game_font)
end

function Player:draw()
  if self.state == "run_right" or self.state == "run_left" then
    self.animations[self.state]:draw(self.x, self.y, 0, self.scaling, self.scaling)
  else
    love.graphics.draw(self.images[self.state], self.x, self.y + 3, 0, self.scaling, self.scaling, 0, 0)
  end

  if Settings.debug then
    love.graphics.rectangle( "line", self.x, self.y, self.width, self.height )
    love.graphics.rectangle( "line", self.x, self.top_edge, self.width, 0.1 )
    love.graphics.rectangle( "line", self.x, self.bottom_edge, self.width, 0.1 )
  end
end

function Player:updateAnimations(dt)
  -- update animations
  self.animations.run_right:update(dt)
  self.animations.run_left:update(dt)
end

function Player:updateGravity(dt)
  -- update the player's position
  self.y = self.y + (self.y_velocity * dt)
  self.x = self.x + (self.x_velocity * dt)

  -- apply gravity
  self.y_velocity = self.y_velocity + (self.gravity * dt)

  -- stop the player when he hits the ground
  if self.y >= 0 then
    self.y = 0
    self:resetVelocity()
  end
end

function Player:handleInput()
  if love.keyboard.isDown(" ") and not self:isJumping() then
    -- make the player jump
    self:jump()
  elseif love.keyboard.isDown("right") then
    self.x_velocity = 200
    self.state = "run_right"
  elseif love.keyboard.isDown("left") then
    self.x_velocity = -200
    self.state = "run_left"
  elseif not self:isJumping() then
    self.x_velocity = 0
    self.state = "front"
  end
end

function Player:update(dt)
  -- if player is the local player (and thus has not joined throug the server)
  -- update all the animations
  -- if player joined through multiplayer, only update the animations
  -- otherwise it would check for input for the second player again and thus
  -- it would look like you control a second player
  if self.origin == "local" then
    self:updateEdges()
    self:handleInput()
    self:updateAnimations(dt)
    self:updateGravity(dt)
    -- the light should follow the player
    self.light:setX(self.x)
    self.light:setY(self.y)
  elseif self.origin == "multiplayer" then
    self:updateAnimations(dt)
  end
end

function Player:jump()
  self.y_velocity = self.jump_velocity
  self.jumping = true
  sfx:play("jump")
  effects.jump:setPosition(self:getCenter(), self:getBottomEdge())
  effects.jump:start()
end

function Player:getLives()
  return self.lives
end

function Player:decreaseLives()
  self.lives = self.lives - 1
end

function Player:incrementRubies(rubies)
  rubies = rubies or 1
  self.rubies = self.rubies + rubies
end

function Player:resetVelocity()
  self.y_velocity = 0
  self.jumping = false
end

function Player:isJumping()
  return self.jumping
end

function Player:setColor(value)
  self.color = value
end

function Player:setName(value)
  self.name = value
end

function Player:setState(value)
  self.state = value
end

function Player:getState()
  return self.state
end

inherit(Player, Base)
inherit(Player, ShadowCastable)