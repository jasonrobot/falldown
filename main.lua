-- main.lua
-- entry point for the Love2d game engine
-- this doesnt work when distributing .love packages
--package.path = package.path .. ';lib/?/init.lua;lib/?.lua;lib/hump/?.lua;src/?.lua'
--local G = love.graphics

--local Camera = require 'camera'
local Gamestate = require 'lib.hump.gamestate'

-- gamestates
local mainMenu = require 'src.MainMenu'

function love.load ()
   -- Only ever called once. Load the scene manager here.
   Gamestate.registerEvents()
   Gamestate.switch(mainMenu)   
end
