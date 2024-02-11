if arg[#arg] == "-debug" then require("mobdebug").start() end

WINDOW_WIDTH = 576*2
WINDOW_HEIGHT = 324*2

VIRTUAL_WIDTH = 576*2
VIRTUAL_HEIGHT = 324*2

msg = ""


function loadMap(filename)
    local map = {}
    local file = io.open(filename, "r")
    for line in file:lines() do
        local row = {}
        for number in string.gmatch(line, "%d+") do
            table.insert(row, tonumber(number))
        end
        table.insert(map, row)
    end
    file:close()
    return map
end

function sign(x)
  if x < 0 then
    return -1
  elseif x > 0 then
    return 1
  else
    return 0
  end
end

function love.load()
  
    Object = require "classic"
    push = require 'push'
    require "entity"
    require "player"
    require "wall"
    require "box"
    require "box2"
    require "enemy"
    require "money"
    require "card"
    require "chest"
        
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

    counter = 0 
    timer = 0 
    timeElapsed = 0
    
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('MyGame')
    defaultFont = love.graphics.newFont(12)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    infoFont = love.graphics.newFont('font.ttf', 12)
    
    sounds = {}
    sounds.song = love.audio.newSource("/audio/beat.wav", "stream")
    sounds.song:setLooping(true)
    sounds.song:setVolume(0.2)
    sounds.song:play()
    sounds.sfx_jump = love.audio.newSource("audio/jump.wav", "static")
    sounds.sfx_jump:setVolume(0.1)
    sounds.sfx_shoot = love.audio.newSource("audio/shoot.wav", "static")
    sounds.sfx_shoot:setVolume(0.3)
    sounds.sfx_pickup = love.audio.newSource("audio/pickup.wav", "static")
    sounds.sfx_pickup:setVolume(0.3)
    sounds.sfx_hurt = love.audio.newSource("audio/hurt.wav", "static")
    sounds.sfx_hurt:setVolume(0.3)
    sounds.sfx_chest_opened = love.audio.newSource("audio/chest_opened.wav", "static")
    sounds.sfx_chest_opened:setVolume(0.3)
    
    win_loss = "U have died!"
    
    player = Player(450, 0)
    enemy = Enemy(2618, 150)
    card = Card(2718, 267)
    chest = Chest (2333, 403)
    box1 = Box2(1030,100)
    box2 = Box2(2052,100)
    box3 = Box2(2052,140)
    box4 = Box2(2052,180)
    objects = {}
    table.insert(objects, player)
    table.insert(objects, enemy)
    table.insert(objects, box1)
    table.insert(objects, box2)
    table.insert(objects, box3)
    table.insert(objects, box4)
    table.insert(objects, card)
    table.insert(objects, chest)

    
    walls = {}
    
  local map = loadMap("map.csv")

    for i,v in ipairs(map) do
        for j,w in ipairs(v) do
            if w ~= 0 then
                table.insert(walls, Wall((j-1)*32, (i-1)*32, w))
            end
        end
   
 end
 
 gameState = "play"

  background_night_over = love.graphics.newImage("/images/2 Background/Night/1.png")
  background_night_2 = love.graphics.newImage("/images/2 Background/Night/22.png")
  background_night_3 = love.graphics.newImage("/images/2 Background/Night/33.png")
  background_night_4 = love.graphics.newImage("/images/2 Background/Night/44.png")
  background_night_5 = love.graphics.newImage("/images/2 Background/Night/55.png")

  scroll_2 = 0
  scroll_3 = 0
  scroll_4 = 0
  scroll_5 = 0
end

function love.resize(WINDOW_WIDTH,WINDOW_HEIGHT)
  push:resize(WINDOW_WIDTH,WINDOW_HEIGHT)
end

function love.update(dt)
  
  if gameState == "play" then-----------------------------------------------------
    if player.health == 0 or chest.opened then --penize sebrany
      gameState = "end"
      timeElapsed = timeElapsed
    end
    if love.keyboard.isDown('p') then
      gameState = "paused"

  end
    timeElapsed = timeElapsed  + dt 
    timer = timer + dt 
    if timer >= 3 then 
        msg = "" 
        timer = 0
    else
        msg = msg
    end
    local initialX = player.x
    -- Update all the objects
    for i,v in ipairs(objects) do
        if v:is(Enemy) then
            v:update(dt, player)
        elseif v:is(Card) then
            v:update(dt, player)
        elseif v:is(Chest) then
            v:update(dt, player)
        else
            v:update(dt)
        end
    end
    
    for i,v in ipairs(walls) do
        v:update(dt)
    end

    
    local loop = true
    local limit = 0

    while loop do
        -- Set loop to false, if no collision happened it will stay false
        loop = false

        limit = limit + 1
        if limit > 100 then
            break
        end

        for i=1,#objects-1 do
            for j=i+1,#objects do
                local collision = objects[i]:resolveCollision(objects[j])
                if collision then
                    loop = true
                end
            end
        end
        
        for i=#objects,1,-1 do -- Iterating backwards since we're deleting elements
          if objects[i].toDelete then
            table.remove(objects, i)
          end
        end
        for i=#objects, 1, -1 do
          if objects[i].toDelete then
            table.remove(objects, i)
          end
        end

        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                local collision = object:resolveCollision(wall)
                if collision then
                    loop = true
                end
            end
        end
        -------------
    end
    
    
  if player.y > 3000 then
    love.event.quit()
  end
  
  
  speed_2 = 0.2
  speed_3 = 0.25
  speed_4 = 0.3
  speed_5 = 0.35
  delta = initialX - player.x -- zaporne jde doprava, kladne jde zpatky doleva
  if delta ~= 0 then
      scroll_2 = scroll_2 + delta * speed_2  --* smerovac
      scroll_3 = scroll_3 + delta * speed_3  --* smerovac
      scroll_4 = scroll_4 + delta * speed_4  --* smerovac
      scroll_5 = scroll_5 + delta * speed_5  --* smerovac
  end
  
 elseif gameState == "paused" then-----------------------------------------------------
  for key, sound in pairs(sounds) do
    sound:setVolume(0)
  end

  if love.keyboard.isDown('r') then
      love.load()
  end
  if love.keyboard.isDown('p') then
      gameState = "play"
    for key, sound in pairs(sounds) do
      if key == 'song' then
          sound:setVolume(0.2)
      elseif key == 'sfx_jump' then
          sound:setVolume(0.1)
      elseif key == 'sfx_shoot' then
          sound:setVolume(0.3)
      end
    end
  end

 elseif gameState == "end" then -------------------------------------------------------
  if love.keyboard.isDown('r') then
      love.load()
  end

 end --zavreni gamestate machine
 
end


function love.keypressed(key)
  if key == "up" then
    player:jump()
    sounds.sfx_jump:play()
  end
  if key == 'escape' then
      love.event.quit()
  end
  if key == "delete" then
      player.deathAnimation = true
  end
end

function love.draw()
    push:apply('start')
    if gameState == "play" or gameState == "paused" then
      love.graphics.setFont(defaultFont)
      love.graphics.scale(2)
      love.graphics.draw(background_night_over, 0, 0)
      love.graphics.draw(background_night_2, scroll_2, 0)
      love.graphics.draw(background_night_3, scroll_3, 0)
      love.graphics.draw(background_night_4, scroll_4, 0)
      love.graphics.draw(background_night_5, scroll_5, 0)
      love.graphics.push()
        -- Draw all the objects
      love.graphics.scale(0.8)
        for i,v in ipairs(objects) do
            v:draw()
        end

        for i,v in ipairs(walls) do
            v:draw()
        end

      love.graphics.pop()
      love.graphics.scale(0.5)
      love.graphics.print(player.action, 10, 50)
      love.graphics.print("x: " .. player.x, 10, 60)
      love.graphics.print("y: " ..player.y, 10, 70)
      love.graphics.print("chest distance" .. chest.distanceFromPlayer, 10, 80)
      love.graphics.print("chest frame" .. chest.currentFrame, 10, 100)
      love.graphics.print(msg, 590, 460)
      love.graphics.setFont(infoFont)
      love.graphics.print("press 'p' for menu and 'spacebar' to shoot", 850, 10)
    end
    if gameState == "paused" then
        love.graphics.setFont(scoreFont)
        love.graphics.print("Paused", 520, 20)
        love.graphics.print("press 'esc' to quit or 'r' to restart", 300, 80)

        
    elseif gameState == "end" and chest.opened then
        love.graphics.setFont(scoreFont)
        win_loss = "U won!"
        love.graphics.print(win_loss, 520, 20)
        love.graphics.print("press 'esc' to quit or 'r' to restart", 300, 80)
        love.graphics.print("time elapsed in game: ".. string.format("%.2f", timeElapsed), 300, 120)
    elseif gameState == "end" then
        love.graphics.setFont(scoreFont)
        love.graphics.print(win_loss, 520, 20)
        love.graphics.print("press 'esc' to quit or 'r' to restart", 300, 80)
        love.graphics.print("time elapsed in game: ".. string.format("%.2f", timeElapsed), 300, 120)
    end
    push:apply('end')
end



