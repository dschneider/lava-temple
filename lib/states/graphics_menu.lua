graphics_menu = Gamestate.new()

function graphics_menu:init()
  -- group defaults
  gui.group.default.size[1] = 150
  gui.group.default.size[2] = 25
  gui.group.default.spacing = 5
end

function graphics_menu:enter(previous)

end

function graphics_menu:update(dt)
  gui.group.push{grow = "down", pos = {(love.graphics.getWidth() / 2) - 130, 200}}

  if gui.Button{text = "Back"} then
    Gamestate.switch(pause_menu)
  end

  if gui.Checkbox{checked = fullscreen, text = "Fullscreen"} then
    fullscreen = not fullscreen
    love.graphics.toggleFullscreen()
  end

  if gui.Checkbox{checked = fullscreen, text = "Fullscreen"} then
    shadows = not shadows
    love.graphics.toggleFullscreen()
  end

  if gui.Button{text = "1024 x 768"} then
    love.graphics.setMode(1440, 900, fullscreen, true, 0)
  end

  if gui.Button{text = "1440 x 900"} then
    love.graphics.setMode(1440, 900, fullscreen, true, 0)
  end

  if gui.Button{text = "1600 x 900"} then
    love.graphics.setMode(1440, 900, fullscreen, true, 0)
  end

  if gui.Button{text = "1680 x 1050"} then
    love.graphics.setMode(1680, 1050, fullscreen, true, 0)
  end

  if gui.Button{text = "1600 x 1200"} then
    love.graphics.setMode(1600, 1200, fullscreen, true, 0)
  end

  if gui.Button{text = "1920 x 1080"} then
    love.graphics.setMode(1600, 1200, fullscreen, true, 0)
  end

  gui.group.pop{}
end

function graphics_menu:draw()
  game:draw()
  gui.core.draw()
end

function graphics_menu:keypressed(key, code)
  gui.keyboard.pressed(key, code)
  if key == "escape" then
    Gamestate.switch(pause_menu)
  end
end
