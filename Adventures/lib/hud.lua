

hud = {}

function hud.load()
	hud.width = window.width
	hud.height = 0.15 * window.height
	hud.x,hud.y = 0, 0
	
	hud.outline = {}
	hud.outline.color = {0,0,0}
	hud.outline.width = 6
	
	hud.buttons = {}
	hud.buttons.quit = button.make{text="Quit",textcolor={255,255,255}, font=defaultfont[24],x=720,y=10, width=70,height=36}
	
	hpbar = {}
	hpbar.x = 39
	hpbar.y = 60
	hpbar.width = 200
	hpbar.height = 14
	hpbar.text = "200/200"
	hpbar.textx = hpbar.x+hpbar.width/2-impactfont[14]:getWidth(hpbar.text)/2
	hpbar.texty = hpbar.y + hpbar.height/2 - impactfont[14]:getHeight()/2
	
	xpbar = {}
	xpbar.y = 38
	
	hearts = {}
	hearts.pic = {}
	hearts.pic.full = love.graphics.newImage("Misc Pics/full heart.png")
	hearts.pic.half = love.graphics.newImage("Misc Pics/half heart.png")
	hearts.pic.empty = love.graphics.newImage("Misc Pics/empty heart.png")
	hearts.pic.drawwidth = 18 -- 9:10
	hearts.pic.drawheight = 18--15
	hearts.pic.picwidth = hearts.pic.full:getWidth()
	hearts.pic.picheight = hearts.pic.full:getHeight()
	
	bubble = {}
	bubble.pic = love.graphics.newImage('Misc Pics/bubble.png')
	bubble.picwidth = bubble.pic:getWidth()
	bubble.picheight = bubble.pic:getHeight()
	bubble.width = 30
	bubble.height = 30
	bubble.time = 30
	
	
	
end


function hud.update(dt)
	for i,b in pairs(hud.buttons) do
		b:update()
	end
end

function hud.draw()
	
	--love.graphics.setColor(200,130,50)
	--love.graphics.rectangle("fill", hud.x,hud.y, hud.width,hud.height)
	love.graphics.setColor(255,255,255)
	local n = 6
	for i=1,n do 
		love.graphics.draw(graybrick.pic, hud.x + (i-1)*hud.width/n,hud.y,0, hud.width/n/graybrick.width,hud.height/graybrick.height)
	end

	
	love.graphics.setColor(unpack(hud.outline.color))
	love.graphics.setLineWidth(hud.outline.width)
	love.graphics.rectangle("line", hud.x+hud.outline.width/2,hud.y+hud.outline.width/2, hud.width-hud.outline.width,hud.height-hud.outline.width)
	
	
	drawHealthBar()
	drawXPBar()
	
	love.graphics.setColorMode('modulate')
	love.graphics.setFont(impactfont[28])
	love.graphics.setColor(30,30,30)
	love.graphics.print(player.name .. ',   Level ' .. player.level, 47,5)
	
	love.graphics.setColor(255,150,80)
	love.graphics.print(player.name .. ',   Level ' .. player.level, 45,3)
	
	love.graphics.setFont(impactfont[20])
	love.graphics.setColor(0,0,0)
	love.graphics.print("Gold: " .. player.gold, 300,10)
	love.graphics.setColor(255,250,5)
	love.graphics.print("Gold: " .. player.gold, 299,9)
	--[[
	if #player.hurtby > 0 then
		love.graphics.setFont(defaultfont[14])
		love.graphics.print("You were hurt by: ",170,58)
		local x = 293
		local i = 1
		while i<= #player.hurtby do
			love.graphics.setColor(255,255,255)
			if player.hurtby[i] == 'foe' then
				love.graphics.draw(foe.pic.right,x,47,0, 8/foe.picwidth,8/foe.picwidth)
				x = x + 13
			elseif player.hurtby[i] == 'pawn' then
				love.graphics.draw(pawn.pic.original,x,58,0, 24/pawn.picwidth,24/pawn.picwidth)
				x = x + 25
			elseif player.hurtby[i] == 'water' then
				love.graphics.setColor(50,50,250)
				love.graphics.rectangle("fill", x, 60, 15,15)
				x = x + 20
			end
			i = i + 1
		end
	end
	--]]
	
	
	love.graphics.setFont(defaultfont[14])
	love.graphics.setColor(255,255,255)
	
	
	for i,b in pairs(hud.buttons) do
		b:draw()
	end
end


function drawHealthBar()
	love.graphics.setColorMode("modulate")
	
	love.graphics.setFont(impactfont[20])
	
	love.graphics.setColor(90,10,10)
	love.graphics.print("HP", 12,hpbar.y-3)
	
	love.graphics.setColor(225,20,20)
	love.graphics.print("HP", 10,hpbar.y-5)


	love.graphics.setColor(20,20,20)
	love.graphics.rectangle("fill", hpbar.x-2,hpbar.y-2,hpbar.width+4,hpbar.height+4)
	
	love.graphics.setColor(200,0,0)
	love.graphics.rectangle("fill", hpbar.x,hpbar.y,hpbar.width*player.hp/player.maxhp, hpbar.height)
	
	
	love.graphics.setFont(impactfont[14])
	
	love.graphics.setColor(20,20,20)
	love.graphics.print(player.hp .. '/' .. player.maxhp, hpbar.textx+1,hpbar.texty+1)
	
	love.graphics.setColor(250,250,250)
	love.graphics.print(player.hp .. '/' .. player.maxhp, hpbar.textx,hpbar.texty)
end


function drawXPBar()
	love.graphics.setColorMode("modulate")
	
	love.graphics.setFont(impactfont[20])
	
	love.graphics.setColor(10,60,10)
	love.graphics.print("XP", 12,xpbar.y - 3)
	
	love.graphics.setColor(20,225,20)
	love.graphics.print("XP", 10,xpbar.y - 5)


	love.graphics.setColor(20,20,20)
	love.graphics.rectangle("fill", hpbar.x-2,xpbar.y-2,hpbar.width+4,hpbar.height+4)
	
	love.graphics.setColor(0,200,0)
	love.graphics.rectangle("fill", hpbar.x,xpbar.y,hpbar.width*player.xp/player.xps[player.level], hpbar.height)
	
	
	love.graphics.setFont(impactfont[14])
	
	love.graphics.setColor(20,20,20)
	love.graphics.print(player.xp .. '/' .. player.xps[player.level], hpbar.textx+1,hpbar.texty + xpbar.y-hpbar.y + 1)
	
	love.graphics.setColor(250,250,250)
	love.graphics.print(player.xp .. '/' .. player.xps[player.level], hpbar.textx,hpbar.texty + xpbar.y-hpbar.y)
end



function drawHearts()
	
	love.graphics.setColorMode("modulate")
	
	love.graphics.setFont(impactfont[20])
	love.graphics.setColor(180,20,20)
	love.graphics.print("Health:", 10,7)
	
	love.graphics.setColorMode('replace')
	local i = 0
	while i < player.health do
		love.graphics.draw(hearts.pic.full, 80 + i*(hearts.pic.drawwidth*1.3),10, 0, hearts.pic.drawwidth/hearts.pic.picwidth,hearts.pic.drawheight/hearts.pic.picheight)
		i = i + 1
	end
	if math.floor(player.health) ~= player.health then
		i = i - 1
		love.graphics.draw(hearts.pic.half, 8 + i*(hearts.pic.drawwidth*1.3),10, 0, hearts.pic.drawwidth/hearts.pic.picwidth,hearts.pic.drawheight/hearts.pic.picheight)
		i = i + 1
	end
	while i < player.maxhealth do
		love.graphics.draw(hearts.pic.empty, 8 + i*(hearts.pic.drawwidth*1.3),10, 0, hearts.pic.drawwidth/hearts.pic.picwidth,hearts.pic.drawheight/hearts.pic.picheight)
		i = i + 1
	end
end

function drawOxygenLevel()	

	love.graphics.setFont(defaultfont[20])
	love.graphics.setColor(30,100,200)
	love.graphics.setColorMode('modulate')
	love.graphics.print(math.round(player.oxygenlevel/player.maxoxygenlevel,0.01)*100 .. "%", window.width/2 - 67,20)
	
	

	love.graphics.setColorMode('replace')
	i = 0
	x = window.width/2 + 10
	while i <= player.oxygenlevel-bubble.time do
		--love.graphics.circle("fill", x, 30, 15)
		love.graphics.draw(bubble.pic, x-bubble.width/2, 30-bubble.height/2, 0, bubble.width/bubble.picwidth,bubble.height/bubble.picheight)
		x = x + 35
		i = i + bubble.time	
	end
	--love.graphics.circle("fill", x, 30, (player.oxygenlevel-i) * 15/bubble.time)
	local width = (2*(player.oxygenlevel-i) * 15/bubble.time)
	local height = (2*(player.oxygenlevel-i) * 15/bubble.time)
	love.graphics.draw(bubble.pic, x-width/2, 30-height/2, 0, width/bubble.picwidth,height/bubble.picheight)
	
	if player.oxygenlevel <= 0 then
		love.graphics.setFont(defaultfont[24])
		love.graphics.setColorMode("modulate")
		
		drowncolortime = love.timer.getTime()
		love.graphics.setColor((math.sin(drowncolortime)+1)*100+55,255 - (math.cos(drowncolortime)+1)*100,0)
		love.graphics.print("Breathe!!", x-15,15)
	end
end
