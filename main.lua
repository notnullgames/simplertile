json = require("lib.dkjson")
tiled = require("lib.tiled")
Camera = require("lib.camera")
anim8 = require("lib.anim8")
bump = require("lib.bump")

local player = require("player")
local map
local camera
local world

-- called for every object to set things up
function handle_object(object)
  -- set initial position of player
  if (object.type == "player" and object.name == "hero") then
    player.x = object.x
    player.y = object.y
    object.draw = player.draw
  end
end

function love.load()
  world = bump.newWorld()
  map = tiled.load("assets/demo.json")
  map.viewport = {x = 0, y = 0, width = love.graphics.getWidth(), height = love.graphics.getHeight()}
  camera = Camera(map.viewport.x + (map.viewport.width/2), map.viewport.y + (map.viewport.height/2))
  tiled.load_objects(map, handle_object)
  player.load(world)
end

function love.update(dt)
  player.update(dt)
  map.viewport.x = player.x - (map.viewport.width / 2) - (player.width / 2)
  map.viewport.y = player.y - (map.viewport.height / 2) - (player.height / 2)
  camera:lookAt(player.x, player.y)
end

function love.draw()
  camera:attach()
  tiled.draw(map)
  camera:detach()
end

function love.keypressed(key)
  if key == "up" then
    player.vy = -1
  end
  if key == "down" then
    player.vy = 1
  end
  if key == "left" then
    player.vx = -1
  end
  if key == "right" then
    player.vx = 1
  end
end

function love.keyreleased(key)
  if key == "up" or key == "down" then
    player.vy = 0
  end
  if key == "left" or key == "right" then
    player.vx = 0
  end
end