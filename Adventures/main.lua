

require ("lib/physics")
require ("lib/collision")
require ("lib/New Tables")
require("lib/enemies")
require("lib/player")
require("lib/level")
require("lib/math")
require("lib/hud")
require("lib/display functions")
require("lib/states")
require("lib/camera")
require("lib/background")
require("lib/misc resources")


function love.load()
	window = {}
	window.width, window.height = love.graphics.getWidth(), love.graphics.getHeight()
	window.fullscreen = false
	
	QUIT = false
	info = false	
	clear = true
	gameloaded = false
	-- FPS cap
	min_dt = 1/60
	next_time = love.timer.getMicroTime()

	resources.load()
	
	lovefunctions = {"mousepressed","mousereleased","keypressed","keyreleased"}
	--states.loadingscreen.load('game',5)
	states.game.load(true)
end

function love.update(dt)
	--  FPS cap
	next_time = next_time + min_dt	
	

	states[state].update(dt)
	
	love.graphics.setCaption(love.timer.getFPS())

	if QUIT then
		love.event.quit()
	end
end


function love.draw()
	states[state].draw()
	
	if info then
		love.graphics.setFont(defaultfont[14])
		love.graphics.setColor(255,255,255)
		love.graphics.print("Player X: " .. player.xposition, 10,10)
		love.graphics.print("Player Y: " .. player.yposition, 10,30)
		
		mousex,mousey = love.mouse.getPosition()
		love.graphics.print("Mouse X: " .. camera.x+(mousex-camera.width/2), 10,50)
		love.graphics.print("Mouse Y: " .. camera.y+(mousey-camera.height/2), 10,70)
		if #player.arrows > 0 then
			love.graphics.print("Arrow Power: " .. tostring(player.arrows[#player.arrows].power), 10,90)
		end
		
		love.graphics.print("Camera Offset X: " .. camera.offset.x, 10,110)
		love.graphics.print("Camera Offset Y: " .. camera.offset.y, 10,130)
		
		love.graphics.setColor(255,0,0)
		local x,y = love.mouse.getPosition()
		if clear then love.graphics.circle("fill",x,y,2) end
	end
	

	
	-- FPS cap
	local cur_time = love.timer.getMicroTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(1*(next_time - cur_time))
end





function newRectangle(left,top,width,height, color,medium, centerx, centery)
	centerx = centerx or left + width/2
	centery = centery or top + height/2
	return {x = left,y=top, width = width, height = height, color = color, medium = medium, centerx = centerx, centery=centery}
end


function math.round(n, round)
	local d = n/round
	if d - math.floor(d) >=  0.5 then
		n = round * (math.floor(d) + 1)
	else
		n = round * math.floor(d)
	end
	return n
end

function getWorldPoint(x,y)
	local worldx,worldy = camera.x+(x-camera.width/2),camera.y+(y-camera.height/2)
	return worldx,worldy
end

function getLocalPoint(x,y)
	local localx,localy = -camera.x+x+camera.width/2,-camera.y+(y+camera.height/2)
	return localx,localy
end

function getWorldScreenRect()
	local left,top = camera.x-camera.width/2,camera.y - camera.height/2 + hud.height
	return left,top,camera.width,camera.height
end

function getLocalScreenRect()
	local left,top = 0 , hud.height
	return left,top,camera.width,camera.height
end

function math.getsign(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return 0
	end
end


function table.length(t)
	local n = 0
	for i,v in pairs(t) do n = n+1 end
	return n
end

function love.processEvents()
	if love.event then
		love.event.pump()
		for e,a,b,c,d in love.event.poll() do
			if e == "quit" then
				if not love.quit or not love.quit() then
					if love.audio then
						love.audio.stop()
					end
					QUIT = true
				end
			end
			love.handlers[e](a,b,c,d)
		end
	end
end

function love.run()

    math.randomseed(os.time())
    math.random() math.random()

    if love.load then love.load(arg) end

    local dt = 0
    -- Main loop time.
    while not QUIT do	
		
        love.processEvents()

        -- Update dt, as we'll be passing it to update
        love.timer.step()
        dt = love.timer.getDelta()

        -- Call update and draw
		love.update(dt)
		
     
		if not paused then
			love.graphics.clear()
		else
			--love.graphics.present()
			love.graphics.clear()
			--love.graphics.present()
		end
		love.draw()
			
		love.graphics.present()

    end

end
