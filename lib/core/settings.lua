Settings = {}

local user_path = love.filesystem.getUserDirectory()
local conf_path = user_path .. "lavatemple.conf"
local config    = table.load(conf_path)

function Settings.load()
  if not config then
    Settings.x_res      = 1024
    Settings.y_res      = 768
    Settings.fullscreen = 0
    Settings.shadows    = 1
    Settings.fsaa       = 0
    Settings.vsync      = 1
    Settings.debug      = 0
    Settings.draw_fps   = 0

    table.save(Settings, conf_path)
  else
    for key, value in pairs(config) do
      if value == 1 then
        Settings[key] = true
      elseif value == 0 then
        Settings[key] = false
      end
    end

    Settings.fsaa  = config.fsaa
    Settings.x_res = config.x_res
    Settings.y_res = config.y_res
  end
end

function Settings.save()
  local settings = {}

  for key, value in pairs(Settings) do
    if value == true then
      settings[key] = 1
    elseif value == false then
      settings[key] = 0
    else
      settings[key] = value
    end
  end

  table.save(settings, conf_path)
end

Settings.load()
