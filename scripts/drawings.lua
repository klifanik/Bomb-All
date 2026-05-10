local D = {}

function D.draw(mx, my)

    if GAME ~= "game" then love.graphics.draw(background_wall, 0, 0, 0, 0.9, 1) end
 
    if GAME == "game" then 
        for _, i in ipairs(buffs) do
            love.graphics.draw(i.image, i.x, i.y, 0, i.scale, i.scale)
        end
            
        for _, obj in ipairs(objects) do obj.draw(obj) end 
        for _, obj in ipairs(pieces) do obj.draw(obj) end
        
        for _, p in ipairs(Players) do
            if not p.playing and p.death and p.timeAnimDeath > 0 then
                if p.color == "white" then whiteDeathAnimation.anim:draw(whiteDeathAnimation.Image, p.x, p.y, 0, 1)
                elseif p.color == "black" then blackDeathAnimation.anim:draw(blackDeathAnimation.Image, p.x, p.y, 0, 1)
                elseif p.color == "green" then greenDeathAnimation.anim:draw(greenDeathAnimation.Image, p.x, p.y, 0, 1)
                elseif p.color == "red" then redDeathAnimation.anim:draw(redDeathAnimation.Image, p.x, p.y, 0, 1) end
            end
        end
            
        for o, player in ipairs(Players) do
            if player.playing then
                if not player.unbreakable then
                    if player.virus > 0 and player.isRed then
                        love.graphics.setColor(1, 0, 0)
                    else
                        love.graphics.setColor(1, 1, 1)
                    end
                    
                    love.graphics.draw(player.sprite, math.floor(player.x), math.floor(player.y), 0, player.size, player.size)
                    
                    love.graphics.setColor(1, 1, 1) 

                        
                    for _, obj in ipairs(breaks) do 
                        if not obj.isExploded then 
                            love.graphics.draw(obj.image, obj.x, obj.y, 0, obj.scale, obj.scale) 
                        end 
                    end
                    
                    for _, obj in ipairs(blocks) do love.graphics.draw(obj.image, obj.x, obj.y, 0, obj.scale, obj.scale) end
                else
                    for _, obj in ipairs(breaks) do 
                        if not obj.isExploded then 
                                love.graphics.draw(obj.image, obj.x, obj.y, 0, obj.scale, obj.scale) 
                        end 
                    end
                    
                    for _, obj in ipairs(blocks) do love.graphics.draw(obj.image, obj.x, obj.y, 0, obj.scale, obj.scale) end

                        if player.virus > 0 and player.isRed then
                            love.graphics.setColor(1, 0, 0)
                        else
                            love.graphics.setColor(1, 1, 1)
                        end
                    
                        love.graphics.draw(player.sprite, math.floor(player.x), math.floor(player.y), 0, player.size, player.size)
                    
                        love.graphics.setColor(1, 1, 1)
                    end
                end
            end
            
        if hasTouch then
            for _, obj in ipairs(buttons) do
                love.graphics.setColor(1, 1, 1, obj.opacity)
                love.graphics.draw(obj.image, obj.x, obj.y, 0, obj.scale, obj.scale)
            end
        end
            
        love.graphics.setColor(1, 1, 1)
 
    elseif GAME == "gui" then 
        love.graphics.draw(image_play_party, button_play_party.x, button_play_party.y, 0, button_play_party.scale, button_play_party.scale) 
        love.graphics.draw(image_play_local, button_play_local.x, button_play_local.y, 0, button_play_local.scale, button_play_local.scale)

        if checkClick(mx, my, button_play_party) then
            ButtonAnimation.position = 1
        elseif checkClick(mx, my, button_play_local) then
            ButtonAnimation.position = 2
        end

        if ButtonAnimation.position == 1 then ButtonAnimation.anim:draw(ButtonAnimation.Image, button_play_party.x - 12.5, button_play_party.y - 12.5, 0, 4, 4)
        elseif ButtonAnimation.position == 2 then ButtonAnimation.anim:draw(ButtonAnimation.Image, button_play_local.x - 12.5, button_play_local.y - 12.5, 0, 4, 4) end

    elseif GAME == "choose_server" then

        love.graphics.draw(image_create_server, button_play_create.x, button_play_create.y, 0, button_play_create.scale, button_play_create.scale) 
        love.graphics.draw(image_join_server, button_play_join.x, button_play_join.y, 0, button_play_join.scale, button_play_join.scale)

        if checkClick(mx, my, button_play_create) then
            ButtonAnimation.position = 1
        elseif checkClick(mx, my, button_play_join) then
            ButtonAnimation.position = 2
        end

        if ButtonAnimation.position == 1 then ButtonAnimation.anim:draw(ButtonAnimation.Image, button_play_party.x - 55, button_play_party.y + 30, 0, 4.85, 2.5)
        elseif ButtonAnimation.position == 2 then ButtonAnimation.anim:draw(ButtonAnimation.Image, button_play_local.x - 55, button_play_local.y - 25, 0, 4.9, 4.5) end

    elseif GAME == "choose_character" then

        if ReadyPlayers == NumberOfPlayers and NumberOfPlayers > 1 then love.graphics.draw(image_play_game, button_play_game.x, button_play_game.y, 0, button_play_game.scale, button_play_game.scale) end

        local startX = 150
        local spacing = 250
        local yPos = 100

        for i = 1, 4 do
            local p = Players[i]
            local x = startX + (i-1) * spacing

            local charImg = choose_NoPlayer_image
            if p and p.playing then charImg = p.image else charImg = choose_NoPlayer_image end
            love.graphics.draw(charImg, x, yPos, 0, 0.5, 0.5)
            local w = choose_NoPlayer_image:getWidth() * 0.5

            if p and p.playing then
                local ctrlImg = nil
                if p.controller == "keyboard" then ctrlImg = choose_keyboard_image
                elseif p.controller == "gamepad" then ctrlImg = choose_gamepad_image
                elseif p.controller == "touch" then ctrlImg = choose_touch_image 
                elseif p.controller == "none" then ctrlImg = choose_NoPlayer_image end

                local wc = ctrlImg:getWidth() * 0.3
                local wk = choose_notready:getWidth() * 0.2
                YforCTRLIMG = (p.controller == "keyboard") and yPos + 250 or (p.controller == "gamepad") and yPos + 240 or yPos + 220
                
                if ctrlImg then love.graphics.draw(ctrlImg, x + ((w - wc) / 2), YforCTRLIMG, 0, 0.3, 0.3) end

                if i == 1 then love.graphics.draw(choose_P1, x + ((w - wc) / 2), yPos - 80, 0, 0.4, 0.4)
                elseif i == 2 then love.graphics.draw(choose_P2, x + ((w - wc) / 2), yPos - 80, 0, 0.4, 0.4)
                elseif i == 3 then love.graphics.draw(choose_P3, x + ((w - wc) / 2), yPos - 80, 0, 0.4, 0.4)
                elseif i == 4 then love.graphics.draw(choose_P4, x + ((w - wc) / 2), yPos - 80, 0, 0.4, 0.4) end

                local lx, rx, ly, ry = x + ((w - wk) / 2), (x + ((w - wk) / 2)) + 3, yPos + 370, yPos + 430

                if p.ready then
                    love.graphics.draw(choose_ready, rx, ry, 0, 0.2, 0.2)
                    love.graphics.draw(choose_notleave, lx, ly, 0, 0.2, 0.2)
                else
                    love.graphics.draw(choose_notready, rx, ry, 0, 0.2, 0.2)
                    love.graphics.draw(choose_leave, lx, ly, 0, 0.2, 0.2)
                end

                if p.positionButton == 1 then ButtonAnimation.anim:draw(ButtonAnimation.Image, lx - 3, ly - 7, 0, 1.8, 1.8)
                elseif p.positionButton == 2 then ButtonAnimation.anim:draw(ButtonAnimation.Image, rx - 7, ry - 7, 0, 1.8, 1.8)
                end
            end
        end

        for _, p in ipairs(Players) do
            if p.playing and p.controller == "keyboard" and not p.ready then
                if checkClick(mx, my, p.btnReady) then
                    p.positionButton = 2
                elseif checkClick(mx, my, p.btnLeave) then
                    p.positionButton = 1
                end
            end
        end

    elseif GAME == "change_modificator" then

        love.graphics.draw(spriteModificatorRounds, (targetWidth / 2) - (spriteModificatorRounds:getWidth() * 1 / 2), 20)

        local startX = 375
        local spacing = 100
        local yPos = 100

        for i = 1, 5 do
            local x = startX + (i-1) * spacing
            NumbersButtons[i].x = x

            love.graphics.draw(SpriteNumbers[i], NumbersButtons[i].x, NumbersButtons[i].y)
        end

        love.graphics.draw(button_teams.image, button_teams.x, button_teams.y, 0, button_teams.scale)

        if button_teams.active then love.graphics.draw(spriteModificatorTeams, (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2), 300, 0, 0.85) end

        local blue = 0
        local red = 0
        for _, p in ipairs(Players) do if p.team == "blue" and p.playing then blue = blue + 1 end end
        for _, p in ipairs(Players) do if p.team == "red" and p. playing then red = red + 1 end end

        if (red > 0 and blue > 0 and button_teams.active) or not button_teams.active then
            love.graphics.draw(image_play_game, button_play_game.x, button_play_game.y, 0, button_play_game.scale, button_play_game.scale) end

        if button_teams.active then
            local raz = 0
            for _, p in ipairs(Players) do if p.controller ~= "none" then raz = raz + 1 end end

            local startX = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2) + 20
            local stY = 320
            local spacing = 92

            for i = 1, raz do
                local x = startX + (i-1) * spacing
                if Players[i].team == "blue" then stY = 320 elseif Players[i].team == "red" then stY = 465 end

                if i == 1 then love.graphics.draw(spriteDownWhite, x, stY, 0, 0.2) end
                if i == 2 then love.graphics.draw(spriteDownBlack, x, stY, 0, 0.2) end
                if i == 3 then love.graphics.draw(spriteDownGreen, x, stY, 0, 0.2) end
                if i == 4 then love.graphics.draw(spriteDownRed, x, stY, 0, 0.2) end
            end
        end

        if checkClick(mx, my, button_one) then
            NumberAnimation.position = 1
            ButtonAnimation.position = 1
        elseif checkClick(mx, my, button_two) then
            NumberAnimation.position = 2
            ButtonAnimation.position = 1
        elseif checkClick(mx, my, button_three) then
            NumberAnimation.position = 3
            ButtonAnimation.position = 1
        elseif checkClick(mx, my, button_four) then
            NumberAnimation.position = 4
            ButtonAnimation.position = 1
        elseif checkClick(mx, my, button_five) then
            NumberAnimation.position = 5
            ButtonAnimation.position = 1
        elseif checkClick(mx, my, button_teams) then
            ButtonAnimation.position = 2
        elseif checkClick(mx, my, button_play_game) then
            local blue = 0
            local red = 0
            for _, p in ipairs(Players) do if p.team == "blue" and p.playing then blue = blue + 1 end end
            for _, p in ipairs(Players) do if p.team == "red" and p.playing then red = red + 1 end end

            if red > 0 and blue > 0 then
                fade.state = "out"
                ReSpawnPlayers()
                fade.level = "game"
            end
        elseif checkClick(mx, my, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2), y = 300, width = 95, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
            if button_teams.active then
                if ButtonAnimation.position == 3 then
                    NumberAnimation.position = 1
                else
                    ButtonAnimation.position = 3
                    NumberAnimation.position = 1
                end
            end
        elseif checkClick(mx, my, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2) + 95, y = 300, width = 90, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
            if button_teams.active then
                if ButtonAnimation.position == 3 then
                    NumberAnimation.position = 2
                else
                    ButtonAnimation.position = 3
                    NumberAnimation.position = 2
                end
            end
        elseif checkClick(mx, my, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2) + 185, y = 300, width = 95, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
            if button_teams.active then
                if ButtonAnimation.position == 3 then
                    NumberAnimation.position = 3
                else
                    ButtonAnimation.position = 3
                    NumberAnimation.position = 3
                end
            end
        elseif checkClick(mx, my, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2) + 280, y = 300, width = 95, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
            if button_teams.active then
                if ButtonAnimation.position == 3 then
                    NumberAnimation.position = 4
                else
                    ButtonAnimation.position = 3
                    NumberAnimation.position = 4
                end
            end
        end

        if ButtonAnimation.position == 1 then
            if NumberAnimation.position == 1 then NumberAnimation.anim:draw(NumberAnimation.Image, 360, 85, 0, 5, 5) end
            if NumberAnimation.position == 2 then NumberAnimation.anim:draw(NumberAnimation.Image, 460, 85, 0, 5, 5) end
            if NumberAnimation.position == 3 then NumberAnimation.anim:draw(NumberAnimation.Image, 560, 85, 0, 5, 5) end
            if NumberAnimation.position == 4 then NumberAnimation.anim:draw(NumberAnimation.Image, 660, 85, 0, 5, 5) end
            if NumberAnimation.position == 5 then NumberAnimation.anim:draw(NumberAnimation.Image, 760, 85, 0, 5, 5) end
        elseif ButtonAnimation.position == 2 then
            ButtonAnimation.anim:draw(ButtonAnimation.Image, 420, 190, 0, 3.6, 2)
        elseif ButtonAnimation.position == 3 then
            if NumberAnimation.position == 1 then ChosenAnimation.anim:draw(ChosenAnimation.Image, 430, 245, 0, 5, 5) end
            if NumberAnimation.position == 2 then ChosenAnimation.anim:draw(ChosenAnimation.Image, 520, 245, 0, 5, 5) end
            if NumberAnimation.position == 3 then ChosenAnimation.anim:draw(ChosenAnimation.Image, 610, 245, 0, 5, 5) end
            if NumberAnimation.position == 4 then ChosenAnimation.anim:draw(ChosenAnimation.Image, 700, 245, 0, 5, 5) end
        end
        
    elseif GAME == "winners" then

        local startY = 100
        local spacing = 120
        local spacingCup = 64
        local xPos = (targetWidth / 2) - win_white_image:getWidth() / 2
        local startCupX = xPos + 120

        local configs = {win_white_image, win_black_inage, win_green_image, win_red_image}
        local raz = 0
        for _, p in ipairs(Players) do if p.controller ~= "none" then raz = raz + 1 end end

        for i = 1, raz do
            local y = startY + (i-1) * spacing
            love.graphics.draw(configs[i], xPos, y)
        end

        for j, p in ipairs(Players) do
            for i = 1, p.wins do
                local needy = startY + (j-1) * spacing
                local y = needy + (configs[j]:getHeight() / 2) - win_cup_image:getHeight() / 2
                local x = startCupX + (i-1) * spacingCup
                love.graphics.draw(win_cup_image, x, y)
            end
        end
        
    elseif GAME == "SETUP_CREATE" then
        for i, button_textBox in ipairs(BoxesCreate) do
            love.graphics.draw(button_textBox.image, button_textBox.x, button_textBox.y, 0, button_textBox.scale)
            love.graphics.print(button_textBox.name, button_textBox.x + 25, button_textBox.y - 25)

            love.graphics.setColor(0, 0, 0)
            love.graphics.setFont(bigFont)
            
            -- 2. Берем текст конкретно для ЭТОГО бокса
            local text = tostring(menuData[button_textBox.name] or "")
            local fieldWidth = (button_textBox.width * button_textBox.scale) - 18 -- ширина минус отступы
            
            -- 3. ОБНОВЛЯЕМ offsetX прямо здесь!
            local textWidth = bigFont:getWidth(text)
            local offsetX = 0
            if textWidth > fieldWidth then
                offsetX = (textWidth + 10) - fieldWidth
            end

            -- 4. Теперь применяем ножницы (Scissor)
            -- Координаты окна (не забывай про sx, sy если они есть)
            love.graphics.setScissor((button_textBox.x + 10) * sx, button_textBox.y * sy, fieldWidth * sx, 80 * sy)

            -- 5. РИСУЕМ ТЕКСТ (вот тут используем наш свежий offsetX)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(text, (button_textBox.x + 10) - offsetX, button_textBox.y + 20)

            -- 6. РИСУЕМ КУРСОР (тоже с этим же offsetX)
            if InputFocus == button_textBox.name then
                DrawField(button_textBox.x - offsetX, button_textBox.y, text)
            end

            -- 7. ВЫКЛЮЧАЕМ ножницы для этого бокса
            love.graphics.setScissor()

            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(normalFont)
        end

        love.graphics.setColor(1, 0, 0)
        love.graphics.print(NetError, (targetWidth / 2) - (normalFont:getWidth(NetError) / 2), button_play.y - 30)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image_play, button_play.x, button_play.y, 0, button_play.scale)

    elseif GAME == "SETUP_JOIN" then
        for i, button_textBox in ipairs(BoxesJoin) do
            love.graphics.draw(button_textBox.image, button_textBox.x, button_textBox.y, 0, button_textBox.scale)
            love.graphics.print(button_textBox.name, button_textBox.x + 25, button_textBox.y - 25)

            love.graphics.setColor(0, 0, 0)
            love.graphics.setFont(bigFont)
            
            -- 2. Берем текст конкретно для ЭТОГО бокса
            local text = tostring(menuData[button_textBox.name] or "")
            local fieldWidth = (button_textBox.width * button_textBox.scale) - 18 -- ширина минус отступы
            
            -- 3. ОБНОВЛЯЕМ offsetX прямо здесь!
            local textWidth = bigFont:getWidth(text)
            local offsetX = 0
            if textWidth > fieldWidth then
                offsetX = (textWidth + 10) - fieldWidth
            end

            -- 4. Теперь применяем ножницы (Scissor)
            -- Координаты окна (не забывай про sx, sy если они есть)
            love.graphics.setScissor((button_textBox.x + 10) * sx, button_textBox.y * sy, fieldWidth * sx, 80 * sy)

            -- 5. РИСУЕМ ТЕКСТ (вот тут используем наш свежий offsetX)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(text, (button_textBox.x + 10) - offsetX, button_textBox.y + 20)

            -- 6. РИСУЕМ КУРСОР (тоже с этим же offsetX)
            if InputFocus == button_textBox.name then
                DrawField(button_textBox.x - offsetX, button_textBox.y, text)
            end

            -- 7. ВЫКЛЮЧАЕМ ножницы для этого бокса
            love.graphics.setScissor()

            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(normalFont)
        end

        love.graphics.setColor(1, 0, 0)
        love.graphics.print(NetError, (targetWidth / 2) - (normalFont:getWidth(NetError) / 2), button_play.y - 30)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image_play, button_play.x, button_play.y, 0, button_play.scale)
        
    elseif GAME == "WaitForReady" then
        local pCount, pTable = 0, {}
        if myClient then pCount, pTable =  myClient:draw() end

        local t = {}
        for _, p in pairs(pTable) do table.insert(t, p) end

        local startX = 150
        local spacing = 250
        local yPos = 100
        
        for i = 1, 4 do
            local x = startX + (i-1) * spacing
            p = t[i]

            local configsI = {choose_white_image, choose_black_image, choose_green_image, choose_red_image}
            local charImg = choose_NoPlayer_image

            if p then charImg = configsI[i] end
            love.graphics.draw(charImg, x, yPos, 0, 0.5)

            if p then
                local ctrlImg = nil
                if p.controller == "keyboard" then ctrlImg = choose_keyboard_image
                elseif p.controller == "gamepad" then ctrlImg = choose_gamepad_image
                elseif p.controller == "touch" then ctrlImg = choose_touch_image 
                elseif p.controller == "none" then ctrlImg = choose_NoPlayer_image end

                local w = choose_NoPlayer_image:getWidth() * 0.5
                local wk = choose_notready:getWidth() * 0.2
                local wc = ctrlImg:getWidth() * 0.3
                local lx, rx, ly, ry = x + ((w - wk) / 2), x + ((w - wk) / 2), yPos + 370, yPos + 430

                YforCTRLIMG = (p.controller == "keyboard") and yPos + 250 or (p.controller == "gamepad") and yPos + 240 or yPos + 220
                if ctrlImg then love.graphics.draw(ctrlImg, x + ((w - wc) / 2), YforCTRLIMG, 0, 0.3, 0.3) end

                if p.ready then
                    love.graphics.draw(choose_ready, rx, ry, 0, 0.2, 0.2)
                    love.graphics.draw(choose_notleave, lx, ly, 0, 0.2, 0.2)
                else
                    love.graphics.draw(choose_notready, rx, ry, 0, 0.2, 0.2)
                    love.graphics.draw(choose_leave, lx, ly, 0, 0.2, 0.2)
                end

                if p.positionButton == 1 then ButtonAnimation.anim:draw(ButtonAnimation.Image, lx - 3, ly - 7, 0, 1.8, 1.8)
                elseif p.positionButton == 2 then ButtonAnimation.anim:draw(ButtonAnimation.Image, rx - 7, ry - 7, 0, 1.8, 1.8)
                end
            end

            local configsP = {choose_P1, choose_P2, choose_P3, choose_P4}

            if not p then love.graphics.draw(configsP[i], x, yPos - 80, 0, 0.4)
            else love.graphics.setFont(bigFont); love.graphics.print(p.name, x, yPos - 50); love.graphics.setFont(normalFont)
            end
        end
    end

    if myServer then love.graphics.print(myServer.playersCount, 100, 100) end
    love.graphics.setColor(1, 1, 1)
end

return D