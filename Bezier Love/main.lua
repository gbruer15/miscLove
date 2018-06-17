require('bezier')

function love.load()
	window = {}
	window.width, window.height = love.graphics.getDimensions()
	
	points = {}
	
	points[1] = {x=300,y=200}
	points[2] = {x=350,y=200}
	points[3] = {x=350,y=250}
	points[4] = {x=260,y=350}
	--points[5] = {x=180,y=350}
	
	pointRadius = 8
end


function love.update(dt)
	local mx,my = love.mouse.getPosition()
	if selectedPoint then
		selectedPoint.x = mx + selectedInfo.xdif
		selectedPoint.y = my + selectedInfo.ydif
	end
	
	love.window.setTitle(love.timer.getFPS())
end


function love.draw()
	
	--love.graphics.scale(0.4,0.4)
	--love.graphics.translate(window.width/2,window.height/2)
	
	love.graphics.setColor(1,1,1)
	local line = {}
	for i,v in ipairs(points) do
		table.insert(line,v.x)
		table.insert(line,v.y)
	end
	love.graphics.line(line)
	
	local n = #points
	for i,v in ipairs(points) do
		love.graphics.setColor(1-(i-1)/n, (i-1)/n,1,40/51)
		love.graphics.circle('fill',v.x,v.y,pointRadius)
	end
	
	bezier.drawBezier(line)
	
	if selectedPoint then
		love.graphics.setColor(1,1,1)
		love.graphics.print("Selected Point #" .. selectedInfo.i,10,10)
	end
end


function love.mousepressed(x,y,b)
	for i,v in ipairs(points) do
		if (v.x-x)^2+(v.y-y)^2 < pointRadius^2 then
			selectedPoint = v
			selectedInfo = {xdif=v.x-x, ydif=v.y-y,i = i}
			return
		end
	end
end

function love.mousereleased(x,y,b)
	if selectedPoint then
		selectedPoint.x = x + selectedInfo.xdif
		selectedPoint.y = y + selectedInfo.ydif
		selectedPoint = nil
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
