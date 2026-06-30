function InitButtons()
    
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

    button_leave = {
        width = image_leave:getWidth(),
        height = image_leave:getHeight(),
        image = image_leave,
        x = 0,
        y = 470,
        scale = 1
    }

    button_continue = {
        width = image_continue:getWidth(),
        height = image_continue:getHeight(),
        image = image_continue,
        x = 0,
        y = 350,
        scale = 1
    }

    button_settings = {
        width = image_settings:getWidth(),
        height = image_settings:getHeight(),
        image = image_settings,
        x = 0,
        y = 440,
        scale = 0.5
    }

    button_musicOnOff = {
        width = image_musicOn:getWidth(),
        height = image_musicOff:getHeight(),
        x = 0,
        y = 400,
        scale = 1,
        image = image_musicOn
    }

    button_soundOnOff = {
        width = image_soundOn:getWidth(),
        height = image_soundOff:getHeight(),
        x = 0,
        y = 500,
        scale = 1,
        image = image_soundOn
    }



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


    NumbersButtons = {}
    table.insert(NumbersButtons, button_one)
    table.insert(NumbersButtons, button_two)
    table.insert(NumbersButtons, button_three)
    table.insert(NumbersButtons, button_four)
    table.insert(NumbersButtons, button_five)

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
    button_leave.x = (targetWidth / 2) - (button_leave.width * button_leave.scale / 2)
    button_continue.x = (targetWidth / 2) - (button_continue.width * button_continue.scale / 2)
    button_settings.x = (targetWidth / 2) - (button_settings.width * button_settings.scale / 2)

    button_musicOnOff.x = (targetWidth / 2) - (button_musicOnOff.width * button_musicOnOff.scale / 2)
    button_soundOnOff.x = (targetWidth / 2) - (button_soundOnOff.width * button_soundOnOff.scale / 2)

    --button_.x = (targetWidth / 2) - (button_.width * button_.scale / 2)

    if BUTTON_RIGHT then table.insert(buttons, BUTTON_RIGHT) end
    if BUTTON_LEFT then table.insert(buttons, BUTTON_LEFT) end
    if BUTTON_DOWN then table.insert(buttons, BUTTON_DOWN) end
    if BUTTON_UP then table.insert(buttons, BUTTON_UP) end
        
    if BUTTON_a then table.insert(buttons, BUTTON_a) end
    if BUTTON_b then table.insert(buttons, BUTTON_b) end
end