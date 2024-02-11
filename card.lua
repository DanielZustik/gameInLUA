Card = Entity:extend()

function Card:new(x,y)
  Card.super.new(self, x, y, "images/4 Animated objects/Card.png")
  self.width = 12
  self.height = 13
  
  self.animation_speed = 9.5
  self.currentFrame = 1
  Card:animation()
end

function Card:draw()
    love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y)
end

function Card:update(dt, player)
  if player then
    ---calculating distance to a plyer
    self.horizontalDistance = self.x - player.x
    self.verticalDistance = self.y - player.y
    local a = self.horizontalDistance * self.horizontalDistance
    local b = self.verticalDistance * self.verticalDistance
    local c = a + b
    self.distanceFromPlayer = math.sqrt(c)
  end
  
  
  if  self.distanceFromPlayer <30 then
    self.pickedup = true
    sounds.sfx_pickup:play()
    self.x = 100000
  end
  
    if self.currentFrame >= 8 then
      self.currentFrame = 1
    else 
      self.currentFrame = self.currentFrame + self.animation_speed * dt
    end
end

function Card:animation()

  local width = 0
  local height = 0
  
  self.image = love.graphics.newImage("images/4 Animated objects/Card.png")
  self.frames = {}
  width = self.image:getWidth()
  height = self.image:getHeight()
  table.insert(self.frames, love.graphics.newQuad(0, 0, 12, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(25, 0, 12, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(51, 0, 12, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(73, 0, 12, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(95, 0, 12, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(122, 0, 12, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(147, 0, 12, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(169, 0, 12, 13, width, height))
  

  end