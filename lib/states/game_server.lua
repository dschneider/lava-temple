game_server = Gamestate.new()

function game_server:init()

end

function game_server:enter(previous)
  
end

function game_server:update(dt)
  if server then 
    server:update(dt)
  end
end

function game_server:draw()

end

function game_server:keypressed(key, code)

end