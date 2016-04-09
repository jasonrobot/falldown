--- InGame.lua
-- the gamestate where all gameplay takes place
Signal = require('signal')
local Timer = require('timer')
local Camera = require('camera')
local P = love.physics

local Player = require('Player')
local Line = require('Line')

local state = {}

local player
local lines = {} -- table to hold all our physical objects
local walls = {}
local world
local cam
local nextLineY

function state:init()
   local x, y = love.window.getMode()
   P.setMeter(64) --the height of a meter our worlds will be 64px
   world = P.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

   walls.left = {}
   walls.left.body = P.newBody(world, -5, y/2, 'static')
   walls.left.shape = P.newRectangleShape(10, y)
   walls.left.fixture = P.newFixture(walls.left.body, walls.left.shape)

   walls.right = {}
   walls.right.body = P.newBody(world, x+5, y/2, 'static')
   walls.right.shape = P.newRectangleShape(10, y)
   walls.right.fixture = P.newFixture(walls.right.body, walls.right.shape)
   
   player = Player.new(world)
   player.intentions = {}

   Timer.every(1, function() self:insertNextLines() end)
	       
   cam = Camera(x/2, y/2)
   nextLineY = y + 100
end

function state:update(dt)
   --player.body:setLinearVelocity(0, 200)
   world:update(dt)
   Timer.update(dt)
   local x = love.window.getMode()
   local _, y = player.body:getWorldCenter()
   cam:lookAt(x/2, y)

   walls.left.body:setPosition(-5, y)
   walls.right.body:setPosition(x+5, y)

   if player.intentions.right then
      player.body:applyForce(200, 0)
   elseif player.intentions.left then
      player.body:applyForce(-200, 0)
   end
end

function state:draw()
   cam:attach()
   
   love.graphics.setColor(193, 47, 14)
   love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())

   love.graphics.setColor(150, 150, 150)
   for k, v in next, lines do
      love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
   end

   love.graphics.polygon("fill", walls.left.body:getWorldPoints(walls.left.shape:getPoints()))

   cam:detach()
end

function state:keypressed(key)
   if key == 'right' then
      player.intentions.right = true
   elseif key == 'left' then
      player.intentions.left = true
   end
end

function state:keyreleased(key)
   if key == 'right' then
      player.intentions.right = false
   elseif key == 'left' then
      player.intentions.left = false
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
