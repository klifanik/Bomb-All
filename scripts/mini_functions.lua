init_other = require ("scripts/init/init_other")
init = require ("scripts/init/init")

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

function SpawnBreaks()
    local X1 = 80 
    local Y1 = 0 
    local X2 = 0 
    local Y2 = 80 
    local X3 = 0 
    local Y3 = 80 
 
    for row = 1, 7 do 
        for col = 1, 13 do 
            local spawnBlock = false 
            if row % 2 == 1 then 
                if col % 2 ~= 1 then 
                    spawnBlock = true 
                end 
            else 
                spawnBlock = true 
            end 
            if col == 0 and row == 0 then spawnBlock = false end 
            if spawnBlock then 
                local block = { 
                    x = col * long, 
                    y = row * long, 
                    width = long, 
                    height = long, 
                    image = block_break, 
                    scale = 0.33, 
                    isExploded = false
                } 
                table.insert(breaks, block) 
            end 
        end 
    end 
    for i = 1, 22 do 
        X1 = X1 + long 
        if X1 > long * 12 then 
            Y1 = long * 8 
            X1 = long * 2 
        end 
         
 
        local block = { 
            x = X1, 
            y = Y1, 
            width = long, 
            height = long, 
            image = block_break, 
            scale = 0.33, 
            isExploded = false
        } 
        table.insert(breaks, block) 
    end 
    for i = 1, 10 do 
 
        Y2 = Y2 + long 
        if Y2 > long * 6 then 
            X2 = X2 + long * 14 
            Y2 = long * 2 
        end 
 
        local block = { 
            x = X2, 
            y = Y2, 
            width = long, 
            height = long, 
            image = block_break, 
            scale = 0.33, 
            isExploded = false
        } 
        table.insert(breaks, block) 
    end 
    for col = 0, 6 do 
        for row = 0, 3 do 
            X3 = long + col * (long * 2) 
            Y3 = long + row * (long * 2) 
 
            local hard = { 
            x = X3, 
            y = Y3, 
            width = long, 
            height = long, 
            image = block_hard, 
            scale = 0.33
            } 
            table.insert(blocks, hard) 
        end  
    end
end

function spawnPlayers()
    for i = 1, 4 do
        local targetX = 0
        local targetY = 0
        local COLOR = "white"
        local ColorID = 1
        if i == 2 then targetX = 1120; targetY = 0; COLOR = "black"; ColorID = 2 end
        if i == 3 then targetX = 0; targetY = 640; COLOR = "green"; ColorID = 3 end
        if i == 4 then targetX = 1120; targetY = 640; COLOR = "red"; ColorID = 4 end

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
            Joy = 0,
            idJoy = 0,
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
            team = "blue",
            bot = false,
            positionNumber = ColorID,
            colorId = ColorID,

            aiTimer = 0,
            targetGridX = nil,
            targetGridY = nil,
            idBot = 0
        }

        table.insert(Players, gamer)
    end
end

function ReSpawnPlayers()
    local i1, c1, w1, i2, c2, w2, i3, c3, w3, i4, c4, w4, t1, t2, t3, t4, b1, b2, b3, b4, idb1, idb2, idb3, idb4
    local raz = 0
    for _, p in ipairs(Players) do if p.controller ~= "none" then raz = raz + 1 end end

    for i = 1, raz do
        if i == 1 then i1, j1, c1, w1, t1, b1, idb1 = Players[1].idJoy, Players[1].Joy, Players[1].controller, Players[1].wins, Players[1].team, Players[1].bot, Players[1].idBot end
        if i == 2 then i2, j2, c2, w2, t2, b2, idb2 = Players[2].idJoy, Players[2].Joy, Players[2].controller, Players[2].wins, Players[2].team, Players[2].bot, Players[2].idBot end
        if i == 3 then i3, j3, c3, w3, t3, b3, idb3 = Players[3].idJoy, Players[3].Joy, Players[3].controller, Players[3].wins, Players[3].team, Players[3].bot, Players[3].idBot end
        if i == 4 then i4, j4, c4, w4, t4, b4, idb4 = Players[4].idJoy, Players[4].Joy, Players[4].controller, Players[4].wins, Players[4].team, Players[4].bot, Players[4].idBot end
    end
    
    Players = {}
    
    for i = 1, raz do
        local targetX = 0
        local targetY = 0
        local COLOR = "white"
        local ColorID = 1
        if i == 2 then targetX = 1120; targetY = 0; COLOR = "black"; ColorID = 2 end
        if i == 3 then targetX = 0; targetY = 640; COLOR = "green"; ColorID = 3 end
        if i == 4 then targetX = 1120; targetY = 640; COLOR = "red"; ColorID = 4 end

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
            winner = false,
            positionNumber = ColorID,
            colorId = ColorID,

            aiTimer = 0,
            targetGridX = nil,
            targetGridY = nil,
            idBot = 0
        }

        table.insert(Players, gamer)
    end
    
    NumberOfPlayers = 0
    for i = 1, raz do
        NumberOfPlayers = NumberOfPlayers + 1
        Players[i].playing = true
        if i == 1 then Players[1].Joy, Players[1].idJoy, Players[1].controller, Players[1].wins, Players[1].team, Players[1].bot, Players[1].idBot = j1, i1, c1, w1, t1, b1, idb1 end
        if i == 2 then Players[2].Joy, Players[2].idJoy, Players[2].controller, Players[2].wins, Players[2].team, Players[2].bot, Players[2].idBot = j2, i2, c2, w2, t2, b2, idb2 end
        if i == 3 then Players[3].Joy, Players[3].idJoy, Players[3].controller, Players[3].wins, Players[3].team, Players[3].bot, Players[3].idBot = j3, i3, c3, w3, t3, b3, idb3 end
        if i == 4 then Players[4].Joy, Players[4].idJoy, Players[4].controller, Players[4].wins, Players[4].team, Players[4].bot, Players[4].idBot = j4, i4, c4, w4, t4, b4, idb4 end
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

function SUREEXIT()
    blur.isPaused = false
    fade.state = "out"
    GAME = "transition"
    NumberOfPlayers = 0
    ReadyPlayers = 0
    TimeToExit = 3.0
    ExitFromWinnersTime = 5.0
    ButtonAnimation.position = 1
    blur.isPaused = false
    Players = {}
    objects = {} 
    pieces = {}
    buffs = {}
    breaks = {}
    spawnPlayers()
    SpawnBuffs()
    SpawnBreaks()

    whiteDeathAnimation.anim:gotoFrame(1)
    blackDeathAnimation.anim:gotoFrame(1)
    greenDeathAnimation.anim:gotoFrame(1)
    redDeathAnimation.anim:gotoFrame(1)

    fade.level = "gui"
end
 
function Exit()
    if GAME ~= "gui" and GAME ~= "WaitForReady" and GAME ~= "game" then
        fade.state = "out"
        GAME = "transition"
        NumberOfPlayers = 0
        ReadyPlayers = 0
        TimeToExit = 3.0
        ExitFromWinnersTime = 5.0
        ButtonAnimation.position = 1
        blur.isPaused = false
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
    elseif GAME == "game" then
        if not blur.isPaused then
            blur.capture(DrawGame)
            ButtonAnimation.position = 2
        else
            blur.isPaused = false
            ButtonAnimation.position = 1
        end
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
    WinnerCupY = -80
    objects = {}
    pieces = {}
    buffs = {}
    breaks = {}
    MAP = {
        {0,0,2,2,2,2,2,2,2,2,2,2,2,0,0}, -- 1 строка: Базы игроков чистые, в центре ящики
        {0,1,2,1,2,1,2,1,2,1,2,1,2,1,0}, -- 2 строка: Ящики между серыми блоками
        {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}, -- 3 строка: Полностью забита ящиками
        {2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}, -- 4 строка: Серые блоки и ящики
        {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}, -- 5 строка: Центральная горизонталь
        {2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}, -- 6 строка: Серые блоки и ящики
        {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}, -- 7 строка: Полностью забита ящиками
        {0,1,2,1,2,1,2,1,2,1,2,1,2,1,0}, -- 8 строка: Ящики между серыми блоками
        {0,0,2,2,2,2,2,2,2,2,2,2,2,0,0}  -- 9 строка (нижняя дорожка + углы)
    }
    SpawnBuffs()
    ReSpawnPlayers()
    SpawnBreaks()

    whiteDeathAnimation.anim:gotoFrame(1)
    blackDeathAnimation.anim:gotoFrame(1)
    greenDeathAnimation.anim:gotoFrame(1)
    redDeathAnimation.anim:gotoFrame(1)

    fade.level = "game"
end

--[[function DeathVibration(joystick)
    if joystick and joystick:isVibrationSupported() then
        joystick:setVibration(1, 1, 0.00)
    end
end]]

function getJoystickByID(id)
    local joysticks = love.joystick.getJoysticks()
    for _, joystick in ipairs(joysticks) do
        if joystick:getID() == id then
            return joystick
        end
    end
    return nil
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

    if #alivePlayers > 0 then
        for i = 1, #alivePlayers do
             alivePlayers[i].wins = alivePlayers[i].wins + 1
             alivePlayers[i].winner = true
        end
    end
end

function registerPlayer(controllerType, controllerPl, isBot, num)
    -- Проверяем, не зарегистрирован ли уже этот физический контроллер
    if not isBot then
        for _, p in ipairs(Players) do
            if p.playing and p.controller == controllerType and p.Joy == controllerPl then
                return 
            end
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

    -- Вспомогательная функция для инициализации игрока/бота в слоте
    local function setupPlayer(index, playerObj)
        local x = startX + (index - 1) * spacing
        local w = choose_NoPlayer_image:getWidth() * 0.5
        local wk = choose_notready:getWidth() * 0.2
        local lx, rx, ly, ry = x + ((w - wk) / 2), (x + ((w - wk) / 2)) + 3, yPos + 370, yPos + 430
        
        -- Если перезаписываем существующего игрока, сначала корректируем глобальные счетчики
        if playerObj.playing then
            if playerObj.bot then BOTS = BOTS - 1 end
            if playerObj.ready then ReadyPlayers = ReadyPlayers - 1 end
            NumberOfPlayers = NumberOfPlayers - 1
        end

        playerObj.playing = true
        playerObj.controller = controllerType
        playerObj.Joy = controllerPl
        playerObj.idJoy = (controllerPl and controllerPl:getID()) or 0
        playerObj.image = configs[index]
        playerObj.bot = isBot
        playerObj.positionButton = isBot and 0 or 1
        playerObj.ready = isBot

        if isBot then 
            ReadyPlayers = ReadyPlayers + 1
            BOTS = BOTS + 1 
        end
        
        NumberOfPlayers = NumberOfPlayers + 1
        
        playerObj.btnReady = {x = rx, y = ry, width = choose_notready:getWidth(), height = choose_notready:getHeight(), scale = 0.2}
        playerObj.btnLeave = {x = lx, y = ly, width = choose_leave:getWidth(), height = choose_leave:getHeight(), scale = 0.2}
    end

    -- Вспомогательная функция для полной очистки слота
    local function clearPlayer(playerObj)
        if playerObj.bot then BOTS = BOTS - 1 end
        if playerObj.ready then ReadyPlayers = ReadyPlayers - 1 end

        playerObj.playing = false
        playerObj.controller = "none"
        playerObj.idJoy = 0
        playerObj.Joy = 0
        playerObj.image = choose_NoPlayer_image
        playerObj.bot = false
        playerObj.positionButton = 1
        playerObj.positionNumber = playerObj.colorId
        playerObj.ready = false
        
        NumberOfPlayers = NumberOfPlayers - 1
    end

    -- Логика выбора слота
    if num == 0 then
        -- Ищем первый свободный слот
        for i, p in ipairs(Players) do
            if not p.playing then
                setupPlayer(i, p)
                break
            end
        end
    else
        -- Работаем с конкретным слотом
        local p = Players[num]
        
        if not p.playing then
            -- Слот пустой — создаем игрока/бота
            setupPlayer(num, p)
        else
            -- Слот ЗАНЯТ. Смотрим, кто пришел:
            if isBot and not p.bot then
                -- Если пришел бот, а сидел живой игрок — заменяем игрока на бота в этом же слоте
                setupPlayer(num, p)
            else
                -- Если повторно пришел тот же тип (или живой на живого, или бот на бота) — очищаем слот
                clearPlayer(p)
            end
        end
    end

    -- Синхронизация номеров позиций
    for _, p in ipairs(Players) do 
        p.positionNumber = p.colorId 
    end
end

function PlayerDeathing(player)
    local joystick = getJoystickByID(player.idJoy)
    
    if joystick then
        if joystick:isVibrationSupported() then
            joystick:setVibration(1, 1, 0.2)
        end
    end
end

function KickBomb(i, direction)
    local picun = objects[i]
    picun.kickDirection = direction
    picun.kickSpeed = 560
    picun.isKicking = true
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
        end
        table.remove(buffs, i)
    elseif buf.image == buff_egg_image then
        if not player.isOnDragon then
            player.Dragon = love.math.random(1, 5)
            player.isOnDragon = true
            table.remove(buffs, i)
        end
    end
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
        
    -- Защита: если у бомбы почему-то нет владельца, берем дефолтный радиус 1
    local fireRadius = 1
    if Owner and Owner.FIRE then
        fireRadius = Owner.FIRE
    end

    -- ОЧИСТКА ЦЕНТРАЛЬНОЙ КЛЕТКИ: где лежала сама бомба
    -- Переводим пиксели бомбы в индексы массива map
    local centerGX = math.floor(kuki.x / long) + 1
    local centerGY = math.floor(kuki.y / long) + 1
    if MAP[centerGY] and MAP[centerGY][centerGX] == 2 then
        MAP[centerGY][centerGX] = 0
    end

    -- Спавним центральный кусочек взрыва прямо под бомбой
    SpawnPiece(kuki.x, kuki.y)

    local directions = {
        {dx = 0, dy = -long},
        {dx = 0, dy = long},
        {dx = -long, dy = 0},
        {dx = long, dy = 0}
    }

    for _, dir in ipairs(directions) do
        local step = 0
        while step < fireRadius do
            step = step + 1
            local spawnX = kuki.x + (dir.dx * step)
            local spawnY = kuki.y + (dir.dy * step)
                
            -- 1. Проверка неразрушимых блоков
            local hitHardBlock = false
            for _, b in ipairs(blocks) do
                if math.abs(b.x - spawnX) < 1 and math.abs(b.y - spawnY) < 1 then
                    hitHardBlock = true
                    break
                end
            end
                
            if hitHardBlock then break end
                
            -- Спавним пламя в этой точке
            SpawnPiece(spawnX, spawnY)
                
            -- 2. Проверка разрушаемых блоков
            local hitBreakBlock = false
            for _, b in ipairs(breaks) do
                if not b.isExploded and math.abs(b.x - spawnX) < 1 and math.abs(b.y - spawnY) < 1 then
                    hitBreakBlock = true
                    
                    -- СИНХРОНИЗАЦИЯ С КАРТОЙ БОТА:
                    -- Переводим пиксели взорванного ящика в индексы сетки
                    local bgx = math.floor(spawnX / long) + 1
                    local bgy = math.floor(spawnY / long) + 1

                    if MAP[bgy] and MAP[bgy][bgx] == 2 then
                        -- Проверяем есть ли бафф на этой клетке
                        local hasBuff = false
                        for _, buff in ipairs(buffs) do
                            local fgx = math.floor(buff.x / long) + 1
                            local fgy = math.floor(buff.y / long) + 1
                            if fgx == bgx and fgy == bgy then
                                hasBuff = true
                                break
                            end
                        end
                        MAP[bgy][bgx] = hasBuff and 3 or 0
                    end
                end
            end
            if hitBreakBlock then break end

            -- 3. Проверка баффов/улучшений на пути взрыва
            local hitBuff = false
            for _, b in ipairs(buffs) do
                if not b.isExploded and math.abs(b.x - spawnX) < 1 and math.abs(b.y - spawnY) < 1 then
                    hitBuff = true
                    
                    -- Если взрыв уничтожает бафф, тоже чистим карту на всякий случай
                    local bgx = math.floor(spawnX / long) + 1
                    local bgy = math.floor(spawnY / long) + 1
                    if MAP[bgy] and MAP[bgy][bgx] == 2 then
                        MAP[bgy][bgx] = 0
                    end
                    
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