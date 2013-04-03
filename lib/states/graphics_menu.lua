graphics_menu = Gamestate.new()

function graphics_menu:init()
  -- group defaults
  gui.group.default.size[1] = 150
  gui.group.default.size[2] = 25
  gui.group.default.spacing = 5
end

function graphics_menu:enter(previous)

end

function graphics_menu:change_mode(x, y)
  love.graphics.setMode(x, y, Settings.fullscreen, Settings.vsync, Settings.fsaa)
  Settings.x_res = x
  Settings.y_res = y
  Settings.save()
end

function graphics_menu:update(dt)
  gui.group.push{grow = "down", pos = {(love.graphics.getWidth() / 2) - 130, 200}}

  if gui.Button{text = "Back"} then
    Gamestate.switch(pause_menu)
  end

  if gui.Checkbox{checked = Settings.fullscreen, text = "Fullscreen"} then
    Settings.fullscreen = not Settings.fullscreen
    love.graphics.toggleFullscreen()
    Settings.save()
  end

  if gui.Checkbox{checked = Settings.shadows, text = "Shadows"} then
    Settings.shadows = not Settings.shadows
    Settings.save()
  end

  if gui.Button{text = "1024 x 768"} then
    self:change_mode(1024, 768)
  end

  if gui.Button{text = "1440 x 900"} then
    self:change_mode(1440, 900)
  end

  if gui.Button{text = "1600 x 900"} then
    self:change_mode(1600, 900)
  end

  if gui.Button{text = "1680 x 1050"} then
    self:change_mode(1680, 1050)
  end

  if gui.Button{text = "1600 x 1200"} then
    self:change_mode(1600, 1200)
  end

  if gui.Button{text = "1920 x 1080"} then
    self:change_mode(1920, 1080)
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
