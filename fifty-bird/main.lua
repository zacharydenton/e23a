push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'

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

  for k, pipe in pairs(pipes) do
    pipe:render()
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
    table.insert(pipes, Pipe())
    pipeTimer = 0
  end

  for k, pipe in pairs(pipes) do
    pipe:update(dt)
    if pipe.x < -pipe.width then
      table.remove(pipes, k)
    end
  end

  love.keyboard.keysPressed = {}
end
