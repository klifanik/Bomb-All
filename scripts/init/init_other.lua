function InitializationOther()
    long = 80

    NumberOfPlayers = 0
    ReadyPlayers = 0

    BOTS = 0

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

    activeVibrations = {}

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

    ChooseHumans = {choose_P1, choose_P2, choose_P3, choose_P4}
    ChooseBots = {choose_BOT1, choose_BOT2, choose_BOT3, choose_BOT4}

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
    
    UserOS = love.system.getOS()
    if UserOS == "Android" or UserOS == "iOS" then
        hasKeyboard = false else hasKeyboard = true end

    targetWidth = 1200 
    targetHeight = 725
 
    sx = windowWidth / targetWidth 
    sy = windowHeight / targetHeight

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
 
    SpawnBreaks()
    SpawnBuffs()
end