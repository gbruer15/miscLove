
function love.load()

	-- this creates the following function with x on [-1.290134, 8.9843432] and y on [-1,1])
	-- x = sin(at) + bt  where a = 2.8 and b = 0.4898285482
	-- y = sin(t)
	
	points = {}
	
	a = 2.8
	b =  0.4898285482
	c = 1
	d = 1
	e = 1.6*math.pi
	f = 1.4*math.pi
	
	makePoints(a,b,c)
	
	aRate = 1.1
	bRate = 1.1
	cRate = 1.1
	dRate = 1
	eRate = 1
	fRate = 1
end

function love.update(dt)
	if love.keyboard.isDown('a') then
		a = a - a*aRate*dt
		makePoints(a,b,c)
	elseif love.keyboard.isDown('d') then
		a = a + a*aRate*dt
		makePoints(a,b,c)
	end
	
	if love.keyboard.isDown('w') then
		b = b + bRate*dt
		makePoints(a,b,c)
	elseif love.keyboard.isDown('s') then
		b = b - bRate*dt
		makePoints(a,b,c)
	end
	
	if love.keyboard.isDown('q') then
		c = c + cRate*dt
		makePoints(a,b,c)
	elseif love.keyboard.isDown('e') then
		c = c - cRate*dt
		makePoints(a,b,c)
	end
	
	if love.keyboard.isDown('up') then
		d = d + dRate*dt
		makePoints(a,b,c)
	elseif love.keyboard.isDown('down') then
		d = d - dRate*dt
		makePoints(a,b,c)
	end
	
	if love.keyboard.isDown('left') then
		e = e + eRate*dt
		makePoints(a,b,c)
	elseif love.keyboard.isDown('right') then
		e = e - eRate*dt
		makePoints(a,b,c)
	end
	
	if love.keyboard.isDown('t') then
		f = f + fRate*dt
		makePoints(a,b,c)
	elseif love.keyboard.isDown('g') then
		f = f - fRate*dt
		makePoints(a,b,c)
	end
end


function love.draw()
	
	love.graphics.setColor(1,1,1)
	love.graphics.line(points)
	
	
	love.graphics.print(a,0,0)
	love.graphics.print(b,0,15)
	love.graphics.print(c,0,30)
	love.graphics.print(d,0,45)
	love.graphics.print(e,0,60)
	love.graphics.print(f,0,75)


end

function makePoints()
	local t = -math.pi/2
	local dt = 6*math.pi/20000
	
	local minx = math.huge
	local maxx = -math.huge
	
	local miny = math.huge
	local maxy = -math.huge
	
	local midt = -math.pi/2 + 3*math.pi
	local i = 1
	while t <= 11/2*math.pi do
		local x = c*math.sin(a*t)+b*t
		local y = math.sin(t)
		
		if x > maxx then
			maxx = x
		elseif x < minx then
			minx = x
		end
	
	
		if y > maxy then
			maxy = y
		elseif y < miny then
			miny = y
		end
	
		points[i] = x
		points[i+1] = y
		
		i = i + 2
		t = t + dt
	end
	
	local xwidth = maxx - minx
	local ywidth = maxy - miny
	
	--translate/scale points to fit to screen better
	local width,height = love.graphics.getDimensions()
	
	local padding = 50
	
	for i = 1,#points-1,2 do
		points[i] = (points[i] - minx)/xwidth * (width-padding*2) + padding
		points[i+1] = -(points[i+1] -miny )/ywidth * (height-padding*2) + (height-padding*2) + padding
	end
end


function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	end
end