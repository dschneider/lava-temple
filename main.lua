--save table to file
require('lib.vendor.table.table')

--animations library
require("lib.vendor.anal.anal")

--networking library (depening on class commons)
require("lib.vendor.hump.class")
require("lib.vendor.lube.LUBE")
require("lib.core.server")
require("lib.core.client")

--2d lighting engine
require("lib.vendor.lumos")

--core libraries needed for the game to run
require("lib.core.settings")
require("lib.core.camera")
require("lib.core.hud")
require("lib.core.world")
require("lib.core.effects")
require("lib.core.sfx")
require("lib.core.shader")
require("lib.core.glow_shader")
require("lib.core.liquid_shader")
gui = require("lib.vendor.quickie")

--entities like players, items, enemies ...
require("lib.entities.whip")
require("lib.entities.inventory")
require("lib.entities.player")
require("lib.entities.life")
require("lib.entities.platform")
require("lib.entities.lava")
require("lib.entities.ruby")
require("lib.entities.chest")

--game states
Gamestate = require('lib.vendor.hump.gamestate')
require("lib.states.game")
require("lib.states.main_menu")
require("lib.states.graphics_menu")
require("lib.states.pause_menu")
require("lib.states.game_server")

--timer
Timer = require('lib.vendor.hump.timer')

require('version')

function love.load()
  love.graphics.setIcon(love.graphics.newImage("media/images/icon.png"))
  love.graphics.setCaption("Lava Temple - " .. VERSION)
  love.graphics.setMode(Settings.x_res, Settings.y_res, Settings.fullscreen, Settings.vsync, Settings.fsaa)
  Gamestate.switch(main_menu)
end

function love.update(dt)
  Gamestate.update(dt)
end

function love.keypressed(key, code)
  Gamestate.keypressed(key, code)
end

function love.draw()
  Gamestate.draw()
end