main_menu = Gamestate.new()
local host_input = {text = "localhost"}
local id_input = {text = "default"}

function main_menu:init()
  main_menu_font = love.graphics.newFont("media/fonts/PressStart2P.ttf", 10)
  love.graphics.setFont(main_menu_font)

  -- group defaults
  gui.group.default.size[1] = 150
  gui.group.default.size[2] = 25
  gui.group.default.spacing = 5

  self.lava = Lava:new(0, 0)
end

function main_menu:enter(previous)

end

function main_menu:update(dt)
  self.lava:update(dt)

  gui.group.push{grow = "down", pos = {(love.graphics.getWidth() / 2) - 130, 200}}

  if gui.Button{text = "Start Singleplayer Game"} then
    -- game_started = true
    Gamestate.switch(game)
  end

  if gui.Button{text = "Join Multiplayer Game"} then
    client = Client:new(host_input.text, id_input.text)
    Gamestate.switch(game)
    player:setName(id_input.text)
  end

  if gui.Button{text = "Start Multiplayer Server"} then
    -- this should start a server and join the server afterwards
  end

  if gui.Button{text = "Act as server"} then
    server = Server:new()
    Gamestate.switch(game_server)
  end

  if gui.Button{text = "Quit Game"} then
    love.event.push('quit')
  end

  gui.Label{text = "Connect to multiplayer server", size = {70}}
  gui.Input{info = host_input, size = {300}}

  gui.Label{text = "Your multiplayer name", size = {70}}
  gui.Input{info = id_input, size = {300}}

  gui.group.pop{}
end

function main_menu:draw()
  self.lava:draw()
  love.graphics.setFont(love.graphics.newFont("media/fonts/PressStart2P.ttf", 40))
  love.graphics.print("LAVA TEMPLE", (love.graphics.getWidth() / 2) - 250, 100)
  love.graphics.setFont(love.graphics.newFont("media/fonts/PressStart2P.ttf", 20))
  gui.core.draw()
end

function main_menu:keypressed(key, code)
  gui.keyboard.pressed(key, code)
end