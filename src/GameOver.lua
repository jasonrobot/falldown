--- GameOver.lua
-- you lose!

local state = {}
state.score = 0

function state:setScore(score)
   self.score = score
end

function state:draw()
   local text = 'Game Over! You Lose!'
   local x, y = love.window.getMode()
   love.graphics.print(text, (x/2)-100, y/2)
   love.graphics.print('Score: ' .. self.score, (x/2)-100, (y/2)+20)
end

return state
