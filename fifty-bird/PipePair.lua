PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
  self.x = VIRTUAL_WIDTH + 32
  self.y = y

  local gap_randomness = math.random(10)
  self.pipes = {
    ['upper'] = Pipe('top', self.y - gap_randomness),
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT + gap_randomness)
  }

  -- whether the pipe is ready to be removed
  self.remove = false

  -- whether this pair has been scored
  self.scored = false
end

function PipePair:update(dt)
  if self.x > -PIPE_WIDTH then
    self.x = self.x - PIPE_SPEED * dt
    self.pipes['lower'].x = self.x
    self.pipes['upper'].x = self.x
  else
    self.remove = true
  end
end

function PipePair:render()
  for k, pipe in pairs(self.pipes) do
    pipe:render()
  end
end
