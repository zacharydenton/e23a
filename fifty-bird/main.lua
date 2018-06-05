push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PauseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

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

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Fifty Bird')

  smallFont = love.graphics.newFont('font.ttf', 8)
  mediumFont = love.graphics.newFont('flappy.ttf', 14)
  flappyFont = love.graphics.newFont('flappy.ttf', 28)
  hugeFont = love.graphics.newFont('flappy.ttf', 56)
  love.graphics.setFont(flappyFont)

  sounds = {
    ['jump'] = love.audio.newSource('jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
    ['score'] = love.audio.newSource('score.wav', 'static'),

    -- https://freesound.org/people/xsgianni/sounds/388079/
    ['music'] = love.audio.newSource('marios_way.mp3', 'static')
  }
  sounds['music']:setLooping(true)
  sounds['music']:play()

  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  gStateMachine = StateMachine({
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,
    ['countdown'] = function() return CountdownState() end,
    ['pause'] = function() return PauseState() end
  })
  gStateMachine:change('title')

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

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    love.keyboard.keysPressed['space'] = true
  end
end

function love.draw()
  push:start()

  love.graphics.draw(background, -backgroundScroll, 0)
  gStateMachine:render()
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  push:finish()
end

function love.update(dt)
  backgroundScroll = (backgroundScroll + dt * BACKGROUND_SCROLL_SPEED)
  % BACKGROUND_LOOPING_POINT

  groundScroll = (groundScroll + dt * GROUND_SCROLL_SPEED)
  % GROUND_LOOPING_POINT

  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
end
