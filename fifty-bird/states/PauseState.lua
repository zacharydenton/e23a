PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
  self.bird = params.bird
  self.pipePairs = params.pipePairs
  self.timer = params.timer
  self.score = params.score
  self.lastY = params.lastY
end

function PauseState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play', {
      bird = self.bird,
      pipePairs = self.pipePairs,
      timer = self.timer,
      score = self.score,
      lastY = self.lastY
    })
  end
end

function PauseState:render()
  for k, pair in pairs(self.pipePairs) do
    pair:render()
  end

  self.bird:render()

  love.graphics.setFont(flappyFont)
  love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
  love.graphics.printf('PAUSED', 0, 64, VIRTUAL_WIDTH, 'center')
end
