local wavy = require('wavy')

function love.load()
    grid = wavy.make{
        granularity = 5,
        lineLength = 5,
        lineWidth = 1,
        lineColor = {255, 255, 255, 255},
    }
    love.window.setTitle('Wavy')
end

function love.update()
    for i = 1, 4 do
        grid:update()
    end
end

function love.draw()
    grid:draw()

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 0,0)
end

function love.keypressed(k)
    if k == 'escape' then
        love.event.quit()
    end
end

