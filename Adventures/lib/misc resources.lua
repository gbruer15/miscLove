

resources = {}

function resources.load()


	-----------------FONTS----------------
	defaultfont = {}
	defaultfont[14] = love.graphics.newFont(14)
	defaultfont[20] = love.graphics.newFont(20)
	defaultfont[24] = love.graphics.newFont(24)
	defaultfont[36] = love.graphics.newFont(36)
	defaultfont[48] = love.graphics.newFont(48)
	defaultfont[64] = love.graphics.newFont(64)
	defaultfont[200] = love.graphics.newFont(200)

	impactfont = {}
	impactfont[14] = love.graphics.newFont('Fonts/Impact.ttf',14)
	impactfont[20] = love.graphics.newFont('Fonts/Impact.ttf',20)
	impactfont[28] = love.graphics.newFont('Fonts/Impact.ttf',28)
	---------------MISC PICS----------------
	infinity = {}
	infinity.pic = love.graphics.newImage("Misc Pics/infinity.png")
	infinity.picwidth = infinity.pic:getWidth()
	infinity.picheight = infinity.pic:getHeight()

	sliderpic = {}
	sliderpic.pic = love.graphics.newImage("Misc Pics/slider bar.png")
	sliderpic.width = sliderpic.pic:getWidth()
	sliderpic.height = sliderpic.pic:getHeight()

	sliderpic.arrowpic = love.graphics.newImage("Misc Pics/updside down triangle.png")
	sliderpic.arrowwidth = sliderpic.pic:getWidth()
	sliderpic.arrowheight = sliderpic.pic:getHeight()
	
	quicksand = {}
	quicksand.pic = love.graphics.newImage("Misc Pics/quicksand.png")
	quicksand.width = quicksand.pic:getWidth()
	quicksand.height = quicksand.pic:getHeight()
	
	graybrick = {}
	graybrick.pic = love.graphics.newImage("Misc Pics/weird gray brick wall.png")
	graybrick.width = graybrick.pic:getWidth()
	graybrick.height = graybrick.pic:getHeight()
	
	-----------------MUSIC------------------
	music = {}
	music.volume = 1
	
	
	music.title = {}
	music.title.music = love.audio.newSource("Music/Title Music/Title Joel strong first loopable.ogg","stream")
	music.title.music:setVolume(0.7)
	
	music.loading = {}
	music.loading.music = love.audio.newSource("Music/Loading Music/Loading Joel loopable.ogg","static")
	music.loading.music:setVolume(0.4)
	music.loading.music:setLooping(true)
	
	music.discovery = {}
	music.discovery.music = love.audio.newSource("Music/Discovery Music/Discovery Joel loopable.ogg","stream")
	music.discovery.music:setVolume(0.6)
	music.discovery.music:setLooping(true)
	
	music.discovery.fastmusic = love.audio.newSource("Music/Discovery Music/Discovery Joel fast loopable.ogg","stream")
	music.discovery.fastmusic:setVolume(0.6)
	music.discovery.fastmusic:setLooping(true)
	
	music.dying = {}
	music.dying.music = love.audio.newSource("Music/Dying Music/Dying Joel loopable.ogg","static")
	music.dying.music:setVolume(0.6)
	music.dying.music:setLooping(true)
	
	music.fight = {}
	music.fight.music = love.audio.newSource("Music/Fight Music/Fight Grant loopable.ogg","stream")
	music.fight.music:setVolume(0.6)
	music.fight.music:setLooping(true)
	
	
	
	
	
	
	---------------SOUND EFFECTS---------------------
	sfx = {}
	
	sfx.twong = love.audio.newSource("Sound Effects/Bow Noises/twong.ogg","static")
	sfx.twong:setVolume(1)
	
end



