collision = {}

function collision.rectangles(left1,top1,width1,height1, left2,top2,width2,height2)
	collide = (left1 + width1 > left2 and left1 < left2 + width2 and top1 < top2 + height2 and top1 + height1 > top2)
	return collide
end


function collision.rectanglevector(left,top,width,height,  vx,vy,vr,vmag)

end
collision.direction = {}
function collision.direction.rectangles(left1,top1,width1,height1, left2,top2,width2,height2)
	if (left1 >= left2 + width2 and left1 + width1 >= left2 + width2) then
		return "right"
	elseif (left1 <= left2  and left1 + width1 <= left2) then
		return "left"
	elseif (top1 <= top2 and top1 + height1 <= top2)  then
		return "top"
	elseif (top1 >= top2 + height2 and top1 + height1 >= top2 + height2)  then
		return "bottom"
	end	
end


function collision.direction.pointRectangle(px,py, left,top,width,height)  -------UNFINISHED-------
	if px < left and py > top and py < top + height then
		return 'left'
	elseif px > left + width and py > top and py < top + height then
		return 'right'
	elseif py < top and px > left and px < left + width then
		return 'top'
	elseif py > top + height and px > left and px < left + width then
		return 'bottom'
	end
end
--(v.x+(v.width/2)) > (player.x - (player.width/2)) and (v.x-(v.width/2)) < (player.x + (player.width/2)) and (v.y-(v.height/2)) < (player.y+(player.height/2)) and (v.y+(v.height/2)) > (player.y - (player.height/2))


function collision.circles(centerx1,centery1,radius1, centerx2,centery2,radius2)
	return (  ( ((centerx1-centerx2)^2) + ((centery1-centery2)^2) )^0.5 < (radius1 + radius2) )
end

function collision.rectangleCircle(left1,top1,width1,height1, centerx2,centery2,radius2) 
--Just an approximation
	return collision.rectangles(left1,top1,width1,height1, centerx2-radius2,centery2-radius2, radius2*2, radius2*2)
end

function collision.pointRectangle(x,y,  left,top,width,height)
	return (x < left+width and x > left and y > top and y < top + height)
end

function collision.pointCircle(x,y, centerx,centery,radius)
	return (  ( ((x-centerx)^2) + ((y-centery)^2) ) < radius )
end

function collision.lineSegments(ax,ay,bx,by, ox,oy,px,py)
	if (ax > ox and ax > px and bx > ox and bx > px) or (ax < ox and ax < px and bx < ox and bx < px) or (ay > oy and ay > py and by > oy and by > py) or (ay < oy and ay < py and by < oy and by < py) then
		return false
	elseif false then
	
		local aprop = (ax - ox)/(ox-px)
		aabove = ay < oy + (oy-py)*aprop
		
		
		local bprop = (bx - ox)/(ox-px)
		babove = by < oy + (oy-py)*bprop
		
		return aabove ~= babove, aabove,babove, aprop, bprop
	else
		-- y = mx + b
		-- b = y - mx
		local abslope = (ay-by)/(ax-bx)
		local abyinter = ay - abslope*ax
		
		local opslope = (oy-py)/(ox-px)
		local opyinter = oy - opslope*ox
		
		if abslope == opslope then
			return abyinter == opyinter
		else
			--  abslope * x + abyinter = opslope * x + opyinter
			local solux = (opyinter-abyinter)/(abslope-opslope)
			local soluy = abslope * solux + abyinter
			return ((solux > ox and solux < px) or (solux > px and solux < ox)) and ((solux > ax and solux < bx) or (solux < ax and solux > bx)), solux, soluy
		end
		
	end
	
	--[[
	ox + (ox-px) * prop == ax
	prop == (ax - ox)/(ox-px)
	
	linex = ax
	liney = oy + (oy-py)*prop
	--]]
	
	--[[
	x1 =  (ax < ox and bx > px)
	x2 =  (ax < px and bx > ox)
	x3 =  (ax > ox and bx < px)
	x4 =  (ax > px and bx < ox)
	--x =  (ax < ox and bx > px) or (ax < px and bx > ox) or (ax > ox and bx < px) or (ax > px and bx < ox)
	--y =  (ay < oy and by > py) or (ay < py and by > oy) or (ay > oy and by < py) or (ay > py and by < oy)
	y1 =  (ay < oy and by > py)
	y2 =  (ay < py and by > oy)
	y3 =  (ay > oy and by < py)
	y4 =  (ay > py and by < oy)
	return x1,x2,x3,x4,y1,y2,y3,y4	
	--]]
end


function collision.polygons(array1,array2)
	local i = 1
	while i <= #array1-3 do
			
		local n = 1
		while n <=	# array2-3  do
			if collision.lineSegments(array1[i],array1[i+1],array1[i+2], array1[i+3], array2[n],array2[n+1],array2[n+2], array2[n+3]) then
				return true
			end
			n = n + 4
		end
		
		i = i + 4
	end
	
	return false
end
function collision.getBoundingBox(array)
	local left = array[1]
	local right = array[1]
	local top = array[2]
	local bottom = array[2] 
	local odd = true
	for i,v in pairs(array) do
		if odd then
			if v < left then
				left = v
			elseif v > right then
				right = v
			end
		else
			if v < top then
				top = v
			elseif v > bottom then
				bottom = v
			end
		end
		odd = not odd
	end
	
	return left, top, right-left, bottom-top
end