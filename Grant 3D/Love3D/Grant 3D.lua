
screencenterx = 400
screencentery = 300

--X axis is horizontal
--Y axis is vertical
--Z axis is 3D, getting larger going away from you
function newRectangle(xcenter,ycenter,zcenter, sidelength, height, depth, yrotation) 
	height = height or sidelength
	depth = depth or sidelength
	yrotation = yrotation or 0
	
	local left, right = xcenter - 0.5*sidelength, xcenter + 0.5*sidelength
	local top, bottom = ycenter - 0.5*height, ycenter + 0.5*height
	local towards, away = zcenter - 0.5*depth, zcenter + 0.5*depth
	local object = {}
	object.faces ={
		topface = {points = {left,top,towards,  left,top,away,  right,top,away,  right,top,towards}, color ={1,0,0}},
		bottomface = {points = {left,bottom,towards,  left,bottom,away,  right,bottom,away,  right,bottom,towards}, color={0,0,1}},
		leftface = {points = {left,top,towards,  left,top,away,  left,bottom,away,  left,bottom,towards}, color = {0,1,0}},
		rightface = {points = {right,top,towards,  right,top,away,  right,bottom,away,  right,bottom,towards}, color = {0,1,1}},
		towardsface = {points = {left,top,towards,  right,top,towards,  right,bottom,towards,  left,bottom,towards}, color = {1,0,1}},
		awayface = {points = {left,top,away,  right,top,away,  right,bottom,away,  left,bottom,away},color = {1,1,0}}
	}
	
	object.position = {xcenter,ycenter,zcenter}
	object.shape = "cube"
	
	return object
end

function to2d(x,y,z,  Camera, w)
	
	
	local w = w or 0
	--[[
	local point = {w = w,x = x,y = y,z = z}
	local i = multiplyQuaternion(Camera.quaternion, point)
	local vector = multiplyQuaternion(i, inverseQuaternion(Camera.quaternion))
	x,y,z = Camera.x - vector.x, Camera.y-vector.y, vector.z-Camera.z
	]]
	
	local vector = multiplyMatrix( {{x-Camera.x,y-Camera.y,z-Camera.z,w}}, Camera.rotationmatrix)
	x,y,z = vector[1][1],vector[1][2],vector[1][3]
	
	local newx
	local newy
	if z == 0 then
		newx = nil
		newy = nil
	elseif z > 0 then
		newx = (x) / ((z)/Camera.perspective) + 400
		newy = (y) / ((z)/Camera.perspective) + 300
	else
		newx = (x) / ((1)/Camera.perspective)
		newy = (y) / ((1)/Camera.perspective)
		
		local newx1 = (x) / (math.abs(z)/Camera.perspective)
		local newy1 = (y) / (math.abs(z)/Camera.perspective)
		
		newx = newx + newx1 + 400
		newy = newy + newy1 + 300		
	end
	
	return newx,newy
end


--------------------------------------------

function updateCube(Cube, Camera)
	local list = Cube
	list.position = unpack(multiplyMatrix({{list.position[1],list.position[2],list.position[3],0}},Camera.zrotaxis))
	
	for a,b in ipairs(list.faces) do
		i = 1
		while i<=#v.points do
			local vector = multiplyMatrix({{v.points[i], v.points[i+1], v.points[i+2],0}}, Camera.zrotaxis)
			v.points[i],v.points[i+1], v.points[i+2] = vector[1], vector[2], vector[3]
			
			i = i + 2
		end
	end



	return list
end




function drawRectangle(rectangleobject, Camera)
	local zlist = {}
	for a,b in pairs(rectangleobject.faces) do
		local bigdistance = -99999
		local it = 1
		while it <= #b.points-2 do
			local distance = distance3d(b.points[it], b.points[it+1], b.points[it+2], Camera.x, Camera.y, Camera.z)
			if distance > bigdistance then
				bigdistance = distance
			end	
			it = it + 3
		end
		table.insert(zlist,{bigdistance, a})
	end
	
	table.sort(zlist, function(a,b) return a[1]>b[1] end)
	local jd = 1
	for i,v in pairs(zlist) do
		local drawpoints = {}
		local it = 1
		
		while it <= #rectangleobject.faces[v[2]].points-2 do
			local x,y = to2d(rectangleobject.faces[v[2]].points[it], rectangleobject.faces[v[2]].points[it+1], rectangleobject.faces[v[2]].points[it+2], Camera)
			if x ~= nil then
				table.insert(drawpoints, x)
				table.insert(drawpoints, y)
			end
			
			it = it + 3
		end
		
		local n = 1
		
		if #drawpoints > 5 then
			if false then
				love.graphics.setColor(0,0,0)
				love.graphics.polygon("fill", unpack(drawpoints))	
				
				love.graphics.setColor(unpack(rectangleobject.faces[v[2]].color))
				
			else
				
				love.graphics.setColor(unpack(rectangleobject.faces[v[2]].color))
				love.graphics.polygon("fill", unpack(drawpoints))	
				
				love.graphics.setColor(0,0,0)
				table.insert(drawpoints, drawpoints[1])
				table.insert(drawpoints, drawpoints[2])
				love.graphics.line(unpack(drawpoints))	
			end
		end
		love.graphics.setColor(rectangleobject.faces[v[2]].color[1]/1.4,rectangleobject.faces[v[2]].color[2]/1.4,rectangleobject.faces[v[2]].color[3]/1.4)
		--love.graphics.print(v[1], 10, jd*20)
		love.graphics.print(tostring(onscreen), 10, jd*20)
		jd = jd + 1
	end


end


function drawRectangles(array)
	table.sort(array, function (a,b) return math.distanceFromPlane(a.position, Camera.forwardpoint, {Camera.x, Camera.y, Camera.z}) > math.distanceFromPlane(b.position, Camera.forwardpoint, {Camera.x, Camera.y, Camera.z}) end )
	
	for i,v in pairs(array) do
		drawRectangle(v, Camera)
	end


end