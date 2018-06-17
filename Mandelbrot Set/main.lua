io.stdout:setvbuf("no")

function love.load()
	window = {}
	window.width, window.height = love.graphics.getDimensions()
	--[[
	For each pixel (Px, Py) on the screen, do:
		{
		  x0 = scaled x coordinate of pixel (scaled to lie in the Mandelbrot X scale (-2.5, 1))
		  y0 = scaled y coordinate of pixel (scaled to lie in the Mandelbrot Y scale (-1, 1))
		  x = 0.0
		  y = 0.0
		  iteration = 0
		  max_iteration = 1000
		  while ( x*x + y*y < 2*2  AND  iteration < max_iteration )
		  {
			xtemp = x*x - y*y + x0
			y = 2*x*y + y0
			x = xtemp
			iteration = iteration + 1
		  }
		  color = palette[iteration]
		  plot(Px, Py, color)
		}
	--]]
	remakeFractal = true
	
	fractalXscale = window.width
	fractalYscale = window.height
	if remakeFractal then
		--makeMainFractal()
		makeFractalPart(fractalXscale*0.4,fractalYscale*0.2,fractalXscale*0.2,fractalYscale*0.2,8000,60)
	end
	fractal = {}
	fractal.image = love.graphics.newImage('image.png')
	fractal.imagewidth,fractal.imageheight = fractal.image:getWidth(), fractal.image:getHeight()
	
	
	camera = {}
	camera.xscale, camera.yscale = 1,1
	camera.x,camera.y = 0,0
	camera.speed = 200
end


function love.update(dt)
	if love.keyboard.isDown('a') then
		camera.x = camera.x - camera.speed*dt/camera.xscale
	end
	
	if love.keyboard.isDown('d') then
		camera.x = camera.x + camera.speed*dt/camera.xscale
	end
	
	if love.keyboard.isDown('w') then
		camera.y = camera.y - camera.speed*dt/camera.yscale
	end
	
	if love.keyboard.isDown('s') then
		camera.y = camera.y + camera.speed*dt/camera.yscale
	end
	love.timer.sleep(1/160)
end


function love.draw()

	love.graphics.push()
	
	love.graphics.translate(window.width/2,window.height/2)
	love.graphics.scale(camera.xscale,camera.yscale)
	love.graphics.translate(-window.width/2 - camera.x,-window.height/2-camera.y)
		
	love.graphics.draw(fractal.image,0,0,0,window.width/fractal.imagewidth, window.height/fractal.imageheight)
		--[[
	for Px=0,window.width do
		for Py=0,window.height do
			love.graphics.setColor(points[Px][Py])
			love.graphics.circle("fill",Px,Py,1)
		end
	end--]]
	
	love.graphics.pop()
end


function love.keypressed(key)
	if  key == 'escape' then
		love.event.quit()
	elseif key == '-' then
		camera.xscale,camera.yscale = camera.xscale/2,camera.yscale/2
	elseif key == '=' then
		camera.xscale,camera.yscale = camera.xscale*2, camera.yscale*2
	end
end


function makeMainFractal()
	makeFractalPart(0,0,fractalXscale,fractalYscale, 1000, 2000)
end

function makeFractalPart(startX,startY,fractalWidth,fractalHeight,imageSize,max_iteration,name)
	
	imageSize = imageSize or 200
	ImageData = love.image.newImageData(imageSize,imageSize)
	
	max_iteration = max_iteration or 100
	local Px,Py = startX,startY
	
	local dx = fractalWidth/imageSize
	local dy = fractalHeight/imageSize*2
	
	while Px < startX + fractalWidth do
		while Py < startY + fractalHeight do
			local x0 = Px/fractalXscale*3.5 - 2.5
			local y0 = Py/fractalYscale*2 - 1
	
			local x = 0
			local y = 0
			local i = 0
			while x*x + y*y < 4 and i <= max_iteration do
				x,y = x*x-y*y + x0, 2*x*y + y0
				i = i + 1
			end
			 
			local color = ((i-1)/max_iteration)
			--points[Px][Py] = {color,color,color}
			--print('Px: ' .. math.floor((Px-startX)/fractalXscale*imageSize) .. '\tPy: ' .. math.floor((Py-startY)/fractalYscale*imageSize))
			-- print ((Px-startX)/fractalXscale*imageSize/255,(Py-startY)/fractalYscale*imageSize/255,color/2,(color)^0.5/math.sqrt(255),color)
			ImageData:setPixel(math.floor((Px-startX)/fractalXscale*imageSize),math.floor((Py-startY)/fractalYscale*imageSize),color/2,(color)^0.5/math.sqrt(255),color)
			Py = Py + dy
		end
		print(Px)
		Py = startY
		Px = Px + dx
	end

	ImageData:encode('png', "image.png")
end
