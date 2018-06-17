local oldSetColor = love.graphics.setColor
function love.graphics.setColor(r,g,b,a)
	if type(r) == 'table' then
		r = r[1]
		g = r[2]
		b = r[3]
		a = r[4]
	end

	r = r/255
	g = g/255
	b = b/255
	a = a and a/255 
    oldSetColor(r,g,b,a)
end
local wavy = require('wavy')
local frames = require('frames')

function love.load()
    grid = wavy.make{
        granularity = 10,
        lineLength = 20,
        lineWidth = 1,
        lineColor = 'crazy',
        spinFactor = 100,
        initialization = 'radial',
        fixedAngle = false,
        borderMovement = true
    }
    love.window.setTitle('Wavy')

    timeControl = frames.make{}

    dragInfo = {}
    dragInfo.dragging = false
    dragInfo.points = {}
    dragInfo.oldPoints = {}

    toggles = {}
    toggles.keys = {}
    toggles.keys['l'] = {name = 'drawLines', val = false}

    for i,v in pairs(toggles.keys) do
        toggles[v.name] = v
    end
end

function love.update(dt)
    local numFrames = timeControl:update()

    grid:update(dt, numFrames)
end

function love.resize(width, height)
    grid:resize(width, height)
end

function love.draw()
    grid:draw()

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 0,0)

    love.graphics.setLineWidth(2)
    if #dragInfo.points >= 4 then
        love.graphics.setColor(255, 100, 100, 100)
        love.graphics.line(dragInfo.points)
    end

    if toggles.drawLines.val then
        love.graphics.setColor(100, 255, 100, 100)
        for i, points in ipairs(dragInfo.oldPoints) do
            if #points >= 4 then
                love.graphics.line(points)
            end
        end
    end

    timeControl:sleep()
end

function love.keypressed(k)
    if k == 'escape' then
        love.event.quit()
    elseif toggles.keys[k] then
        toggles.keys[k].val = not toggles.keys[k].val
    elseif k == 's' then
        timeControl.timeFactor = timeControl.timeFactor*0.8
    elseif k == 'a' then
        timeControl.timeFactor = timeControl.timeFactor/0.8
    elseif k == 'r' then
        timeControl.timeFactor = 1
        timeControl.leftover = 0
    end
end

function love.mousepressed(x,y)
    dragInfo.dragging = true
end

function love.mousemoved(x,y)
    if dragInfo.dragging then
        table.insert(dragInfo.points, x)
        table.insert(dragInfo.points, y)
    end
end

function love.mousereleased(x,y)
    if #dragInfo.points >= 4 then
        grid:addPoints(dragInfo.points)
        table.insert(dragInfo.oldPoints, dragInfo.points)
    end
    dragInfo.dragging = false
    dragInfo.points = {}
end

