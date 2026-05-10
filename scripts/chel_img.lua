local krik = {}

function krik.stop(i, player)
    if player.direction == "up" then
        if i == 1 then player.sprite = spriteUpWhite end
        if i == 2 then player.sprite = spriteUpBlack end
        if i == 3 then player.sprite = spriteUpGreen end
        if i == 4 then player.sprite = spriteUpRed end
    elseif player.direction == "down" then
        if i == 1 then player.sprite = spriteDownWhite end
        if i == 2 then player.sprite = spriteDownBlack end
        if i == 3 then player.sprite = spriteDownGreen end
        if i == 4 then player.sprite = spriteDownRed end
    elseif player.direction == "left" then
        if i == 1 then player.sprite = spriteLeftWhite end
        if i == 2 then player.sprite = spriteLeftBlack end
        if i == 3 then player.sprite = spriteLeftGreen end
        if i == 4 then player.sprite = spriteLeftRed end
    elseif player.direction == "right" then
        if i == 1 then player.sprite = spriteRightWhite end
        if i == 2 then player.sprite = spriteRightBlack end
        if i == 3 then player.sprite = spriteRightGreen end
        if i == 4 then player.sprite = spriteRightRed end
    end

    if player.isOnDragon then
        if player.Dragon == 1 then
            if player.sprite == spriteLeftWhite then player.sprite = spriteGreenDragonLeftWhite; player.size = 0.17 end
            if player.sprite == spriteRightWhite then player.sprite = spriteGreenDragonRightWhite; player.size = 0.17 end
            if player.sprite == spriteDownWhite then player.sprite = spriteGreenDragonDownWhite; player.size = 0.2 end
            if player.sprite == spriteUpWhite then player.sprite = spriteGreenDragonUpWhite; player.size = 0.2 end

            if player.sprite == spriteLeftBlack then player.sprite = spriteGreenDragonLeftBlack; player.size = 0.17 end
            if player.sprite == spriteRightBlack then player.sprite = spriteGreenDragonRightBlack; player.size = 0.17 end
            if player.sprite == spriteDownBlack then player.sprite = spriteGreenDragonDownBlack; player.size = 0.2 end
            if player.sprite == spriteUpBlack then player.sprite = spriteGreenDragonUpBlack; player.size = 0.2 end

            if player.sprite == spriteLeftGreen then player.sprite = spriteGreenDragonLeftGreen; player.size = 0.17 end
            if player.sprite == spriteRightGreen then player.sprite = spriteGreenDragonRightGreen; player.size = 0.17 end
            if player.sprite == spriteDownGreen then player.sprite = spriteGreenDragonDownGreen; player.size = 0.2 end
            if player.sprite == spriteUpGreen then player.sprite = spriteGreenDragonUpGreen; player.size = 0.2 end

            if player.sprite == spriteLeftRed then player.sprite = spriteGreenDragonLeftRed; player.size = 0.17 end
            if player.sprite == spriteRightRed then player.sprite = spriteGreenDragonRightRed; player.size = 0.17 end
            if player.sprite == spriteDownRed then player.sprite = spriteGreenDragonDownRed; player.size = 0.2 end
            if player.sprite == spriteUpRed then player.sprite = spriteGreenDragonUpRed; player.size = 0.2 end

            elseif player.Dragon == 2 then
        
            if player.sprite == spriteLeftWhite then player.sprite = spriteYellowDragonLeftWhite; player.size = 0.17 end
            if player.sprite == spriteRightWhite then player.sprite = spriteYellowDragonRightWhite; player.size = 0.17 end
            if player.sprite == spriteDownWhite then player.sprite = spriteYellowDragonDownWhite; player.size = 0.2 end
            if player.sprite == spriteUpWhite then player.sprite = spriteYellowDragonUpWhite; player.size = 0.2 end

            if player.sprite == spriteLeftBlack then player.sprite = spriteYellowDragonLeftBlack; player.size = 0.17 end
            if player.sprite == spriteRightBlack then player.sprite = spriteYellowDragonRightBlack; player.size = 0.17 end
            if player.sprite == spriteDownBlack then player.sprite = spriteYellowDragonDownBlack; player.size = 0.2 end
            if player.sprite == spriteUpBlack then player.sprite = spriteYellowDragonUpBlack; player.size = 0.2 end

            if player.sprite == spriteLeftGreen then player.sprite = spriteYellowDragonLeftGreen; player.size = 0.17 end
            if player.sprite == spriteRightGreen then player.sprite = spriteYellowDragonRightGreen; player.size = 0.17 end
            if player.sprite == spriteDownGreen then player.sprite = spriteYellowDragonDownGreen; player.size = 0.2 end
            if player.sprite == spriteUpGreen then player.sprite = spriteYellowDragonUpGreen; player.size = 0.2 end

            if player.sprite == spriteLeftRed then player.sprite = spriteYellowDragonLeftRed; player.size = 0.17 end
            if player.sprite == spriteRightRed then player.sprite = spriteYellowDragonRightRed; player.size = 0.17 end
            if player.sprite == spriteDownRed then player.sprite = spriteYellowDragonDownRed; player.size = 0.2 end
            if player.sprite == spriteUpRed then player.sprite = spriteYellowDragonUpRed; player.size = 0.2 end

        elseif player.Dragon == 3 then
                
            if player.sprite == spriteLeftWhite then player.sprite = spriteBlueDragonLeftWhite; player.size = 0.17 end
            if player.sprite == spriteRightWhite then player.sprite = spriteBlueDragonRightWhite; player.size = 0.17 end
            if player.sprite == spriteDownWhite then player.sprite = spriteBlueDragonDownWhite; player.size = 0.2 end
            if player.sprite == spriteUpWhite then player.sprite = spriteBlueDragonUpWhite; player.size = 0.2 end

            if player.sprite == spriteLeftBlack then player.sprite = spriteBlueDragonLeftBlack; player.size = 0.17 end
            if player.sprite == spriteRightBlack then player.sprite = spriteBlueDragonRightBlack; player.size = 0.17 end
            if player.sprite == spriteDownBlack then player.sprite = spriteBlueDragonDownBlack; player.size = 0.2 end
            if player.sprite == spriteUpBlack then player.sprite = spriteBlueDragonUpBlack; player.size = 0.2 end

            if player.sprite == spriteLeftGreen then player.sprite = spriteBlueDragonLeftGreen; player.size = 0.17 end
            if player.sprite == spriteRightGreen then player.sprite = spriteBlueDragonRightGreen; player.size = 0.17 end
            if player.sprite == spriteDownGreen then player.sprite = spriteBlueDragonDownGreen; player.size = 0.2 end
            if player.sprite == spriteUpGreen then player.sprite = spriteBlueDragonUpGreen; player.size = 0.2 end

            if player.sprite == spriteLeftRed then player.sprite = spriteBlueDragonLeftRed; player.size = 0.17 end
            if player.sprite == spriteRightRed then player.sprite = spriteBlueDragonRightRed; player.size = 0.17 end
            if player.sprite == spriteDownRed then player.sprite = spriteBlueDragonDownRed; player.size = 0.2 end
            if player.sprite == spriteUpRed then player.sprite = spriteBlueDragonUpRed; player.size = 0.2 end
                
        elseif player.Dragon == 4 then
            if player.sprite == spriteLeftWhite then player.sprite = spritePurpleDragonLeftWhite; player.size = 0.17 end
            if player.sprite == spriteRightWhite then player.sprite = spritePurpleDragonRightWhite; player.size = 0.17 end
            if player.sprite == spriteDownWhite then player.sprite = spritePurpleDragonDownWhite; player.size = 0.2 end
            if player.sprite == spriteUpWhite then player.sprite = spritePurpleDragonUpWhite; player.size = 0.2 end

            if player.sprite == spriteLeftBlack then player.sprite = spritePurpleDragonLeftBlack; player.size = 0.17 end
            if player.sprite == spriteRightBlack then player.sprite = spritePurpleDragonRightBlack; player.size = 0.17 end
            if player.sprite == spriteDownBlack then player.sprite = spritePurpleDragonDownBlack; player.size = 0.2 end
            if player.sprite == spriteUpBlack then player.sprite = spritePurpleDragonUpBlack; player.size = 0.2 end

            if player.sprite == spriteLeftGreen then player.sprite = spritePurpleDragonLeftGreen; player.size = 0.17 end
            if player.sprite == spriteRightGreen then player.sprite = spritePurpleDragonRightGreen; player.size = 0.17 end
            if player.sprite == spriteDownGreen then player.sprite = spritePurpleDragonDownGreen; player.size = 0.2 end
            if player.sprite == spriteUpGreen then player.sprite = spritePurpleDragonUpGreen; player.size = 0.2 end

            if player.sprite == spriteLeftRed then player.sprite = spritePurpleDragonLeftRed; player.size = 0.17 end
            if player.sprite == spriteRightRed then player.sprite = spritePurpleDragonRightRed; player.size = 0.17 end
            if player.sprite == spriteDownRed then player.sprite = spritePurpleDragonDownRed; player.size = 0.2 end
            if player.sprite == spriteUpRed then player.sprite = spritePurpleDragonUpRed; player.size = 0.2 end
            
        elseif player.Dragon == 5 then
            
            if player.sprite == spriteLeftWhite then player.sprite = spritePinkDragonLeftWhite; player.size = 0.17 end
            if player.sprite == spriteRightWhite then player.sprite = spritePinkDragonRightWhite; player.size = 0.17 end
            if player.sprite == spriteDownWhite then player.sprite = spritePinkDragonDownWhite; player.size = 0.2 end
            if player.sprite == spriteUpWhite then player.sprite = spritePinkDragonUpWhite; player.size = 0.2 end

            if player.sprite == spriteLeftBlack then player.sprite = spritePinkDragonLeftBlack; player.size = 0.17 end
            if player.sprite == spriteRightBlack then player.sprite = spritePinkDragonRightBlack; player.size = 0.17 end
            if player.sprite == spriteDownBlack then player.sprite = spritePinkDragonDownBlack; player.size = 0.2 end
            if player.sprite == spriteUpBlack then player.sprite = spritePinkDragonUpBlack; player.size = 0.2 end

            if player.sprite == spriteLeftGreen then player.sprite = spritePinkDragonLeftGreen; player.size = 0.17 end
            if player.sprite == spriteRightGreen then player.sprite = spritePinkDragonRightGreen; player.size = 0.17 end
            if player.sprite == spriteDownGreen then player.sprite = spritePinkDragonDownGreen; player.size = 0.2 end
            if player.sprite == spriteUpGreen then player.sprite = spritePinkDragonUpGreen; player.size = 0.2 end

            if player.sprite == spriteLeftRed then player.sprite = spritePinkDragonLeftRed; player.size = 0.17 end
            if player.sprite == spriteRightRed then player.sprite = spritePinkDragonRightRed; player.size = 0.17 end
            if player.sprite == spriteDownRed then player.sprite = spritePinkDragonDownRed; player.size = 0.2 end
            if player.sprite == spriteUpRed then player.sprite = spritePinkDragonUpRed; player.size = 0.2 end
            
        end
    end
end

return krik