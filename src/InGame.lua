--- InGame.lua
-- the gamestate where all gameplay takes place
Signal = require('signal')
local Timer = require('timer')
local Camera = require('camera')

local Player = require('Player')
local Line = require('Line')

local state = {}

local player
local lines = {} -- table to hold all our physical objects
local world
local cam
local nextLineY

function state:init()
   love.physics.setMeter(64) --the height of a meter our worlds will be 64px
   world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
   
   player = Player.new(world)

   Timer.every(1, function() self:insertNextLines() end)
	       
   local x, y = love.window.getMode()
   cam = Camera(x/2, y/2)
   nextLineY = y + 100
end

function state:update(dt)
   player.body:setLinearVelocity(0, 200)
   world:update(dt)
   Timer.update(dt)
   cam:lookAt(player.body:getWorldCenter())
end

function state:draw()
   cam:attach()
   
   love.graphics.setColor(193, 47, 14)
   love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())

   love.graphics.setColor(150, 150, 150)
   for k, v in next, lines do
      love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
   end

   cam:detach()
end

function state:keypressed(key)
   if key == 'right' then
      print('did it')
      player.body:applyForce(200, 0)
   end
end

function state:insertNextLines()
   local x, y = love.window.getMode()
   local a, b = Line.new(world, nextLineY)
   nextLineY = nextLineY + 200
   table.insert(lines, a)
   table.insert(lines, b)
end


return state
