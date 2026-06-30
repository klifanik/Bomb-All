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
    blur.shader = love.graphics.newShader(shaderCode)
    blur.resize()
end

function blur.resize()
    local w, h = love.graphics.getDimensions()
    local canvasW = math.floor(w / blur.scale)
    local canvasH = math.floor(h / blur.scale)
    
    if blur.canvasA then blur.canvasA:release() end
    if blur.canvasB then blur.canvasB:release() end
    
    blur.canvasA = love.graphics.newCanvas(canvasW, canvasH)
    blur.canvasB = love.graphics.newCanvas(canvasW, canvasH)
    
    blur.canvasA:setFilter("linear", "linear")
    blur.canvasB:setFilter("linear", "linear")

    love.graphics.setCanvas(blur.canvasA)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setCanvas(blur.canvasB)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setCanvas()
end

-- Теперь не нужно передавать sx и sy в аргументы
function blur.capture(drawGameCallback)
    if not drawGameCallback or type(drawGameCallback) ~= "function" then
        return 
    end

    -- Читаем глобальные sx и sy. Если они nil или 0, ставим 1, чтобы не было деления на ноль
    local currentSX = (_G.sx and _G.sx > 0) and _G.sx or 1
    local currentSY = (_G.sy and _G.sy > 0) and _G.sy or 1

    blur.isPaused = true
    
    local w, h = love.graphics.getDimensions()
    local canvasW, canvasH = blur.canvasA:getDimensions()

    blur.canvasA:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)
        love.graphics.push()
        love.graphics.origin()
        
        -- Сжимаем под холст и учитываем глобальный масштаб игры
        love.graphics.scale(canvasW / w, canvasH / h)
        love.graphics.scale(currentSX, currentSY)
        
        drawGameCallback() 
        
        love.graphics.pop()
    end)

    love.graphics.setShader(blur.shader)
    blur.shader:send("texelSize", {1.0 / canvasW, 1.0 / canvasH})

    blur.canvasB:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)
        blur.shader:send("direction", {1.0, 0.0})
        love.graphics.draw(blur.canvasA, 0, 0)
    end)

    blur.canvasA:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)
        blur.shader:send("direction", {0.0, 1.0})
        love.graphics.draw(blur.canvasB, 0, 0)
    end)

    love.graphics.setShader()
end

-- Отрисовка тоже сама берет глобальные масштабы
function blur.draw()
    if not blur.isPaused then return end

    if blur.canvasA then
        love.graphics.setColor(1, 1, 1, 1)
        
        local currentSX = (_G.sx and _G.sx > 0) and _G.sx or 1
        local currentSY = (_G.sy and _G.sy > 0) and _G.sy or 1
        
        local screenW, screenH = love.graphics.getDimensions()
        local canvasW, canvasH = blur.canvasA:getDimensions()
        
        -- Компенсируем внешний scale твоего движка
        local finalScaleX = (screenW / canvasW) / currentSX
        local finalScaleY = (screenH / canvasH) / currentSY
        
        love.graphics.draw(blur.canvasA, 0, 0, 0, finalScaleX, finalScaleY)
    end
end

return blur