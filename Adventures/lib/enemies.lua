

enemies = {}

function enemies.load()
	pawn = {}
	
	
	pawn.pic = {angry = love.graphics.newImage("Enemy Pics/Pawns/joel pawn.png"), scared = love.graphics.newImage("Enemy Pics/Pawns/scared pawn.png"), original = love.graphics.newImage("Enemy Pics/Pawns/original pawn.png")}
	
	pawn.squashedpic = {angry = love.graphics.newImage("Enemy Pics/Pawns/squashed joel pawn.png"), scared = love.graphics.newImage("Enemy Pics/Pawns/squashed scared pawn.png"),original = love.graphics.newImage("Enemy Pics/Pawns/squashed original pawn.png")}
	
	pawn.animation = {}
	pawn.animation.original = {}
	pawn.animation.original.delay = 0.1
	for i=1,6 do
		table.insert(pawn.animation.original, love.graphics.newImage("Enemy Pics/Pawns/original animation/" .. i .. ".png"))
	end
	pawn.animation.angry = {}
	pawn.animation.angry.delay = 0.02
	for i=1,6 do
		table.insert(pawn.animation.angry, love.graphics.newImage("Enemy Pics/Pawns/joel animation/" .. i .. ".png"))
	end
	pawn.animation.scared = {}
	pawn.animation.scared.delay = 0.05
	for i=1,6 do
		table.insert(pawn.animation.scared, love.graphics.newImage("Enemy Pics/Pawns/scared animation/" .. i .. ".png"))
	end
	
	pawn.picwidth = pawn.pic.angry:getWidth()
	pawn.picheight = pawn.pic.angry:getHeight()
	pawn.drawwidth = 80
	pawn.drawheight = 80
	pawn.drawproportion = pawn.drawheight/pawn.drawwidth
	
	pawn.actualwidth = 0.85 * pawn.drawwidth
	pawn.actualheight = 0.70 * pawn.drawheight
	pawn.actualproportion = pawn.actualheight/pawn.actualwidth
	pawn.count = 0
	pawn.jump = true --false
	
	foe = {}
	foe.pic = {left = love.graphics.newImage("Enemy Pics/Foes/facing left.png"),right = love.graphics.newImage("Enemy Pics/Foes/facing right.png")}
	foe.picwidth = foe.pic.left:getWidth()
	foe.picheight = foe.pic.left:getHeight()
	foe.drawheight = 180
	foe.drawwidth = foe.drawheight/230 * 54
	foe.drawproportion = foe.drawheight/foe.drawwidth
	
	foe.actualwidth = 0.85 * foe.drawwidth
	foe.actualheight = 15/23 * foe.drawheight
	foe.actualproportion = foe.actualheight/foe.actualwidth
	foe.foes = {}
	foe.formerfoes = {}
	foe.speed = 10
	foe.count = 0
	
	
	
	
	spawnpic = {}
	spawnpic.pic = love.graphics.newImage("Enemy Pics/portal.png")
	spawnpic.width,spawnpic.height = 100,100
	spawnpic.picwidth,spawnpic.picheight = spawnpic.pic:getWidth(), spawnpic.pic:getHeight()
	
	pawn.spawn = {enemySpawnPoint(640,0,"pawn",0.1,25),enemySpawnPoint(640,0,"foe",1.5,8),enemySpawnPoint(-250,-100,"foe",1,20),enemySpawnPoint(-250,-100,"pawn",0.3,30),enemySpawnPoint(-1500,900,"foe",1.2,80),enemySpawnPoint(-250,750,"pawn",1,100) }
	
	pawn.spawn = {}-----------------------------
	
	pawn.pawns = {}
	pawn.formerpawns = {}
end

function enemies.draw()
	love.graphics.setColorMode("replace")
	love.graphics.setLineWidth(3)
	love.graphics.setColor(0,0,0)
	
	for i,v in pairs(pawn.spawn) do
		if collision.rectangles(v.x-spawnpic.width/2,v.y-spawnpic.height/2,spawnpic.width,spawnpic.height, getWorldScreenRect()) then
			love.graphics.draw(spawnpic.pic, v.x-spawnpic.width/2, v.y-spawnpic.height/2,0, spawnpic.width/spawnpic.picwidth,spawnpic.height/spawnpic.picheight)
		end
	end
	
	local enemyonscreen = false	
	for i,v in pairs(foe.foes) do
		if collision.rectangles(v.xposition-v.drawwidth/2, v.yposition-v.drawheight*0.95, v.drawwidth, v.drawheight, getWorldScreenRect()) then
			love.graphics.setColorMode("replace")
			if v.killed.type then
				love.graphics.setColorMode("modulate")
				love.graphics.setColor(255,255,255,v.killed.countdown * 255)
				if v.xspeed > 0 then
					love.graphics.draw(foe.pic.right, v.xposition-v.drawwidth/2, v.yposition-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
				else
					love.graphics.draw(foe.pic.left, v.xposition-v.drawwidth/2, v.yposition-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
				end
			elseif v.xspeed > 0 then
				love.graphics.draw(foe.pic.right, v.xposition-v.drawwidth/2, v.yposition-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
			else
				love.graphics.draw(foe.pic.left, v.xposition-v.drawwidth/2, v.yposition-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
			end
			
			enemyonscreen = true	
			love.graphics.setLineWidth(1)
			--love.graphics.rectangle("line", v.xposition - v.actualwidth/2, v.yposition - v.actualheight * 0.95, v.actualwidth, v.actualheight) 
			love.graphics.setColor(255,255,255)
			--love.graphics.circle("fill", v.xposition, v.yposition, 2)
			--Collision Box
			
		end
	end
	
	for i,v in pairs(pawn.pawns) do
		if collision.rectangles(v.xposition-v.drawwidth/2, v.yposition-v.drawheight/2, v.drawwidth, v.drawheight, getWorldScreenRect()) then
			if v.killed.type == "squashed" then
				love.graphics.setColorMode("modulate")
				love.graphics.setColor(255,255,255,math.random(1,3)*80)
				love.graphics.draw(pawn.squashedpic[v.pic], v.xposition-v.drawwidth/2, v.yposition-v.drawheight/2,0,v.drawwidth/pawn.picwidth, v.drawheight/pawn.picheight)
			elseif v.killed.type == "arrow" then
				love.graphics.setColorMode("modulate")
				love.graphics.setColor(255,255,255,v.killed.countdown*255/3)
				love.graphics.draw(pawn.animation[v.pic][v.anim], v.xposition-v.drawwidth/2, v.yposition-v.drawheight/2,0,v.drawwidth/pawn.picwidth, v.drawheight/pawn.picheight)
			else
				love.graphics.setColorMode("replace")
				love.graphics.draw(pawn.animation[v.pic][v.anim], v.xposition-v.drawwidth/2, v.yposition-v.drawheight/2,0,v.drawwidth/pawn.picwidth, v.drawheight/pawn.picheight)
			end
			enemyonscreen = true	
			--love.graphics.rectangle("line",v.xposition-v.actualwidth/2, v.yposition-v.actualheight/2,v.actualwidth, v.actualheight)
		end
	end
	
	if player.hp > 0 and table.length(pawn.pawns) + table.length(foe.foes) > 0 then
		if (music.fight.music:isPaused() or music.fight.music:isStopped()) then
			love.audio.pause()
			music.fight.music:rewind()
			music.fight.music:play()
		end
	elseif --[[not enemyonscreen]] player.hp > 0 then
		if (music.discovery.music:isPaused() or music.discovery.music:isStopped() ) then
			love.audio.pause()
			music.discovery.music:play()
		end
	end
	
	
end

function enemies.update(dt)
	updateEnemySpawnPoints(dt)
	for i,v in pairs(pawn.pawns) do
		if v.killed.type ~= "squashed" then
			pawn.formerpawns[i] = {}
			pawn.formerpawns[i].xposition = v.xposition
			pawn.formerpawns[i].yposition = v.yposition
			
			if pawn.jump then
				local rand = math.random()
				if rand < 0.007 then
					v.yspeed = -50
				end
			end
			v = updateObject(v, dt)	
			v.xspeed = v.speed
			if v.yposition + v.actualheight/2 > levely then
				v.yposition = levely - v.actualheight/2
				if v.yspeed > 0 then
					v.yspeed = 0
				end
			end
			if v.health <= 0 and v.killed.type ~= "arrow" then
				v.killed.type = "arrow"
				v.killed.countdown = 2
				v.yspeed = -50
				v.ygrav = 10
				v.speed = 0
			end
		end
		if v.killed.countdown then
			v.killed.countdown = v.killed.countdown - dt
			if v.killed.countdown <= 0 then
				pawn.pawns[i] = nil
			end
		end
		v.animdelay = v.animdelay + dt
		if v.animdelay > pawn.animation[v.pic].delay then
			v.animdelay = 0
			v.anim = v.anim + 1
			if v.anim > 6 then
				v.anim = 1
			end
		end
	end
	for i,v in pairs(pawn.pawns) do				
		for a,b in pairs(pawn.pawns) do
			if not v.killed.type and not b.killed.type then
				if collision.rectangles(b.xposition - b.actualwidth/2, b.yposition-b.actualheight/2, b.actualwidth,b.actualheight, v.xposition - v.actualwidth/2, v.yposition - v.actualheight/2 , v.actualwidth , v.actualheight) then
					local direction = collision.direction.rectangles(pawn.formerpawns[i].xposition - v.actualwidth/2,pawn.formerpawns[i].yposition-v.actualheight/2, v.actualwidth, v.actualheight, pawn.formerpawns[a].xposition - b.actualwidth/2,pawn.formerpawns[a].yposition-b.actualheight/2, b.actualwidth, b.actualheight)
					if direction == "right" then
						v.xposition = b.xposition + b.actualwidth/2 + v.actualwidth/2
						if v.speed * b.speed > 0 then
							v.speed = math.abs(v.speed)
						else
							v.speed = math.abs(v.speed)
							b.speed = -math.abs(b.speed)
						end
					elseif direction == "left" then
						v.xposition = b.xposition - b.actualwidth/2 - v.actualwidth/2
						if v.speed * b.speed > 0 then
							v.speed = -math.abs(v.speed)
						else
							v.speed = -math.abs(v.speed)
							b.speed = math.abs(b.speed)
						end
					elseif direction=="top"  then
						v.yposition = b.yposition - b.actualheight/2 - v.actualheight/2
						v.yspeed = 0
					elseif direction == "bottom"  then
						v.direction = "bottom" 
						b.yspeed = 0
						b.yposition = v.yposition - v.actualheight/2 - b.actualheight/2
					end
				end
			end --if not nil
		end  -- for loop
		
		if not v.killed.type then
			for j,rect in pairs(level.stuff) do
				if collision.rectangles(rect.x, rect.y, rect.width,rect.height, v.xposition - v.actualwidth/2, v.yposition - v.actualheight/2 , v.actualwidth , v.actualheight) then
					if rect.medium == "level" or rect.color[4] == nil or rect.color[4] == 255 then
						local direction = collision.direction.rectangles(pawn.formerpawns[i].xposition - v.actualwidth/2,pawn.formerpawns[i].yposition-v.actualheight/2, v.actualwidth, v.actualheight, rect.x, rect.y, rect.width,rect.height)
						if direction == "right" then
							v.xposition = rect.x + rect.width + v.actualwidth/2
							v.speed = math.abs(v.speed)
						elseif direction == "left" then
							v.xposition = rect.x - v.actualwidth/2 
							v.speed = -math.abs(v.speed)
						elseif direction=="top"  then
							v.yposition = rect.y - v.actualheight/2
							v.yspeed = 0
						elseif direction == "bottom"  then
							v.yspeed = 0
							v.yposition = rect.y + rect.height + v.actualheight/2
						end
					elseif rect.medium == "liquid" then
						v.xspeed = v.speed * 0.55
						if v.yspeed > 0 then
							v.yspeed = v.yspeed - v.yspeed * dt * 10
						else
							v.yspeed = v.yspeed *0.99
						end
					end
				else
					v.direction = ""
				end
			end--for level loop
			
		end
		
	end
	
	
	foe.formerfoes = {}
	for i,v in pairs(foe.foes) do
		foe.formerfoes[i] = {}
		foe.formerfoes[i].xposition = v.xposition
		foe.formerfoes[i].yposition = v.yposition
		
		if v.killed.countdown then
			v.xspeed = 0
		end
		v = updateObject(v, dt)	
		v.xspeed = v.speed
		if v.yposition > levely  then
			--v.yposition = levely
			--v.yspeed = 0
		end
		
		if v.killed.countdown then
			v.killed.countdown = v.killed.countdown - dt
			if v.killed.countdown <= 0 then
				foe.foes[i] = nil
			end
		end
	end
	
	for i,v in pairs(foe.foes) do
		for j,rect in pairs(level.stuff) do
			if not v.killed.countdown then
				if collision.rectangles(rect.x, rect.y, rect.width,rect.height, v.xposition - v.actualwidth/2, v.yposition - v.actualheight * 0.95, v.actualwidth , v.actualheight) then
					if rect.medium == "level" or rect.color[4] == nil or rect.color[4] == 255 then
						local direction = collision.direction.rectangles(foe.formerfoes[i].xposition - v.actualwidth/2,foe.formerfoes[i].yposition-v.actualheight*0.95, v.actualwidth, v.actualheight, rect.x, rect.y, rect.width,rect.height)
						if direction == "right" then
							v.xposition = rect.x + rect.width + v.actualwidth/2
							v.speed = math.abs(v.speed)
						elseif direction == "left" then
							v.xposition = rect.x - v.actualwidth/2 
							v.speed = -math.abs(v.speed)
						elseif direction=="top"  then
							v.yposition = rect.y - v.actualheight*0.05 - 0.1
							v.yspeed = 0
						elseif direction == "bottom"  then
							v.yspeed = 0
							v.yposition = rect.y + rect.height + v.actualheight * 0.95
						end
					elseif rect.medium == "liquid" then
						v.xspeed = v.speed * 0.55
						if v.yspeed > 0 then
							v.yspeed = v.yspeed - v.yspeed * dt * 10
						else
							v.yspeed = v.yspeed *0.99
						end
					end
				else
					v.direction = ""
				end
			end
		end--for level loop	
	end
	
	
end
spawn = {}
function spawn.pawn(x,y, speed)
	local enemy = createObject({xposition=x,yposition=y, mass = 50, ygrav= 5, yspeed = math.random(0,6)*-15})
	enemy.direction = ""
	
	if not speed then
		speed = math.random(1,4)*10
		if math.random(0,1) == 0 then
			speed = -speed
		end
	end
	
	enemy.speed = speed or 0

	local rand = math.random(1,3)
	if rand == 1 then
		enemy.pic = "scared"
	elseif rand == 2 then
		enemy.pic = "original"
	else
		enemy.pic = "angry"
	end
	enemy.anim = 1
	enemy.animdelay = 0
	enemy.killed = {}
	enemy.killed.type = false
	enemy.killed.countdown = false
	
	enemy.drawwidth = math.random(1,3)/2 * pawn.drawwidth
	enemy.drawheight = enemy.drawwidth * pawn.drawproportion
	
	enemy.actualwidth = 0.85 * enemy.drawwidth
	enemy.actualheight = 0.7 * enemy.drawheight
	
	enemy.health = math.round(3*(enemy.drawwidth/pawn.drawwidth)/1.5,1)
	
	pawn.pawns[tostring(pawn.count)] = enemy
	pawn.count = pawn.count + 1
end



function spawn.foe(x,y,speed)
	local enemy = createObject({xposition=x,yposition=y, mass = 50, ygrav= 5, yspeed = 0})
	enemy.direction = ""
	
	enemy.speed = speed or foe.speed

	enemy.killed = {}
	enemy.killed.type = false
	enemy.killed.countdown = false
	
	enemy.drawwidth = foe.drawwidth
	enemy.drawheight = foe.drawwidth * foe.drawproportion
	
	enemy.actualwidth = foe.actualwidth
	enemy.actualheight = foe.actualheight
	
	enemy.health = 1
	foe.foes[tostring(foe.count)] = enemy
	foe.count = foe.count + 1
end

function enemySpawnPoint(x,y, typ, spawnrate, totalenemies,maxenemies)
	
	return {x=x,y=y,type = typ, spawnrate = spawnrate, maxenemies = maxenemies, totalenemies = totalenemies, counter = 0}
end

function updateEnemySpawnPoints(dt)
	for i,v in pairs(pawn.spawn) do
		if v.destroy then
			table.remove(pawn.spawn, i)
		end
		v.counter = v.counter + dt
		if v.counter >= v.spawnrate then
			v.counter = 0
			spawn[v.type](v.x, v.y,speed)
			if v.totalenemies then
				v.totalenemies = v.totalenemies - 1
				if v.totalenemies <= 0 then
					v.destroy = true
				end
			end
		end
	end
end
