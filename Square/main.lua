 function love.load()
	screen = {}
	screen.width,screen.height = love.graphics.getDimensions()
	
	
	rectangle = {}
	rectangle.x,rectangle.y = screen.width/2,screen.height/2
	rectangle.width = 500
	rectangle.height = 300
	
	draw = {}
	draw.x,draw.y = rectangle.x,rectangle.y
	draw.radius = 7
	draw.width,draw.height = -300,-500
	draw.widthSpeed = 0
	draw.heightSpeed = 0
	
	draw.midWidth = (rectangle.width+draw.width)/2
	draw.midHeight = (rectangle.height+draw.height)/2
	
	draw.kWidth = 5
	draw.kHeight = 5
	draw.widthAcceleration = draw.kWidth*(draw.midWidth-draw.width)
	draw.maxWidthAcceleration = draw.widthAcceleration
	
	draw.heightAcceleration = draw.kHeight*(draw.midHeight-draw.height)
	draw.maxHeightAcceleration = draw.heightAcceleration
 
	love.graphics.setBackgroundColor(0,100/255,1)
 end
 
 function love.update(dt)
	if dt > 1/50 then
		dt = 1/50
	end
	draw.widthAcceleration = draw.kWidth*(draw.midWidth-draw.width)
	draw.heightAcceleration = draw.kHeight*(draw.midHeight-draw.height)
	
	draw.widthSpeed = draw.widthSpeed + draw.widthAcceleration*dt
	draw.heightSpeed = draw.heightSpeed + draw.heightAcceleration*dt
	
	draw.width = draw.width + draw.widthSpeed*dt
	draw.height = draw.height + draw.heightSpeed*dt
	
	love.window.setTitle(love.timer.getFPS())
 end
 
 
 function love.draw()
	--love.graphics.setColor((1-draw.width/rectangle.width)*255,255 - 255*math.abs(0.5-draw.width/rectangle.width),draw.width/rectangle.width*255)
	--love.graphics.setColor(draw.width/rectangle.width*200,(1-draw.width/rectangle.width)*200,0)
	
	draw.color = {math.abs(draw.widthAcceleration/draw.maxWidthAcceleration),math.abs(draw.widthAcceleration/draw.maxWidthAcceleration),math.abs(draw.widthAcceleration/draw.maxWidthAcceleration)}
	
	love.graphics.setColor(draw.color)
	love.graphics.rectangle("fill", draw.x-draw.width/2,draw.y-draw.height/2,draw.width,draw.height)
	
	love.graphics.setColor(0,0,0)
	love.graphics.setLineWidth(draw.radius)
	love.graphics.rectangle("line", draw.x-draw.width/2,draw.y-draw.height/2,draw.width,draw.height)
	
	--[[
	love.graphics.setColor(220,0,0)
	love.graphics.circle("fill",draw.x-draw.width/2,draw.y-draw.height/2,draw.radius)
	
	love.graphics.setColor(0,220,0)
	love.graphics.circle("fill",draw.x+draw.width/2,draw.y-draw.height/2,draw.radius)
	
	love.graphics.setColor(0,0,220)
	love.graphics.circle("fill",draw.x-draw.width/2,draw.y+draw.height/2,draw.radius)
	
	love.graphics.setColor(255,255,0)
	love.graphics.circle("fill",draw.x+draw.width/2,draw.y+draw.height/2,draw.radius)
	--]]
	
	--[
	love.graphics.setColor(1,1,1)
	love.graphics.print("Width: " .. draw.width,40,40)
	love.graphics.print("Height: " .. draw.height,40,55)
	love.graphics.print("Speed: " .. draw.widthSpeed,40,70)
	love.graphics.print("Acceleration: " .. draw.widthAcceleration,40,85)
	love.graphics.print("Mid: " .. draw.midWidth,40,100)
	
	love.graphics.print("R Width: " .. rectangle.width,40,120)
	--]]
 end