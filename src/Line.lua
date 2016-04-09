--- Line.lua
-- ganerates lines (walls, whatever)

local Line = {}

-- so this is actually going to need to make two lines (or more) with a space inbetween
function Line.new(world, y)
   local x = love.window.getMode()
   local gapWidth = 40
   -- get a random number between gapWidth/2 and x-(gapWidth/2)
   local gapX = math.floor(math.random(gapWidth/2, x-(gapWidth/2)))
   print(gapX)

   local l1 = {}
   local l1w = gapX - (gapWidth/2)
   local l1x = l1w/2
   l1.body = love.physics.newBody(world, l1x, y, 'static')
   l1.shape = love.physics.newRectangleShape(l1w, 5)
   l1.fixture = love.physics.newFixture(l1.body, l1.shape, 1)

   local l2 = {}
   local l2w = x - (gapX + (gapWidth/2))
   local l2x = gapX + (gapWidth/2) + (l2w/2)
   l2.body = love.physics.newBody(world, l2x, y, 'static')
   l2.shape = love.physics.newRectangleShape(l2w, 5)
   l2.fixture = love.physics.newFixture(l2.body, l2.shape, 1)

   print(l1x, l1w)
   print(l2x, l2w)
   return l1, l2
end

return Line
