--- Player.lua
-- code for manipulating the player object

local Player = {}

function Player.new(world)
   local p = {}
   p.body = love.physics.newBody(world, love.window.getMode()/2, 100, 'dynamic')
   p.shape = love.physics.newCircleShape(15)
   p.fixture = love.physics.newFixture(p.body, p.shape, 1)
   p.fixture:setRestitution(0.5)
   return p
end

return Player
