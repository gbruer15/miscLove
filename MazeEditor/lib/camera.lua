camera = {}
camera._index = camera

function camera.load()
	camera.x,camera.y = 0, 0
	camera.xspeed,camera.yspeed = 0,0
	camera.speed = 15
	camera.width,camera.height = window.width, window.height
	camera.lock = false
	
	camera.moveEdge = 50
	
	camera.xscale,camera.yscale = 1,1
end


function camera.update(dt)

	if camera.lock and camera.y < -50  then
		camera.offset.y = camera.offset.y + camera.offset.speed
	end
	if camera.lock and camera.offset.y > 100 then
		camera.offset.y = 100
	end
	if camera.lock and player.yposition - player.height/2 < camera.y - camera.height/2  then
		camera.y = player.yposition - player.height/2 + camera.height/2
	end
	
	
	local x,y = love.mouse.getPosition()
	if x < camera.moveEdge then
		camera.xspeed = -camera.speed * (camera.moveEdge-x)
	elseif x > window.width - camera.moveEdge then
		camera.xspeed = camera.speed * (x - window.width + camera.moveEdge)
	else
		camera.xspeed = 0
	end
	
	
	if y < camera.moveEdge then
		camera.yspeed =  -camera.speed * (camera.moveEdge-y)
	elseif y > window.height - camera.moveEdge then
		camera.yspeed = camera.speed * (y - window.height + camera.moveEdge)
	else
		camera.yspeed = 0
	end
	
	
	if camera.lock then
		camera.offset.x = camera.offset.x - camera.offset.speed*math.getsign(camera.offset.x-camera.aimoffset.x)/2
		camera.offset.y = camera.offset.y  - camera.offset.speed*math.getsign(camera.offset.y - camera.aimoffset.y)/2
	end
	camera.x = camera.x + camera.xspeed*dt
	camera.y = camera.y + camera.yspeed*dt
	
end


function camera.set()
	love.graphics.push()
		
	love.graphics.translate(camera.width/2, camera.height/2)
	love.graphics.scale(camera.xscale,camera.yscale)
	love.graphics.translate(-camera.width/2, -camera.height/2)
	
	love.graphics.translate(camera.width/2-camera.x, camera.height/2 - camera.y)
end


function camera.unset()
	love.graphics.pop()
end

function camera.getWorldPoint(px,py)
	px = camera.x + (- camera.width/2 + px)/camera.xscale
	py = camera.y + (- camera.height/2 + py)/camera.yscale
	return px,py
end

