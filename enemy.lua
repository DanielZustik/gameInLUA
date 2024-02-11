Enemy = Entity:extend()

function Enemy:new(x, y)
  Enemy.super.new(self, x, y, "images/2 Punk/Punk_hurt.png", name)
  self.name = "enemy"
  self.speed = 100
  self.width = 15
  self.height = 35
  self.strength = 10
  self.weight = 1500
  self.angleFromPlayer = 0
  self.distanceFromPlayer = 1000

  Enemy:animation()
end

function Enemy:update(dt, player)
  Enemy.super.update(self, dt) 
  self.initialX = self.x

  if player then
    self.angleFromPlayer = math.atan2(player.y - self.y, player.x - self.x)
    ---calculating distance to a plyer
    self.horizontalDistance = self.x - player.x
    self.verticalDistance = self.y - player.y
    local a = self.horizontalDistance * self.horizontalDistance
    local b = self.verticalDistance * self.verticalDistance
    local c = a + b
    self.distanceFromPlayer = math.sqrt(c)
  end
  
  cos = math.cos(self.angleFromPlayer)
  sin = math.sin(self.angleFromPlayer)
  
  if  self.distanceFromPlayer < 200 then
    self.x = self.x + self.speed * cos * dt
  end
  
  if  self.distanceFromPlayer <25 or (self.distanceFromPlayer <36 and math.floor(self.angleFromPlayer) == -2)  then
    sounds.sfx_hurt:play()
    player.health = 0
  end

    if self.x > self.initialX then
      self.action = "run_right"
      self.currentFrame = self.currentFrame + animation_speed * dt
      if self.currentFrame >= 7 then
        self.currentFrame = 1
      end
    elseif self.x < self.initialX then
      self.action = "run_left"
      self.currentFrame = self.currentFrame + animation_speed * dt
      if self.currentFrame >= 7 then
        self.currentFrame = 1
      end
    else
      if (self.action ~= "idle_right" and self.action ~= "idle_left") then
        self.currentFrame = 1
        if self.action ~= "run_left" then
          self.action = "idle_right"
        else
          self.action = "idle_left"
        end
      end
      self.currentFrame = self.currentFrame + (animation_speed - 4) * dt
      if self.currentFrame >= 4 then
        self.currentFrame = 1
      end
    end
    
end

function Enemy:getDistance(x1,z1,x2,y2)
  horizontalDistance = x1 - x2
  verticalDistance = y1 - y2
end

function Enemy:draw()
    love.graphics.draw(self.images[self.action], self.frames[self.action][math.floor(self.currentFrame)], self.x, self.y)
end

function Enemy:animation()
  
  self.currentFrame = 1
  self.action = "idle_right" -- implicitely used, later modified
  
  local width = 0
  local height = 0
  
  animation_speed = 9.5
  self.images = {}
  self.images["run_right"] = love.graphics.newImage("/images/2 Punk/run_right.png")
  self.images["run_left"] = love.graphics.newImage("/images/2 Punk/run_left.png")
  self.images["idle_right"] = love.graphics.newImage("/images/2 Punk/idle_right.png")
  self.images["idle_left"] = love.graphics.newImage("/images/2 Punk/idle_left.png")

  self.frames = {}
  self.frames["run_right"] = {}
  width = self.images["run_right"]:getWidth()
  height = self.images["run_right"]:getHeight()
  table.insert(self.frames["run_right"], love.graphics.newQuad(0, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(52, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(97, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(140, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(195, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(240, 0, 23, 35, width, height))
  
  self.frames["run_left"] = {}
  width = self.images["run_left"]:getWidth()
  height = self.images["run_left"]:getHeight()
  table.insert(self.frames["run_left"], love.graphics.newQuad(238, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(191, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(138, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(90, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(47, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(0, 0, 23, 35, width, height))
  
  self.frames["idle_right"] = {}
  width = self.images["idle_right"]:getWidth()
  height = self.images["idle_right"]:getHeight()
  table.insert(self.frames["idle_right"], love.graphics.newQuad(0, 0, 19, 35, width, height)) --47
  table.insert(self.frames["idle_right"], love.graphics.newQuad(47,0, 19, 35, width, height))
  table.insert(self.frames["idle_right"], love.graphics.newQuad(94, 0, 19, 35, width, height))
  table.insert(self.frames["idle_right"], love.graphics.newQuad(144, 0, 19, 35, width, height))

  self.frames["idle_left"] = {}
  width = self.images["idle_left"]:getWidth()
  height = self.images["idle_left"]:getHeight()
  table.insert(self.frames["idle_left"], love.graphics.newQuad(143, 0, 19, 35, width, height))
  table.insert(self.frames["idle_left"], love.graphics.newQuad(96, 0, 22, 35, width, height))
  table.insert(self.frames["idle_left"], love.graphics.newQuad(48, 0, 21, 35, width, height))
  table.insert(self.frames["idle_left"], love.graphics.newQuad(0, 0, 21, 35, width, height))

end