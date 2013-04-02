pause_menu = Gamestate.new()

function pause_menu:init()
  -- group defaults
  gui.group.default.size[1] = 150
  gui.group.default.size[2] = 25
  gui.group.default.spacing = 5
end

function pause_menu:enter(previous)

end

function pause_menu:update(dt)
  gui.group.push{grow = "down", pos = {(love.graphics.getWidth() / 2) - 130, 200}}

  if gui.Button{text = "Resume"} then
    Gamestate.switch(game)
  end

  if gui.Button{text = "Fullscreen"} then
    love.graphics.setMode(1680, 1050, false, true, 0)
    love.graphics.toggleFullscreen()
  end

  if gui.Button{text = "Main Menu"} then
    Gamestate.switch(main_menu)
  end

  gui.group.pop{}
end

function pause_menu:draw()
  game:draw()
  gui.core.draw()
end

function pause_menu:keypressed(key, code)
  gui.keyboard.pressed(key, code)
  if key == "escape" then
    paused = not paused
    Gamestate.switch(game)
  end
end
