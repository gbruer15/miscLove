
function love.load()


	window = {}	window.width,window.height = love.graphics.getWidth(), love.graphics.getHeight()

	meter = 300
	groundy = window.height*0.6
	box = {}
	box.x, box.y = 100, 200
	box.length = meter/8
	box.width = meter*0.1 --40
	box.angle = 0

	box.hypo = (box.length*box.length + box.width*box.width)^0.5
	box.hypoangle = math.atan(box.length/box.width)

	box.period = 0
	box.laststop = love.timer.getTime()
	go = 9.80*meter
	gravity = 0
	box.anglea = gravity*math.sin(math.pi/2 - (-box.angle-box.hypoangle))/ (2*box.hypo)
	box.angles = 0

	box.xspeed = 0
	box.yspeed = 0

	box.xaccel = 0
	box.yaccel = 0
	box.onground = false

	paused = false

	love.graphics.setBackgroundColor(0,180/255,1)
	-- FPS cap
	min_dt = 1/60 
	next_time = love.timer.getTime()

	love.graphics.clear()
	love.draw()
	love.graphics.present()
end


function love.update(dt)
	--  FPS cap
	next_time = next_time + min_dt	

	if dt > 1/60 then
		dt = 1/60
	end
	
	if not paused then
		if box.onground then
			if box.width < 0 and box.length < 0 then
				box.anglea = -gravity*math.sin(math.pi/2 - (-box.angle-box.hypoangle))/ (2*box.hypo)
			elseif box.width < 0 then
				box.anglea = gravity*math.sin(math.pi/2 - (-box.angle+box.hypoangle))/ (2*box.hypo)
			elseif box.length < 0 then
				box.anglea = -gravity*math.sin(math.pi/2 - (-box.angle+box.hypoangle))/ (2*box.hypo)
			else
				box.anglea = gravity*math.sin(math.pi/2 - (-box.angle-box.hypoangle))/ (2*box.hypo)
			end
		else
			box.anglea = 0
		end

		if love.keyboard.isDown('right') then
			box.angle = box.angle + 5*dt--40
			gravity = 0
		end
		if love.keyboard.isDown('left') then
			box.angle = box.angle - 5*dt--40
			gravity = 0
		end

		if box.angles*(box.angles+box.anglea*dt) < 0 then
			box.period = love.timer.getTime() - box.laststop
			box.laststop = love.timer.getTime()
		end
		box.angles = box.angles + box.anglea*dt
		box.angle = box.angle + box.angles*dt


		if not box.onground then
			box.yaccel = gravity
		else
			box.yaccel = 0
		end
		if love.keyboard.isDown('w') then
			box.yaccel = box.yaccel - 10*meter
			gravity = go
			box.onground = false
		end
		if love.keyboard.isDown('s') then
			box.yaccel = box.yaccel + 10*meter
			gravity = go
			box.onground = false
		end
		box.xspeed = box.xspeed + box.xaccel*dt
		box.yspeed = box.yspeed + box.yaccel*dt
		box.x = box.x + box.xspeed*dt
		box.y = box.y + box.yspeed*dt



		if box.y > groundy and not box.onground then
			box.angles = box.angles - box.yspeed * math.cos(math.pi-box.angle + box.hypoangle)/(box.hypo/2)

			if math.abs(box.angles) > 10 then
				--box.angles = 3*(math.abs(box.angles)/box.angles)
				--box.yspeed = -box.yspeed*0.3
				box.yspeed = 0
				box.onground = true
			else
				box.yspeed = 0
				box.onground = true
			end
			box.y = groundy

		end
		box.angle = box.angle-math.floor(box.angle/(-2*math.pi))*-2*math.pi
		box.rightx = box.x + box.width*math.cos(math.pi/2 + box.angle)
		box.righty = box.y + box.width*math.sin(math.pi/2 + box.angle)

		box.leftx = box.x - box.length*math.cos(-math.pi-box.angle)
		box.lefty = box.y + box.length*math.sin(-math.pi-box.angle)
		if box.righty > groundy and box.righty > box.lefty then
			box.x,box.y = box.rightx,groundy
			box.width = -box.width
			box.angles = box.angles*0.4
		elseif box.lefty > groundy then

			box.x,box.y = box.leftx,groundy
			box.length = -box.length
			box.angles = box.angles*0.4

		end
	end
	love.window.setTitle(love.timer.getFPS())
end



function love.draw()


	--love.graphics.setLineWidth(4)
	--love.graphics.setColor(220,0,220)
	--love.graphics.line(box.x,box.y, box.x + box.length*math.cos(box.angle),box.y + box.length*math.sin(box.angle))

	love.graphics.setColor(10/255,140/255,10/255)
	love.graphics.rectangle("fill", 0,window.height*0.6, window.width,window.height*0.4)

	love.graphics.setLineWidth(3)
	love.graphics.setColor(180/255,130/255,90/255) 
	--love.graphics.polygon("fill", box.x,box.y,  box.x+box.length*math.cos(box.angle),box.y + box.length*math.sin(box.angle),   box.x+box.length*math.cos(box.angle) - box.width*math.sin(box.angle), box.y+ box.length*math.sin(box.angle) + box.width*math.cos(box.angle), box.x - box.width*math.sin(box.angle), box.y + box.width*math.cos(box.angle) )
	if box.onground then
		love.graphics.rectangle("fill", box.x,box.y, box.width,box.length, box.angle)
	else
		love.graphics.rectangle("fill", box.x- box.hypo/2*math.cos(box.hypoangle+box.angle),box.y- box.hypo/2*math.sin(box.hypoangle+box.angle), box.width,box.length, box.angle,box.hypo/2*math.cos(box.hypoangle+box.angle),box.hypo/2*math.sin(box.hypoangle+box.angle))
	end

	love.graphics.setColor(0,0,0)
	love.graphics.circle("fill", box.x , box.y,3)

	love.graphics.setColor(222/255,100/255,58/255)
	love.graphics.circle("fill", box.x + box.hypo/2*math.cos(box.hypoangle+box.angle), box.y + box.hypo/2*math.sin(box.hypoangle+box.angle),3)

	love.graphics.setColor(0,0,0)
	--love.graphics.rectangle("line", box.x,box.y, box.width,box.length, box.angle)

--[[
	love.graphics.setColor(220,0,180)
	love.graphics.circle("fill",box.x,box.y,2)

	love.graphics.setColor(220,220,180)
	love.graphics.circle("fill",box.rightx,box.righty,2)

	love.graphics.setColor(0,220,180)
	love.graphics.circle("fill",box.leftx,box.lefty,2)
]]

	love.graphics.setColor(0,0,0)
	love.graphics.print("Period: " .. box.period, 10,10)

	love.graphics.print("Width: " .. box.width,10,30)
	love.graphics.print("Length: " .. box.length, 10,45)

	love.graphics.print("Angle: " .. box.angle,10,65)
	love.graphics.print("Angle Speed: " .. box.angles,10,80)
	love.graphics.print("Angle Acceleration: " .. box.anglea, 10, 95)

	love.graphics.print("Y Speed: " .. box.yspeed, 10,115)
	love.graphics.print("Gravity: " .. gravity, 10,130)


	if paused then
		love.graphics.setColor(1,1,1,100/255)
		love.graphics.rectangle('fill',0,0,window.width,window.height)
	end
	-- FPS cap
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
	end
	love.timer.sleep(next_time - cur_time)
end



function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'r' then
		love.load()
	elseif key == 'k' then
		gravity = go
		box.angles = 8
	elseif key == 'j' then
		gravity = go
		box.angles = -8
	elseif key == 'p' then
		paused = not paused
	elseif key == ' ' then
		box.yspeed = 0
		go = 0
		box.angles = 0
	end
end

love.graphics.oldrectangle = love.graphics.rectangle
function love.graphics.rectangle(dmode, x,y, width,height,angle,xoff,yoff)
	xoff = xoff or 0
	yoff = yoff or 0
	if angle == nil or angle == 0 then
		love.graphics.oldrectangle(dmode,x+xoff,y+yoff,width,height)
	else
		xoff = xoff or 0
		yoff = yoff or 0
		local vertices = {x,y,  x+width*math.cos(angle),y + width*math.sin(angle),   x+width*math.cos(angle) - height*math.sin(angle),y+ width*math.sin(angle) + height*math.cos(angle),  x - height*math.sin(angle), y + height*math.cos(angle)}
		love.graphics.push()
		love.graphics.translate(-xoff,-yoff)
		love.graphics.polygon(dmode, vertices)
		love.graphics.pop()

	end
end


function math.getSign(n)
	return n/math.abs(n)
end