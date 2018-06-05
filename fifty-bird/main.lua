push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

GRAVITY = 20

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = VIRTUAL_WIDTH

local bird = Bird()

local pipes = {}
local pipeTimer = 0
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Fifty Bird')

  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  love.keyboard.keysPressed = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true

  if key == 'escape' then
    love.event.quit()
  end
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.draw()
  push:start()

  love.graphics.draw(background, -backgroundScroll, 0)

  for k, pipePair in pairs(pipes) do
    pipePair:render()
  end

  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  bird:render()

  push:finish()
end

function love.update(dt)
  backgroundScroll = (backgroundScroll + dt * BACKGROUND_SCROLL_SPEED)
      % BACKGROUND_LOOPING_POINT

  groundScroll = (groundScroll + dt * GROUND_SCROLL_SPEED)
      % GROUND_LOOPING_POINT

  bird:update(dt)

  pipeTimer = pipeTimer + dt
  if pipeTimer > 2 then
    local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY +
    math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
    lastY = y

    table.insert(pipes, PipePair(y))
    pipeTimer = 0
  end

  for k, pipePair in pairs(pipes) do
    pipePair:update(dt)
  end


  for k, pipePair in pairs(pipes) do
    if pipePair.remove then
      table.remove(pipes, k)
    end
  end

  love.keyboard.keysPressed = {}
end
