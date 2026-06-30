function InitAnims()
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

    ChosenAnimationP1 = {}
    ChosenAnimationP1.Image = love.graphics.newImage("sprites/choose character/P1choosen.png")
    ChosenAnimationP1.Grid = anim8.newGrid(13, 11, ChosenAnimationP1.Image:getWidth(), ChosenAnimationP1.Image:getHeight())
    ChosenAnimationP1.anim = anim8.newAnimation(ChosenAnimationP1.Grid('1-2', 1), 0.35)
    ChosenAnimationP1.position = 1

    ChosenAnimationP2 = {}
    ChosenAnimationP2.Image = love.graphics.newImage("sprites/choose character/P2choosen.png")
    ChosenAnimationP2.Grid = anim8.newGrid(13, 11, ChosenAnimationP2.Image:getWidth(), ChosenAnimationP2.Image:getHeight())
    ChosenAnimationP2.anim = anim8.newAnimation(ChosenAnimationP2.Grid('1-2', 1), 0.35)
    ChosenAnimationP2.position = 1

    ChosenAnimationP3 = {}
    ChosenAnimationP3.Image = love.graphics.newImage("sprites/choose character/P3choosen.png")
    ChosenAnimationP3.Grid = anim8.newGrid(13, 11, ChosenAnimationP3.Image:getWidth(), ChosenAnimationP3.Image:getHeight())
    ChosenAnimationP3.anim = anim8.newAnimation(ChosenAnimationP3.Grid('1-2', 1), 0.35)
    ChosenAnimationP3.position = 1

    ChosenAnimationP4 = {}
    ChosenAnimationP4.Image = love.graphics.newImage("sprites/choose character/P4choosen.png")
    ChosenAnimationP4.Grid = anim8.newGrid(13, 11, ChosenAnimationP4.Image:getWidth(), ChosenAnimationP4.Image:getHeight())
    ChosenAnimationP4.anim = anim8.newAnimation(ChosenAnimationP4.Grid('1-2', 1), 0.35)
    ChosenAnimationP4.position = 1

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
end