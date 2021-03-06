
function initializePhysics()
	objects = {}
	GRAVCONSTANT = 5
end


function createObject(traitlist) --grav is pixels per second per second,  rotation speed is in radians per second
	
		
	table.insert(objects, {})
	local n = #objects
	
	objects[n] = {xspeed = traitlist.xspeed or 0, yspeed = traitlist.yspeed or 0,xgravity = traitlist.xgrav or 0, ygravity = traitlist.ygrav or 0, xposition = traitlist.xposition or 0, yposition = traitlist.yposition or 0, mass = traitlist.mass or 1,rotation = traitlist.rotation or 0, rotationspeed = traitlist.rotationspeed or 0, bounciness = traitlist.bounciness or 1, airdamping = traitlist.airdamping or 0, shapepoints = traitlist.shapepoints or {}, kind = "movable", shape = traitlist.shape or 'polygon', color = traitlist.color}
	return objects[n]
end

function createImmovableObject(traitlist) --grav is pixels per second per second,  rotation speed is in radians per second
	
		
	table.insert(objects, {})
	local n = #objects
	
	if traitlist.shapepoints == nil then
		error("You didn't give me a shape info")
	end
	
	objects[n] = {xspeed = traitlist.xspeed or 0, yspeed = traitlist.yspeed or 0,xgravity = traitlist.xgrav or 0, ygravity = traitlist.ygrav or 0, xposition = traitlist.xposition or 0, yposition = traitlist.yposition or 0, mass = traitlist.mass or 1,rotation = traitlist.rotation or 0, rotationspeed = traitlist.rotationspeed or 0, bounciness = traitlist.bounciness or 1, airdamping = traitlist.airdamping or 0, shapepoints = traitlist.shapepoints, kind = "immovable", shape = traitlist.shape or 'polygon', color = traitlist.color}
	return objects[n]
end


function updatePhysics(dt)
	for i,thing in pairs(objects) do
		thing.xposition = thing.xposition + thing.xspeed*dt
		thing.yposition = thing.yposition + thing.yspeed*dt
		
		if mass~=0 then
			thing.xspeed = thing.xspeed + thing.xgravity*dt*GRAVCONSTANT
			thing.yspeed = thing.yspeed + thing.ygravity*dt*GRAVCONSTANT
		end
		
		thing.xspeed = thing.xspeed * (1-thing.airdamping*dt)
		thing.yspeed = thing.yspeed * (1-thing.airdamping*dt)
		
		thing.rotation = thing.rotation + thing.rotationspeed*dt
		while thing.rotation > math.pi * 2 do
			thing.rotation = thing.rotation - 2*math.pi
		end
		while thing.rotation < 0 do
			thing.rotation = thing.rotation + 2*math.pi
		end
	end
	
end

function updateObject(thing, dt)
	thing.xposition = thing.xposition + thing.xspeed*dt
	thing.yposition = thing.yposition + thing.yspeed*dt
	
	if mass ~= 0 then
		thing.xspeed = thing.xspeed + thing.xgravity*dt
		thing.yspeed = thing.yspeed + thing.ygravity*dt
	end
end

function applyForce(object, xforce, yforce,dt)
	if mass ~=0 then
		object.xspeed = object.xspeed + (xforce/object.mass)*dt
		object.yspeed = object.yspeed + (yforce/object.mass)*dt
	else
		object.xspeed = object.xspeed + xforce*dt
		object.yspeed = object.yspeed + yforce*dt	
	end
end

function drawObject(thing)
	if thing.color then
		love.graphics.setColor(unpack(thing.color))
	else
		love.graphics.setColor(255,255,255)
	end
	
	if thing.shape =='circle' then
		love.graphics.circle("fill", thing.xposition, thing.yposition, thing.shapepoints)
	elseif thing.shape=='rectangle' then
		love.graphics.rectangle('fill', thing.xposition + thing.shapepoints[1], thing.yposition + thing.shapepoints[2], thing.shapepoints[3], thing.shapepoints[4])
	elseif thing.shape=='polygon' then
		local n = 1
		local list = {}
		
		while n <= #thing.shapepoints do
			if n/2 == math.floor(n/2) then
				table.insert(list, thing.shapepoints[n]+thing.yposition)
			else 
				table.insert(list, thing.shapepoints[n]+thing.xposition)
			end
			n = n + 1
		end
		
		love.graphics.line(unpack(list))
	end
end

function drawAllObjects()
	for i,thing in pairs(objects) do
		if thing.color then
			love.graphics.setColor(unpack(thing.color))
		else
			love.graphics.setColor(255,255,255)
		end
		if thing.shape =='circle' then
			love.graphics.circle("fill", thing.xposition, thing.yposition, thing.shapepoints)
		elseif thing.shape=='rectangle' then
			love.graphics.rectangle('fill', thing.xposition + thing.shapepoints[1], thing.yposition + thing.shapepoints[2], thing.shapepoints[3], thing.shapepoints[4])
		elseif thing.shape=='polygon' then
			local n = 1
			local list = {}
			
			while n <= #thing.shapepoints do
				if n/2 == math.floor(n/2) then
					table.insert(list, thing.shapepoints[n]+thing.yposition)
				else 
					table.insert(list, thing.shapepoints[n]+thing.xposition)
				end
				n = n + 1
			end
			
			love.graphics.line(unpack(list))
		end
	end
end

function whenObjectsCollide(object1, object2)
	



end