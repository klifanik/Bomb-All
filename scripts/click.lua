local C = {}

function C.click(x, y, btnCode, isTouch)
    local actionTaken = false
    if btnCode == 1 then
        if GAME == "gui" then
            if checkClick(x, y, button_play_party) then
                if ButtonAnimation.position == 1 then
                    actionTaken = true
                    fade.state = "out"
                    fade.level = "choose_character"
                else
                    ButtonAnimation.position = 1
                end
            elseif checkClick(x, y, button_play_local) then
                if ButtonAnimation.position == 2 then
                    actionTaken = true
                    fade.state = "out"
                    fade.level = "not_work"
                    --fade.level = "choose_server"
                else
                    ButtonAnimation.position = 2
                end
            end
        elseif GAME == "choose_character" then
            local currentInput = isTouch and "touch" or "keyboard"
            
            for i, p in ipairs(Players) do
                if p.playing then
                    if checkClick(x, y, p.btnReady) then
                        if p.controller == currentInput then
                            if p.positionButton == 2 then
                                if p.ready then p.ready = false; ReadyPlayers = ReadyPlayers - 1 else p.ready = true; ReadyPlayers = ReadyPlayers + 1 end
                            else
                                p.positionButton = 2
                            end
                        end
                        actionTaken = true
                        break
                    end
                    if checkClick(x, y, p.btnLeave) and not p.ready then
                        if p.controller == currentInput then
                            if p.positionButton == 1 then
                                p.playing = false
                                p.controller = "none"
                                p.id = 0
                                p.image = choose_NoPlayer_image
                                NumberOfPlayers = NumberOfPlayers - 1
                                if isTouch then hasTouch = false else hasKeyboard = false end
                            else
                                p.positionButton = 1
                            end
                        end
                        actionTaken = true
                        break
                    end
                    if checkClick(x, y, button_play_game) then
                        if ReadyPlayers == NumberOfPlayers and NumberOfPlayers > 1 then
                            fade.state = "out"
                            fade.level = "change_modificator"
                            ButtonAnimation.position = 1
                        end
                    end
                end
            end
            
            if not actionTaken and isTouch then registerPlayer("touch", 0); hasTouch = true end

        --[[elseif GAME == "choose_server" then
            if not actionTaken then
                if checkClick(x, y, button_play_create) then
                    if ButtonAnimation.position == 1 then
                        fade.state = "out"
                        fade.level = "SETUP_CREATE"
                    else
                        ButtonAnimation.position = 1
                    end
                elseif checkClick(x, y, button_play_join) then
                    if ButtonAnimation.position == 2 then
                        fade.state = "out"
                        fade.level = "SETUP_JOIN"
                    else
                        ButtonAnimation.position = 2
                    end
                end
            end
        ]]
        
        elseif GAME == "change_modificator" then
            if not actionTaken then
                if checkClick(x, y, NumbersButtons[1]) then
                    if NumberAnimation.position == 1 then
                        if not NumbersButtons[1].active then
                            for _, i in ipairs(NumbersButtons) do i.active = false end
                            NumbersButtons[1].active = true
                            WINS = 1
                        end
                    else
                        NumberAnimation.position = 1
                        ButtonAnimation.position = 1
                    end
                elseif checkClick(x, y, NumbersButtons[2]) then
                    if NumberAnimation.position == 2 then
                        if not NumbersButtons[2].active then
                            for _, i in ipairs(NumbersButtons) do i.active = false end
                            NumbersButtons[2].active = true
                            WINS = 2
                        end
                    else
                        NumberAnimation.position = 2
                        ButtonAnimation.position = 1
                    end
                elseif checkClick(x, y, NumbersButtons[3]) then
                    if NumberAnimation.position == 3 then
                        if not NumbersButtons[3].active then
                            for _, i in ipairs(NumbersButtons) do i.active = false end
                            NumbersButtons[3].active = true
                            WINS = 3
                        end
                    else
                        NumberAnimation.position = 3
                        ButtonAnimation.position = 1
                    end
                elseif checkClick(x, y, NumbersButtons[4]) then
                    if NumberAnimation.position == 4 then
                        if not NumbersButtons[4].active then
                            for _, i in ipairs(NumbersButtons) do i.active = false end
                            NumbersButtons[4].active = true
                            WINS = 4
                        end
                    else
                        NumberAnimation.position = 4
                        ButtonAnimation.position = 1
                    end
                elseif checkClick(x, y, NumbersButtons[5]) then
                    if NumberAnimation.position == 5 then
                        if not NumbersButtons[5].active then
                            for _, i in ipairs(NumbersButtons) do i.active = false end
                            NumbersButtons[5].active = true
                            WINS = 5
                        end
                    else
                        NumberAnimation.position = 5
                        ButtonAnimation.position = 1
                    end
                elseif checkClick(x, y, button_teams) then
                    if ButtonAnimation.position == 2 then
                        if button_teams.active then
                            button_teams.active = false
                            button_teams.image = spriteModificatorTeamsOff
                        else
                            button_teams.active = true
                            button_teams.image = spriteModificatorTeamsOn
                        end
                    else
                        ButtonAnimation.position = 2
                    end
                elseif checkClick(x, y, button_play_game) then
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
                elseif checkClick(x, y, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2), y = 300, width = 95, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
                    if button_teams.active then
                        if ButtonAnimation.position == 3 then
                            if Players[1] and Players[1].team == "blue" then
                                Players[1].team = "red"
                            else
                                Players[1].team = "blue"
                            end
                            NumberAnimation.position = 1
                        else
                            ButtonAnimation.position = 3
                            NumberAnimation.position = 1
                        end
                    end
                elseif checkClick(x, y, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2) + 95, y = 300, width = 90, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
                    if button_teams.active then
                        if ButtonAnimation.position == 3 then
                            if Players[2] and Players[2].team == "blue" then
                                Players[2].team = "red"
                            else
                                Players[2].team = "blue"
                            end
                            NumberAnimation.position = 2
                        else
                            ButtonAnimation.position = 3
                            NumberAnimation.position = 2
                        end
                    end
                elseif checkClick(x, y, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2) + 185, y = 300, width = 95, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
                    if button_teams.active then
                        if ButtonAnimation.position == 3 then
                            if Players[3] and Players[2].team == "blue" then
                                Players[3].team = "red"
                            else
                                Players[3].team = "blue"
                            end
                            NumberAnimation.position = 3
                        else
                            ButtonAnimation.position = 3
                            NumberAnimation.position = 3
                        end
                    end
                elseif checkClick(x, y, {x = (targetWidth / 2) - ((spriteModificatorTeams:getWidth() * 0.85) / 2) + 280, y = 300, width = 95, height = spriteModificatorTeams:getHeight() * 0.85, scale = 1}) then
                    if button_teams.active then
                        if ButtonAnimation.position == 3 then
                            if Players[4] and Players[2].team == "blue" then
                                Players[4].team = "red"
                            else
                                Players[4].team = "blue"
                            end
                            NumberAnimation.position = 4
                        else
                            ButtonAnimation.position = 3
                            NumberAnimation.position = 4
                        end
                    end
                end
            end
        --[[elseif GAME == "SETUP_CREATE" then
            if checkClick(x, y, button_textBox1) then
                for _, b in ipairs(BoxesCreate) do b.image = image_TextBox end
                button_textBox1.image = image_TextBox_Active
                NetError = ""
                InputFocus = "Nickname"
                cursorPos = utf8.len(menuData[InputFocus] or "")
                love.keyboard.setTextInput(true)
            elseif checkClick(x, y, button_textBox2) then
                for _, b in ipairs(BoxesCreate) do b.image = image_TextBox end
                button_textBox2.image = image_TextBox_Active
                NetError = ""
                InputFocus = "port"
                cursorPos = utf8.len(menuData[InputFocus] or "")
                love.keyboard.setTextInput(true)
            elseif checkClick(x, y, button_textBox3) then
                for _, b in ipairs(BoxesCreate) do b.image = image_TextBox end
                button_textBox3.image = image_TextBox_Active
                NetError = ""
                InputFocus = "password"
                cursorPos = utf8.len(menuData[InputFocus] or "")
                love.keyboard.setTextInput(true)
            elseif not checkClick(x, y, button_textBox1) and not checkClick(x, y, button_textBox2) and not checkClick(x, y, button_textBox3) and not checkClick(x, y, button_play) then
                for _, b in ipairs(BoxesCreate) do b.image = image_TextBox end
                InputFocus = ""
                love.keyboard.setTextInput(false)
            elseif checkClick(x, y, button_play) then

                for _, b in ipairs(BoxesCreate) do b.image = image_TextBox end
                love.keyboard.setTextInput(false)

                local p = tonumber(menuData["port"]) or 12345
                
                if myServer then
                    myServer = nil 
                end

                local s, err = ServerModule.new(p, menuData["password"])
                
                if not s then 
                    NetError = err
                else
                    myServer = s

                if myClient then
                    myClient.udp = nil
                    myClient = nil
                    collectgarbage("collect")
                end

                    package.loaded["scripts/sock"] = nil
                    sock = require "scripts/sock"
                    
                    myClient = ClientModule.new("127.0.0.1", p, menuData["Nickname"], menuData["password"])
                    
                    InputFocus = ""
                    NetError = ""
                    cursorPos = 0
                end

            end
        elseif GAME == "SETUP_JOIN" then
            if checkClick(x, y, button_textBox1) then
                for _, b in ipairs(BoxesJoin) do b.image = image_TextBox end
                button_textBox1.image = image_TextBox_Active
                NetError = ""
                InputFocus = "Nickname"
                cursorPos = utf8.len(menuData[InputFocus] or "")
                love.keyboard.setTextInput(true)
            elseif checkClick(x, y, button_textBox2) then
                for _, b in ipairs(BoxesJoin) do b.image = image_TextBox end
                button_textBox2.image = image_TextBox_Active
                NetError = ""
                InputFocus = "port"
                cursorPos = utf8.len(menuData[InputFocus] or "")
                love.keyboard.setTextInput(true)
            elseif checkClick(x, y, button_textBox3) then
                for _, b in ipairs(BoxesJoin) do b.image = image_TextBox end
                button_textBox3.image = image_TextBox_Active
                NetError = ""
                InputFocus = "password"
                cursorPos = utf8.len(menuData[InputFocus] or "")
                love.keyboard.setTextInput(true)
            elseif checkClick(x, y, button_textBox4) then
                for _, b in ipairs(BoxesJoin) do b.image = image_TextBox end
                button_textBox4.image = image_TextBox_Active
                NetError = ""
                InputFocus = "IP"
                cursorPos = utf8.len(menuData[InputFocus] or "")
                love.keyboard.setTextInput(true)
            elseif not checkClick(x, y, button_textBox1) and not checkClick(x, y, button_textBox2) and not checkClick(x, y, button_textBox3) and not checkClick(x, y, button_textBox4) and not checkClick(x, y, button_play) then
                for _, b in ipairs(BoxesJoin) do b.image = image_TextBox end
                InputFocus = ""
                love.keyboard.setTextInput(false)
            elseif checkClick(x, y, button_play) then

                for _, b in ipairs(BoxesCreate) do b.image = image_TextBox end
                love.keyboard.setTextInput(false)

                local p = tonumber(menuData["port"]) or 12345
                local ip = menuData["IP"]:gsub("%s+", "")

                if myClient then
                    myClient.udp = nil
                    myClient = nil
                    collectgarbage("collect")
                end

                package.loaded["scripts/sock"] = nil
                sock = require "scripts/sock"

                myClient = ClientModule.new(ip, p, menuData["Nickname"], menuData["password"])
                
                InputFocus = ""
                NetError = ""
                cursorPos = 0

            end
        ]]
        end
    end
end

return C