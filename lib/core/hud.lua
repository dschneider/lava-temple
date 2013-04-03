Hud = {}

function Hud:new(object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  hud_font = love.graphics.newFont("media/fonts/PressStart2P.ttf", 25)

  return object
end

function Hud:draw()
  self:drawLives()
  self:drawRubies()
end

function Hud:drawRubies()
  love.graphics.setFont(hud_font)
  love.graphics.print("Rubies \n" .. player.rubies, (camera.x + love.graphics.getWidth()) - 200, 25)
end

function Hud:drawLives()
  local lives = {}
  counter = 10
  for i = player.lives, 1, -1 do
    table.insert(lives, Life:new(10 + counter * 3, 25))
    counter = counter + 10
  end

  for key, life in ipairs(lives) do
    life:draw()
  end
end

function Hud:drawRelativeMessages()
  self:drawDanger()
  self:drawServerMessages()

  if draw_fps then
    self:drawFPS()
  end
end

function Hud:drawFPS()
  fps = love.timer.getFPS()
  love.graphics.print(fps, camera.x + love.graphics.getWidth() - 130, camera.y + love.graphics.getHeight() - 100)
end

function Hud:drawDanger()
  love.graphics.setFont(game_font)
  local time = love.timer.getTime()
  if time <= 10 and (math.sin(time) > (-0.7) and math.sin(time) < 0.7) then
    love.graphics.print("DANGER!", (camera.x + love.graphics.getWidth() / 2) - 130, (camera.y + love.graphics.getHeight() / 2))
  end
end

function Hud:drawServerMessages()
  if self.player_joined then
    love.graphics.setFont(hud_font)
    love.graphics.print("Another player joined the game", (camera.x + love.graphics.getWidth() / 2), (camera.y + love.graphics.getHeight()  / 2))
    Timer.add(6, function() self.player_joined = false end)
  end
end