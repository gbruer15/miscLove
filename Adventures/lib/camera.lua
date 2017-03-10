camera = {}
camera._index = camera

function camera.load()
	camera.x,camera.y = player.xposition or 0,player.yposition or 0
	camera.offset = {x=0,y=0}
	camera.aimoffset = {x=0,y=0}
	camera.offset.speed = 5
	camera.width,camera.height = window.width, window.height*0.85
	camera.lock = true
end


function camera.update(dt)


	camera.x, camera.y = player.xposition, player.yposition-100
	if camera.y < -50  and camera.lock then
		--camera.offset.y = camera.offset.y + camera.offset.speed
	end
	if camera.offset.y > 100 and camera.lock then
		camera.offset.y = 100
	end
	if player.yposition - player.height/2 < camera.y - camera.height/2 and camera.lock then
		camera.y = player.yposition - player.height/2 + camera.height/2
	end
	
	
	
	if love.keyboard.isDown("left") then
		camera.offset.x = camera.offset.x - camera.offset.speed
	end
	if love.keyboard.isDown("right") then
		camera.offset.x = camera.offset.x + camera.offset.speed
	end
	if love.keyboard.isDown("up") then
		camera.offset.y = camera.offset.y - camera.offset.speed
	end
	if love.keyboard.isDown("down") then
		camera.offset.y = camera.offset.y + camera.offset.speed
	end
	
	if math.abs(camera.offset.y) > camera.height*0.4 then
		camera.offset.y = camera.height*0.4*math.getsign(camera.offset.y)
	end
	if math.abs(camera.offset.x) > camera.width*0.4 then
		camera.offset.x = camera.width*0.4*math.getsign(camera.offset.x)
	end
	if camera.lock then
		camera.offset.x = camera.offset.x - camera.offset.speed*math.getsign(camera.offset.x-camera.aimoffset.x)/2
		camera.offset.y = camera.offset.y  - camera.offset.speed*math.getsign(camera.offset.y - camera.aimoffset.y)/2
	end
	camera.x = camera.x + camera.offset.x
	camera.y = camera.y + camera.offset.y
	
end


function camera.set()
	love.graphics.push()
		
	love.graphics.translate(camera.width/2, camera.height/2)
	love.graphics.scale(1,1)
	love.graphics.translate(-camera.width/2, -camera.height/2)
	
	love.graphics.translate(camera.width/2-camera.x, camera.height/2 - camera.y)
end


function camera.unset()
	love.graphics.pop()
end

