function love.load()
    width = love.graphics.getWidth( )
    height = love.graphics.getHeight()
    
    require("almost/vmath")
    require("almost/geom")
    require("almost/files")
    require("almost/ui")
    require("almost/state")
	
    require("game")
    
    love.graphics.setBackgroundColor(255,255,255)
    
    loadstate(Game)
    --loadstate(Menu)

    timediff = 0
    timestep = 1/30
end

function love.draw()
    activestate:draw()
    love.graphics.setColor(255,255,255)
    local fps = "FPS: " .. love.timer.getFPS()
    love.graphics.print(fps,20,20)
end

function love.update(dt)
    timediff = timediff + dt
    --while timediff > timestep do
     --   timediff = timediff - timestep
    activestate:update(dt)
    --end
end

function love.mousepressed(x,y, button)
    for i = #activestate.layers, 1, -1 do
        local layer = activestate.layers[i]
        local clickHandled = layer:mousepress(x,y,button)
        if clickHandled then break end
    end
end

function love.mousereleased(x,y, button)
    activestate:mouserelease(x,y,button)
end

function love.keypressed(key, isrepeat)
    if key == "r" then
        love.load()
    elseif key == "q" or key == "escape" then
        love.event.quit()
    else
        activestate:keypress(key, isrepeat)
    end
end

function love.keyreleased(key)
    activestate:keyrelease(key)
end


function love.focus(hasFocus)
    PAUSED = not hasFocus
end


function loadstate(s)
    activestate = s
    s:load()
end

function resumestate(s)
    activestate = s
    if not s.loaded then
        s:load()
        s.loaded = true
    end
end