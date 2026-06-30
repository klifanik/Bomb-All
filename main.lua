_G.love = require("love") 
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then require("lldebugger").start() end

function love.load()
    anim8           = require("scripts/anim8")
    inputSys        = require("scripts/input_system")
    chelImage       = require("scripts/chel_img")
    updFunc         = require("scripts/upd_func")
    miniFunc        = require("scripts/mini_functions")
    Drawings        = require("scripts/drawings")
    ClickMouse      = require("scripts/click")
    ServerModule    = require "scripts/server_module"
    ClientModule    = require "scripts/client_module"
    PlayerScript    = require "scripts/player"
    blur            = require("scripts/blur")
    BOTScode        = require("scripts/Bot")

    init            = require("scripts/init/init")
    initOther       = require("scripts/init/init_other")
    initBtns        = require("scripts/init/init_btns")
    initAnimations  = require("scripts/init/init_anim")
    
    love.joystick.loadGamepadMappings("scripts/gamecontrollerdb.txt")

    initializationSprites()
    InitializationOther()
    InitButtons()
    InitAnims()
    blur.load()

    local iconData = love.image.newImageData("icon.png")
    love.window.setIcon(iconData)
    
    spawnPlayers()
    SpawnBuffs()
end

function love.mousepressed(x, y, btnCode, isTouch) ClickMouse.click(x, y, btnCode, isTouch) end

function love.touchreleased(id, x, y, dx, dy, pressure)
    for _, btn in pairs(buttons) do
        if btn.idTouch == id and btn.isTouch then
            btn.isTouch = false
            btn.idTouch = nil
            btn.opacity = 0.6
        end
    end
end

function love.joystickremoved(joystick)
    for i, player in ipairs(Players) do
        if player.playing and player.controller == "gamepad" and player.id == joystick then
            player.playing = false
            player.controller = "none"
            player.idJoy = 0
            player.Joy = 0
            player.image = choose_NoPlayer_image
            NumberOfPlayers = NumberOfPlayers - 1
        end
    end
end

local timeScale = 1.0
function love.update(dt)
    if love.keyboard.isDown("lshift") then
        timeScale = 10.0
    else
        timeScale = 1.0
    end

    local DeltaTime = dt * timeScale

    ButtonAnimation.anim:update(DeltaTime)

    if blur.isPaused then return end

    updFunc.update(DeltaTime)
    ChosenAnimation.anim:update(DeltaTime)
    NumberAnimation.anim:update(DeltaTime)

    ChosenAnimationP1.anim:update(DeltaTime)
    ChosenAnimationP2.anim:update(DeltaTime)
    ChosenAnimationP3.anim:update(DeltaTime)
    ChosenAnimationP4.anim:update(DeltaTime)

    if myServer then myServer:update(DeltaTime) end
    if myClient then myClient:update(DeltaTime) end
end
 
function love.draw()
    local mx, my = love.mouse.getPosition()
    love.graphics.push() 
    love.graphics.scale(sx, sy)
    Drawings.draw(mx, my)
    love.graphics.pop()

    if fade.alpha > 0 then
        love.graphics.setColor(0, 0, 0, fade.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function love.textinput(t)
    NetError = ""

    local field = InputFocus
    local s = menuData[field]

    if s then
        local limit = 50
        if utf8.len(s) < limit then
            -- Вставляем символ именно там, где стоит курсор
            local pos = cursorPos or utf8.len(s)
            local byteOffset = utf8.offset(s, pos + 1) or (#s + 1)
            local before = string.sub(s, 1, byteOffset - 1)
            local after = string.sub(s, byteOffset)
            
            menuData[field] = before .. t .. after
            cursorPos = pos + 1 -- Двигаем курсор за вставленную букву
        end
    end
end

function love.keypressed(key)
    if key ~= "escape" then love.mouse.setPosition(0, 0) end
    hasKeyboard = true
    if key == "escape" and GAME ~= "choose_character" and GAME ~= "SETUP_CREATE" and GAME ~= "SETUP_JOIN" then
        Exit()
    elseif key == "escape" and GAME == "choose_character" then
        for _, p in ipairs(Players) do
            if (p.controller == "keyboard" or p.controller == "touch") and p.ready then
                p.ready = false
                ReadyPlayers = ReadyPlayers - 1
                return
            else Exit()
            end
        end
    elseif GAME == "SETUP_CREATE" or GAME == "SETUP_JOIN" then
        if key == "escape" then
            if InputFocus == "" then
                Exit()
            else
                InputFocus = ""
                love.keyboard.setTextInput(false)
                for _, t in ipairs(BoxesCreate) do t.image = image_TextBox end
                for _, t in ipairs(BoxesJoin) do t.image = image_TextBox end
            end
        end

        if (key == "return" or key == "kpenter") and (UserOS == "Android" or UserOS == "iOS") then
            InputFocus = ""
            love.keyboard.setTextInput(false)
            for _, t in ipairs(BoxesCreate) do t.image = image_TextBox end
            for _, t in ipairs(BoxesJoin) do t.image = image_TextBox end
        end

        local field = InputFocus
        local s = menuData[field]

        if s then
            if key == "backspace" then
                handleBackspace()
            elseif key == "left" then
                cursorPos = math.max(0, (cursorPos or 0) - 1)
            elseif key == "right" then
                cursorPos = math.min(utf8.len(s), (cursorPos or 0) + 1)
            elseif key == "home" then
                cursorPos = 0
            elseif key == "end" then
                cursorPos = utf8.len(s)
            end
        end
    elseif GAME == "game" and blur.isPaused then inputSys.ControlGui({idJoy = nil, Joy = nil, controller = "keyboard"}, nil, key, "keyboard")
    end
    for _, p in ipairs(Players) do
        if GAME == "game" then
            if p.playing and p.controller == "keyboard" then
                if key == "space" then inputSys.performAction("bomb", p)
                elseif key == "lctrl" then inputSys.performAction("special", p) end
            end
        elseif GAME == "choose_character" then
            if p.controller == "keyboard" then inputSys.ControlGui(p, nil, key, "keyboard"); break end
            registerPlayer("keyboard", nil, false, 0)
        elseif (GAME == "choose_server" or GAME == "change_modificator" or GAME == "WaitForReady") and p.controller == "keyboard" then
            inputSys.ControlGui(p, nil, key, "keyboard"); break
        elseif GAME == "gui" then inputSys.ControlGui(nil, nil, key, "keyboard"); break
        end
    end
end

function love.touchpressed(id, x, y)
    local tx, ty = x/sx, y/sy
    for _, btn in pairs(buttons) do
        if tx >= btn.x and tx <= btn.x+btn.width*btn.scale and ty >= btn.y and ty <= btn.y+btn.height*btn.scale then
            btn.isTouch, btn.idTouch = true, id
            for _, p in ipairs(Players) do
                if p.playing and p.controller == "touch" and GAME == "game" then
                    if btn == BUTTON_a then inputSys.performAction("bomb", p)
                    elseif btn == BUTTON_b then inputSys.performAction("special", p) end
                end
            end
        end
    end
end

local last_axis_state = {x = 0, y = 0}
local triggerState = {triggerleft = false, triggerright = false}

function love.gamepadaxis(joy, axis, value)
    local threshold = 0.5
    local deadzone = 0.2
    local current_dir = 0

    if value > threshold then 
        current_dir = 1 
    elseif value < -threshold then 
        current_dir = -1
    elseif math.abs(value) < deadzone then 
        current_dir = 0 
    end

    local command = nil

    if axis == "lefty" then
        if current_dir ~= last_axis_state.y then
            last_axis_state.y = current_dir
            if current_dir ~= 0 then
                command = (current_dir == 1) and "dpdown" or "dpup"
            end
        end

    elseif axis == "leftx" then
        if current_dir ~= last_axis_state.x then
            last_axis_state.x = current_dir
            if current_dir ~= 0 then
                command = (current_dir == 1) and "dpright" or "dpleft"
            end
        end
    elseif axis == "triggerleft" or axis == "triggerright" then
        if GAME == "choose_character" then
            local found_player = false

            for _, p in ipairs(Players) do
                if p.idJoy == joy:getID() and p.controller == "gamepad" then
                    found_player = true

                    local isPressed = value > 0.3
                    
                    if isPressed ~= triggerState[axis] then
                        triggerState[axis] = isPressed
                        local btn = (axis == "triggerleft") and "LT" or "RT"
                        
                        if isPressed then inputSys.ControlGui(p, joy, btn, "gamepad") end
                        break
                    end

                end
            end

            if not found_player then registerPlayer("gamepad", joy, false, 0) end
        end
    end

    if command then
        if GAME == "gui" or GAME == "choose_server" or GAME == "change_modificator" then
            inputSys.ControlGui({idJoy = joy:getID(), Joy = joy, controller = "gamepad"}, joy, command, "gamepad")

        elseif GAME == "choose_character" then
            local found_player = false
            for _, p in ipairs(Players) do
                if p.idJoy == joy:getID() and p.controller == "gamepad" then
                    found_player = true
                    inputSys.ControlGui(p, joy, command, "gamepad")
                    break
                end
            end
            
            if not found_player then registerPlayer("gamepad", joy, false, 0) end

        elseif GAME == "game" and blur.isPaused then inputSys.ControlGui({idJoy = joy:getID(), Joy = joy, controller = "gamepad"}, joy, command, "gamepad")
        end
    end
end

function love.gamepadpressed(joy, btn)
    hasGamepad = true
    if btn == "b" and GAME ~= "game" and GAME ~= "choose_character" then Exit()
    elseif GAME == "game" and btn == "start" then Exit()
    elseif GAME == "game" and blur.isPaused then inputSys.ControlGui({idJoy = joy:getID(), Joy = joy, controller = "gamepad"}, joy, btn, "gamepad") if btn == "a" or btn == "b" then return end
    end
    for _, p in ipairs(Players) do
        if GAME == "game" then
            if p.playing and p.controller == "gamepad" and p.idJoy == joy:getID() then
                if btn == "a" then inputSys.performAction("bomb", p)
                elseif btn == "b" then inputSys.performAction("special", p) end
            end
        elseif GAME == "choose_character" then
            if p.idJoy == joy:getID() and p.controller == "gamepad" and p.Joy == joy then inputSys.ControlGui(p, joy, btn, "gamepad"); break end
            registerPlayer("gamepad", joy, false, 0)
        elseif (GAME == "choose_server" or GAME == "change_modificator") and (p.idJoy == joy:getID() and p.controller == "gamepad") then
            inputSys.ControlGui(p, joy, btn, "gamepad"); break
        elseif GAME == "gui" then inputSys.ControlGui(nil, joy, btn, "gamepad"); break
        end
    end
end