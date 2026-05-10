function InitializationOther()
    long = 80

    NumberOfPlayers = 0
    ReadyPlayers = 0

    TimeToExit = 3.0

    ExitFromWinnersTime = 5.0
    winnerHandled = false
    
    WINS = 1
    
    TEST1 = 0.0
    TEST2 = false
    TEST3 = "TEST"

    hasKeyboard = false
    hasGamepad = false
    hasTouch = false
    
    CanMoveButton = true

    joysticks = love.joystick.getJoysticks()

    Players = {}

    objects = {}
    pieces = {}
    breaks = {}
    blocks = {}
    buffs = {}

    buttons = {}
    BoxesCreate = {}
    BoxesJoin = {}

    spriteNumbersNo = {spriteModificatorOneNo, spriteModificatorTwoNo, spriteModificatorThreeNo, spriteModificatorFourNo, spriteModificatorFiveNo}
    spriteNumbersYes = {spriteModificatorOneYes, spriteModificatorTwoYes, spriteModificatorThreeYes, spriteModificatorFourYes, spriteModificatorFiveYes}

    SpriteNumbers = {spriteModificatorOneYes, spriteModificatorTwoNo, spriteModificatorThreeNo, spriteModificatorFourNo, spriteModificatorFiveNo}

    fade = {
    state = "in",
    alpha = 1,
    speed = 3.0,
    level = "gui"}

    menuData = {}
    menuData["Nickname"] = "Player"
    menuData["password"] = 123
    menuData["IP"] = "localhost"
    menuData["port"] = 12345
    
    cursorTimer = 0
    showCursor = true
    cursorPos = 0
    InputFocus = ""
    NetError = ""

    backspaceTimer = 0
    backspaceDelay = 0.5
    backspaceInterval = 0.05
    backspaceRepeatTimer = 0

    myServer, myClient = nil, nil

    GAME = "gui" 

    os.execute("chcp 65001 > nul")
    utf8 = require("utf8")

    love.graphics.setDefaultFilter("nearest", "nearest")

    normalFont = love.graphics.newFont("scripts/arial.ttf", 18)
    bigFont = love.graphics.newFont("scripts/arial.ttf", 36)

    windowWidth = love.graphics.getWidth() 
    windowHeight = love.graphics.getHeight() 
 
    love.graphics.setBackgroundColor(0, 0.5, 0)


    ButtonAnimation = {}
    ButtonAnimation.Image = love.graphics.newImage("data/sprites/gui/animation.png")
    ButtonAnimation.Grid = anim8.newGrid(101, 30, ButtonAnimation.Image:getWidth(), ButtonAnimation.Image:getHeight())
    ButtonAnimation.anim = anim8.newAnimation(ButtonAnimation.Grid('1-4', 1), 0.1)
    ButtonAnimation.position = 1

    ChosenAnimation = {}
    ChosenAnimation.Image = love.graphics.newImage("data/sprites/modificators/choosen_anim.png")
    ChosenAnimation.Grid = anim8.newGrid(13, 11, ChosenAnimation.Image:getWidth(), ChosenAnimation.Image:getHeight())
    ChosenAnimation.anim = anim8.newAnimation(ChosenAnimation.Grid('1-2', 1), 0.35)
    ChosenAnimation.position = 1

    NumberAnimation = {}
    NumberAnimation.Image = love.graphics.newImage("data/sprites/modificators/number_anim.png")
    NumberAnimation.Grid = anim8.newGrid(13, 16, NumberAnimation.Image:getWidth(), NumberAnimation.Image:getHeight())
    NumberAnimation.anim = anim8.newAnimation(NumberAnimation.Grid('1-3', 1), 0.1)
    NumberAnimation.position = 1
    
    whiteDeathAnimation = {}
    whiteDeathAnimation.Image = love.graphics.newImage("data/sprites/man_white/animation_death.png")
    whiteDeathAnimation.Grid = anim8.newGrid(68, 92, whiteDeathAnimation.Image:getWidth(), whiteDeathAnimation.Image:getHeight())
    whiteDeathAnimation.anim = anim8.newAnimation(whiteDeathAnimation.Grid('1-8', 1), 0.225)

    blackDeathAnimation = {}
    blackDeathAnimation.Image = love.graphics.newImage("data/sprites/man_black/animation_death.png")
    blackDeathAnimation.Grid = anim8.newGrid(68, 92, blackDeathAnimation.Image:getWidth(), blackDeathAnimation.Image:getHeight())
    blackDeathAnimation.anim = anim8.newAnimation(blackDeathAnimation.Grid('1-8', 1), 0.225)

    greenDeathAnimation = {}
    greenDeathAnimation.Image = love.graphics.newImage("data/sprites/man_green/animation_death.png")
    greenDeathAnimation.Grid = anim8.newGrid(68, 92, greenDeathAnimation.Image:getWidth(), greenDeathAnimation.Image:getHeight())
    greenDeathAnimation.anim = anim8.newAnimation(greenDeathAnimation.Grid('1-8', 1), 0.225)

    redDeathAnimation = {}
    redDeathAnimation.Image = love.graphics.newImage("data/sprites/man_red/animation_death.png")
    redDeathAnimation.Grid = anim8.newGrid(68, 92, redDeathAnimation.Image:getWidth(), redDeathAnimation.Image:getHeight())
    redDeathAnimation.anim = anim8.newAnimation(redDeathAnimation.Grid('1-8', 1), 0.225)
    
    UserOS = love.system.getOS()
    if UserOS == "Android" or UserOS == "iOS" then
        hasKeyboard = false else hasKeyboard = true end

    targetWidth = 1200 
    targetHeight = 725

    button_one = {
        width = spriteModificatorOneNo:getWidth(),
        height = spriteModificatorOneNo:getHeight(),
        scale = 1,
        x = 0,
        y = 100,
        active = true
    }

    button_three = {
        width = spriteModificatorOneNo:getWidth(),
        height = spriteModificatorOneNo:getHeight(),
        scale = 1,
        x = 0,
        y = 100,
        active = false
    }

    button_two = {
        width = spriteModificatorOneNo:getWidth(),
        height = spriteModificatorOneNo:getHeight(),
        scale = 1,
        x = 0,
        y = 100,
        active = false
    }

    button_four = {
        width = spriteModificatorOneNo:getWidth(),
        height = spriteModificatorOneNo:getHeight(),
        scale = 1,
        x = 0,
        y = 100,
        active = false
    }

    button_five = {
        width = spriteModificatorOneNo:getWidth(),
        height = spriteModificatorOneNo:getHeight(),
        scale = 1,
        x = 0,
        y = 100,
        active = false
    }

    NumbersButtons = {}
    table.insert(NumbersButtons, button_one)
    table.insert(NumbersButtons, button_two)
    table.insert(NumbersButtons, button_three)
    table.insert(NumbersButtons, button_four)
    table.insert(NumbersButtons, button_five)

    button_teams = {
        image = spriteModificatorTeamsOff,
        active = false,
        width = spriteModificatorTeamsOff:getWidth(),
        height = spriteModificatorTeamsOff:getHeight(),
        scale = 1,
        x = 0,
        y = 200
    }

    button_play_game = {
        width = image_play_game:getWidth(),
        height = image_play_game:getHeight(),
        scale = 0.5,
        x = 0,
        y = 600
    }
    
    button_play = {
        width = image_play:getWidth(),
        height = image_play:getHeight(),
        scale = 0.4,
        x = 0,
        y = 600
    }

    button_play_party = { 
        width = image_play_party:getWidth(), 
        height = image_play_party:getHeight(), 
        x = 0, 
        y = 0, 
        scale = 0.5
    } 

    button_play_local = {
        width = image_play_local:getWidth(),
        height = image_play_local:getHeight(),
        x = 0,
        y = 0,
        scale = 0.5
    }

    button_play_create = {
        width = image_create_server:getWidth(),
        height = image_create_server:getHeight(),
        x = 0,
        y = 0,
        scale = 0.3
    }

    button_play_join = {
        width = image_join_server:getWidth(),
        height = image_join_server:getHeight(),
        x = 0,
        y = 0,
        scale = 0.3
    }

    button_textBox1 = {
        width = image_TextBox:getWidth(),
        height = image_TextBox:getHeight(),
        image = image_TextBox,
        x = 0,
        y = 120,
        scale = 0.4,
        name = "Nickname"
    }

    button_textBox2 = {
        width = image_TextBox:getWidth(),
        height = image_TextBox:getHeight(),
        image = image_TextBox,
        x = 0,
        y = 240,
        scale = 0.4,
        name = "port"
    }

    button_textBox3 = {
        width = image_TextBox:getWidth(),
        height = image_TextBox:getHeight(),
        image = image_TextBox,
        x = 0,
        y = 360,
        scale = 0.4,
        name = "password"
    }

    button_textBox4 = {
        width = image_TextBox:getWidth(),
        height = image_TextBox:getHeight(),
        image = image_TextBox,
        x = 0,
        y = 420,
        scale = 0.4,
        name = "IP"
    }

    table.insert(BoxesCreate, button_textBox1)
    table.insert(BoxesCreate, button_textBox2)
    table.insert(BoxesCreate, button_textBox3)

    table.insert(BoxesJoin, button_textBox1)
    table.insert(BoxesJoin, button_textBox4)
    table.insert(BoxesJoin, button_textBox2)
    table.insert(BoxesJoin, button_textBox3)

    for _, b in ipairs(BoxesCreate) do b.x = (targetWidth / 2) - ((b.width * b.scale) / 2) end
    for _, b in ipairs(BoxesJoin) do b.x = (targetWidth / 2) - ((b.width * b.scale) / 2) end

    button_play_party.x = (targetWidth / 2) - ((button_play_party.width * button_play_party.scale) / 2)
    button_play_party.y = (targetHeight / 2) - (button_play_party.height * button_play_party.scale) - 60

    button_play_local.x = (targetWidth / 2) - ((button_play_local.width * button_play_local.scale) / 2)
    button_play_local.y = (targetHeight / 2) - (button_play_local.height * button_play_local.scale) + 60

    button_play_create.x = (targetWidth / 2) - ((button_play_create.width * button_play_create.scale) / 2)
    button_play_create.y = (targetHeight / 2) - (button_play_create.height * button_play_create.scale) - 60

    button_play_join.x = (targetWidth / 2) - ((button_play_join.width * button_play_join.scale) / 2)
    button_play_join.y = (targetHeight / 2) - (button_play_join.height * button_play_join.scale) + 60

    button_play_game.x = (targetWidth / 2) - (button_play_game.width * button_play_game.scale / 2)
    button_play.x = (targetWidth / 2) - (button_play.width * button_play.scale / 2)
    button_teams.x = (targetWidth / 2) - (button_teams.width * button_teams.scale / 2)
 
    sx = windowWidth / targetWidth 
    sy = windowHeight / targetHeight
    
    BUTTON_DOWN = {
        width = sprite_button_down:getWidth(),
        height = sprite_button_down:getHeight(),
        image = sprite_button_down,
        x = 150,
        y = 600,
        scale = 1.5,
        opacity = 0.6,
        isTouch = false,
        idTouch = nil}
    BUTTON_UP = {
        width = sprite_button_up:getWidth(),
        height = sprite_button_up:getHeight(),
        image = sprite_button_up,
        x = 150,
        y = 400,
        scale = 1.5,
        opacity = 0.6,
        isTouch = false,
        idTouch = nil}
    BUTTON_LEFT = {
        width = sprite_button_left:getWidth(),
        height = sprite_button_left:getHeight(),
        image = sprite_button_left,
        x = 65,
        y = 485,
        scale = 1.5,
        opacity = 0.6,
        isTouch = false,
        idTouch = nil}
    BUTTON_RIGHT = {
        width = sprite_button_right:getWidth(),
        height = sprite_button_right:getHeight(),
        image = sprite_button_right,
        x = 250,
        y = 485,
        scale = 1.5,
        opacity = 0.6,
        isTouch = false,
        idTouch = nil}
        
        if BUTTON_RIGHT then table.insert(buttons, BUTTON_RIGHT) end
        if BUTTON_LEFT then table.insert(buttons, BUTTON_LEFT) end
        if BUTTON_DOWN then table.insert(buttons, BUTTON_DOWN) end
        if BUTTON_UP then table.insert(buttons, BUTTON_UP) end
        
    BUTTON_a = {
        width = sprite_button_A:getWidth(),
        height = sprite_button_A:getHeight(),
        image = sprite_button_A,
        x = 850,
        y = 500,
        scale = 0.4,
        opacity = 0.6,
        isTouch = false,
        idTouch = nil}
    BUTTON_b = {
        width = sprite_button_B:getWidth(),
        height = sprite_button_B:getHeight(),
        image = sprite_button_B,
        x = 1000,
        y = 350,
        scale = 0.4,
        opacity = 0.6,
        isTouch = false,
        idTouch = nil}
        
        if BUTTON_a then table.insert(buttons, BUTTON_a) end
        if BUTTON_b then table.insert(buttons, BUTTON_b) end
 
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