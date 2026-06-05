function InitializationOther()
    long = 80

    NumberOfPlayers = 0
    ReadyPlayers = 0

    TimeToExit = 3.0
    ExitFromWinnersTime = 5.0

    WinnerCupSlide = false
    WinnerCupY = -80
    
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
    ButtonAnimation.Image = love.graphics.newImage("sprites/gui/animation.png")
    ButtonAnimation.Grid = anim8.newGrid(101, 30, ButtonAnimation.Image:getWidth(), ButtonAnimation.Image:getHeight())
    ButtonAnimation.anim = anim8.newAnimation(ButtonAnimation.Grid('1-4', 1), 0.1)
    ButtonAnimation.position = 1

    ChosenAnimation = {}
    ChosenAnimation.Image = love.graphics.newImage("sprites/modificators/choosen_anim.png")
    ChosenAnimation.Grid = anim8.newGrid(13, 11, ChosenAnimation.Image:getWidth(), ChosenAnimation.Image:getHeight())
    ChosenAnimation.anim = anim8.newAnimation(ChosenAnimation.Grid('1-2', 1), 0.35)
    ChosenAnimation.position = 1

    NumberAnimation = {}
    NumberAnimation.Image = love.graphics.newImage("sprites/modificators/number_anim.png")
    NumberAnimation.Grid = anim8.newGrid(13, 16, NumberAnimation.Image:getWidth(), NumberAnimation.Image:getHeight())
    NumberAnimation.anim = anim8.newAnimation(NumberAnimation.Grid('1-3', 1), 0.1)
    NumberAnimation.position = 1
    
    whiteDeathAnimation = {}
    whiteDeathAnimation.Image = love.graphics.newImage("sprites/man_white/animation_death.png")
    whiteDeathAnimation.Grid = anim8.newGrid(68, 92, whiteDeathAnimation.Image:getWidth(), whiteDeathAnimation.Image:getHeight())
    whiteDeathAnimation.anim = anim8.newAnimation(whiteDeathAnimation.Grid('1-8', 1), 0.225)

    blackDeathAnimation = {}
    blackDeathAnimation.Image = love.graphics.newImage("sprites/man_black/animation_death.png")
    blackDeathAnimation.Grid = anim8.newGrid(68, 92, blackDeathAnimation.Image:getWidth(), blackDeathAnimation.Image:getHeight())
    blackDeathAnimation.anim = anim8.newAnimation(blackDeathAnimation.Grid('1-8', 1), 0.225)

    greenDeathAnimation = {}
    greenDeathAnimation.Image = love.graphics.newImage("sprites/man_green/animation_death.png")
    greenDeathAnimation.Grid = anim8.newGrid(68, 92, greenDeathAnimation.Image:getWidth(), greenDeathAnimation.Image:getHeight())
    greenDeathAnimation.anim = anim8.newAnimation(greenDeathAnimation.Grid('1-8', 1), 0.225)

    redDeathAnimation = {}
    redDeathAnimation.Image = love.graphics.newImage("sprites/man_red/animation_death.png")
    redDeathAnimation.Grid = anim8.newGrid(68, 92, redDeathAnimation.Image:getWidth(), redDeathAnimation.Image:getHeight())
    redDeathAnimation.anim = anim8.newAnimation(redDeathAnimation.Grid('1-8', 1), 0.225)
    
    UserOS = love.system.getOS()
    if UserOS == "Android" or UserOS == "iOS" then
        hasKeyboard = false else hasKeyboard = true end

    targetWidth = 1200 
    targetHeight = 725
 
    sx = windowWidth / targetWidth 
    sy = windowHeight / targetHeight
 
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