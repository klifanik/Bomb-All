init_other = require ("scripts/init_other")
init = require ("scripts/init")

local U = {}

function U.update(dt)

    if GAME == "game" then
        for o, player in ipairs(Players) do
        
            -- 1. ЛОГИКА РЫВКА
            if player.isDashing then
                -- (Здесь оставляем весь код рывка из предыдущего ответа)
                
                -- Проверка подбора баффов
                for i, buf in ipairs(buffs) do
                    if checkCollision(player, buf) then
                        ApplyBuff(buf, i, player)
                    end
                end

                local dashDirX, dashDirY = 0, 0
                if player.direction == "right" then dashDirX = 1
                elseif player.direction == "left" then dashDirX = -1
                elseif player.direction == "up" then dashDirY = -1
                elseif player.direction == "down" then dashDirY = 1
                end

                local dashSpeed = 800 * dt
                local nextX = player.x + dashDirX * dashSpeed
                local nextY = player.y + dashDirY * dashSpeed

                local hit = false
                local tempRect = { x = nextX, y = nextY, width = player.width, height = player.height }
                
                -- Границы экрана
                if nextX < 5 or nextX > 1135 or nextY < 0 or nextY > 645 then
                    hit = true
                end

                -- Блоки
                if not hit then
                    for _, b in ipairs(blocks) do
                        if checkCollision(tempRect, b) then hit = true break end
                    end
                end
                
                if not hit then
                    for _, b in ipairs(breaks) do
                        if not b.isExploded and checkCollision(tempRect, b) then hit = true break end
                    end
                end

                if not hit then
                    player.x = nextX
                    player.y = nextY
                else
                    player.isDashing = false
                end
            
            else

                if player.playing and not player.unbreakable then
                    local dx, dy = inputSys.getMovement(player)
                    if dx ~= 0 or dy ~= 0 then
                        player.x, player.y = player.x + dx * player.speed, player.y + dy * player.speed
                        player.direction = (dx > 0 and "right") or (dx < 0 and "left") or (dy > 0 and "down") or "up"
                        player.size = (dx ~= 0) and 0.3 or 0.25
                    end
                end

            end
        end
    end

    for i, player in ipairs(Players) do
        if player.x < 5 then player.x = 5 end 
        if player.y < 0 and not player.unbreakable then player.y = 0 end 
        if player.x > 1135 then player.x = 1135 end 
        if player.y > 645 then player.y = 645 end
    end

    for i, player in ipairs(Players) do
        if player.virus ~= 0 then
            -- Создаем переменные, если их еще нет
            player.blinkTimer = (player.blinkTimer or 0) + dt
            local blinkFrequency = 0.15 -- Скорость мигания (в секундах)
            
            -- Переключаем флаг цвета каждые 0.15 сек
            if player.blinkTimer >= blinkFrequency then
                player.blinkTimer = 0
                player.isRed = not player.isRed
            end
            
            -- Логика завершения действия вируса (ваша существующая)
            if player.buba and love.timer.getTime() - player.buba < 30 then
                if player.virus == 2 and player.BOMBS > 0 then
                    local gridX = round(player.x / long) * long
                    local gridY = round(player.y / long) * long
                    local pCenterX = player.x + (player.width * player.size) / 2
                    local pCenterY = player.y + (player.height * player.size) / 2
                    local cellCenterX = gridX + long / 2
                    local cellCenterY = gridY + long / 2
                    local dist = math.sqrt((pCenterX - cellCenterX)^2 + (pCenterY - cellCenterY)^2)

                    if dist < 30 and (gridX ~= player.lastAutoBombX or gridY ~= player.lastAutoBombY) then
                        local oldCnt = #objects
                        Spawning(player)
                        if #objects > oldCnt then
                            player.lastAutoBombX, player.lastAutoBombY = gridX, gridY
                            objects[#objects].isPassable = true -- Не застреваем
                        end
                    end
                end

                for _, p in ipairs(Players) do if checkCollision(player, p) then p.virus = player.virus; p.buba = player.buba end end

                if player.virus == 3 then player.BOMBS = 0 end
                if player.virus == 4 then player.FIRE = 1 end
                if player.virus == 5 then player.speed = 10 end
                if player.virus == 6 then player.speed = 2.5 end
            else
                player.isRed = false -- Сбрасываем цвет
                player.buba = nil
                player.FIRE = player.far
                player.BOMBS = player.bam
                player.speed = 5
                player.lastAutoBombX = -1
                player.lastAutoBombY = -1
                player.virus = 0
            end
        end
    end

    if GAME == "game" then for i, player in ipairs(Players) do chelImage.stop(i, player) end end

    -- 1. СНАЧАЛА ОБНОВЛЯЕМ СТАТУС БОМБ (Вне цикла по игрокам!)
    for _, obj in ipairs(objects) do
        if not obj or obj.isExploded then goto nextBomb end
    
        -- Если бомба еще "мягкая", проверяем, есть ли ХОТЯ БЫ ОДИН игрок на ней
        if obj.isPassable then
            local someoneInside = false
            
            for _, p in ipairs(Players) do
                -- Проверка касания конкретного игрока p и бомбы obj
                if p.x < obj.x + 80 and
                   p.x + 60 > obj.x and -- Твой hbW = 60
                   p.y < obj.y + 80 and
                   p.y + 76 > obj.y then -- Твой hbH = 76
                    someoneInside = true
                    break -- Один нашелся, дальше можно не искать
                end
            end
    
            -- Если мы прошлись по ВСЕМ игрокам и НИКТО не стоит на бомбе
            if not someoneInside then
                obj.isPassable = false -- Только теперь закрываем "дверь"
            end
        end
        ::nextBomb::
    end

    for _, player in ipairs(Players) do
        if player.unbreakable then goto nextPlayer end

        local hbW = 60  -- Твоя ширина (80-15-5)
        local hbH = 76  -- Твоя высота (80-4)
        local size = 80 -- Клетка

        -- 2. Теперь выполняем ФИЗИКУ (выталкивание) для всех объектов
        local obstacleGroups = {
            {list = objects, type = 1}, 
            {list = breaks,  type = 2}, 
            {list = blocks,  type = 3}
        }

        for _, group in ipairs(obstacleGroups) do
            for i, obj in ipairs(group.list) do
                if not obj or obj.isExploded then goto nextObj end

                -- Проверка касания
                local isOverlapping = player.x < obj.x + size and
                                      player.x + hbW > obj.x and
                                      player.y < obj.y + size and
                                      player.y + hbH > obj.y

                -- ВЫТАЛКИВАЕМ, только если объект ТВЕРДЫЙ
                -- (Стены и ящики по умолчанию не имеют поля isPassable, поэтому они всегда твердые)
                if isOverlapping and not obj.isPassable then
                    local distL = (player.x + hbW) - obj.x
                    local distR = (obj.x + size) - player.x
                    local distT = (player.y + hbH) - obj.y
                    local distB = (obj.y + size) - player.y
                    local minD  = math.min(distL, distR, distT, distB)

                    
                    if group.type == 1 and (player.kicking or player.popa) then
                        local kDir = (minD == distL) and "right" or 
                         (minD == distR) and "left" or 
                         (minD == distT) and "down" or "up"
    
                        KickBomb(i, kDir)
                        player.popa = false
                        break
                    end

                    -- Само выталкивание
                    if minD == distL then player.x = obj.x - hbW
                    elseif minD == distR then player.x = obj.x + size
                    elseif minD == distT then player.y = obj.y - hbH
                    else player.y = obj.y + size end

                    -- GRID SNAPPING (Подруливание)
                    -- Чтобы не застревать между двумя бомбами в узком проходе
                    local edgeMargin = 30
                    local slideSpeed = 160 * dt
                    if (player.direction == "up" or player.direction == "down") then
                        if distL > 0 and distL < edgeMargin then player.x = player.x - slideSpeed
                        elseif distR > 0 and distR < edgeMargin then player.x = player.x + slideSpeed end
                    elseif (player.direction == "left" or player.direction == "right") then
                        if distT > 0 and distT < edgeMargin then player.y = player.y - slideSpeed
                        elseif distB > 0 and distB < edgeMargin then player.y = player.y + slideSpeed end
                    end
                end
                ::nextObj::
            end
        end
        ::nextPlayer::
    end


    for _, obj in ipairs(objects) do
        if obj.isKicking and obj.kickDirection then
            -- Вычисляем сдвиг за этот кадр
            local dx, dy = 0, 0
            local speed = obj.kickSpeed * dt  -- пикселей за этот кадр
            local hitBlock = false

            if obj.kickDirection == "right" then dx = speed
            elseif obj.kickDirection == "left" then dx = -speed
            elseif obj.kickDirection == "down" then dy = speed
            elseif obj.kickDirection == "up" then dy = -speed
            end

            -- Новая позиция
            local newX = obj.x + dx
            local newY = obj.y + dy

            if obj.LifeBomb <= 0.1 then
                hitBlock = true
                obj.x = round(obj.x / 80) * 80
                obj.y = round(obj.y / 80) * 80
                break
            end

            -- Проверка границ экрана
            if newX < 0 or newX > 1120 or newY < 0 or newY > 640 then
                hitBlock = true
                obj.x = round(obj.x / 80) * 80
                obj.y = round(obj.y / 80) * 80
                break
            end

            -- Проверка столкновений (аналогично вашему коду)
            local hitBlock = false
            for _, blk in ipairs(blocks) do
                if checkCollision({x = newX, y = newY, width = long, height = long}, blk) then
                    hitBlock = true
                    obj.x = round(obj.x / 80) * 80
                    obj.y = round(obj.y / 80) * 80
                    break
                end
            end
            if not hitBlock then
                for _, brk in ipairs(breaks) do
                    if not brk.isExploded and checkCollision({x = newX, y = newY, width = long, height = long}, brk) then
                        hitBlock = true
                        obj.x = round(obj.x / 80) * 80
                        obj.y = round(obj.y / 80) * 80
                        break
                    end
                end
            end
            if not hitBlock then
                for _, otherObj in ipairs(objects) do
                    if not otherObj.isExploded and otherObj ~= obj and checkCollision({x = newX, y = newY, width = long, height = long}, otherObj) then
                        hitBlock = true
                        obj.x = round(obj.x / 80) * 80
                        obj.y = round(obj.y / 80) * 80
                        break
                    end
                end
            end

            -- Если нет препятствий — двигаем бомбу
            if not hitBlock then
                obj.x = newX
                obj.y = newY
            else
                -- Столкновение — останавливаем
                obj.x = round(obj.x / 80) * 80
                obj.y = round(obj.y / 80) * 80
                obj.isKicking = false
                obj.kickDirection = nil
            end
        end
    end

    for _, brk in ipairs(breaks) do
        if brk.isKicking and not brk.isExploded then
            local speed = 600 * dt -- фиксированная скорость
            local dx, dy = 0, 0
            if brk.kickDirection == "right" then dx = speed
            elseif brk.kickDirection == "left" then dx = -speed
            elseif brk.kickDirection == "down" then dy = speed
            elseif brk.kickDirection == "up" then dy = -speed end

            local nextX, nextY = brk.x + dx, brk.y + dy

            -- Проверка границ экрана (с учетом размера блока 80)
            local outOfBounds = nextX < 0 or nextX > 1120 or nextY < 0 or nextY > 640
            
            -- Проверка столкновений
            local hit = false
            local tempRect = {x = nextX + 2, y = nextY + 2, width = 76, height = 76} -- чуть меньше блока для мягкости
            
            for _, b in ipairs(blocks) do
                if checkCollision(tempRect, b) then hit = true break end
            end
            if not hit then
                for _, b in ipairs(breaks) do
                    if b ~= brk and not b.isExploded and checkCollision(tempRect, b) then hit = true break end
                end
            end

            if not hit and not outOfBounds then
                brk.x, brk.y = nextX, nextY
            else
                -- ОСТАНОВКА И ВЫРАВНИВАНИЕ ПО СЕТКЕ 80x80
                brk.isKicking = false
                brk.x = math.floor((brk.x + 40) / 80) * 80
                brk.y = math.floor((brk.y + 40) / 80) * 80
            end
        end
    end

    for i, player in ipairs(Players) do
        for _, piece in ipairs(pieces) do
            if checkCollision(player, piece) and not player.unbreakable then 
                if player.isOnDragon then
                    player.isOnDragon = false
                    player.unbreakable = true
                    jumpTimer = 0
                    jumpBaseY = player.y
                else
                    if not player.unbreakable and player.playing then
                        NumberOfPlayers = NumberOfPlayers - 1
                        player.playing = false
                        player.death = true
                    end
                end
                break
            end 
        end
    end

    for i, player in ipairs(Players) do
        for _, piece in ipairs(objects) do
            if piece.isExploded then
                if checkCollision(player, piece) and not player.unbreakable then 
                    if player.isOnDragon then
                        player.isOnDragon = false
                        player.unbreakable = true
                        jumpTimer = 0
                        jumpBaseY = player.y
                    else
                        if not player.unbreakable and player.playing then
                            NumberOfPlayers = NumberOfPlayers - 1
                            player.playing = false
                            player.death = true
                        end
                    end
                    break
                end 
            end
        end
    end

    for _, p in ipairs(Players) do
        if not p.playing and p.death then
            if p.timeAnimDeath > 0 then
                p.timeAnimDeath = p.timeAnimDeath - dt
                whiteDeathAnimation.anim:update(dt)
                blackDeathAnimation.anim:update(dt)
                greenDeathAnimation.anim:update(dt)
                redDeathAnimation.anim:update(dt)
            else
                p.death = false
                whiteDeathAnimation.anim:gotoFrame(1)
                blackDeathAnimation.anim:gotoFrame(1)
                greenDeathAnimation.anim:gotoFrame(1)
                redDeathAnimation.anim:gotoFrame(1)
            end
        end
    end
    
    if NumberOfPlayers < 2 and GAME == "game" and not button_teams.active then
        if TimeToExit > 0 then
            TimeToExit = TimeToExit - dt
        else
            whiteDeathAnimation.anim:gotoFrame(1)
            blackDeathAnimation.anim:gotoFrame(1)
            greenDeathAnimation.anim:gotoFrame(1)
            redDeathAnimation.anim:gotoFrame(1)

            if fade.state == "idle" then
                fade.state = "out"
                TimeToExit = 3.0
                RewardLastSurvivor()
                fade.level = "winners"
            end
        end
    elseif button_teams.active and GAME == "game" then
        local blue = 0
        local red = 0
        for _, p in ipairs(Players) do if p.playing and p.team == "blue" then blue = blue + 1 end end
        for _, p in ipairs(Players) do if p.playing and p.team == "red" then red = red + 1 end end 
            
        if red == 0 or blue == 0 then
            if TimeToExit > 0 then
                TimeToExit = TimeToExit - dt
            else
                whiteDeathAnimation.anim:gotoFrame(1)
                blackDeathAnimation.anim:gotoFrame(1)
                greenDeathAnimation.anim:gotoFrame(1)
                redDeathAnimation.anim:gotoFrame(1)
    
                if fade.state == "idle" then
                    fade.state = "out"
                    TimeToExit = 3.0
                    RewardLastSurvivor()
                    fade.level = "winners"
                end
            end
        end
    end

    if fade.state == "out" then
        fade.alpha = fade.alpha + fade.speed * dt
        if fade.alpha >= 1 then
            fade.alpha = 1
            GAME = fade.level
            fade.level = "none"            
            fade.state = "in"
        end
    elseif fade.state == "in" then
        fade.alpha = fade.alpha - fade.speed * dt
        if fade.alpha <= 0 then
            fade.alpha = 0
            fade.state = "idle"
        end
    end

    if GAME == "winners" then
        if ExitFromWinnersTime > 0 then
            ExitFromWinnersTime = ExitFromWinnersTime - dt
        else
            if isGameOver() then
                Exit()
            else
                RetryGame()
            end
        end
    end

    for i, player in ipairs(Players) do
        if player.unbreakable then
            local jumpDuration = 1
            local jumpHeight = 80
            
            jumpTimer = jumpTimer + dt
            local t = jumpTimer / jumpDuration

            if t <= 0.5 and not player.isOnDragon then
                if player.direction == "left" then
                    player.size = 0.3
                    if player.color == "white" then player.sprite = spriteLeftWhite end
                    if player.color == "black" then player.sprite = spriteLeftBlack end
                    if player.color == "green" then player.sprite = spriteLeftGreen end
                    if player.color == "red" then player.sprite = spriteLeftRed end
                elseif player.direction == "right" then
                    player.size = 0.3
                    if player.color == "white" then player.sprite = spriteRightWhite end
                    if player.color == "black" then player.sprite = spriteRightBlack end
                    if player.color == "green" then player.sprite = spriteRightGreen end
                    if player.color == "red" then player.sprite = spriteRightRed end
                elseif player.direction == "up" then
                    player.size = 0.25
                    if player.color == "white" then player.sprite = spriteUpWhite end
                    if player.color == "black" then player.sprite = spriteUpBlack end
                    if player.color == "green" then player.sprite = spriteUpGreen end
                    if player.color == "red" then player.sprite = spriteUpRed end
                elseif player.direction == "down" then
                    player.size = 0.25
                    if player.color == "white" then player.sprite = spriteDownWhite end
                    if player.color == "black" then player.sprite = spriteDownBlack end
                    if player.color == "green" then player.sprite = spriteDownGreen end
                    if player.color == "red" then player.sprite = spriteDownRed end
                end
            end
            
            if t <= 1 then
                local offset = 4 * jumpHeight * t * (1 - t)
                player.y = jumpBaseY - offset
            else
                player.y = jumpBaseY
                player.unbreakable = false
                jumpTimer = 0
            end
        end
    end

    cursorTimer = cursorTimer + dt
    if cursorTimer > 0.5 then
        cursorTimer = 0
        showCursor = not showCursor
    end

    if love.keyboard.isDown("backspace") then
        _G.backspaceTimer = _G.backspaceTimer + dt
        
        -- Если кнопка зажата дольше, чем 0.5 сек
        if _G.backspaceTimer > _G.backspaceDelay then
            _G.backspaceRepeatTimer = _G.backspaceRepeatTimer + dt
            
            -- Удаляем символ каждые 0.05 сек
            if _G.backspaceRepeatTimer > _G.backspaceInterval then
                handleBackspace() -- Вызываем функцию удаления
                _G.backspaceRepeatTimer = 0
            end
        end
    else
        -- Сбрасываем таймеры, когда кнопка отпущена
        _G.backspaceTimer = 0
        _G.backspaceRepeatTimer = 0
    end

    if GAME == "SETUP_CREATE" then button_textBox1.y = 120; button_textBox2.y = 240; button_textBox3.y = 360 end
    if GAME == "SETUP_JOIN" then button_textBox1.y = 60; button_textBox2.y = 180; button_textBox3.y = 300 end
    
    if GAME == "SETUP_JOIN" then button_play.y = 540 elseif GAME == "SETUP_CREATE" then button_play.y = 480 end
    
    for i, n in ipairs(NumbersButtons) do if n.active then SpriteNumbers[i] = spriteNumbersYes[i] else SpriteNumbers[i] = spriteNumbersNo[i] end end
    
    for j, player in ipairs(Players) do
        for i, buf in ipairs(buffs) do
            if checkCollision(player, buf) and not player.unbreakable then
                ApplyBuff(buf, i, player)
            end
        end
    end

    for a, piece in ipairs(pieces) do
        for b = #objects, 1, -1 do
            local obj = objects[b]
            if not obj.isExploded then
                if checkCollision(obj, piece) then
                    obj.isExploded = true
                    if obj.owner then
                        obj.owner.BOMBS = obj.owner.BOMBS + 1
                    end
                    BOOMING(b)
                    table.remove(objects, b)
                end
            end
        end
    end

    for i = #buffs, 1, -1 do
        local b = buffs[i]
        local hitByFire = false

        for _, piece in ipairs(pieces) do
            if checkCollision(b, piece) then
                hitByFire = true
                break 
            end
        end

        if hitByFire then
            local covered = false
            for _, brk in ipairs(breaks) do
                if brk.x == b.x and brk.y == b.y and not brk.isExploded then
                    covered = true
                    break
                end
            end

            if not covered then
                b.buba = b.buba - dt
                if b.buba <= 0 then
                    table.remove(buffs, i)
                end
            end
        end
    end

    for _, block in ipairs(breaks) do 
        for _, piece in ipairs(pieces) do 
            if checkCollision(block, piece) then block.isExploded = true break end 
        end 
    end 
 
    for i = #objects, 1, -1 do
        local obj = objects[i]
        if not obj.isExploded then
            obj.LifeBomb = obj.LifeBomb - dt
            if obj.LifeBomb <= 0 then
                if obj.owner then obj.owner.BOMBS = obj.owner.BOMBS + 1 end
                obj.scale = 0.32
                obj.image = boom
                BOOMING(i)
                obj.isExploded = true
            end
        else
            obj.LifeFire = obj.LifeFire - dt
            if obj.LifeFire <= 0 then
                table.remove(objects, i)
            end
        end
    end
    
    for i = #pieces, 1, -1 do
        local p = pieces[i]
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(pieces, i)
        end
    end
end

return U