Chest = Entity:extend()

function Chest:new(x,y)
  Chest.super.new(self, x, y, "images/4 Animated objects/Chest.png")
  self.width = 30
  self.height = 36
  Chest:animation()
  self.currentFrame = 1
  self.distanceFromPlayer = 100
  self.opened = false
end

function Chest:draw()
    love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y)
end

function Chest:update(dt, player)
 
  if player then
    ---calculating distance to a plyer
    self.horizontalDistance = self.x - player.x
    self.verticalDistance = self.y - player.y
    local a = self.horizontalDistance * self.horizontalDistance
    local b = self.verticalDistance * self.verticalDistance
    local c = a + b
    self.distanceFromPlayer = math.sqrt(c)
  end
  
  
  if  self.distanceFromPlayer <33 and card.pickedup then
    if self.currentFrame >= 6 then
      return
    else 
      timer = 0
      msg = "....empty, but GJ! xD"
      sounds.sfx_chest_opened:play()
      self.opened = true
      self.currentFrame = self.currentFrame + self.animation_speed * dt
    end
end
  
end

function Chest:animation()
  self.animation_speed = 5.5
  local width = 0
  local height = 0
  
  self.image = love.graphics.newImage("images/4 Animated objects/Chest.png")
  self.frames = {}
  width = self.image:getWidth()
  height = self.image:getHeight()
  table.insert(self.frames, love.graphics.newQuad(4, 37, 36, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(51, 37, 36, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(99, 32, 36, 18, width, height))
  table.insert(self.frames, love.graphics.newQuad(148, 41, 36, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(194, 41, 36, 13, width, height))
  table.insert(self.frames, love.graphics.newQuad(243, 41, 36, 13, width, height))


  end