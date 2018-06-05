push = require 'push'
Class = require 'class'

require 'Bird'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = VIRTUAL_WIDTH

local bird = Bird()

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Fifty Bird')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  push:start()

  love.graphics.draw(background, -backgroundScroll, 0)
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  bird:render()

  push:finish()
end

function love.update(dt)
  backgroundScroll = (backgroundScroll + dt * BACKGROUND_SCROLL_SPEED)
      % BACKGROUND_LOOPING_POINT
  groundScroll = (groundScroll + dt * GROUND_SCROLL_SPEED)
      % GROUND_LOOPING_POINT
end
