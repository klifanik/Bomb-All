local blur = {
    shader = nil,
    canvasA = nil,
    canvasB = nil,
    isPaused = false,
    scale = 4
}

local shaderCode = [[
    extern vec2 direction;
    extern vec2 texelSize;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec4 sum = vec4(0.0);
        vec2 tc = texture_coords;
        for (int i = -3; i <= 3; i++) {
            sum += Texel(texture, tc + direction * float(i) * texelSize);
        }
        return (sum / 7.0) * color;
    }
]]

function blur.load()
    -- Если вылет происходит прямо на этой строке, значит видеокарта не поддерживает шейдеры
    blur.shader = love.graphics.newShader(shaderCode)
    blur.resize()
end

function blur.resize()
    local w, h = love.graphics.getDimensions()
    local canvasW = math.floor(w / blur.scale)
    local canvasH = math.floor(h / blur.scale)
    
    if blur.canvasA then blur.canvasA:release() end
    if blur.canvasB then blur.canvasB:release() end
    
    -- Если вылет происходит здесь, значит видеокарта не поддерживает Canvas (Холсты)
    blur.canvasA = love.graphics.newCanvas(canvasW, canvasH)
    blur.canvasB = love.graphics.newCanvas(canvasW, canvasH)
    
    blur.canvasA:setFilter("linear", "linear")
    blur.canvasB:setFilter("linear", "linear")
end

function blur.toggle(drawGameCallback)
    blur.isPaused = not blur.isPaused
    if blur.isPaused and drawGameCallback then
        local w, h = love.graphics.getDimensions()
        local canvasW = math.floor(w / blur.scale)
        local canvasH = math.floor(h / blur.scale)
        
        love.graphics.setCanvas(blur.canvasA)
        love.graphics.clear()
        love.graphics.push()
        love.graphics.scale(1 / blur.scale)
        drawGameCallback()
        love.graphics.pop()
        love.graphics.setCanvas()

        love.graphics.setShader(blur.shader)
        blur.shader:send("texelSize", {1.0 / canvasW, 1.0 / canvasH})

        love.graphics.setCanvas(blur.canvasB)
        love.graphics.clear()
        blur.shader:send("direction", {1.0, 0.0})
        love.graphics.draw(blur.canvasA)
        love.graphics.setCanvas()

        love.graphics.setCanvas(blur.canvasA)
        love.graphics.clear()
        blur.shader:send("direction", {0.0, 1.0})
        love.graphics.draw(blur.canvasB)
        love.graphics.setCanvas()

        love.graphics.setShader()
    end
end

function blur.draw()
    if blur.canvasA then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(blur.canvasA, 0, 0, 0, blur.scale, blur.scale)
    end
end

return blur