compatibility = {}

local queuedScreenShots = {}

local major, minor, revision, codename = love.getVersion()
print(string.format("Using compatibility profile for version %d.%d.%d", major, minor, revision))
local version10 = (major == 0 and minor == 10)
if version10 then
    -- Queue up screenshot so that the screenshot is taken after the next love.draw()
    function love.graphics.captureScreenshot(filename)
        table.insert(queuedScreenShots, {filename = filename, delay = 1})
    end
else
    -- Convert colors from [0,255] to [0,1]
    local oldSetColor = love.graphics.setColor
    function love.graphics.setColor(r, g, b, a)
        if type(r) == 'table' then
            g = r[2]
            b = r[3]
            a = r[4]
            r = r[1]
        end
        g = g/255
        b = b/255
        a = a and a/255
        r = r/255
        oldSetColor(r,g,b,a)
    end
end

function love.run()
    if version10 then
        if love.math then
            love.math.setRandomSeed(os.time())
        end
    end
    if love.load then love.load(arg, arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    if love.graphics and love.graphics.isActive() then
        love.graphics.origin()
        love.graphics.clear(love.graphics.getBackgroundColor())
        love.graphics.present()
    end

    -- Main loop time.
    function mainLoop ()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then dt = love.timer.step() or love.timer.getDelta() end

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then love.draw() end

            love.graphics.present()

            -- Take screenshot after presenting, because this is what 0.11.0 does.
            if #queuedScreenShots > 0 then
                local ss = love.graphics.newScreenshot()
                for i,v in pairs(queuedScreenShots) do
                    if v.delay == 0 then
                        ss:encode('png', v.filename)
                        queuedScreenShots[i] = nil
                    end
                    v.delay = v.delay - 1
                end
            end
        end

        if love.timer then love.timer.sleep(0.001) end
    end
    if version10 then
        local rv
        while true do
            rv = mainLoop()
            if rv ~= nil then
                return rv
            end
        end
    else
        return mainLoop
    end
end