function love.conf(t)
    t.identity = "data/saves"
    t.console = false
    t.window.title = "BomberMan - Окно "
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.fullscreen = true
    t.window.highdpi = true
    t.window.msaa = 2
    t.window.asyncbuffer = true
    t.window.focused = false
    t.run = nil
end