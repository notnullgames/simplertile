local player = {}

local player = {
  direction = "S",
  speed = 100,
  x = 0,
  y = 0,
  width = 64,
  height = 64,
  vx = 0,
  vy = 0
}

function player.load(world)
  player.world = world
  player.image = love.graphics.newImage("assets/hero.png")
  local g = anim8.newGrid(64, 64, player.image:getWidth(), player.image:getHeight())
  player.animations = {
    N = anim8.newAnimation(g("1-8",1), 0.1 * (50 / player.speed)),
    W = anim8.newAnimation(g("1-8",2), 0.1 * (50 / player.speed)),
    S = anim8.newAnimation(g("1-8",3), 0.1 * (50 / player.speed)),
    E = anim8.newAnimation(g("1-8",4), 0.1 * (50 / player.speed))
  }
  player.world:add(player,0,0,64,64) -- x,y, width, height
end

function player.update(dt)
  local actualX, actualY, cols, len = player.world:move(player, player.x + (player.vx * player.speed * dt), player.y + (player.vy * player.speed * dt))
  player.x = actualX
  player.y = actualY

  if player.vy == -1 then
    player.direction = 'N'
  elseif player.vy == 1 then
    player.direction = 'S'
  elseif player.vx == -1 then
    player.direction = 'W'
  elseif player.vx == 1 then
    player.direction = 'E'
  end 

  if player.vx ~= 0 or player.vy ~= 0  then
    player.animations[player.direction]:update(dt)
    player.animations[player.direction]:resume()
  else
    player.animations[player.direction]:gotoFrame(1)
    player.animations[player.direction]:pause()
  end
end

function player.draw(object, map)
  player.animations[player.direction]:draw(player.image, player.x-(player.width/2), player.y-(player.height/2))
end

return player