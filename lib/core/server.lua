Server = {}

local function connected(client_id)
  clean_string = client_id:gsub("%.", "dot")
  local ip, port = clean_string:match("(%w+):(%w+)")
  clean_ip = ip:gsub("dot", ".")
  print("Client with IP " .. clean_ip .. " connected")
  server:send("new_player\n", client_id)
end

local function receive(data, client_id)
  if Settings.debug then print("SERVER: " .. data) end
  if data:match("^new_player:client_id:") then
    server:registerPlayer(data, client_id)
    server:send(("player_joined:%s"):format(server:getPlayerName(client_id)))
  elseif data:match("^playerdata:") or data:match("^rubydata:") or data:match("^lavadata:") then
    -- send player data and ruby data to all players, including the sender
    server:send(data)
  end
end

function Server:new(port, object)
  if not love then print "This library requires Love2D"; return false; end

  object = object or {} -- create object if user does not provide one
  setmetatable(object, self)
  self.__index = self -- self refers to Server here

  object.port = port or 3410
  object.players = {}
  object.connection = lube.udpServer()
  object.connection.handshake = "lava-temple"
  object.connection:setPing(true, 16, "areYouStillThere?\n")
  object.connection:listen(object.port)
  object.connection.callbacks.recv = receive
  object.connection.callbacks.connect = connected
  object.connection.callbacks.disconnect = function() print("Client XYZ disconnected") end
  print("Now listening on port 3410")

  return object
end

function Server:getOtherPlayer(client_id)
  for k, v in ipairs(self.players) do
    if not (v == client_id) then
      return v
    end
  end
end

function Server:getPlayerName(client_id)
  return self.players[client_id]
end

function Server:registerPlayer(data, client_id)
  local name = data:match("^new_player:client_id:(%w+)")
  self.players[client_id] = name
end

function Server:send(data, client_id)
  self.connection:send(data, client_id)
end

function Server:update(dt)
  self.connection:update(dt)
end