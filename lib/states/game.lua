game = Gamestate.new()

function game:init()
  game_font = love.graphics.newFont("media/fonts/PressStart2P.ttf", 40)
  love.graphics.setFont(game_font)
  hud          = Hud:new()
  sfx          = Sfx:new()
  camera       = Camera:new(0, 0)
  --A level is 900px wide. We put the camera into the center of the level,
  --depending on the screen resolution.
  camera:centerInWorld(900)
  paused       = false
  game_started = true

  sfx:setLooping("lava", true)
  sfx:play("lava")

  sfx:setLooping("background", true)
  sfx:play("background")

  physics_world = love.physics.newWorld(0, 9.81*64, true)
  love.physics.setMeter(64)

  body1 = love.physics.newBody(physics_world, 50, -350, "static")
  body2 = love.physics.newBody(physics_world, 50, -250, "dynamic")

  shape1 = love.physics.newCircleShape(50, 50, 50)
  shape2 = love.physics.newRectangleShape(50, 50)

  fixture1 = love.physics.newFixture(body1, shape1)
  fixture2 = love.physics.newFixture(body2, shape2)

  distance_joint = love.physics.newDistanceJoint(body1, body2, 50, -350, 50, -250)
end

function game:enter(previous)
  if previous == main_menu then world = World:new("one") end
end

function game:shakeScreen(dt)
  lava_player_distance = Vector:new(lava:getX(), lava:getY()):distance(Vector:new(player:getX(), player:getY()), "number")
  shake_factor         = 70 - (lava_player_distance  / 20)

  if shake_factor <= 0 then
    shake_factor = 0
  end

  sfx:setVolume("lava", shake_factor / 38)
  shake = dt * shake_factor * math.random(1.0, 2.0)
end

function game:drawScreenShake()
  if not shake then shake = 10 end
  love.graphics.translate(math.random(-shake,shake), math.random(-shake,shake))
end

function game:gameover()
  -- TODO : DRAW GAMEOVER
  -- light.luminosity = 0
end

function game:update(dt)
  if world then
    physics_world:update(dt)

    if body2 then
      player.x = body2:getX()
      player.y = body2:getY()
    end

    self:handleInput()

    Timer.update(dt)

    -- world holds all players, players are accessed via player and second_player
    -- global variables right now
    for index, player in pairs(world.players) do player:update(dt) end

    world:update(dt)
    player.light:update(dt)
    effects:update(dt)

    -- Send player data to server in multiplayer and update the client
    if client and player then
      client:syncPlayerDataWithServer()
      client:syncLavaDataWithServer()
      client:update(dt)
    end

    -- Move the camera with the player, but only on the y-axis
    camera:setPosition(nil, player:getY() - 500)

    -- Game is over if all player lives are gone
    if player:getLives() <= 0 then self:gameover() end

    -- Shake the screen (the closer the lava, the stronger it shakes)
    if lava and player then self:shakeScreen(dt) end
  end
end

function game:draw()
  if world then
    camera:set()
    self:drawScreenShake()
    camera:drawLayers()
    world:draw()
    effects:draw()
    r, g, b = love.graphics.getColor()
    love.graphics.setColor(72, 160, 14)
    love.graphics.circle("fill", body1:getX(), body1:getY(), 20)
    love.graphics.setColor(r, g, b)
    player.light:draw()
    hud:drawRelativeMessages()
    camera:unset()
    hud:draw()
  end
end

function game:handleInput()
  if love.keyboard.isDown("right") then
    if body2 then
      body2:applyForce(120, 0, 120, 0)
    end
  elseif love.keyboard.isDown("left") then
    if body2 then
      body2:applyForce(-120, 0, -120, 0)
    end
  elseif love.keyboard.isDown("j") then
    if distance_joint then
      distance_joint:destroy()
      distance_joint = nil
    end
  end
end

function game:keypressed(key, code)
  if key == "escape" then
    paused = not paused
    Gamestate.switch(pause_menu)
  elseif key == "s" then
    game_started = not game_started
  end
end