background = {}

function background.load()
	
	
	tile = {}
	tile.image = love.graphics.newImage('grass.png')
	tile.imagewidth = tile.image:getWidth()
	tile.imageheight = tile.image:getHeight()
	tile.width = tile.imagewidth
	tile.height = tile.imageheight

end



function background.draw(tile)
	local screenleft,screentop = getWorldScreenRect()
	local left = math.floor( screenleft /tile.width )  * tile.width 
	
	local x = left
	
	local right = left + camera.width + tile.width
	
	local top = math.floor( screentop /tile.height )  * tile.height
	
	local bottom = top + camera.height + tile.height
	
	local y = top
	
	love.graphics.setColorMode('replace')
	
	while y < bottom  do
	
		while x < right do
			
			love.graphics.draw(tile.image, x,y, 0, tile.width/tile.imagewidth, tile.height/tile.imageheight)
			
			x = x + tile.width
		end
		
		y = y + tile.height
		x = left
	end
	
	love.graphics.setColorMode('modulate')
	
end
