graphics_menu = Gamestate.new()

function graphics_menu:init()
  -- group defaults
  gui.group.default.size[1] = 150
  gui.group.default.size[2] = 25
  gui.group.default.spacing = 5

  modes = love.graphics.getModes()
end

function graphics_menu:enter(previous)

end

function graphics_menu:change_mode(x, y)
  love.graphics.setMode(x, y, Settings.fullscreen, Settings.vsync, Settings.fsaa)
  Settings.x_res = x
  Settings.y_res = y
  --A level is 900px wide. We put the camera into the center of the level,
  --depending on the screen resolution.
  camera:centerInWorld(900)
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

  --Generate all the resolution buttons.
  for index, mode in ipairs(modes) do
    if gui.Button{text = mode.width .. "x" .. mode.height} then
      self:change_mode(mode.width, mode.height)
    end
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
