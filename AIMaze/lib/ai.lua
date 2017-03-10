
ai = {}

function ai.load()
	
	ai.info = false
	ai.x,ai.y = 0,500
	ai.radius = 15
	
	ai.state = 'navigate'
	
	ai.angle = math.pi/2 - 0.001
	ai.lookangle = math.pi/6
	
	ai.pointlength = 25
	ai.pointangle = math.pi/9
	
	ai.maxa = 400 --max acceleration pixels per square second
	ai.maxs = 100 -- max speed
	ai.maxr = math.pi -- max rotationspeed
	
	ai.maxra = math.pi/2
	ai.xacc,ai.yacc = 0,0
	ai.xspeed,ai.yspeed = 0,1
	ai.speed = 50
	ai.rspeed = 0
	ai.racc = 0
	
	
	ai.arriveradius = ai.radius
	ai.arrived = true
	ai.alignstopradius = math.pi/24
	ai.alignslowradius = math.pi/6
	
	ai.targetangle = ai.angle
	ai.anglearrived = true
	
	ai.wandcircle = {}
	ai.wandcircle.radius = 60
	ai.wandcircle.distance = ai.radius + 50
	
	ai.clear = {}
	ai.checkn = 1
	ai.lookahead = 35
	ai.targetx,ai.targety = 0,0
	target = {}
	
	
	ai.leftx = ai.x + math.cos(ai.angle-math.pi/2)*ai.radius
	ai.lefty = ai.y + math.sin(ai.angle-math.pi/2)*ai.radius
	
	ai.rightx = ai.x + math.cos(ai.angle+math.pi/2)*ai.radius
	ai.righty = ai.y + math.sin(ai.angle+math.pi/2)*ai.radius
	
	ai.lefthit = false
	ai.righthit = false
	
end


function ai.update(dt)
	
	ai.navigateMaze(dt)
	ai.xspeed = ai.xspeed + ai.xacc*dt
	ai.yspeed = ai.yspeed + ai.yacc*dt
	

	if ai.speed > ai.maxs then
		ai.xspeed = ai.xspeed/ai.speed*ai.maxs
		ai.yspeed = ai.yspeed/ai.speed*ai.maxs
	end
	ai.x = ai.x + ai.xspeed*dt
	ai.y = ai.y + ai.yspeed*dt
	
	ai.rspeed = ai.rspeed + ai.racc*dt
	ai.angle = ai.angle + ai.rspeed*dt
	

end

function ai.draw()
	
	love.graphics.setColor(0,0,220)
	
	local x1,y1 = ai.pointlength*math.cos(ai.angle),ai.pointlength*math.sin(ai.angle)
	local x2,y2 = ai.radius*math.cos(ai.angle+ai.pointangle),ai.radius*math.sin(ai.angle+ai.pointangle)
	local x3,y3 = ai.radius*math.cos(ai.angle-ai.pointangle),ai.radius*math.sin(ai.angle-ai.pointangle)
	love.graphics.polygon("fill", ai.x+x1,ai.y+y1, ai.x+x2,ai.y+y2, ai.x+x3, ai.y+y3)

	love.graphics.setColor(220,0,0)
	if ai.state == 'wander' then
		love.graphics.setColor(220,0,0,150)
	end
	
	love.graphics.circle("fill",ai.x,ai.y,ai.radius)
	
	love.graphics.setColor(255,255,0)
	if target.x then
		love.graphics.circle("fill",target.x,target.y,10)
	end
	
	if ai.info then
		love.graphics.setColor(100,100,100)
		love.graphics.circle("fill", ai.leftx,ai.lefty,4)
		love.graphics.setColor(200,200,200)
		love.graphics.circle("fill", ai.rightx,ai.righty,4)
	
		love.graphics.setColor(255,0,0)
		love.graphics.setLineWidth(1)
		love.graphics.line(ai.leftx,ai.lefty, ai.leftx+ math.cos(ai.angle)*ai.lookahead, ai.lefty +  math.sin(ai.angle)*ai.lookahead)
	
		love.graphics.line(ai.rightx,ai.righty, ai.rightx+ math.cos(ai.angle)*ai.lookahead, ai.righty +  math.sin(ai.angle)*ai.lookahead)
	end
end










function ai.seek(tx,ty)
	if tx == ai.x and ty == ai.y then
		return 
	end
	tx = tx-ai.x
	ty = ty-ai.y
	
	local mag = (tx*tx + ty*ty)^0.5
	tx = tx/mag
	ty = ty/mag
	return tx*ai.maxa,ty*ai.maxa --these are unit vector components of acceleration
end

function ai.flee(tx,ty)
	if tx == ai.x and ty == ai.y then
		return 
	end
	tx = ai.x-tx
	ty = ai.y-ty
	
	local mag = (tx*tx + ty*ty)^0.5
	tx = tx/mag
	ty = ty/mag
	return tx*ai.maxa,ty*ai.maxa --these are unit vector components of acceleration
end



function ai.arrive(tx,ty,timetot)
	if not tx then
		return 0,0
	end
	
	if tx == ai.x and ty == ai.y then
		ai.arrived = true
		return 0,0
	end
	tx = tx-ai.x
	ty = ty-ai.y
	
	local mag = (tx*tx + ty*ty)^0.5
	if mag < ai.arriveradius then
		ai.arrived = true
		return 0,0
	end
	
	ai.arrived = false
	tx = tx/timetot
	ty = ty/timetot

	return tx,ty
end


function ai.wander(dt)

	ai.xspeed = math.cos(ai.angle)*ai.maxs
	ai.yspeed = math.sin(ai.angle)*ai.maxs

	


	if not ai.arrived then
		ai.xspeed,ai.yspeed = ai.arrive(ai.targetx,ai.targety,0.1)
		ai.align()
	else
		local rang = math.random()*2*math.pi
		
		
		ai.targetx = ai.x + ai.wandcircle.radius*math.cos(rang)+ai.wandcircle.distance*math.cos(ai.angle)
		ai.targety = ai.y + ai.wandcircle.radius*math.sin(rang)+ai.wandcircle.distance*math.sin(ai.angle)
		ai.xspeed,ai.yspeed = ai.arrive(ai.targetx,ai.targety,0.1)
		
		ai.targetangle = math.atan2(ai.targety - ai.y, ai.targetx-ai.x)
		ai.align()
	end

end


function ai.align()

	ai.targetangle = ai.targetangle - 2*math.pi*math.floor(ai.targetangle/(2*math.pi))
	local r = ai.targetangle - ai.angle
	ai.racc = 0
	
	if r > math.pi then 
		r = r - 2*math.pi
	elseif r < -math.pi then
		r = r + 2*math.pi
	end
	
	local absr = math.abs(r)
	
	if absr < ai.alignstopradius then
		ai.rspeed = 0
		ai.angle = ai.targetangle
		ai.anglearrived = true
		return 
	end
	ai.anglearrived = false
	
	if absr > ai.alignslowradius then
		ai.rspeed = ai.maxr*r/absr
	else
		ai.rspeed = ai.maxr*r/ai.alignslowradius
	end
	
	
end

function ai.navigateMaze(dt)
	ai.leftx = ai.x + math.cos(ai.angle-math.pi/2)*ai.radius
	ai.lefty = ai.y + math.sin(ai.angle-math.pi/2)*ai.radius
	
	ai.rightx = ai.x + math.cos(ai.angle+math.pi/2)*ai.radius
	ai.righty = ai.y + math.sin(ai.angle+math.pi/2)*ai.radius
	
	ai.lefthit = false
	ai.righthit = false

	for i,v in pairs(level.blocks) do
		if not ai.lefthit and collision.lineRectangle(ai.leftx,ai.lefty, ai.leftx +  math.cos(ai.angle)*ai.lookahead, ai.lefty +  math.sin(ai.angle)*ai.lookahead, v.x,v.y,v.width,v.height) then
			ai.lefthit = true
			if ai.righthit then
				break
			end
		end
		
		if not ai.righthit and collision.lineRectangle(ai.rightx,ai.righty, ai.rightx + math.cos(ai.angle)*ai.lookahead, ai.righty +  math.sin(ai.angle)*ai.lookahead, v.x,v.y,v.width,v.height) then
			ai.righthit = true
			if ai.lefthit then
				break
			end
		end
	end
	
	if ai.state == 'navigate' then
		if ai.lefthit then	
			if ai.righthit then
				ai.state = 'scout'
				ai.checkn = 1
				ai.targetangle = ai.angle+math.pi/2
			else
				ai.rspeed = 1
			end
			ai.xspeed = 0
			ai.yspeed = 0
		else
			if ai.righthit then
				ai.rspeed = -1
				ai.xspeed = 0
				ai.yspeed = 0
			else
				if ai.rspeed == 0 then
					ai.rspeed = (math.random(1,2)*2-3)*math.random()*ai.maxr
				else
					ai.racc = -ai.maxra *ai.rspeed/ai.maxr
				end

				ai.xspeed = ai.speed*math.cos(ai.angle)
				ai.yspeed = ai.speed*math.sin(ai.angle)
			end
		end

	end
	
	if ai.state == 'scout' then
		ai.align()
		if ai.anglearrived then
			if not (ai.lefthit or ai.righthit) then
				table.insert(ai.clear,ai.checkn)
			end
			
			if ai.checkn > 2 then
				if ai.checkn > 3 then
					ai.state = 'navigate'
					ai.checkn = 0
					ai.clear = {}
				else
					if #ai.clear ~= 0 then
						ai.chosen = ai.clear[math.random(1,#ai.clear)]
						ai.targetangle = ai.angle - math.pi/2 * (3- ai.chosen)
					else
						ai.chosen = 'none'
						ai.targetangle = ai.angle - math.pi/2
					end					
				end
			else
				ai.targetangle = ai.angle - math.pi/2
			end
			ai.checkn = ai.checkn+1
		end
	end
end

function randomBinomial()
	return math.random() - math.random()
end
