Client = {}

local function clientReceive(data)
  if debug then print("CLIENT: " .. data) end

  if data:match("^new_player") then
    client:registerPlayerAtServer()
  elseif data:match("^player_joined") then
    if not (data:match("^player_joined:(%w+)") == client:getId()) then
      hud.player_joined = true
      -- after this timer counted down, the lava will start raising
      Timer.add(10, function() game_started = true end)
    end
  elseif data:match("^playerdata:") then
    client:syncPlayerDataWithClient(data)
  elseif data:match("^rubydata:") then
    client:syncRubyDataWithClient(data)
  elseif data:match("^lavadata:") then
    client:syncLavaDataWithClient(data)
  end
end

function Client:new(host, id, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Client here

  object.id = id or "default"
  object.host = host or "localhost"
  object.connection = lube.udpClient()
  object.connection.handshake = "lava-temple"
  object.connection:setPing(true, 2, "areYouStillThere?\n")
  assert(object.connection:connect(object.host, 3410, true))
  object.connection.callbacks.recv = clientReceive
  print("Client is connecting to server " .. object.host .. " on port 3410")

  return object
end

function Client:getId()
  return self.id
end

function Client:syncPlayerDataWithClient(data)
  local name, x, y, state = data:match("^playerdata:(%w+):(%w+):(%w+):(%w+)")

  -- add magic characters again, underscore, minus etc.
  x = x:gsub("dot", "."):gsub("minus", "-")
  y = y:gsub("dot", "."):gsub("minus", "-")
  state = state:gsub("underscore", "_")

  if not (name == client:getId()) and type(name) == "string" then
    if not second_player then
      print("Found another player")
      second_player = Player:new(300, 0, name, "red", "multiplayer")
      -- register in world's player table
      world:registerPlayer(second_player)
    else
      -- send data to local second player copy
      second_player:setX(x)
      second_player:setY(y)
      second_player:setState(state)
    end
  end
end

function Client:syncPlayerDataWithServer()
  -- transform magic characters into words, otherwise it breaks the communication
  local clean_x_coordinate = tostring(player:getX()):gsub("%-", "minus"):gsub("%.", "dot")
  local clean_y_coordinate = tostring(player:getY()):gsub("%-", "minus"):gsub("%.", "dot")
  local clean_state = player:getState():gsub("%_", "underscore")

  local data = ("playerdata:" .. client:getId() .. ":%s:%s:%s\n"):format(clean_x_coordinate, clean_y_coordinate, clean_state)
  self:send(data)
end

function Client:syncLavaDataWithClient(data)
  local y = data:match("^lavadata:(%w+)")
  y = y:gsub("minus", "-"):gsub("dot", ".")
  y = tonumber(y)
  lava:setY(y)
end

function Client:syncLavaDataWithServer()
  local clean_y_coordinate = tostring(lava:getY()):gsub("%-", "minus"):gsub("%.", "dot")
  local data = ("lavadata:%s"):format(clean_y_coordinate)
  self:send(data)
end

function Client:syncRubyDataWithClient(data)
  local name, key = data:match("^rubydata:(%w+):(%w+)")
  if not (name == client:getId()) then world:removeRuby(key) end
end

function Client:syncRubyDataWithServer(key)
  local data = ("rubydata:" .. client:getId() .. ":%s\n"):format(key)
  self:send(data)
end

function Client:registerPlayerAtServer()
  client:send("new_player:client_id:" .. client:getId() .. "\n")
end

function Client:send(data)
  self.connection:send(data)
end

function Client:update(dt)
  self.connection:update(dt)
end