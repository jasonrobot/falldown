--- MainMenu.lua
-- Handles the main menu for the program.
local Gamestate = require 'lib.hump.gamestate'
local G = love.graphics

local InGame = require "src.InGame"

local state = {}

local menuOptions = {
   'Start a new game',
   'Quit',
}

local selectedOptionIndex = 1

function state.draw()
   local strbuf = ''
   for i = 1, #menuOptions, 1 do
      if i == selectedOptionIndex then
	 strbuf = '>>> '
      end
      strbuf = strbuf .. menuOptions[i]
      G.print(strbuf, 20, i * 20)
      strbuf = ''
   end
   
end

function state:keypressed(key, code)
   if key == 'down' and selectedOptionIndex < #menuOptions then
      selectedOptionIndex = selectedOptionIndex + 1
   end
   if key == 'up' and selectedOptionIndex > 1 then
     selectedOptionIndex = selectedOptionIndex - 1
   end
   if key == 'return' then
      if selectedOptionIndex == 1 then
	 Gamestate.switch(InGame)
      end
      if selectedOptionIndex == 2 then
	 love.event.quit()
      end
   end
end

return state

