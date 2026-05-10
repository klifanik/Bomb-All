init_other = require ("scripts/init_other")
init = require ("scripts/init")

function SpawnBuffs()
    AvailableBlocks = {}
    for _, i in ipairs(breaks) do table.insert(AvailableBlocks, i) end
    
    if #breaks == #AvailableBlocks then
        for i = 1, love.math.random(7, 17) do
            local randomat = love.math.random(1, #AvailableBlocks)
            local object = AvailableBlocks[randomat]
            if object then
                local boomb = {
                    x = object.x,
                    y = object.y,
                    width = object.width,
                    height = object.height,
                    image = buff_bomb_image,
                    scale = object.scale}
                table.insert(buffs, boomb)
                table.remove(AvailableBlocks, randomat)
            end
        end
        for i = 1, love.math.random(7, 17) do
            local randomat = love.math.random(1, #AvailableBlocks)
            local object = AvailableBlocks[randomat]
            if object then
                local fierun = {
                    x = object.x,
                    y = object.y,
                    width = object.width,
                    height = object.height,
                    image = buff_fire_image,
                    scale = object.scale}
                table.insert(buffs, fierun)
                table.remove(AvailableBlocks, randomat)
            end
        end
        for i = 1, love.math.random(7, 12) do
            local randomat = love.math.random(1, #AvailableBlocks)
            local object = AvailableBlocks[randomat]
            if object then
                local skuller = {
                    x = object.x,
                    y = object.y,
                    width = object.width,
                    height = object.height,
                    image = buff_skull_image,
                    scale = object.scale}
                table.insert(buffs, skuller)
                table.remove(AvailableBlocks, randomat)
            end
        end
        for i = 1, love.math.random(2, 6) do
            local randomat = love.math.random(1, #AvailableBlocks)
            local object = AvailableBlocks[randomat]
            if object then
                local linerun = {
                    x = object.x,
                    y = object.y,
                    width = object.width,
                    height = object.height,
                    image = buff_line_image,
                    scale = object.scale}
                table.insert(buffs, linerun)
                table.remove(AvailableBlocks, randomat)
            end
        end
        for i = 1, love.math.random(4, 8) do
            local randomat = love.math.random(1, #AvailableBlocks)
            local object = AvailableBlocks[randomat]
            if object then
                local kickun = {
                    x = object.x,
                    y = object.y,
                    width = object.width,
                    height = object.height,
                    image = buff_kick_image,
                    scale = object.scale}
                table.insert(buffs, kickun)
                table.remove(AvailableBlocks, randomat)
            end
        end
        for i = 1, love.math.random(4, 8) do
            local randomat = love.math.random(1, #AvailableBlocks)
            local object = AvailableBlocks[randomat]
            if object then
                local eggun = {
                    x = object.x,
                    y = object.y,
                    width = object.width,
                    height = object.height,
                    image = buff_egg_image,
                    scale = 0.2}
            table.insert(buffs, eggun)
            table.remove(AvailableBlocks, randomat)
            end
        end
        for i, buf in ipairs(buffs) do buf.buba = 1.0 end
    end
end

function spawnPlayers()
    for i = 1, 4 do
        local targetX = 12
        local targetY = 5
        local COLOR = "white"
        if i == 2 then targetX = 1988; targetY = 5; COLOR = "black" end
        if i == 3 then targetX = 12; targetY = 720; COLOR = "green" end
        if i == 4 then targetX = 1995; targetY = 720; COLOR = "red" end

        gamer = { 
            x = targetX, 
            y = targetY, 
            sprite = spriteDownWhite, 
            size = 0.25, 
            width = long, 
            height = long,
            lining = false,
            kicking = false,
            virus = 0,
            speed = 5,
            lastAutoBombX = -1,
            lastAutoBombY = -1,
            isOnDragon = false,
            Dragon = 0,
            direction = "down",
            unbreakable = false,
            FIRE = 1,
            BOMBS = 1,
            far = 1,
            bam = 1,
            controller = "none",
            id = 0,
            playing = false,
            isDashing = false,
            lastClickTime = 0,
            lastTouchATime = 0,
            blinkTimer = 0,
            popa = false,
            image = choose_NoPlayer_image,
            positionButton = 1,
            ready = false,
            color = COLOR,
            timeAnimDeath = 1.45,
            death = false,
            wins = 0,
            winner = false,
            team = "blue"
        }

        table.insert(Players, gamer)
    end
end

function ReSpawnPlayers()
    local i1, c1, w1, i2, c2, w2, i3, c3, w3, i4, c4, w4, t1, t2, t3, t4
    local raz = 0
    for _, p in ipairs(Players) do if p.controller ~= "none" then raz = raz + 1 end end

    for i = 1, raz do
        if i == 1 then i1, c1, w1, t1 = Players[1].id, Players[1].controller, Players[1].wins, Players[1].team end
        if i == 2 then i2, c2, w2, t2 = Players[2].id, Players[2].controller, Players[2].wins, Players[2].team end
        if i == 3 then i3, c3, w3, t3 = Players[3].id, Players[3].controller, Players[3].wins, Players[3].team end
        if i == 4 then i4, c4, w4, t4 = Players[4].id, Players[4].controller, Players[4].wins, Players[4].team end
    end
    
    Players = {}
    
    for i = 1, raz do
        local targetX = 12
        local targetY = 5
        local COLOR = "white"
        if i == 2 then targetX = 1988; targetY = 5; COLOR = "black" end
        if i == 3 then targetX = 12; targetY = 720; COLOR = "green" end
        if i == 4 then targetX = 1995; targetY = 720; COLOR = "red" end

        gamer = { 
            x = targetX, 
            y = targetY, 
            sprite = spriteDownWhite, 
            size = 0.25, 
            width = long, 
            height = long,
            lining = false,
            kicking = false,
            virus = 0,
            speed = 5,
            lastAutoBombX = -1,
            lastAutoBombY = -1,
            isOnDragon = false,
            Dragon = 0,
            direction = "down",
            unbreakable = false,
            FIRE = 1,
            BOMBS = 1,
            far = 1,
            bam = 1,
            isDashing = false,
            lastClickTime = 0,
            lastTouchATime = 0,
            blinkTimer = 0,
            popa = false,
            image = choose_NoPlayer_image,
            positionButton = 1,
            ready = true,
            color = COLOR,
            timeAnimDeath = 1.45,
            death = false,
            winner = false
        }

        table.insert(Players, gamer)
    end
    
    NumberOfPlayers = 0
    for i = 1, raz do
        NumberOfPlayers = NumberOfPlayers + 1
        Players[i].playing = true
        if i == 1 then Players[1].id, Players[1].controller, Players[1].wins, Players[1].team = i1, c1, w1, t1 end
        if i == 2 then Players[2].id, Players[2].controller, Players[2].wins, Players[2].team = i2, c2, w2, t2 end
        if i == 3 then Players[3].id, Players[3].controller, Players[3].wins, Players[3].team = i3, c3, w3, t3 end
        if i == 4 then Players[4].id, Players[4].controller, Players[4].wins, Players[4].team = i4, c4, w4, t4 end
    end
end
 
function checkCollision(a, b)
    return a.x + 30 < b.x + b.width and 
           a.x + a.width > b.x + 30 and 
           a.y + 30 < b.y + b.height and 
           a.y + a.height > b.y + 30 end
 
function round(num) return num >= 0 and math.floor(num + 0.5) or math.ceil(num - 0.5) end

function checkClick(mx, my, button)
    local clickX, clickY = mx / sx, my / sy
    return clickX >= button.x and 
           clickX <= button.x + (button.width * button.scale) and 
           clickY >= button.y and 
           clickY <= button.y + (button.height * button.scale)
end

function SwitchToMenu()
    if NetError ~= "" then fade.state = "out"; fade.level = myServer and "SETUP_CREATE" or "SETUP_JOIN" end

    if myClient then
        if myClient.isAuth and myClient.udp then
            pcall(function() myClient.udp:send("quit") end)
            for i=1,5 do pcall(function() myClient.udp:update() end) end
        end
        myClient = nil
    end
    
    if myServer then 
        myServer:stop() 
        myServer = nil 
    end
    collectgarbage("collect")

    InputFocus = ""
    cursorPos = 0
end
 
function Exit()
    if GAME ~= "gui" and GAME ~= "WaitForReady" then
        fade.state = "out"
        GAME = "transition"
        NumberOfPlayers = 0
        ReadyPlayers = 0
        TimeToExit = 3.0
        ExitFromWinnersTime = 5.0
        ButtonAnimation.position = 1
        Players = {}
        objects = {} 
        pieces = {}
        buffs = {}
        for _, i in ipairs(breaks) do i.isExploded = false end
        spawnPlayers()
        SpawnBuffs()

        whiteDeathAnimation.anim:gotoFrame(1)
        blackDeathAnimation.anim:gotoFrame(1)
        greenDeathAnimation.anim:gotoFrame(1)
        redDeathAnimation.anim:gotoFrame(1)

        fade.level = "gui"
    elseif GAME == "gui" then
        love.event.quit()
    elseif GAME == "WaitForReady" then
        if myClient then
            if myClient.udp then
                myClient.udp:disconnect()
                for i=1,5 do pcall(function() myClient.udp:update() end) end
            end
            myClient = nil
        end
        if myServer then myServer.udp:destroy(); myServer = nil end
        collectgarbage("collect")

        fade.state = "out"
        fade.level = "choose_server"
    end
end

function love.quit()
    if myClient then myClient.udp:disconnect(); for i=1,5 do pcall(function() myClient:update() end) end end
    if myServer then myServer.udp:destroy() end
end

function RetryGame()
    fade.state = "out"
    GAME = "transition"
    ExitFromWinnersTime = 5.0
    TimeToExit = 3.0
    objects = {}
    pieces = {}
    buffs = {}
    for _, i in ipairs(breaks) do i.isExploded = false end
    SpawnBuffs()
    ReSpawnPlayers()

    whiteDeathAnimation.anim:gotoFrame(1)
    blackDeathAnimation.anim:gotoFrame(1)
    greenDeathAnimation.anim:gotoFrame(1)
    redDeathAnimation.anim:gotoFrame(1)

    fade.level = "game"
end

function isGameOver()
    for i, player in ipairs(Players) do
        if player.wins >= WINS then
            return true
        end
    end
    return false
end

function RewardLastSurvivor()
    local alivePlayers = {}

    for i, player in ipairs(Players) do
        if player.playing then
            table.insert(alivePlayers, player)
        end
    end

    if #alivePlayers then
        for i = 1, #alivePlayers do
             alivePlayers[i].wins = alivePlayers[i].wins + 1
             alivePlayers[i].winner = true
        end
    end
end

function registerPlayer(controllerType, controllerId)
    -- Проверяем, не зарегистрирован ли уже этот контроллер
    for _, p in ipairs(Players) do
        if p.playing and p.controller == controllerType and p.id == controllerId then
            return 
        end
    end

    -- Конфигурация цветов для 4-х слотов
    local configs = {
        choose_white_image,
        choose_black_image,
        choose_green_image,
        choose_red_image
    }

    local startX = 150
    local spacing = 250
    local yPos = 100

    -- Ищем свободный слот
    for i, p in ipairs(Players) do
        local x = startX + (i-1) * spacing
        if not p.playing then
            local w = choose_NoPlayer_image:getWidth() * 0.5
            local wk = choose_notready:getWidth() * 0.2
            local lx, rx, ly, ry = x + ((w - wk) / 2), (x + ((w - wk) / 2)) + 3, yPos + 390, yPos + 450
            
            p.playing = true
            p.controller = controllerType
            p.id = controllerId
            p.image = configs[i] -- Назначаем цвет согласно очереди
            
            p.positionButton = 1
            p.ready = false
            
            NumberOfPlayers = NumberOfPlayers + 1
            
            p.btnReady = {x = rx, y = ry, width = choose_notready:getWidth(), height = choose_notready:getHeight(), scale = 0.2}
            p.btnLeave = {x = lx, y = ly, width = choose_leave:getWidth(), height = choose_leave:getHeight(), scale = 0.2}
            break
        end
    end
end

function KickBomb(i, direction)
    local picun = objects[i]
    picun.kickDirection = direction
    picun.kickSpeed = 560
    picun.isKicking = true
end

function Spawning(player)
    if player.BOMBS > 0 then
        local gridX = round(player.x / long) * long
        local gridY = round(player.y / long) * long
        
        -- Проверка: нет ли уже тут бомбы
        local occupied = false
        for _, obj in ipairs(objects) do
            if obj and obj.x == gridX and obj.y == gridY and not obj.isExploded then
                occupied = true
                break
            end
        end

        if not occupied then
            local bm = { 
                x = gridX, 
                y = gridY,
                width = long,
                height = long,
                image = bomb, 
                scale = 0.22, 
                isExploded = false,
                owner = player,
                LifeBomb = 3,
                LifeFire = 1,
                isPassable = true,
                draw = function(self) 
                    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale) 
                end 
            }
            table.insert(objects, bm)
            player.BOMBS = player.BOMBS - 1
            return true
        end
    end
    return false
end

function ApplyBuff(buf, i, player)
    if buf.image == buff_bomb_image then
        player.BOMBS = player.BOMBS + 1
        player.bam = player.bam + 1
        table.remove(buffs, i)
    elseif buf.image == buff_fire_image then
        player.FIRE = player.FIRE + 1
        player.far = player.far + 1
        table.remove(buffs, i)
    elseif buf.image == buff_line_image then
        player.lining = true
        table.remove(buffs, i)
    elseif buf.image == buff_kick_image then
        player.kicking = true
        table.remove(buffs, i)
    elseif buf.image == buff_skull_image then
        if player.virus == 0 then
            player.virus = love.math.random(1, 6)
            player.buba = love.timer.getTime()
            table.remove(buffs, i)
        end
    elseif buf.image == buff_egg_image then
        if not player.isOnDragon then
            player.Dragon = love.math.random(1, 5)
            player.isOnDragon = true
            table.remove(buffs, i)
        end
    end
end
 
function SpawnPiece(dx, dy)
    local clone = { 
        x = dx, 
        y = dy,
        width = long,
        height = long,
        image = boom, 
        life = 1,

        draw = function(self) 
            love.graphics.draw(self.image, self.x, self.y, 0, 0.33, 0.33) 
        end 
    } 

    table.insert(pieces, clone) 
    return clone 
end 

function BOOMING(i)
    local kuki = objects[i]
    local Owner = kuki.owner
        
    local directions = {
        {dx = 0, dy = -long},
        {dx = 0, dy = long},
        {dx = -long, dy = 0},
        {dx = long, dy = 0}
    }

    for _, dir in ipairs(directions) do
        local step = 0
        while step < Owner.FIRE do
            step = step + 1
            local spawnX = kuki.x + (dir.dx * step)
            local spawnY = kuki.y + (dir.dy * step)
                
            local hitHardBlock = false
            for _, b in ipairs(blocks) do
                if math.abs(b.x - spawnX) < 1 and math.abs(b.y - spawnY) < 1 then
                    hitHardBlock = true
                    break
                end
            end
                
            if hitHardBlock then break end
                
            SpawnPiece(spawnX, spawnY)
                
            local hitBreakBlock = false
            for _, b in ipairs(breaks) do
                if not b.isExploded and math.abs(b.x - spawnX) < 1 and math.abs(b.y - spawnY) < 1 then
                    hitBreakBlock = true
                    break
                end
            end
            if hitBreakBlock then break end

            local hitBuff = false
            for _, b in ipairs(buffs) do
                if not b.isExploded and math.abs(b.x - spawnX) < 1 and math.abs(b.y - spawnY) < 1 then
                    hitBuff = true
                    break
                end
            end
            if hitBuff then break end
        end
    end
end

function DrawField(drawX, y, text)
    -- 1. Проверяем, нужно ли сейчас показывать курсор (мигание)
    if showCursor then
        -- 2. Находим позицию курсора в байтах (для работы с UTF-8)
        local pos = cursorPos or utf8.len(text)
        local byteOffset = utf8.offset(text, pos + 1) or (#text + 1)
        
        -- 3. Берем только ту часть текста, которая СЛЕВА от курсора
        local textBeforeCursor = string.sub(text, 1, byteOffset - 1)
        
        -- 4. Измеряем ширину этой части
        local cursorRelativeX = bigFont:getWidth(textBeforeCursor)
        
        -- 5. Рисуем саму палочку
        love.graphics.setColor(0, 0, 0) -- Цвет курсора (черный)
        
        -- drawX — это (button.x + padding - offsetX)
        -- Добавляем к нему ширину текста до курсора
        love.graphics.rectangle("fill", drawX + cursorRelativeX + 10, y + 20, 2, 40)
        
        love.graphics.setColor(1, 1, 1) -- Сброс цвета
    end
end

function handleBackspace()
    local field = _G.InputFocus
    local s = menuData[field]
    if s and (_G.cursorPos or 0) > 0 then
        local pos = _G.cursorPos
        local byteBefore = utf8.offset(s, pos)
        local byteAfter = utf8.offset(s, pos + 1) or (#s + 1)
        
        if byteBefore then
            local before = string.sub(s, 1, byteBefore - 1)
            local after = string.sub(s, byteAfter)
            menuData[field] = before .. after
            _G.cursorPos = pos - 1
        end
    end
end