--- InGame.lua
-- the gamestate where all gameplay takes place
Signal = require('lib.hump.signal')
local Timer = require('lib.hump.timer')
local Camera = require('lib.hump.camera')
local P = love.physics
local Gamestate = require('lib.hump.gamestate')

-- gamestates
local gameOver = require('src.GameOver')

local Player = require('src.Player')
local Line = require('src.Line')

--gamestate table
local state = {}

--physics objects
local player
local lines = {} -- table to hold all our physical objects
local walls = {}
--physics world
local world
--camera object
local cam
--camera y location
local camY
-- where to draw the next line
local nextLineY

local gameSpeed = 80
local score = 0
local x, y = love.window.getMode()

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

   camY = y/2
   cam = Camera(x/2, camY)
   nextLineY = y
end

function state:update(dt)
   --player.body:setLinearVelocity(0, 200)
   world:update(dt)
   Timer.update(dt)

   --update the camera's position
   local lowerBound = 50
   if player.body:getY() < camY + (y/2) - lowerBound then
      -- player is behind the camera bottom
      camY = camY + (gameSpeed * dt)
   else
      camY = camY + (player.body:getY() - (camY + (y/2) - lowerBound))
   end
   cam:lookAt(x/2, camY)
      
   --move the walls with the screen
   walls.left.body:setPosition(-5, camY)
   walls.right.body:setPosition(x+5, camY)

   --add lines if needed
   if nextLineY-50 < camY + (y/2) then
      local a, b = Line.new(world, nextLineY)
      nextLineY = nextLineY + 100
      table.insert(lines, a)
      table.insert(lines, b)
   end

   --remove lines that arent needed (this doesnt work)
   for k, v in next, lines do
      if v.body:getY() + v.shape:getRadius() < camY - (y/2) then
	 lines[k] = nil
	 --lets also give the player some score when this happens
	 score = score + 10
      end
   end
   
   --do player input
   if player.intentions.right then
      player.body:applyForce(200, 0)
   elseif player.intentions.left then
      player.body:applyForce(-200, 0)
   end

   --check if you lose
   if select(2, player.body:getWorldCenter()) + player.shape:getRadius() < camY - (y/2) then
      gameOver:setScore(score)
      Gamestate.switch(gameOver)
   end
end

function state:draw()
   cam:attach()
   
   love.graphics.setColor(193, 47, 14)
   love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())

   love.graphics.setColor(150, 150, 150)
   local lineCount = 0
   for k, v in next, lines do
      lineCount = lineCount + 1
      love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
   end
   
   cam:detach()
   
   love.graphics.print(score, 20, 20)
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

return state
