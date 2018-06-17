require('Love3D/Grant 3D')
require('Love3D/Camera')
require('Love3D/Math')
require('physics')
require("New Tables")
require("Love3D/3D Collisions")

function love.load()

	WINDOWWIDTH = 800
	WINDOWHEIGHT = 600
	initializePhysics()
	
	Cube = newRectangle(0,60,140, 100,10,100)
	Floor = { {-1000,50,-1000}, {-1000,50,1000}, {1000,50,1000}, {1000,50,-1000}}
	
	simplecubic = {}
	cubeobject = {}
	sidelength = 10
	x = -30
	y = -30
	z = 30
	for i=1, 10 do
		if y >= 60 then
			y = -30
			x = x + 30
			if x >= 60 then
				x = -30
				z = z -30
			end
		end
		table.insert(simplecubic, newRectangle(x,y,z, sidelength) )
		table.insert(cubeobject, createObject({ygrav = 10,xposition=x, yposition=y}))
		y = y + 30
	end
	simpleunitcell = {4,5,8,7, 4,13,14,5, 8,17,16,7, 16,13, 14, 17,16}
	--4,5,7,8,13,14,,16,17
	displayunitcell = false
	Camera = {}
	Camera.x = 0
	Camera.y = 0
	Camera.z = -140
	
	Camera.forwardpoint = {0, 0,1,0}
	Camera.horizontalpoint = {1, 0, 0,0}
	Camera.verticalpoint = {0, -1, 0,0}
	Camera.rotated = true
	
	Camera.quaternion = {w=1,x=0,y=0,z=0}
	Camera.rotationmatrix = getRotationMatrix(Camera.quaternion)
	
	Camera.perspective = 600
	
	Camera.speed = 2
	Camera.rotatespeed = 0.03

	missiles = {}
	MISSILESLOWDOWN = 10
	missileslowdown = 10
	missilespeed = 1
	
	graph = {}
	for i=1,300 do
		local x,y = to2d(-10,-10,i,Camera)
		table.insert(graph, x)
		table.insert(graph, y)
	end
	
	mouserotate = false
	mouserotatespeed = 5
	mouseretractspeed = 5
	-- FPS cap
	min_dt = 1/60
	next_time = love.timer.getTime()
end

function love.update(dt)
	--  FPS cap
	next_time = next_time + min_dt

	if love.keyboard.isDown('a') then
		Camera = moveCamera(Camera, Camera.horizontalpoint, -Camera.speed)
	elseif love.keyboard.isDown('d') then
		Camera = moveCamera(Camera, Camera.horizontalpoint, Camera.speed)
	end
	
	if love.keyboard.isDown('w') then
		Camera = moveCamera(Camera, Camera.forwardpoint, Camera.speed)
	elseif love.keyboard.isDown('s') then
		Camera = moveCamera(Camera, Camera.forwardpoint, -Camera.speed)
	end
	
	if love.keyboard.isDown('e') then
		Camera = moveCamera(Camera, Camera.verticalpoint, Camera.speed)

	elseif love.keyboard.isDown('r') then
		Camera = moveCamera(Camera, Camera.verticalpoint, -Camera.speed)
	end
	
	if not mouserotate then
		
		if love.keyboard.isDown('left') then
			Camera = rotateCamera(Camera, Camera.verticalpoint,-1)
			Camera.rotated = false
		elseif love.keyboard.isDown('right') then
			Camera = rotateCamera(Camera, Camera.verticalpoint)
			Camera.rotated = false
		end
		
		
		if love.keyboard.isDown('up') then
			Camera = rotateCamera(Camera, Camera.horizontalpoint)
			Camera.rotated = false
		elseif love.keyboard.isDown('down') then
			Camera = rotateCamera(Camera, Camera.horizontalpoint, -1)
			Camera.rotated = false
		end
		
		if love.keyboard.isDown('j') then
			Camera = rotateCamera(Camera, Camera.forwardpoint)
			Camera.rotated = false
		elseif love.keyboard.isDown('m') then
			Camera = rotateCamera(Camera, Camera.forwardpoint, -1)
			Camera.rotated = false
		end
		
		
	else
		local x,y = love.mouse.getPosition()
		local distance = (((300-y)^2)+ ((x-400)^2) )^0.5
		if distance > 50 then	
			Camera.xrotaxis = (300 -y)
			Camera.yrotaxis = (400-x)
			slope = math.atan2( (300-y),(400-x) )
				
			x = x + math.cos(slope)*mouseretractspeed		
			y = y + math.sin(slope)*mouseretractspeed
			
			love.mouse.setPosition(x,y)
		end
	end
	
	
	
	if not Camera.rotated then
		Camera = updateCameraPoints(Camera)
		Camera.rotated = true
	end
	updatePhysics(dt)
	
	if Camera.y > 50 then
		Camera.y = 50
	end
	
	for i,v in pairs(simplecubic) do
		if cubeobject[i].yposition > 50 then
			cubeobject[i].yspeed = -cubeobject[i].yspeed
		end
		simplecubic[i] = newRectangle(cubeobject[i].xposition, cubeobject[i].yposition, simplecubic[i].position[3], 10)
		
	end
	
	if love.mouse.isDown(1) and missileslowdown < 0 then
		missileslowdown = MISSILESLOWDOWN
		table.insert(missiles,{})
		local n = #missiles
		missiles[n].cube = newRectangle(Camera.x+Camera.forwardpoint[1]*5, Camera.y+Camera.forwardpoint[2]*5, Camera.z+Camera.forwardpoint[3]*5, 3,3,8)
		missiles[n].vector = Camera.forwardpoint	
	else
		missileslowdown = missileslowdown - 1
	end
	
	for i,v in pairs(missiles) do
		if v.destroy then
			table.remove(missiles, i)
		end
		v.cube = newRectangle(v.cube.position[1]+v.vector[1]*missilespeed, v.cube.position[2]+v.vector[2]*missilespeed, v.cube.position[3]+v.vector[3]*missilespeed, 3,3,8)
		if distance3d(v.cube.position[1], v.cube.position[2], v.cube.position[3], Camera.x, Camera.y, Camera.z) > 400 then
			v.destroy = true
		end
	end
	love.window.setTitle("FPS: " .. tostring(love.timer.getFPS()))
end




function love.draw()
	love.graphics.setLineWidth(1)
	
	love.graphics.setColor(1,1,1)

	local floorpoints = {}
	
	for i,v in pairs(Floor) do
		local x,y = to2d(v[1], v[2], v[3], Camera)
		table.insert(floorpoints, x)
		table.insert(floorpoints, y)
	end

	
	local list = {unpack(simplecubic)}
	
	local i = #missiles
	while i >= 1 do
		table.insert(list, missiles[i].cube)
		i = i - 1
	end
	love.graphics.print(#list, 10,10)
	
	if Camera.y < Floor[1][2] then
		if #floorpoints > 5 then
			love.graphics.setColor(0.5, 0.25,0)
			love.graphics.polygon("fill", unpack(floorpoints))
		end
		
		drawRectangles(list)
	else
		drawRectangles(list)
		if #floorpoints > 5 then
			love.graphics.setColor(0.5, 0.25,0)
			love.graphics.polygon("fill", unpack(floorpoints))
		end
	end
	
	if mouserotate then
		love.graphics.setColor(1,1,1,12/51)
		love.graphics.circle('fill', 400,300,50)
		love.graphics.setColor(1,1,1)
		love.graphics.circle('line', 400,300,50)
	end
	

	love.graphics.setColor(100/255,200/255,200/255, 100/255)
	love.graphics.circle("fill", 400, 300, 10)
	
	love.graphics.print(tabletostring(Camera.horizontalpoint), 50/255,100/255)
	
	-- FPS cap
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
	return
	end
	love.timer.sleep(1*(next_time - cur_time))
end






function love.keypressed(key)

	if key == "escape" then
		love.event.quit()
	elseif key =='b' then
		mouserotate = not mouserotate
	elseif key == 'y' then
		if displayunitcell == 'only' then
			displayunitcell = true
		elseif displayunitcell then
			displayunitcell = false
		else
			displayunitcell = 'only'
		end
	end
end