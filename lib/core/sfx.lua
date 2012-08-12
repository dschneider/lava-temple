Sfx = {}

function Sfx:new(x, y, scale_x, scale_y, rotation, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Camera here

  object.sound_effects = {}
  object.sound_effects["jump"] = love.audio.newSource("media/audio/effects/jump.ogg")
  object.sound_effects["jump"]:setVolume(0.1)
  object.sound_effects["lava"] = love.audio.newSource("media/audio/effects/lava.ogg")
  object.sound_effects["lava"]:setVolume(0.5)
  object.sound_effects["background"] = love.audio.newSource("media/audio/music/background.mp3")
  object.sound_effects["background"]:setVolume(0.2)
  return object
end

function Sfx:play(sound, mode)
  if mode then
    love.audio.play(self.sound_effects[sound], mode)
  else
    love.audio.play(self.sound_effects[sound])
  end
end

function Sfx:setLooping(sound, value)
  self.sound_effects[sound]:setLooping(value)
end

function Sfx:setVolume(sound, value)
  self.sound_effects[sound]:setVolume(value)
end