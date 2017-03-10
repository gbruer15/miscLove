level = {}
level._index = level

function level.load()
	--[[
	level.stuff = {newRectangle(-camera.width/2-340, -camera.height/1.5 + 30, 100, camera.height, {math.random(0,16)*16-1,55,math.random(0,2)*94}, "deathtrap"),newRectangle(150, 0, 200, 100, {math.random(0,16)*16-1,55,math.random(0,2)*94}, "level"), newRectangle(200, -50, 100, 50, {math.random(0,16)*16-1,55,math.random(0,2)*94},"level")}
	table.insert(level.stuff, newRectangle(-camera.width/2-340, 100, camera.width + 340, 100, {math.random(0,16)*16-1,55,math.random(0,2)*94}, "level") )
	table.insert(level.stuff, newRectangle(camera.width/2-100, 200, 100, 200, {math.random(0,16)*16-1,55,200}, "level") )
	table.insert(level.stuff, newRectangle(camera.width/2-100, 250, 700, 100, {math.random(0,16)*16-1,55,math.random(0,2)*94}, "level") )
	table.insert(level.stuff, newRectangle(camera.width/2+500, -300, 100, 700, {math.random(0,16)*16-1,55,math.random(0,2)*94}, "level") )
	table.insert(level.stuff, newRectangle(-1700, 1000-900, 100, 900, {math.random(0,16)*16-1,55,math.random(0,2)*94}, "level") )
	table.insert(level.stuff, newRectangle(2000, 1000-900, 100, 900, {math.random(0,16)*16-1,55,math.random(0,2)*94}, "level") )
	
	levely = 1000
	table.insert(level.stuff, newRectangle(camera.width/2, 120+100, 500, 290-100, {0,55,188,155}, "liquid") )
	--table.insert(level.stuff, newRectangle(-625, -1000, 1500, 290-100, {0,55,188,155}, "liquid") )
	
	table.insert(level.stuff, newRectangle(-1610,levely - 500, 2620, 505, {0,55,188,155}, "liquid") )
	table.insert(level.stuff, newRectangle(1000,levely - 1000, 1000, 1005, {128,64,0,160}, "deathtrap", 1000 + 1000, levely - 1000 + 1008) )
	
	--table.insert(level.stuff, newRectangle(-camera.width/2-350, -camera.height/1.5, 100, camera.height, {0,55,188,155}, "liquid") )

	
	table.insert(level.stuff, newRectangle(-1700,levely - 6, 3800, 100, {128,64,255}, "level"))
	
	--]]
	
	level.stuff = {}
	
	table.insert(level.stuff, newRectangle(0,-500,100,600,{100,100,100},"level"))
	table.insert(level.stuff, newRectangle(100,0,800,100,{100,100,100},"level"))
	
	levely = 1000
	level.startx = 260
	level.starty = -175
	
	watercolor = {0,55,188,155}

end


function level.draw(type)
	if type == 'liquid' then
		level.drawWater()
	elseif type == 'level' then
		level.drawLevel()
	else
		level.drawWater()
		level.drawLevel()
	end

end



function level.drawWater()
	for i,rect in pairs(level.stuff) do
		if i ~= "y" then
			if rect.medium == "liquid" or rect.medium == "deathtrap" then
				if collision.rectangles(rect.x,rect.y,rect.width,rect.height, getWorldScreenRect()) then
					--if rect.medium == 'deathtrap' then
					if rect.color then 
						love.graphics.setColor(unpack(rect.color))
					end
					love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
				end
			end
		end
	end
end

function level.drawLevel()
	for i,rect in pairs(level.stuff) do
		if i ~= "y" then
			if rect.medium ~= "liquid" and rect.mediuim ~= "deathtrap" then
				if collision.rectangles(rect.x,rect.y,rect.width,rect.height, getWorldScreenRect()) then
					if rect.color then 
						love.graphics.setColor(unpack(rect.color))
					end
					love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
				end
			end
		end
	end
end
