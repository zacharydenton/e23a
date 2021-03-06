Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')


function Pipe:init(orientation, y)
  self.orientation = orientation
  self.x = VIRTUAL_WIDTH
  self.y = y
end

function Pipe:update(dt)
  self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
  love.graphics.draw(PIPE_IMAGE, self.x,
  (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
  0, 1, self.orientation == 'top' and -1 or 1)
end
