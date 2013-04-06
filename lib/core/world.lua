World = {}

function World:new(level_number, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.structureImage = love.image.newImageData("levels/level_" .. level_number .. ".png")
  object.rubies         = {}
  object.chests         = {}
  object.platforms      = {}
  object.mountings      = {}
  object.players        = {}
  object:build()

  return object
end

function World:update(dt)
  self:calculateCollisionsWithPlayer(player)
  lava:update(dt)
end

function World:draw()
  self:drawCaveBackground()
  self:drawGround()

  if Settings.shadows then self:castShadows() end

  self:drawRubies()
  self:drawPlatforms()
  self:drawMountings()
  self:drawChests()
  player:draw()

  if second_player then
    second_player:draw()
    player:drawName()
    second_player:drawName()
  end

  lava:draw()
end

function World:registerPlayer(player)
  table.insert(self.players, player)
end

--a level is 900px wide
function World:build()
  local block_size = 50

  for x = 0, self.structureImage:getWidth() - 1 do
    for y = 0, self.structureImage:getHeight() - 1 do
      local red, green, blue, alpha = self.structureImage:getPixel(x, y)

      -- It's calculating x and y from the top right image corner
      -- We turn it around so that it builds the map from the bottom up
      local x_location_in_world = x * block_size
      local y_location_in_world = (self.structureImage:getHeight() - y) * block_size * (-1)

      if red == 153 and green == 0 and blue == 0 and alpha == 255 then
        local p = Platform:new(self, x_location_in_world, y_location_in_world, "one")
        local s = love.physics.newRectangleShape(p.width, p.height)
        local b = love.physics.newBody(physics_world, x_location_in_world, y_location_in_world, "static")
        love.physics.newFixture(b, s)
        table.insert(self.platforms, p)
      elseif red == 0 and green == 153 and blue == 0 and alpha == 255 then
        table.insert(self.platforms, Platform:new(self, x_location_in_world, y_location_in_world, "two"))
      elseif red == 0 and green == 0 and blue == 153 and alpha == 255 then
        table.insert(self.platforms, Platform:new(self, x_location_in_world, y_location_in_world, "three"))
      elseif red == 100 and green == 10 and blue == 0 and alpha == 255 then
        local ruby = Ruby:new(self, x_location_in_world, y_location_in_world)
        --every block has 50 * 50 pixels - that's why we need to get the ruby to the bottom
        ruby.y = ruby.y + 40 - ruby:getHeight()
        ruby.x = ruby.x + 40
        table.insert(self.rubies, ruby)
      elseif red == 100 and green == 50 and blue == 0 and alpha == 255 then
        local chest = Chest:new(self, x_location_in_world, y_location_in_world)
        chest.y = chest.y + 50 - chest:getHeight()
        chest.x = chest.x + 40
        table.insert(self.chests, chest)
      elseif red == 255 and green == 234 and blue == 0 and alpha == 255 then
        local mounting = Mounting:new(self, x_location_in_world, y_location_in_world)
        table.insert(self.mountings, mounting)
      elseif red == 0 and green == 0 and blue == 0 and alpha == 255 then
        player = Player:new(self, x_location_in_world, y_location_in_world, "default", "blue")
        -- register player in world's player table (necessary for multiplayer)
        self:registerPlayer(player)
      end

    end
  end

  -- draw cave background
  self.cave_quad  = love.graphics.newQuad(-400, 1, 4000, 10000, 296, 296)
  self.background = love.graphics.newImage("media/images/entities/cave.png")
  self.background:setWrap("repeat", "repeat")

  -- draw ground floor
  self.ground_quad = love.graphics.newQuad(-400, 1, 4000, 1000, 160 * 5, 96 * 5)
  self.ground      = love.graphics.newImage("media/images/entities/ground.png")
  self.ground:setWrap("repeat", "clamp")

  -- create the lava
  lava = Lava:new(-400, 400)
end

function World:drawCaveBackground()
  love.graphics.drawq(self.background, self.cave_quad, -400, -5000, 0, 1, 1, 1, 0)
end

function World:drawGround()
  love.graphics.drawq(self.ground, self.ground_quad, -400, 45, 0, 1, 1, 1, 0)
end

function World:drawRubies()
  for key, ruby in ipairs(self.rubies) do ruby:draw() end
end

function World:drawChests()
  for key, chest in ipairs(self.chests) do chest:draw() end
end

function World:drawPlatforms()
  for key, platform in ipairs(self.platforms) do platform:draw() end
end

function World:drawMountings()
  for key, mounting in ipairs(self.mountings) do mounting:draw() end
end

function World:castShadows()
  for key, platform in ipairs(self.platforms) do player.light:castShadow(platform) end
  for key, ruby in ipairs(self.rubies) do player.light:castShadow(ruby) end
  for key, chest in ipairs(self.chests) do player.light:castShadow(chest) end
end

function World:removeRuby(key)
  table.remove(self.rubies, key)
  if client then client:syncRubyDataWithServer(key) end
end

function World:calculateCollisionsWithPlayer(player)
  for key, platform in ipairs(self.platforms) do
    if platform:intersects(player) then
      if not (player.y == (platform:getY() - player:getHeight())) then
        player.y = platform:getY() - player:getHeight()
        player:resetVelocity()
        player:setBodyState(false)
      end
    end
  end

  for key, ruby in ipairs(self.rubies) do
    if ruby:isNear(player) then
      ruby:moveTo(player)
    end

    if ruby:intersects(player) then
      player:incrementRubies()
      self:removeRuby(key)
    end
  end

  if lava:intersects(player) then
    player:decreaseLives()
  end
end