Player = Entity:extend()

function Player:new(x, y)
  Player.super.new(self, x, y, "/images/3 Cyborg/run_right.png", name)
  self.name = "player"
  self.width = 23
  self.height = 35 --45
  self.strength = 10
  self.weight = 1500
  
  self.health = 100
  
  self.canJump = false
  self.animationJump = false -- remebers which action is in progress and allows complitingin it
  
  Player:animation()
  self.deathAnimation = false -- spinac death animace
  
end

function Player:update(dt)
    Player.super.update(self, dt)
    
  if self.shakeDuration > 0 then
      self.shakeDuration = self.shakeDuration - dt
      if self.shakeWait > 0 then
          self.shakeWait = self.shakeWait - dt
      else
          self.shakeOffset.x = love.math.random(-5,5)
          self.shakeOffset.y = love.math.random(-5,5)
          self.shakeWait = 0.05
      end
  end
    
    if love.keyboard.isDown("left") then
        self.x = self.x - 140 * dt
        self.direction = "left"
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 140 * dt
        self.direction = "right"
    end
    
    if love.keyboard.isDown("right") and love.keyboard.isDown("up") and not self.canJump and not self.deathAnimation then 
      self.action = "jump_right"
      self.currentFrame = self.currentFrame + (animation_speed + 3) * dt
      if self.currentFrame >= 4 then
        self.currentFrame = 1
      end
    elseif love.keyboard.isDown("left") and love.keyboard.isDown("up") and not self.canJump and not self.deathAnimation then 
      self.action = "jump_left"
      self.currentFrame = self.currentFrame + (animation_speed + 3) * dt
      if self.currentFrame >= 4 then
        self.currentFrame = 1
      end
    elseif love.keyboard.isDown("right") and self.canJump and not self.deathAnimation then
      self.action = "run_right"
      self.currentFrame = self.currentFrame + animation_speed * dt
      if self.currentFrame >= 7 then
        self.currentFrame = 1
      end
    elseif love.keyboard.isDown("left") and self.canJump and not self.deathAnimation then
      self.action = "run_left"
      self.currentFrame = self.currentFrame + animation_speed * dt
      if self.currentFrame >= 7 then
        self.currentFrame = 1
      end
    elseif self.deathAnimation then
      self.action = "death"
      self.currentFrame = self.currentFrame + (animation_speed) * dt
      if self.currentFrame >= 7 then
        self.currentFrame = 1
        self.deathAnimation = false
      end
    elseif love.keyboard.isDown("space") and self.canJump and not self.deathAnimation then
      if self.direction == "right" then
        self.action = "attack_right"
        
      else
        self.action = "attack_left"
      end
      timer = 0
      msg = "....no ammo! xD"
      self.currentFrame = self.currentFrame + (animation_speed - 2) * dt
      if self.currentFrame >= 5 then
        self.shakeDuration = 0.3
        if self.currentFrame >= 9 then
          sounds.sfx_shoot:play()
          self.currentFrame = 1
        end
      end
    else
      if (self.action ~= "idle_right" and self.action ~= "idle_left") and self.canJump and not self.deathAnimation then -- selcanJump aby nerusilo animace skoku a behu pri pusteni klaves, a ze neprobiha animace idle pokud ano resetovani currentframu az po jejim dokonceni popor v jine animaci 
        self.currentFrame = 1
        if self.action ~= "run_left" and self.action ~= "jump_left"  then
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
    
    if self.last.y ~= self.y then
        self.canJump = false
    end
end

function Player:jump()
  if self.canJump then
    self.gravity = -410
    self.canJump = false

  end
end

function Player:collide(e, direction)
    Player.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end

function Player:checkResolve(e, direction)
    if e:is(Box) then
        if direction == "bottom" then
            return true
        else
            return false
        end
    end
    return true
end

function Player:draw()
    love.graphics.translate(-player.x + 355, -player.y + 290)
    if self.shakeDuration > 0 then
        love.graphics.translate(self.shakeOffset.x, self.shakeOffset.y)
    end
    love.graphics.draw(self.images[self.action], self.frames[self.action][math.floor(self.currentFrame)], self.x, self.y)
end

function Player:is(t)
    return t == Player
end

function Player:animation()
  self.shakeDuration = 0
  self.shakeWait = 0
  self.shakeOffset = {x = 0, y = 0}
  
  self.currentFrame = 1
  self.action = "jump_right" -- implicitely used, later modified
  
  local width = 0
  local height = 0
  
  animation_speed = 9.5
  self.images = {}
  self.images["run_right"] = love.graphics.newImage("/images/3 Cyborg/run_right.png")
  self.images["run_left"] = love.graphics.newImage("/images/3 Cyborg/run_left.png")
  self.images["jump_right"] = love.graphics.newImage("/images/3 Cyborg/jump_right.png")
  self.images["jump_left"] = love.graphics.newImage("/images/3 Cyborg/jump_left.png")
  self.images["idle_right"] = love.graphics.newImage("/images/3 Cyborg/idle_right.png")
  self.images["idle_left"] = love.graphics.newImage("/images/3 Cyborg/idle_left.png")
  self.images["death"] = love.graphics.newImage("/images/3 Cyborg/death.png")
  self.images["attack_right"] = love.graphics.newImage("/images/3 Cyborg/attack_right.png")
  self.images["attack_left"] = love.graphics.newImage("/images/3 Cyborg/attack_left.png")

  self.frames = {}
  self.frames["run_right"] = {}
  width = self.images["run_right"]:getWidth()
  height = self.images["run_right"]:getHeight()
  table.insert(self.frames["run_right"], love.graphics.newQuad(0, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(45, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(92, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(138, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(190, 0, 23, 35, width, height))
  table.insert(self.frames["run_right"], love.graphics.newQuad(240, 0, 23, 35, width, height))
  
  self.frames["run_left"] = {}
  width = self.images["run_left"]:getWidth()
  height = self.images["run_left"]:getHeight()
  table.insert(self.frames["run_left"], love.graphics.newQuad(238, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(194, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(138, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(88, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(47, 0, 23, 35, width, height))
  table.insert(self.frames["run_left"], love.graphics.newQuad(0, 0, 23, 35, width, height))
  
  self.frames["jump_right"] = {}
  width = self.images["jump_right"]:getWidth()
  height = self.images["jump_right"]:getHeight()
  table.insert(self.frames["jump_right"], love.graphics.newQuad(0, 0, 31, 35, width, height))
  table.insert(self.frames["jump_right"], love.graphics.newQuad(47, 0, 31, 35, width, height))
  table.insert(self.frames["jump_right"], love.graphics.newQuad(95, 0, 31, 35, width, height))
  table.insert(self.frames["jump_right"], love.graphics.newQuad(142, 0, 31, 35, width, height))
  
  self.frames["jump_left"] = {}
  width = self.images["jump_left"]:getWidth()
  height = self.images["jump_left"]:getHeight()
  table.insert(self.frames["jump_left"], love.graphics.newQuad(145, 0, 31, 35, width, height))
  table.insert(self.frames["jump_left"], love.graphics.newQuad(96, 0, 31, 35, width, height))
  table.insert(self.frames["jump_left"], love.graphics.newQuad(49, 0, 31, 35, width, height))
  table.insert(self.frames["jump_left"], love.graphics.newQuad(0, 0, 31, 35, width, height))
  
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
  
  self.frames["death"] = {}
  width = self.images["death"]:getWidth()
  height = self.images["death"]:getHeight()
  table.insert(self.frames["death"], love.graphics.newQuad(0, 0, 19, 35, width, height))
  table.insert(self.frames["death"], love.graphics.newQuad(45, 0, 19, 35, width, height))
  table.insert(self.frames["death"], love.graphics.newQuad(99, 0, 19, 35, width, height))
  table.insert(self.frames["death"], love.graphics.newQuad(145, 0, 25, 35, width, height))
  table.insert(self.frames["death"], love.graphics.newQuad(193, 0, 22, 35, width, height))
  table.insert(self.frames["death"], love.graphics.newQuad(242, 0, 22, 35, width, height))
  
  self.frames["attack_right"] = {}
  width = self.images["attack_right"]:getWidth()
  height = self.images["attack_right"]:getHeight()
  table.insert(self.frames["attack_right"], love.graphics.newQuad(0, 0, 21, 35, width, height))
  table.insert(self.frames["attack_right"], love.graphics.newQuad(46, 0, 21, 35, width, height))
  table.insert(self.frames["attack_right"], love.graphics.newQuad(93, 0, 21, 35, width, height))
  table.insert(self.frames["attack_right"], love.graphics.newQuad(148, 0, 21, 35, width, height))
  table.insert(self.frames["attack_right"], love.graphics.newQuad(196, 0, 30, 35, width, height))
  table.insert(self.frames["attack_right"], love.graphics.newQuad(244, 0, 21, 35, width, height))
  table.insert(self.frames["attack_right"], love.graphics.newQuad(292, 0, 30, 35, width, height))
  table.insert(self.frames["attack_right"], love.graphics.newQuad(338, 0, 21, 35, width, height))
  
  self.frames["attack_left"] = {}
  width = self.images["attack_left"]:getWidth()
  height = self.images["attack_left"]:getHeight()
  table.insert(self.frames["attack_left"], love.graphics.newQuad(349, 0, 21, 35, width, height))
  table.insert(self.frames["attack_left"], love.graphics.newQuad(302, 0, 21, 35, width, height))
  table.insert(self.frames["attack_left"], love.graphics.newQuad(253, 0, 30, 35, width, height))
  table.insert(self.frames["attack_left"], love.graphics.newQuad(203, 0, 30, 35, width, height))
  table.insert(self.frames["attack_left"], love.graphics.newQuad(143, 0, 30, 35, width, height))
  table.insert(self.frames["attack_left"], love.graphics.newQuad(96, 0, 30, 35, width, height))
  table.insert(self.frames["attack_left"], love.graphics.newQuad(47, 0, 30, 35, width, height))
  table.insert(self.frames["attack_left"], love.graphics.newQuad(0, 0, 30, 35, width, height))
  
  end