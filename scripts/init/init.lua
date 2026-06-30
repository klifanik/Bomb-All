function initializationSprites()
    -- 1. АВТОМАТИЗАЦИЯ ЧЕЛОВЕЧКОВ И ДРАКОНОВ
    local colors = {"White", "Black", "Green", "Red"}
    local directions = {"down", "up", "left", "right"}
    local dragons = {"Blue", "Yellow", "Green", "Purple", "Pink"}

    for _, color in ipairs(colors) do
        -- Базовые направления (например: spriteDownWhite)
        for _, dir in ipairs(directions) do
            -- Делаем первую букву направления заглавной для правильного имени переменной (down -> Down)
            local dirCap = dir:sub(1,1):upper() .. dir:sub(2)
            local varName = "sprite" .. dirCap .. color
            local folderColor = color:lower()
            
            _G[varName] = love.graphics.newImage("sprites/man_" .. folderColor .. "/" .. dir .. ".png")
        end
        
        -- Спрайты драконов (например: spriteBlueDragonLeftBlack)
        for _, dragon in ipairs(dragons) do
            for _, dir in ipairs(directions) do
                local varName = "sprite" .. dragon .. "Dragon" .. dir:sub(1,1):upper() .. dir:sub(2) .. color
                local folderColor = color:lower()
                local fileName = dragon:lower() .. "_" .. dir
                
                _G[varName] = love.graphics.newImage("sprites/man_" .. folderColor .. "/" .. fileName .. ".png")
            end
        end
    end

    -- 2. КНОПКИ УПРАВЛЕНИЯ
    for _, dir in ipairs(directions) do _G["sprite_button_" .. dir] = love.graphics.newImage("sprites/buttons/" .. dir .. ".png") end
    sprite_button_A = love.graphics.newImage("sprites/buttons/A.png")
    sprite_button_B = love.graphics.newImage("sprites/buttons/B.png")
 
    -- 3. БОМБЫ И БЛОКИ
    bomb = love.graphics.newImage("sprites/bomb/boombox.png") 
    boom = love.graphics.newImage("sprites/bomb/boom.png") 
    block_break = love.graphics.newImage("sprites/blocks/break.png") 
    block_hard = love.graphics.newImage("sprites/blocks/hard.png") 
 
    -- 4. GUI И ИНТЕРФЕЙС
    image_play_local        = love.graphics.newImage("sprites/gui/play_local.png")
    image_play_party        = love.graphics.newImage("sprites/gui/play_party.png")
    image_play_game         = love.graphics.newImage("sprites/gui/start.png")
    image_create_server     = love.graphics.newImage("sprites/localhost/create_server.png")
    image_join_server       = love.graphics.newImage("sprites/localhost/join_server.png")
    image_TextBox           = love.graphics.newImage("sprites/localhost/textBox.png")
    image_TextBox_Active    = love.graphics.newImage("sprites/localhost/textBoxActive.png")
    image_play              = love.graphics.newImage("sprites/gui/play.png")
    image_btn_select        = love.graphics.newImage("sprites/gui/select_btns.png")
    image_btn_cancel        = love.graphics.newImage("sprites/gui/cancel_btns.png")
    image_waitings          = love.graphics.newImage("sprites/gui/waitings.png")
    image_sure_leave        = love.graphics.newImage("sprites/gui/sure_leave.png")
    image_continue          = love.graphics.newImage("sprites/gui/continue.png")
    image_leave             = love.graphics.newImage("sprites/gui/leave.png")
    image_settings          = love.graphics.newImage("sprites/gui/settings.png")
    image_press_any_btn     = love.graphics.newImage("sprites/gui/press_btn.png")
    image_how_to_add_bot    = love.graphics.newImage("sprites/gui/add_bot.png")
    image_how_to_delete_bot = love.graphics.newImage("sprites/gui/delete_bot.png")
    image_how_to_select_bot = love.graphics.newImage("sprites/gui/select_bot.png")
    background_wall         = love.graphics.newImage("sprites/gui/background.png")
    
    -- 5. БАФФЫ
    local buffs = {"bomb", "fire", "skull", "kick", "line", "egg"}
    for _, b in ipairs(buffs) do
        _G["buff_" .. b .. "_image"] = love.graphics.newImage("sprites/buffs/" .. b .. ".png")
    end

    -- 6. ВЫБОР ПЕРСОНАЖА (Choose Character)
    local choose_colors = {"white", "black", "green", "red", "NoPlayer"}
    for _, c in ipairs(choose_colors) do
        local file = (c == "NoPlayer") and "no_player" or c
        _G["choose_" .. c .. "_image"] = love.graphics.newImage("sprites/choose character/" .. file .. ".png")
    end

    local choose_types = {gamepad = "gamepad_player", keyboard = "keyboard_player", touch = "touch_player", bot = "bot_player"}
    for key, file in pairs(choose_types) do
        _G["choose_" .. key .. "_image"] = love.graphics.newImage("sprites/choose character/" .. file .. ".png")
    end

    for i = 1, 4 do
        _G["choose_P" .. i] = love.graphics.newImage("sprites/choose character/P" .. i .. ".png")
        _G["choose_BOT" .. i] = love.graphics.newImage("sprites/choose character/BOT" .. i .. ".png")
        _G["P" .. i .. "_choosen"] = love.graphics.newImage("sprites/choose character/P" .. i .. "choosen.png")
    end

    local choose_states = {"ready", "notready", "leave", "notleave"}
    for _, state in ipairs(choose_states) do
        local file = (state == "notready") and "not ready" or (state == "notleave") and "not leave" or state
        _G["choose_" .. state] = love.graphics.newImage("sprites/choose character/" .. file .. ".png")
    end

    -- 7. ЭКРАН ПОБЕДЫ
    win_black_image = love.graphics.newImage("sprites/win_mode/black.png")
    win_green_image = love.graphics.newImage("sprites/win_mode/green.png")
    win_red_image   = love.graphics.newImage("sprites/win_mode/red.png")
    win_white_image = love.graphics.newImage("sprites/win_mode/white.png")
    win_cup_image   = love.graphics.newImage("sprites/win_mode/cup.png")

    -- 8. МОДИФИКАТОРЫ
    spriteModificatorRounds    = love.graphics.newImage("sprites/modificators/rounds.png")
    spriteModificatorTeamsOn  = love.graphics.newImage("sprites/modificators/teams_on.png")
    spriteModificatorTeamsOff = love.graphics.newImage("sprites/modificators/teams_off.png")
    spriteModificatorTeams     = love.graphics.newImage("sprites/modificators/teams.png")

    local nums = {"One", "Two", "Three", "Four", "Five"}
    for _, num in ipairs(nums) do
        local file = num:lower()
        _G["spriteModificator" .. num .. "No"]  = love.graphics.newImage("sprites/modificators/" .. file .. "_no.png")
        _G["spriteModificator" .. num .. "Yes"] = love.graphics.newImage("sprites/modificators/" .. file .. "_yes.png")
    end

    -- 9. НАСТРОЙКИ
    image_musicOn = love.graphics.newImage("sprites/settings/musicOn.png")
    image_musicOff = love.graphics.newImage("sprites/settings/musicOff.png")
    image_soundOn = love.graphics.newImage("sprites/settings/soundOn.png")
    image_soundOff = love.graphics.newImage("sprites/settings/soundOff.png")
    image_tutorial = love.graphics.newImage("sprites/settings/tutorial.png")
end