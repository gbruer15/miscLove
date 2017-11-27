function love.conf(t)

    t.title = "A Maze-ing Maze"      -- The title of the window the game is in (string)
    t.author = "Grant"        	-- The author of the game (string)
    t.url = ""		    		-- The website of the game (string)
    t.version = "0.10.2"         -- The LÖVE version this game was made for (string)
	
	t.identity = "Maze Levels"
    t.window.width = 800        -- The window width (number)
    t.window.height = 600       -- The window height (number)
    t.modules.joystick = false  -- Enable the joystick module (boolean)
	
    t.modules.audio = true      -- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = true      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.timer = true      -- Enable the timer module (boolean)
    t.modules.mouse = true      -- Enable the mouse module (boolean)
    t.modules.sound = true      -- Enable the sound module (boolean)
	
    t.modules.physics = false    -- Enable the physics module (boolean)
	
end
