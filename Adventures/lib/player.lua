playerfunctions = {}
--player._index = player

function playerfunctions.load(restart)
	restart = restart or false
	if love.filesystem.isFile("playertable.lua") and not restart then
		player = stringtotable(grant.table.load("playertable.lua"))
		
		player.shooting = false
		player.image.left = love.graphics.newImage("Person Pics/facing left.png")
		player.image.right = love.graphics.newImage("Person Pics/facing right.png")
		player.image.front = love.graphics.newImage("Person Pics/facing front.png")
		
		for i=1,5 do
			table.insert(player.animation.jumping, love.graphics.newImage("Person Pics/jumping person/" .. i .. ".png"))
		end
		
		player.arrowpic.pic = love.graphics.newImage("arrow.png")
		player.arrowpic.picwidth = player.arrowpic.pic:getWidth()
		player.arrowpic.picheight = player.arrowpic.pic:getHeight()
		
		player.arrows = {}
		arrows = {}
		arrows.ygravity = 5
	else
		player = {}
		local playerobject = createObject({xposition = 260, yposition = -175, ygrav = 9.8, mass = 60, airdamping = 0})
		for i,v in pairs(playerobject) do
			player[i] = v
		end
		player.width = 36--45
		player.height = 140
		player.drawwidth, player.drawheight = 45,140
		
		player.speed = 40
		player.quick = {delay = 0.5,count = -1, speed = 1}
		
		player.maxoxygenlevel = 90
		player.oxygenlevel = player.maxoxygenlevel
		player.maxhp = 20
		player.hp = player.maxhp
		player.hurttime = 0
		player.maxhurttime = 2
		player.hurtby = {}
		player.defaultxspeed = 0
		
		player.name = "George"
		player.level = 1
		player.xp = 29
		player.xps = {30,60,100,180,250,500}
		player.gold = 10
		
		player.jumpability = 0.5
		player.maxjumps = 5
		player.jumps = 0
		player.image = {}
		
		player.image.left = love.graphics.newImage("Person Pics/facing left.png")
		player.image.right = love.graphics.newImage("Person Pics/facing right.png")
		player.image.front = love.graphics.newImage("Person Pics/facing front.png")
		
		player.animation = {}
		player.animation.jumping = {}
		for i=1,5 do
			table.insert(player.animation.jumping, love.graphics.newImage("Person Pics/jumping person/" .. i .. ".png"))
		end
		player.animation.jumping.delay = 0.02
		player.animation.jumping.frames = 5
		player.anim = {}
		player.anim.frame = false
		player.anim.type = false
		player.anim.delay = 0
		
		
		player.picwidth, player.picheight = player.image.left:getWidth(), player.image.left:getHeight()
		player.inwater = false
		player.buoyancy = 0.5
		player.wateragility = 3
		player.shooting = false
		player.numberofarrows = 175
		player.infinitearrows = false
		player.arrows = {}
		player.formerarrows = {}
		player.arrowpic = {}
		player.arrowpic.pic = love.graphics.newImage("arrow.png")
		player.arrowpic.picwidth = player.arrowpic.pic:getWidth()
		player.arrowpic.picheight = player.arrowpic.pic:getHeight()
		player.arrowpic.width = 40
		player.arrowpic.height = 10
		player.arrowpic.angle = math.atan2(0.5*player.arrowpic.height, player.arrowpic.width)
		
		
		player.mouthx = 14 * player.drawwidth/player.picwidth
		player.mouthy = 42 * player.drawheight/player.picheight
		player.mouthwidth = (34-14) * player.drawwidth/player.picwidth
		player.mouthheight = (51-42) * player.drawheight/player.picheight
		player.mouthinwater = false
		
		arrows ={}
		arrows.ygravity =5
	end
	formerplayer = player
	
	function love.quit()
		grant.table.save(player,"playertable.lua")
	end
	
	--[[
	
	string1 = tabletostring(player,true)
	table1 = stringtotable(string1)
	string2 = tabletostring(table1,true)
	
	
	love.filesystem.write( "playertable.txt", string2 , all)
	
	love.graphics.setFont(defaultfont[14])
	--love.graphics.clear()
	-- love.graphics.print(string1,3,3)
	--love.graphics.print(string2,3,300)
	-- love.graphics.present()
	function love.keypressed(key)
		if key == 'h' then
			first =  not first
		end
	end
	local xt = 0
	local yt = 0
	local cat = true
	while cat do
		if love.keyboard.isDown('k') then
			cat = false
			break
		end
		
		if love.keyboard.isDown('w') then
			yt = yt - 1
		end
		if love.keyboard.isDown('s') then
			yt = yt + 1
		end
		if love.keyboard.isDown('a') then
			xt = xt - 1
		end
		if love.keyboard.isDown('d') then
			xt = xt + 1
		end
		love.processEvents()
		
		love.graphics.setFont(defaultfont[14])
		love.graphics.clear()
		
		if first then
			love.graphics.print(string1,xt,yt)
		else
			love.graphics.print(string2,xt,yt)
		end
		--love.graphics.print(string2,3,300)
		
		
		love.graphics.present()
	end
	--]]
	
	
end

function playerfunctions.updateWeapons(dt)
	if player.shooting then
		if player.shooting == "aiming" then
			player.arrows[#player.arrows].power = player.arrows[#player.arrows].power + 1
			
			local x,y = love.mouse.getPosition()
			local worldx,worldy = getWorldPoint(x,y) --camera.x+(x-camera.width/2),camera.y+(y-camera.height/2)
			player.arrows[#player.arrows].power = 0.3 * ( (worldx-player.xposition)^2 + (worldy - player.yposition)^2)^0.5
			
			if player.arrows[#player.arrows].power > 100 then
				player.arrows[#player.arrows].power = 100
			elseif player.arrows[#player.arrows].power < 10 then
				player.arrows[#player.arrows].power = 10
			end
			--player.arrows[#player.arrows].power = 25
		else
			local speed =(player.arrows[#player.arrows].power + 25) * 3
			local x,y = love.mouse.getPosition()
			local worldx,worldy = getWorldPoint(x,y)
			local angle = math.atan2(-(player.yposition-worldy),-(player.xposition-worldx))
			
			
			local xspeed = math.cos(angle)*speed
			local yspeed = math.sin(angle)*speed
			player.arrows[#player.arrows] = createObject({xposition=player.xposition, yposition=player.yposition, xspeed=xspeed, yspeed=yspeed, ygrav=arrows.ygravity, mass=0.001})
			player.arrows[#player.arrows].angle = angle
			player.arrows[#player.arrows].update = true
			player.shooting = false
			player.arrows[#player.arrows].stuck = {}
			
			local mag = player.arrowpic.width*0.1
			player.arrows[#player.arrows].mouthx = player.arrows[#player.arrows].xposition + math.cos(player.arrows[#player.arrows].angle)*mag
			player.arrows[#player.arrows].mouthy = player.arrows[#player.arrows].yposition + math.sin(player.arrows[#player.arrows].angle)*mag
			
			local mag = (  (0.5*player.arrowpic.height)^2 + ( player.arrowpic.width^2) )^0.5
			player.arrows[#player.arrows].drawx = player.arrows[#player.arrows].mouthx - math.cos(player.arrowpic.angle + player.arrows[#player.arrows].angle)*mag
			player.arrows[#player.arrows].drawy = player.arrows[#player.arrows].mouthy - math.sin(player.arrowpic.angle + player.arrows[#player.arrows].angle)*mag
			
			
			if crazycolor then
				local rand = math.random(2,2)
				if rand == 1 then
					player.arrows[#player.arrows].color = {255,0,0}
				elseif rand == 2 then
					player.arrows[#player.arrows].color = {0,255,0}
				elseif rand == 3 then
					player.arrows[#player.arrows].color = {0,0,255}
				end
			else
				player.arrows[#player.arrows].color = {255,255,255}
			end
			if not player.infinitearrows then
				player.numberofarrows = player.numberofarrows - 1
			end
			sfx.twong:stop()
			sfx.twong:play()
			
		end
	end
	
	player.formerarrows = {}
	for a,b in pairs(player.arrows) do
		table.insert(player.formerarrows, b)
		if b.xposition and b.update then
			if not b.stuck.xoff then
				b = updateObject(b, dt)
				b.angle = math.atan2(b.yspeed,b.xspeed)
			elseif b.stuck.type == "pawn" and pawn.pawns[b.stuck.key] then
				b.xposition = pawn.pawns[b.stuck.key].xposition - b.stuck.xoff 
				b.yposition = pawn.pawns[b.stuck.key].yposition - b.stuck.yoff
			elseif b.stuck.type == "foe" and foe.foes[b.stuck.key] then
				b.xposition = foe.foes[b.stuck.key].xposition - b.stuck.xoff 
				b.yposition = foe.foes[b.stuck.key].yposition - b.stuck.yoff
			else
				b.stuck.countdown = -1
			end
			local mag = player.arrowpic.width*0.1
			b.mouthx = b.xposition + math.cos(b.angle)*mag
			b.mouthy = b.yposition + math.sin(b.angle)*mag
			
			local mag = (  (0.5*player.arrowpic.height)^2 + ( player.arrowpic.width^2) )^0.5
			b.drawx = b.mouthx - math.cos(player.arrowpic.angle + b.angle)*mag
			b.drawy = b.mouthy - math.sin(player.arrowpic.angle + b.angle)*mag
			
			if b.yposition > levely and not b.stuck.countdown then
				if not night then
					b.update = false
				else
					b.stuck.countdown = 3
					if b.yspeed > 0 then
						b.yspeed = 0
					end
					b.xspeed = 0
					b.ygravity = -5
				end
			end
				
			if not b.stuck.xoff then
				for i,v in pairs(foe.foes) do
					if collision.pointRectangle(b.xposition,b.yposition, v.xposition-v.actualwidth/2, v.yposition - v.actualheight*0.95, v.actualwidth, v.actualheight) then
						if not v.killed.countdown then
							if collision.pointRectangle(b.xposition,b.yposition, v.xposition-v.actualwidth/2, v.yposition - v.actualheight*0.95, v.actualwidth, v.actualheight*40/160) then
								v.killed.type = "arrow"
								v.killed.countdown = 1
								v.yspeed = -50
								v.ygravity = 10
								
								b.stuck = {}
								b.stuck.countdown = {}
								b.stuck.xoff = v.xposition - b.xposition
								b.stuck.yoff = v.yposition - b.yposition
								b.stuck.countdown = v.killed.countdown
								b.stuck.key = i
								b.stuck.type = "foe"
								break
							else
								--v.killed.type = "arrow"
								--v.killed.countdown = 2
								--v.yspeed = -50
								v.speed = v.speed
								b.stuck = {}
								b.stuck.countdown = {}
								b.stuck.xoff = v.xposition - b.xposition
								b.stuck.yoff = v.yposition - b.yposition
								b.stuck.countdown = v.killed.countdown
								b.stuck.key = i
								b.stuck.type = "foe"
								--b.life = 10
								break
							end
						end
					end
				end --Enemy Collisions
				
				if not b.stuck.xoff then
					for i,v in pairs(pawn.pawns) do
						if collision.pointRectangle(b.xposition,b.yposition, v.xposition-v.actualwidth/2, v.yposition - v.actualheight/2, v.actualwidth, v.actualheight) then
							if not v.killed.countdown then
								--v.killed.type = "arrow"
								--v.killed.countdown = 2
								--v.yspeed = -50
								v.speed = v.speed * 0.5
								v.health = v.health - 1
								--
								b.stuck = {}
								b.stuck.countdown = {}
								b.stuck.xoff = v.xposition - b.xposition
								b.stuck.yoff = v.yposition - b.yposition
								b.stuck.countdown = v.killed.countdown
								b.stuck.key = i
								b.stuck.type = "pawn"
								--]]
								--b.life = 10
								
								break
							end
						end
				end --Enemy Collisions
				end
				
				b.collide = false
				for i,rect in pairs(level.stuff) do
					if collision.pointRectangle(b.xposition, b.yposition,rect.x, rect.y, rect.width,rect.height) then
						if not night or true then
							if rect.medium =="level" then
								b.update = false
								b.life = 4
							elseif rect.medium =='liquid' then
								local s = (b.xspeed * b.xspeed + b.yspeed * b.yspeed)^0.5
								local ang = math.atan2(b.yspeed,b.xspeed)
								s = s * 0.9
								b.xspeed = math.cos(ang)*s
								b.yspeed = math.sin(ang)*s
							elseif rect.medium == 'deathtrap' then
								local s = (b.xspeed * b.xspeed + b.yspeed * b.yspeed)^0.5
								local ang = math.atan2(b.yspeed,b.xspeed)
								s = s * 0.9
								b.xspeed = math.cos(ang)*s
								b.yspeed = math.sin(ang)*s
							end
						else -- bouncy. doesn't work very well
							b.collide = true
							if rect.medium == "level" then
								local direction = collision.direction.pointRectangle(player.formerarrows[a].xposition, player.formerarrows[a].yposition, rect.x, rect.y, rect.width, rect.height)
								if direction == "right" then
									b.xposition = rect.x + rect.width
									b.xspeed = math.abs(b.xspeed)* 0.6
								elseif direction == "left" then
									b.xposition = rect.x
									b.xspeed = - math.abs(b.xspeed) * 0.6
								elseif direction == "top" or rect.direction=="top" then
									b.yposition = rect.y
									b.yspeed = -math.abs(b.yspeed)* 0.6
									b.xspeed = b.xspeed * 0.6
								elseif direction == "bottom" or rect.direction=="bottom" then
									b.yspeed = math.abs(b.yspeed)* 0.6
									b.yposition = rect.y + rect.height
									b.xspeed = b.xspeed * 0.6
								end
							elseif rect.medium == "liquid" then
								b.xspeed = b.xspeed * dt * 54.6
								b.yspeed = b.yspeed * dt * 54.6
							end
							if math.round(b.xspeed,0.01) == 0 then
								b.stuck.countdown = 2
								b.ygravity = -5
							end
						end
					end 
				end --Level Collisions
				
				if not b.stuck then
					b.angle = math.atan2(b.yspeed,b.xspeed) -- - player.arrowpic.angle
				end
				local mag = player.arrowpic.width*0.1
				b.mouthx = b.xposition + math.cos(b.angle)*mag
				b.mouthy = b.yposition + math.sin(b.angle)*mag
				
				local mag = (  (0.5*player.arrowpic.height)^2 + ( player.arrowpic.width^2) )^0.5
				b.drawx = b.mouthx - math.cos(player.arrowpic.angle + b.angle)*mag
				b.drawy = b.mouthy - math.sin(player.arrowpic.angle + b.angle)*mag
			elseif b.stuck.countdown then
				b.stuck.countdown = b.stuck.countdown - dt
				if b.stuck.countdown < 0 then
					table.remove(player.arrows,a)
				end
			elseif b.life then
				b.life = b.life - dt
				if b.life < 0 then
					table.remove(player.arrows,a)
				end
			end
		elseif b.xposition and not b.update then
			if b.life then
				b.life = b.life - dt
				if b.life <= 0 then
					table.remove(player.arrows,a)
				end
			end
		end
		
	end
	
	
	---------------------------------
			--Next Weapon--
	
	
	
end

function playerfunctions.drawWeapons()
	love.graphics.setColor(255,255,255)
	love.graphics.setLineWidth(1)
	for i,v in pairs(player.arrows) do
		if v.xposition then
			if collision.rectangles(v.drawx-player.arrowpic.width,v.drawy-player.arrowpic.width,player.arrowpic.width * 2,player.arrowpic.width * 2, getWorldScreenRect()) then
				if v.stuck.countdown ~= nil then
					love.graphics.setColorMode("modulate")
					love.graphics.setColor(255,255,255)
					if pawn.pawns[v.stuck.key] then
						if pawn.pawns[v.stuck.key].countdown then
							love.graphics.setColor(255,255,255,pawn.pawns[v.stuck.key].countdown*255/3)
						else
							love.graphics.setColor(255,255,255)
						end
					end
					if night then
						love.graphics.setColor(0,255,0)
					end
					love.graphics.draw(player.arrowpic.pic, v.drawx, v.drawy,v.angle, player.arrowpic.width/player.arrowpic.picwidth,player.arrowpic.height/player.arrowpic.picheight)
				elseif v.life then
					love.graphics.setColorMode("modulate")
					love.graphics.setColor(255,255,255)
					if v.life < 3 then
						love.graphics.setColor(255,255,255,v.life*85)
					end
					love.graphics.draw(player.arrowpic.pic, v.drawx, v.drawy,v.angle, player.arrowpic.width/player.arrowpic.picwidth,player.arrowpic.height/player.arrowpic.picheight)				
				else -- if clear then ?
					love.graphics.setColorMode("replace")
					if night then
						love.graphics.setColorMode("modulate")
						love.graphics.setColor(0,255,0)
					end
					love.graphics.draw(player.arrowpic.pic, v.drawx, v.drawy,v.angle, player.arrowpic.width/player.arrowpic.picwidth,player.arrowpic.height/player.arrowpic.picheight)
				end
			end
			
			
			love.graphics.setColor(0,200,0)
			--love.graphics.circle("fill", v.xposition,v.yposition,2)
			--love.graphics.setColor(120,120,0)
			--love.graphics.circle("fill", v.mouthx,v.mouthy,2)
			
			
			--[[love.graphics.line(v.xposition,v.yposition,v.drawx,v.drawy)
			love.graphics.circle("fill", v.drawx,v.drawy, 1)
			love.graphics.setColor(0,0,200)			
			love.graphics.circle("fill", v.xposition,v.yposition, 1)]]	
			
		end
	end
	
	if player.shooting == "aiming" and clear then		
		v = player.arrows[#player.arrows]
		local speed =(v.power + 25) * 3
		local x,y = love.mouse.getPosition()
		local worldx,worldy = getWorldPoint(x,y)--camera.x+(x-camera.width/2),camera.y+(y-camera.height/2)
		local angle = math.atan2(-(player.yposition-worldy),-(player.xposition-worldx))
		
		local xspeed = math.cos(angle)*speed
		local yspeed = math.sin(angle)*speed
		local t = 0
					
		local count = 0
		
		if v.power < 5 then
			love.graphics.setLineWidth(1)
		else
			love.graphics.setLineWidth(v.power/5)
		end
		local size = (v.power)^0.6
		while math.abs(t) <= 7 do
			y = arrows.ygravity*metersize/2 * t*t + yspeed* t + player.yposition
			x = xspeed * t + player.xposition
			love.graphics.setColor(255 - math.abs(t*255/7),math.abs(t*255/7),math.abs(t*255/7), 255 - math.abs(t*255/7))
			love.graphics.circle("fill",x,y,size - math.abs(t*size/7))
			t = t + 0.1
			count = count + 1
			if count > 300 or x < camera.x - camera.width/2 or x > camera.x + camera.width/2 then
				break
			end
		end
	end
	
end



function playerfunctions.update(dt)
	
	player.collide = false
	player.inwater = 1
	formerplayer = {}
	formerplayer.xposition = player.xposition
	formerplayer.yposition = player.yposition
	formerplayer.width, formerplayer.height = player.width, player.height
	
	player = updateObject(player,dt)
	-- print(player.xgravity)
	player.mouthinwater = false
	player.inlevel = false
	
	player.defaultxspeed = 0
	-----Collide With Level----------
	player.indeathtrap = false
	if player.hp > 0 then
		for i,rect in pairs(level.stuff) do
			if collision.rectangles(rect.x, rect.y, rect.width,rect.height, player.xposition - player.width/2, player.yposition - player.height/2 , player.width , player.height, false) then
				player.collide = true
				rect.collide = true
				if rect.medium == "level" then
					--[[if rect.direction ~= "" then
						if rect.direction == "right" then
							player.xposition = rect.x + rect.width + player.width/2
							player.xspeed = 0
							rect.direction = "right"
						elseif rect.direction == "left" then
							player.xposition = rect.x - player.width/2
							player.xspeed = 0
							rect.direction = "left"
						elseif rect.direction == "top" then
							player.yposition = rect.y - player.height/2
							player.yspeed = 0
							rect.direction = "top"
							player.jumps = 0
						elseif rect.direction == "bottom" then
							rect.direction = "bottom"
							player.yspeed = 0
							player.yposition = rect.y + rect.height + player.height/2
						end

					end]]
					local direction = collision.direction.rectangles(formerplayer.xposition-formerplayer.width/2, formerplayer.yposition-formerplayer.height/2, formerplayer.width, formerplayer.height, rect.x, rect.y, rect.width, rect.height)
					if direction == "right" or rect.direction == "right" then
						player.xposition = rect.x + rect.width + player.width/2
						player.xspeed = 0
						rect.direction = "right"
					elseif direction == "left" or rect.direction=="left" then
						player.xposition = rect.x - player.width/2
						player.xspeed = 0
						rect.direction = "left"
					elseif direction == "top" or rect.direction=="top" then
						player.yposition = rect.y - player.height/2
						player.yspeed = 0
						rect.direction = "top"
						player.jumps = 0
					elseif direction == "bottom" or rect.direction=="bottom" then
						rect.direction = "bottom" 
						player.yspeed = 0
						player.yposition = rect.y + rect.height + player.height/2
					end
					player.inlevel = true
				elseif rect.medium == "liquid" then
					if player.yspeed > 0 then
						player.yspeed = player.yspeed - player.yspeed * dt * 10
					else
						player.yspeed = player.yspeed - player.yspeed * dt * 5/player.wateragility
					end
					if collision.rectangles(rect.x,rect.y,rect.width,rect.height, player.mouthx + player.xposition-player.drawwidth/2, player.mouthy + player.yposition-player.drawheight/2, player.mouthwidth,player.mouthheight) then
						player.mouthinwater = true
					end
					player.jumps = 0
					player.inwater = 0.55*(player.wateragility)^0.5
				elseif rect.medium == 'deathtrap' then
					player.ygravity = math.getSign(rect.centery - player.yposition)*5
					player.xgravity = math.getSign(rect.centerx - player.xposition)*100
					player.indeathtrap = true
					if collision.rectangles(rect.x,rect.y,rect.width,rect.height, player.mouthx + player.xposition-player.drawwidth/2, player.mouthy + player.yposition-player.drawheight/2, player.mouthwidth,player.mouthheight) then
						player.mouthinwater = true
					end
					player.jumps = 0
				end
			else
				rect.direction = ""
				rect.collide = false
			end
		end
		-----------------------------
	
	
		------Collision With Enemies------
		for i,v in pairs(pawn.pawns) do
			if not v.killed.type then
				if collision.rectangles(player.xposition - player.width/2, player.yposition-player.height/2, player.width,player.height, v.xposition - v.actualwidth/2, v.yposition - v.actualheight/2 , v.actualwidth , v.actualheight) then
					
					local direction = collision.direction.rectangles(formerplayer.xposition - player.width/2, formerplayer.yposition-player.height/2, player.width, player.height, pawn.formerpawns[i].xposition - v.actualwidth/2,pawn.formerpawns[i].yposition-v.actualheight/2, v.actualwidth, v.actualheight)
					if direction == "right" then
						--v.xposition = player.xposition  - player.width/2 - pawn.actualwidth/2
						v.speed = -math.abs(v.speed)
						playerfunctions.damage(0.5,"pawn")
					elseif direction == "left" then
						--v.xposition = player.xposition + player.width/2 + pawn.actualwidth/2
						v.speed = math.abs(v.speed)
						playerfunctions.damage(0.5,"pawn")
					elseif direction=="top"  then
						if not v.killed.type then
							v.killed.type = "squashed"
							v.killed.countdown = 0.5
							v.ygravity = 0
							v.yspeed = 0
							v.speed = 0
							player.yspeed = -100
							player.yposition = v.yposition - v.actualheight/2 - player.height/2
							player.jumps = 0
							break
						end
					elseif direction == "bottom"  then
						v.yposition = player.yposition - player.height/2 - v.actualheight/2
						v.yspeed = 0
						playerfunctions.damage(0.5,"pawn")
					end
				end
			end
		
		end
	
		--[
		if player.hurttime <= 0 then
			for i,v in pairs(foe.foes) do
				if not v.killed.type then
					local left
					if v.xspeed > 0 then
						left = v.xposition - v.drawwidth/2 + 4*v.drawwidth/foe.picwidth
					else
						left = v.xposition + v.drawwidth/2 - 16*v.drawwidth/foe.picwidth
					end
					
					if collision.rectangles(player.xposition - player.width/2, player.yposition-player.height/2, player.width,player.height, left, v.yposition - v.drawheight*0.95 , 12*v.drawwidth/foe.picwidth , 16*v.drawwidth/foe.picwidth) then
						
						local direction = collision.direction.rectangles(formerplayer.xposition - player.width/2, formerplayer.yposition-player.height/2, player.width, player.height, left, v.yposition - v.drawheight*0.95 , 12*v.drawwidth/foe.picwidth , 16*v.drawwidth/foe.picwidth)
						if direction == "right" then
							--v.xposition = player.xposition  - player.width/2 - pawn.actualwidth/2
							--v.speed = -math.abs(v.speed)
						elseif direction == "left" then
							--v.xposition = player.xposition + player.width/2 + pawn.actualwidth/2
							--v.speed = math.abs(v.speed)
						elseif direction=="top"  then
							player.yspeed = -50
							playerfunctions.damage(0.5,"foe")							
						elseif direction == "bottom"  then
							--v.yposition = player.yposition - player.height/2 - pawn.actualheight/2
							--v.yspeed = 0
						end
					end
				end
			
			end
		end--if player.hurttime <= 0
		--]]
		----Move Player----
		if love.keyboard.isDown("alt") then
			player.quick.speed = 3
		end

		if love.keyboard.isDown("a") then
			player.xspeed = -player.speed * player.quick.speed * player.inwater
		end
		if love.keyboard.isDown("d") then
			player.xspeed = player.speed * player.quick.speed * player.inwater 
		end
		
		if not player.indeathtrap then
			player.xgravity,player.ygravity = 0,9.8
		end

		if not love.keyboard.isDown("a") and not love.keyboard.isDown("d") and player.xgravity == 0 or player.hp<= 0 then
			player.xspeed =  0
		end
		
		player.xspeed = player.xspeed + player.defaultxspeed
		
		if love.keyboard.isDown("s") then
			applyForce(player, 0, player.speed * player.mass,dt)
		end
		player.oxygenlevel = player.oxygenlevel - (player.speed*player.quick.speed * dt)*0.02
	end -- if player.hp > 0
	
	
	if player.yposition + player.height/2 >= levely then
		player.yposition = levely - player.height/2
		player.yspeed = 0
		player.jumps = 0
	end
		
	if player.anim.type then
		player.anim.delay = player.anim.delay + dt
		if player.anim.delay > player.animation[player.anim.type].delay then
			player.anim.delay = 0
			player.anim.frame = player.anim.frame + 1
			if player.anim.frame > player.animation[player.anim.type].frames then
				player.anim.frame = false
				player.anim.type = false
			end
		end
	end
	
	if player.xposition < -1700 then
		player.xposition = -1700
	elseif player.xposition > 2000 then
		player.xposition = 2000
	end
	
	if player.mouthinwater then
		player.oxygenlevel = player.oxygenlevel - dt
	elseif player.hp > 0 then
		player.oxygenlevel = player.oxygenlevel + dt * 30
	end
	
	if player.oxygenlevel > player.maxoxygenlevel then
		player.oxygenlevel = player.maxoxygenlevel
	elseif player.oxygenlevel < 0 then
		player.oxygenlevel = 0
		if player.hurttime <= 0 then
			playerfunctions.damage(1,"water")
		end
	end
	
	if player.hp <= 0 then
		player.hp = 0
		slowmotion = slowmotion - slowmotion*0.75 * dt
		camera.lock = false
		if player.hurttime/player.maxhurttime < 0.6 then
			states.gameover.load()
		end
	end	
	
	
	player.hurttime = player.hurttime - dt
	if player.hurttime < 0 then
		player.hurttime = 0
	end
	
	if slowmotion < 1 then
		slowmotion = slowmotion + (slowmotion)*dt*10
	elseif slowmotion > 1 then
		slowmotion = 1
	end
	
	
	if player.quick.count >= 0 and player.quick.count < player.quick.delay then
		player.quick.count = player.quick.count + dt
	else
		player.quick.count = -1
	end
	
end


function playerfunctions.draw()
	love.graphics.setColorMode("replace")
	if player.anim.type then
		love.graphics.draw(player.animation[player.anim.type][player.anim.frame], player.xposition-player.drawwidth/2, player.yposition-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
	else
		if player.shooting == "aiming" then
			local x,y = getWorldPoint(love.mouse.getPosition())
			if  x > player.xposition then
				love.graphics.draw(player.image.right, player.xposition-player.drawwidth/2, player.yposition-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
			else
				love.graphics.draw(player.image.left, player.xposition-player.drawwidth/2, player.yposition-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
			end
		else
			if player.hurttime > 0 then
				love.graphics.setColorMode('modulate')
				if player.hp > 0 then
					love.graphics.setColor(255,200,200,135 + math.random(1,15)*6)
				else
					love.graphics.setColor(255,100,100,player.hurttime/player.maxhurttime*200)
					width = player.drawwidth*(player.hurttime/player.maxhurttime)^((player.maxhurttime-player.hurttime)^2*1000)
					height = player.drawheight*(player.hurttime/player.maxhurttime)^((player.maxhurttime-player.hurttime)^2*1000)
					love.graphics.draw(player.image.front, player.xposition-width/2, player.yposition-height/2,0, width/player.picwidth,height/player.picheight)
					
					return
				end
			end
			if love.keyboard.isDown('d') then
				love.graphics.draw(player.image.right, player.xposition-player.drawwidth/2, player.yposition-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
			elseif love.keyboard.isDown('a') then
				love.graphics.draw(player.image.left, player.xposition-player.drawwidth/2, player.yposition-player.drawheight/2)
			elseif player.image.front then
				love.graphics.draw(player.image.front, player.xposition-player.drawwidth/2, player.yposition-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
			elseif player.image.original then
				love.graphics.draw(player.image.original, player.xposition-player.drawwidth/2, player.yposition-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
			end
		end
		
		love.graphics.setColor(0,0,0)
	end
end

function playerfunctions.damage(damage,enemytype)
	if player.hurttime <= 0 and player.hp > 0 then
		local damage = damage or 1
		player.hp = player.hp - damage
		player.hurttime = player.maxhurttime
		slowmotion = 0.05
		if player.hp <= 0 then
			slowmotion = 0.02
			player.yspeed = 0
			player.xspeed = 0
			
			love.audio.pause()
			music.dying.music:play()
		end
		table.insert(player.hurtby,enemytype)
	end
end
