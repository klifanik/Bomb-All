local M = {}

-- 1. ЛОГИКА ДВИЖЕНИЯ (для love.update)
function M.getMovement(player)
    local dx, dy = 0, 0
    local deadzone = 0.25

    if player then
        if not player.unbreakable then
            if player.controller == "keyboard" then
                if love.keyboard.isDown("right", "d") then dx = 1
                elseif love.keyboard.isDown("left", "a") then dx = -1
                elseif love.keyboard.isDown("up", "w") then dy = -1
                elseif love.keyboard.isDown("down", "s") then dy = 1 end
            elseif player.controller == "touch" then
                for _, btn in ipairs(buttons) do
                    if btn.isTouch then
                        if btn == BUTTON_RIGHT then dx = 1
                        elseif btn == BUTTON_LEFT then dx = -1
                        elseif btn == BUTTON_UP then dy = -1
                        elseif btn == BUTTON_DOWN then dy = 1 end
                    end
                end
            elseif player.controller == "gamepad" then
                for _, gp in ipairs(joysticks) do
                    if player.id == gp then
                        local ax, ay = gp:getAxis(1), gp:getAxis(2)
                        if gp:isGamepadDown("dpright") or ax > deadzone then dx = 1
                        elseif gp:isGamepadDown("dpleft") or ax < -deadzone then dx = -1
                        elseif gp:isGamepadDown("dpup") or ay < -deadzone then dy = -1
                        elseif gp:isGamepadDown("dpdown") or ay > deadzone then dy = 1 end
                    end
                end
            end
        end

        if player.virus == 1 then dx, dy = -dx, -dy end
    end

    return dx, dy
end

-- 2. ДЕЙСТВИЯ (Бомбы и Драконы)
function M.performAction(actionType, player)
    local kbPlayer = player

    if not player.unbreakable and not player.isDashing then
        if actionType == "bomb" then
            if player.BOMBS <= 0 then return end
            local cur = love.timer.getTime()
            Spawning(player) -- Твоя функция
            if cur - (player.lastActionTime or 0) < 0.3 and player.lining then
                local adx, ady = 0, 0
                if player.direction == "up" then ady = -long
                elseif player.direction == "down" then ady = long
                elseif player.direction == "left" then adx = -long
                elseif player.direction == "right" then adx = long end
                local nx = math.floor(player.x / long + 0.5) * long + adx
                local ny = math.floor(player.y / long + 0.5) * long + ady
                while player.BOMBS > 0 do
                    if nx < 0 or nx > 1135 or ny < 0 or ny > 645 then break end
                    local hit = false
                    for _, b in ipairs(blocks) do if math.abs(b.x-nx)<1 and math.abs(b.y-ny)<1 then hit=true break end end
                    for _, b in ipairs(breaks) do if not b.isExploded and math.abs(b.x-nx)<1 and math.abs(b.y-ny)<1 then hit=true break end end
                    for _, o in ipairs(objects) do if not o.isExploded and math.abs(o.x-nx)<1 and math.abs(o.y-ny)<1 then hit=true break end end
                    if hit then break end
                    player.BOMBS = player.BOMBS - 1
                    table.insert(objects, {x=nx, y=ny, width = long, height = long, image=bomb, scale=0.22, isExploded=false, oppo=cur, owner = kbPlayer,
                    LifeBomb = 3, LifeFire = 1, isPassable = true, draw=function(s) love.graphics.draw(s.image,s.x,s.y,0,s.scale,s.scale) end})
                    nx, ny = nx + adx, ny + ady
                end
                player.lastActionTime = 0
            else player.lastActionTime = cur end

        elseif actionType == "special" then
            if not player.isOnDragon or player.isDashing or player.unbreakable then return end
            if player.Dragon == 1 then player.isDashing = true -- Рывок
            elseif player.Dragon == 2 then
                local size = 80 
                local reach = 15 
                
                -- Точка удара перед лицом игрока
                local checkX, checkY = player.x + 30, player.y + 38 
                local dir = player.direction

                if dir == "right" then checkX = player.x + 60 + reach 
                elseif dir == "left" then checkX = player.x - reach 
                elseif dir == "up" then checkY = player.y - reach 
                elseif dir == "down" then checkY = player.y + 76 + reach end

                -- 1. Ищем блок, в который непосредственно уперся игрок
                for i, firstObj in ipairs(breaks) do
                    if not firstObj.isExploded then
                        if checkX > firstObj.x and checkX < firstObj.x + size and
                        checkY > firstObj.y and checkY < firstObj.y + size then
                            
                            -- 2. Ищем самый дальний блок в этом ряду
                            local lastBlock = firstObj
                            local searching = true
                            
                            while searching do
                                local nX, nY = lastBlock.x, lastBlock.y
                                if dir == "right" then nX = nX + size
                                elseif dir == "left" then nX = nX - size
                                elseif dir == "up" then nY = nY - size
                                elseif dir == "down" then nY = nY + size end
                                                                                
                                local foundNext = false
                                for _, nextBrk in ipairs(breaks) do
                                    if not nextBrk.isExploded and 
                                    math.abs(nextBrk.x - nX) < 5 and 
                                    math.abs(nextBrk.y - nY) < 5 then
                                        lastBlock = nextBrk -- Нашли следующий, теперь проверяем от него
                                        foundNext = true
                                        break
                                    end
                                end
                                if not foundNext then searching = false end
                            end

                            -- 3. Проверяем, есть ли куда лететь этому ПОСЛЕДНЕМУ блоку
                            if not lastBlock.isKicking then
                                local targetX, targetY = lastBlock.x, lastBlock.y
                                if dir == "right" then targetX = targetX + size
                                elseif dir == "left" then targetX = targetX - size
                                elseif dir == "up" then targetY = targetY - size
                                elseif dir == "down" then targetY = targetY + size end
                                                                            
                                local canMove = targetX >= 0 and targetX <= 1120 and targetY >= 0 and targetY <= 640
                                
                                -- Проверка на препятствия (стены) для последнего блока
                                if canMove then
                                    for _, b in ipairs(blocks) do
                                        if math.abs(b.x - targetX) < 5 and math.abs(b.y - targetY) < 5 then
                                            canMove = false
                                            break
                                        end
                                    end
                                end

                                -- Если место свободно, запускаем ТОЛЬКО этот последний блок
                                if canMove then
                                    lastBlock.isKicking = true
                                    lastBlock.kickDirection = dir
                                    player.kicking = false 
                                end
                            end
                            
                            break -- Нашли первый блок, определили последний и закончили
                        end
                    end
                end
            elseif player.Dragon == 3 then player.popa = true
            elseif player.Dragon == 4 then
                if not player.unbreakable then player.unbreakable = true; jumpTimer = 0; jumpBaseY = player.y end
            end
        end
    end
end

function M.ControlGui(player, joystick, btn, Typecntrl)
    if GAME == "gui" then
        if (Typecntrl == "keyboard" and btn == "down" or btn == "s" or btn == "up" or btn == "w") or
        (Typecntrl == "gamepad" and btn == "dpdown" or btn == "dpup") then

            ButtonAnimation.position = (ButtonAnimation.position == 1) and 2 or 1

        elseif (Typecntrl == "keyboard" and btn == "kpenter" or btn == "return" or btn == "space") or
        (Typecntrl == "gamepad" and btn == "start" or btn == "a") then

            if ButtonAnimation.position == 1 then
                fade.state = "out"
                fade.level = "choose_character"
            elseif ButtonAnimation.position == 2 then
                fade.state = "out"
                fade.level = "not_work"
                --fade.level = "choose_server"
            end

        end
    --[[elseif GAME == "choose_server" then
        if (Typecntrl == "keyboard" and btn == "down" or btn == "s" or btn == "up" or btn == "w") or
        (Typecntrl == "gamepad" and btn == "dpdown" or btn == "dpup") then

            ButtonAnimation.position = (ButtonAnimation.position == 1) and 2 or 1

        elseif (Typecntrl == "keyboard" and btn == "kpenter" or btn == "return" or btn == "space") or
        (Typecntrl == "gamepad" and btn == "start" or btn == "a") then

            if ButtonAnimation.position == 1 then
                fade.state = "out"
                fade.level = "SETUP_CREATE"
            elseif ButtonAnimation.position == 2 then
                fade.state = "out"
                fade.level = "SETUP_JOIN"
            end

        end
    ]]
    elseif GAME == "choose_character" then
        if player.playing then
            if not player.ready then
                if (player.controller == "keyboard" and (btn == "down" or btn == "s" or btn == "up" or btn == "w")) or
                   (player.controller == "gamepad" and (btn == "dpdown" or btn == "dpup")) then
                    player.positionButton = (player.positionButton == 1) and 2 or 1
                end
            end

            if (player.controller == "keyboard" and (btn == "return" or btn == "kpenter")) or
               (player.controller == "gamepad" and btn == "a") then
                if player.positionButton == 1 then
                    player.playing = false
                    player.controller = "none"
                    player.id = 0
                    player.image = choose_NoPlayer_image
                    NumberOfPlayers = NumberOfPlayers - 1
                    if player.controller == "keyboard" then hasKeyboard = false else hasGamepad = false end
                elseif player.positionButton == 2 then
                    if not player.ready then
                        player.ready = true
                        ReadyPlayers = ReadyPlayers + 1
                    else
                        player.ready = false
                        ReadyPlayers = ReadyPlayers - 1
                    end
                end
            end

            if (player.controller == "keyboard" and btn == "space") or
               (player.controller == "gamepad" and btn == "start") then
                if NumberOfPlayers == ReadyPlayers and NumberOfPlayers > 1 then
                    fade.state = "out"
                    fade.level = "change_modificator"
                    ButtonAnimation.position = 1
                end
            end
        end
    elseif GAME == "change_modificator" then
        if ButtonAnimation.position == 1 then
            if (Typecntrl == "keyboard" and (btn == "down" or btn == "s")) or
            (Typecntrl == "gamepad" and btn == "dpdown") then ButtonAnimation.position = 2 end

            if (Typecntrl == "keyboard" and ((btn == "right" or btn == "d"))) or
            (Typecntrl == "gamepad" and btn == "dpright") then if NumberAnimation.position ~= 5 then NumberAnimation.position = NumberAnimation.position + 1 end end

            if (Typecntrl == "keyboard" and ((btn == "left" or btn == "a"))) or
            (Typecntrl == "gamepad" and btn == "dpleft") then if NumberAnimation.position ~= 1 then NumberAnimation.position = NumberAnimation.position - 1 end end

            if (Typecntrl == "keyboard" and ((btn == "return" or btn == "kpenter"))) or
            (Typecntrl == "gamepad" and btn == "a") then
                if NumberAnimation.position == 1 then for _, i in ipairs(NumbersButtons) do i.active = false end; button_one.active = true end
                if NumberAnimation.position == 2 then for _, i in ipairs(NumbersButtons) do i.active = false end; button_two.active = true end
                if NumberAnimation.position == 3 then for _, i in ipairs(NumbersButtons) do i.active = false end; button_three.active = true end
                if NumberAnimation.position == 4 then for _, i in ipairs(NumbersButtons) do i.active = false end; button_four.active = true end
                if NumberAnimation.position == 5 then for _, i in ipairs(NumbersButtons) do i.active = false end; button_five.active = true end
            end
        elseif ButtonAnimation.position == 2 then
            if (Typecntrl == "keyboard" and (btn == "up" or btn == "w")) or
            (Typecntrl == "gamepad" and btn == "dpup") then ButtonAnimation.position = 1 end

            if button_teams.active then
                if (Typecntrl == "keyboard" and (btn == "down" or btn == "s")) or
                (Typecntrl == "gamepad" and btn == "dpdown") then ButtonAnimation.position = 3 end
            end

            if (Typecntrl == "keyboard" and (btn == "return" or btn == "kpenter")) or
            (Typecntrl == "gamepad" and btn == "a") then
                if button_teams.active then
                    button_teams.active = false
                    button_teams.image = spriteModificatorTeamsOff
                else
                    button_teams.active = true
                    button_teams.image = spriteModificatorTeamsOn
                end
            end
        elseif ButtonAnimation.position == 3 then
            if (Typecntrl == "keyboard" and (btn == "up" or btn == "w")) or
            (Typecntrl == "gamepad" and btn == "dpup") then
                if Players[NumberAnimation.position] and Players[NumberAnimation.position].team == "red" then
                    Players[NumberAnimation.position].team = "blue"
                else
                    ButtonAnimation.position = 2
                end
            end

            if (Typecntrl == "keyboard" and (btn == "down" or btn == "s")) or
            (Typecntrl == "gamepad" and btn == "dpdown") then
                if Players[NumberAnimation.position] and Players[NumberAnimation.position].team == "blue" then
                    Players[NumberAnimation.position].team = "red"
                end
            end
            
            if (Typecntrl == "keyboard" and (btn == "return" or btn == "kpenter")) or
            (Typecntrl == "gamepad" and btn == "a") then
                if Players[NumberAnimation.position] and Players[NumberAnimation.position].team == "blue" then
                    Players[NumberAnimation.position].team = "red"
                else
                    Players[NumberAnimation.position].team = "blue"
                end
            end

            local raz = 0
            for _, p in ipairs(Players) do if p.controller ~= "none" then raz = raz + 1 end end

            if (Typecntrl == "keyboard" and ((btn == "right" or btn == "d"))) or
            (Typecntrl == "gamepad" and btn == "dpright") then if NumberAnimation.position < raz then NumberAnimation.position = NumberAnimation.position + 1 end end

            if (Typecntrl == "keyboard" and ((btn == "left" or btn == "a"))) or
            (Typecntrl == "gamepad" and btn == "dpleft") then if NumberAnimation.position ~= 1 then NumberAnimation.position = NumberAnimation.position - 1 end end
        end

        if player.playing then
            if (player.controller == "keyboard" and btn == "space") or
            (player.controller == "gamepad" and btn == "start") then
                
                local blue = 0
                local red = 0
                local totalPlaying = 0

                for _, p in ipairs(Players) do 
                    if p.playing then 
                        totalPlaying = totalPlaying + 1
                        
                        if p.team == "blue" then 
                            blue = blue + 1 
                        elseif p.team == "red" then 
                            red = red + 1 
                        end 
                    end 
                end

                if button_teams.active then
                    if red > 0 and blue > 0 then
                        fade.state = "out"
                        ReSpawnPlayers()
                        fade.level = "game"
                    end
                else
                    if totalPlaying >= 2 then
                        fade.state = "out"
                        ReSpawnPlayers()
                        fade.level = "game"
                    end
                end
            end
        end
    elseif GAME == "WaitForReady" then
        
    end
end

return M