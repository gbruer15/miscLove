 
states = {} 

 -------------------------------------  Menu  ---------------------------------
 ------------------------------------------------------------------------------
states.titlemenu = {}
function states.titlemenu.load()
	
	if (music.title.music:isStopped() or music.title.music:isPaused()) then
		love.audio.stop()
		music.title.music:setLooping(true)
		
		
		music.title.music:rewind()
		music.title.music:play()
	end
	
	
	title = {}
	title.text = "Adventures"
	title.font = defaultfont[64]
	
	title.width = title.font:getWidth(title.text)
	title.height = title.font:getHeight()
	
	title.x = window.width/2 - title.width/2
	title.y = 60
	
	state = 'titlemenu'
	for i,v in pairs(lovefunctions) do
		love[v] = states[state][v]
	end
	
	states.titlemenu.buttons = {}
	states.titlemenu.buttons.play = button.make{text="Play",width=160,height=60,x=window.width/2-160/2,y=300,font=defaultfont[48], textcolor ={230,230,230}}
	states.titlemenu.buttons.options = button.make{text="Options",width=170,height=60,x=window.width/2-170/2,y=370,font=defaultfont[36], textcolor={0,0,0}}
	states.titlemenu.buttons.leveleditor = button.make{text="Level Editor",width=160,height=40,x=window.width/2-160/2,y=440,font=defaultfont[24], textcolor={0,0,0}}
	states.titlemenu.buttons.quit = button.make{text="Quit",width=60,height=25,x=window.width/2-60/2,y=490,font=defaultfont[14], textcolor={40,0,0}}
	
end

function states.titlemenu.update(dt)
	
	for i,b in pairs(states.titlemenu.buttons) do
		b:update()
	end
end

function states.titlemenu.draw()
	
	love.graphics.setColor(0,162,232)
	love.graphics.rectangle('fill', 0,0,window.width,window.height)
	love.graphics.setColor(200,0,150)
	love.graphics.rectangle("fill", title.x - 100,title.y-20,title.width+200, title.height+40)
	
	love.graphics.setColor(0,0,150)
	love.graphics.setLineWidth(10)
	love.graphics.rectangle("line", title.x - 100 + 5,title.y-20 + 5,title.width+200-10, title.height+40-10)
	
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(title.font)
	love.graphics.print(title.text,title.x,title.y)
	
	for i,b in pairs(states.titlemenu.buttons) do
		b:draw()
	end
	
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(defaultfont[24])
	love.graphics.print("Music mostly by Joel Eaton", 40,270,-math.pi/10)
end


function states.titlemenu.mousepressed(x,y,button)
	for i,b in pairs(states.titlemenu.buttons) do
		if b.hover then
			if i =='play' then
				states.fileselect.load()
			elseif i =='quit' then
				QUIT = true
			elseif i == 'options' then
				states.mainoptions.load()
			end
		end
		
	end
end

function states.titlemenu.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key ==' ' then
		states.fileselect.load()
	elseif key == 'f' then
		window.fullscreen = not window.fullscreen
		love.graphics.setMode( window.width, window.height, window.fullscreen)
	end
end

------------------------------------  Options  --------------------------------
-------------------------------------------------------------------------------
states.mainoptions = {}
 function states.mainoptions.load()
	
	
	
	state = 'mainoptions'
	for i,v in pairs(lovefunctions) do
		love[v] = states[state][v]
	end
	
	states.mainoptions.buttons = {}
	states.mainoptions.buttons.back = button.make{text="Back",width=160,height=60,x=window.width-180,y=520,font=defaultfont[24], textcolor ={230,230,230}}
	
	states.mainoptions.sliders = {}
	states.mainoptions.sliders.titlevolume = slider.make{value=music.title.music:getVolume(),text="Title Music",x = 40,y=100, font=defaultfont[24], color={120,120,255}, multiplyer= 100, round=0.01}
	states.mainoptions.sliders.fightvolume = slider.make{value=music.fight.music:getVolume(),text="Battle Music",x = 40,y=170, font=defaultfont[24], color={120,120,255}, multiplyer= 3,round = 0.33333333333333333333333333}
 end
 
 function states.mainoptions.update()
	music.title.music:setVolume(states.mainoptions.sliders.titlevolume.value)
	music.fight.music:setVolume(states.mainoptions.sliders.fightvolume.value)
	for i,b in pairs(states.mainoptions.buttons) do
		b:update()
	end
	for i,s in pairs(states.mainoptions.sliders) do
		s:update()
	end
 end
 
 function states.mainoptions.draw()
	love.graphics.setBackgroundColor(255,0,255)
	for i,b in pairs(states.mainoptions.buttons) do
		b:draw()
	end
	
	for i,s in pairs(states.mainoptions.sliders) do
		s:draw()
	end
 end
 
 function states.mainoptions.mousepressed(x,y,button)
	for i,b in pairs(states.mainoptions.buttons) do
		if b.hover then
			if i =='back' then
				states.titlemenu.load()
			end
		end
	end
	
	for i,s in pairs(states.mainoptions.sliders) do
		if s.hover then
			if s.selected then
				s.value = (x - s.x)/s.width
			else
				s.selected = true
			end
		elseif collision.pointRectangle(x,y,s.x + s.width * s.value - s.arrowwidth/2, s.y - s.arrowheight*0.6,s.arrowwidth, s.arrowheight) then
			s.mouseoffx = s.x + s.width*s.value - x
			s.selected = true
		else
			s.selected = false
			s.mouseoffx = 0
		end
	end
 end
 
 function states.mainoptions.mousereleased(x,y,button)
	
 end
 
 function states.mainoptions.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'b' then
		love.titlemenu.load()
	end
	
 end

 ------------------------------  File Select Screen  --------------------------
 ------------------------------------------------------------------------------
states.fileselect = {}
function states.fileselect.load()

	states.fileselect.buttons = {}
	
	local height = window.height * 0.17
	local width = window.width*0.75
	local spacing = 20
	local top = 180
	states.fileselect.buttons.one = button.make{text="1",width=width,height=height,x=window.width/2-width/2,y=top,font=defaultfont[48], textcolor ={230,230,230}}
	states.fileselect.buttons.two = button.make{text="2",width = width,height =height,x=window.width/2-width/2,y=top+height+spacing,font=defaultfont[48], textcolor ={230,230,230}}
	states.fileselect.buttons.three = button.make{text="3",width=width,height=height,x=window.width/2-width/2,y=top+height+spacing+height+spacing,font=defaultfont[48], textcolor ={230,230,230}}
	states.fileselect.buttons.back = button.make{text="Back to Title",height=40,x=window.width-200,y=555,font=defaultfont[24], textcolor={0,0,0}}
	
	love.graphics.setBackgroundColor(0,0,0)
	
	state = 'fileselect'
	for i,v in pairs(lovefunctions) do
		love[v] = states[state][v]
	end
	
end

function states.fileselect.update()
	for i,b in pairs(states.fileselect.buttons) do
		b:update()
	end
end

function states.fileselect.draw()

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(defaultfont[64])
	love.graphics.print("File Select",120,50)
	

	for i,b in pairs(states.fileselect.buttons) do
		b:draw()
	end
end

function states.fileselect.mousepressed(x,y,button)
	for i,b in pairs(states.fileselect.buttons) do
		if b.hover then
			if b.selected or i == 'back' then
				if i == 'back' then
					states.titlemenu.load()
				else
					states.game.load(true)
				end
			else
				b.selected = true
			end
		else
			b.selected = false
		end
		
	end
end

function states.fileselect.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

 --------------------------------  Loading Screen  ----------------------------
 ------------------------------------------------------------------------------
states.loadingscreen = {}
function states.loadingscreen.load(nextone,speed,...)
	dotdelay = 0.74
	love.audio.stop()	
	
	music.loading.music:play()
	
	startingtime = love.timer.getTime()
	t = {"",".","..","..."}
	dotcounter = 1
	
	loadspeed = speed or 1
	nextstate = nextone
	state = 'loadingscreen'	
	
	if states[nextstate].loaded then
		states[nextstate].load(unpack(...))
	else
		states[nextstate].loaded = true
	end
	for i,v in pairs(lovefunctions) do
		love[v] = states[state][v]
	end
	
	states.loadingscreen.percentdone = 0
	up = 1
end

function states.loadingscreen.update(dt)
	if love.timer.getTime() - startingtime > dotdelay * dotcounter then
		dotcounter = dotcounter + 1
		if math.random() < 1 then
			if up == 1 then
				if math.random() < 0.02 then
					up = -up
				end
			else
				if math.random() < 0.8 then
					up = -up
				end
			end
		end
	else
		if math.random() < 0.3 then
			states.loadingscreen.percentdone = states.loadingscreen.percentdone + math.random(-50,250)/2*dt * up * loadspeed
		end
	end 
	if states.loadingscreen.percentdone >= 100 then
		states[nextstate].load()	
	end
end

function states.loadingscreen.draw()
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setFont(defaultfont[64])
	love.graphics.setColor(255,255,255)
	love.graphics.print("Loading" .. t[dotcounter-math.floor((dotcounter-1)/#t)*#t],50,100)
	
	love.graphics.setLineWidth(2)
	love.graphics.rectangle('line', 50,400,700,30)
	
	love.graphics.setColor(0,200,0)
	love.graphics.rectangle('fill', 50+2,400+2, (700-4)*states.loadingscreen.percentdone/100, 30-4)
	
	love.graphics.setFont(defaultfont[24])
	love.graphics.setColor(255,255,255)
	love.graphics.print(math.round(states.loadingscreen.percentdone,0.1) .. "%", 350,400+2)
end

function states.loadingscreen.mousepressed(x,y,button)
end

function states.loadingscreen.keypressed(key)
	if key == 'm' then
		states.titlemenu.load()
	else
		states[nextstate].load()
	end
end



 -------------------------------------  Game  ---------------------------------
 ------------------------------------------------------------------------------
states.game = {}
function states.game.load(restart)

		
	--fred = love.thread.newThread("fred","george.lua")
	
	--[[
	if fred:get('error') then
		error(fred:get('error'))
	end
	--]]
	
	
	metersize = 50
	initializePhysics(metersize)
	slowmotion = 1
	
	
	playerfunctions.load(restart)
	hud.load()
	camera.load()
		
	enemies.load()
	
	level.load()
	background.load()
	
	crazycolor = false
	paused = false
	night = false	
 
	state = 'game'
	for i,v in pairs(lovefunctions) do
		love[v] = states[state][v]
	end
	states.game.buttons = {}
	
	love.timer.step()
		
	love.audio.stop()
	
	music.discovery.music:setLooping(true)
	music.discovery.music:rewind()
	music.discovery.music:play()
	
	charactercode = 1
	
end
 
function states.game.update(dt)
	if dt > 1/30  then
		dt = 1/30
	end
	dt = dt * slowmotion
	
	if not paused then
		playerfunctions.update(dt)
		playerfunctions.updateWeapons(dt)
		
		hud.update(dt)
		
		enemies.update(dt)
		
		camera.update(dt)
		
	end
	
end
 
function states.game.draw()	

	if not paused or true then
		camera.set()
		
		if clear and not night then
			background.draw(tile)
		end
		
		level.drawLevel()
		
		love.graphics.setColor(100,100,0)
		
		enemies.draw()
		
		playerfunctions.drawWeapons()
		playerfunctions.draw()
		
		level.drawWater()

		local x,y = love.mouse.getPosition()
		local worldx,worldy = getWorldPoint(x,y)--camera.x+(x-camera.width/2),camera.y+(y-camera.height/2)
		if clear then love.graphics.circle("fill",worldx,worldy,3) end
		
		love.graphics.setFont(defaultfont[64])
		love.graphics.setColor(255,255,255)
		love.graphics.print("Shop",168,0)
		camera.unset()
	end
	hud.draw()
	if not paused or true then
		if player.hurttime > 0 then
			if player.hp > 0 then
				love.graphics.setColor(255,0,0, player.hurttime/player.maxhurttime*200 )
				love.graphics.rectangle("fill", 0,hud.height, camera.width,camera.height)
			else
				love.graphics.setColor(255,0,0, 255 - (player.hurttime/player.maxhurttime)^10 * 255 )
				--love.graphics.setColor(70,100,255, 255 - (player.hurttime/player.maxhurttime)^10 * 255 )
				love.graphics.rectangle("fill", 0,hud.height, camera.width,camera.height)
				
				love.graphics.setColorMode('modulate')
				--love.graphics.setColor(255,255,255,255 - (player.hurttime/player.maxhurttime) * 255)
				love.graphics.setFont(defaultfont[200])
				love.graphics.setColor(0,0,0,(255 - (player.hurttime/player.maxhurttime) * 255)*0.9)
				love.graphics.print("DEAD",119,102)
				
				love.graphics.setColor(150,0,0,(255 - (player.hurttime/player.maxhurttime) * 255)*0.9)
				love.graphics.print("DEAD",115,100)
			end
		end
	end
	
	if paused then
		love.graphics.setColor(255,255,255,100)
		love.graphics.rectangle("fill", 0,hud.y+hud.height,window.width,window.height-hud.height)
	end
	
	
 
end

function states.game.mousepressed(x,y,button)
	if player.hp > 0 then
		if button == 'l' and player.numberofarrows > 0 then
			player.shooting = "aiming"
			table.insert(player.arrows,{})
			player.arrows[#player.arrows].power = 0
		end
		for i,b in pairs(hud.buttons) do
			if b.hover then
				if i == 'quit' then
					states.titlemenu.load()
				end
			end
		end
	end
	
end

function states.game.keypressed(key)
	if key == "escape" then
		if player.shooting == 'aiming' then
			player.shooting = false
		else
			love.event.quit()
		end
	elseif key == "p" or key == ' ' then
		paused = not paused
	elseif key =="w" then
		if player.jumps < player.maxjumps and not paused and player.hp > 0 then
			player.jumps = player.jumps + 1
			if player.yspeed >= 0 then
				player.yspeed = -80 - 40 *player.jumpability
			else
				player.yspeed = player.yspeed/2 -80 - 40 *player.jumpability
			end
			player.oxygenlevel = player.oxygenlevel - 0.5
			--player.anim.type = "jumping"
			--player.anim.frame = 1
		end
	elseif key == 'lshift' then
		player.quick.speed = 3
	elseif key == "a" or key == 'd' then
		if player.quick.count > 0 and player.quick.count < player.quick.delay then
			player.quick.speed = 2
		else
			player.quick.count = 0
		end
	elseif key == 'r' then
		states.game.load(true)
	elseif key =='n' then
		night = not night
	elseif key =='l' then
		camera.lock = not camera.lock
	elseif key == 'c' then
		crazycolor = not crazycolor
	elseif key == 'j' then
		pawn.jump = not pawn.jump
	elseif key == 'i' then
		info = not info
	elseif key == 'm' then
		if music.discovery.music:isStopped() then
			music.discovery.fastmusic:stop()
			music.discovery.music:play()
		else
			music.discovery.music:stop()
			music.discovery.fastmusic:play()	
		end
	elseif key == 'f' then
		window.fullscreen = not window.fullscreen
		love.graphics.setMode( window.width, window.height, window.fullscreen)
	elseif key == 'h' then
		playerfunctions.damage(1,'foe')
	elseif key == 'o' then
		player.infinitearrows = not player.infinitearrows
	elseif key == '[' then
		charactercode = charactercode + 1
	else
		if key == 'q' or key == 'e' or key == 't' or key == 'x' or key == 'o' or key == 'y' then
			--error("You tried to perform arithmetic. Please be more careful. \n Who knows what that kind of arithmetic could lead to.")
		else
			--error("You pressed the '" .. key .. "' key. This key has no function \n associated with it. Please don't press random keys.")
		end
	end
end

function states.game.mousereleased(x,y,button)
	if button == 'l' and player.shooting == 'aiming' then
		player.shooting = true
	end
end

function states.game.keyreleased (key)
	if key == "a" or key =="d" then
		if not (love.keyboard.isDown('a') or love.keyboard.isDown('d')) then
			player.quick.speed = 1
		end
	end
	
end


 ----------------------------------  Game Over  -------------------------------
 ------------------------------------------------------------------------------
states.gameover = {}
function states.gameover.load()

	yesbutton = button.make{text="Yes.",textcolor={0,150,0},x=217,y=450,width=100,height=50, image=buttonpic, font=defaultfont[24],shadow={x=-3,y=3,width=0,height=0}}
	nobutton = button.make{text="No.",textcolor = {200,0,0},x=483,y=450,width=100,height=50, image=buttonpic, font=defaultfont[24],shadow={x=3,y=3,width=1,height=2}}
	
	love.graphics.setBackgroundColor(255,255,255)
	alpha = 0
	
	state = 'gameover'
	for i,v in pairs(lovefunctions) do
		love[v] = states[state][v]
	end
end

function states.gameover.update(dt)
	yesbutton:update()
	nobutton:update()
	hud.update()
end

function states.gameover.draw()

	love.graphics.setColor(255,0,0)
	--love.graphics.setColor(70,100,255)
	love.graphics.rectangle("fill", 0,hud.height, camera.width,camera.height)
	
	love.graphics.setColorMode('modulate')
	--love.graphics.setColor(255,255,255)
	love.graphics.setFont(defaultfont[200])
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("DEAD",119,102)
	
	love.graphics.setColor(150,0,0)
	love.graphics.print("DEAD",115,100)
		

	alpha = alpha + 1		
	if alpha > 200 then
		alpha = 200
	end
	love.graphics.setColor(0,0,0,alpha*0.5)
	love.graphics.draw(buttonpic,113,315,0,576/buttonpicwidth, 220/buttonpicheight)
	
	love.graphics.setColor(0,100,0,alpha)
	love.graphics.draw(buttonsmalloutlinepic, 95,310,0,612/buttonpicwidth,230/buttonpicheight)
	
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(defaultfont[36])
	love.graphics.printf("Would you like to play again?",225,345, 350,'center')
	
	yesbutton:draw()
	nobutton:draw()
	
	hud.draw()
		
end

function states.gameover.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
function states.gameover.mousepressed(x,y,button)
	if yesbutton.hover then
		states.game.load(true)
		--[[
		player.hp = player.maxhp
		player.oxygenlevel = player.maxoxygenlevel
		player.xposition = level.startx
		player.yposition = level.starty
		--]]
	elseif nobutton.hover then
		states.titlemenu.load()
	else
		for i,b in pairs(hud.buttons) do
			if b.hover then
				if i == 'quit' then
					states.titlemenu.load()
				end
			end
		end
	end
end
