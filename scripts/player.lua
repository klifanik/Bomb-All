-- это для игры по локальной сети (создание игрока)

--[[

local P = {}

function P.newPlayer(playersData, name, id, count)

    local c = "keyboard"
    if UserOS == "Android" or UserOS == "iOS" then c = "touch" end

    local gamer = {
            name = name,
            id = id,
            isMe = false,
            spriteName = "down", 
            size = 0.25, 
            width = long, 
            height = long,
            lining = false,
            kicking = false,
            virus = 0,
            speed = 5,
            lastAutoBombX = -1,
            lastAutoBombY = -1,
            isOnDragon = false,
            Dragon = 0,
            direction = "down",
            unbreakable = false,
            FIRE = 1,
            BOMBS = 1,
            far = 1,
            bam = 1,
            controller = c,
            idJoy = 0,
            playing = true,
            isDashing = false,
            lastClickTime = 0,
            lastTouchATime = 0,
            blinkTimer = 0,
            popa = false,
            image = "choose_NoPlayer_image",
            positionButton = 1,
            ready = false,
            timeAnimDeath = 1.45,
            death = false,
            wins = 0,
            winner = false,
        }



        if count == 0 then gamer.color = "white"; gamer.x = 12; gamer.y = 5
    elseif count == 1 then gamer.color = "black"; gamer.x = 1088; gamer.y = 5
    elseif count == 2 then gamer.color = "green"; gamer.x = 12; gamer.y = 600
    elseif count == 3 then gamer.color = "red"; gamer.x = 1095; gamer.y = 600 end

    return gamer
end

return P

]]