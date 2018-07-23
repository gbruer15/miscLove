local wavy = {}
wavy.__index = wavy

wavy.initializations = {}

function wavy.initializations.radial(i, j, gridWidth, gridHeight)
    return math.atan((i - gridHeight/2)/(j - gridWidth/2))
end

function wavy.initializations.circumferential(i, j, gridWidth, gridHeight)
    return math.atan((i - gridHeight/2)/(j - gridWidth/2)) + math.pi/2
end

function wavy.initializations.random(i, j, gridWidth, gridHeight)
    return math.pi/2*(math.random()*2-1)
end

function wavy.initializations.fixed(i, j, gridWidth, gridHeight)
    return 0
end

-- function wavy.initializations.lines(i, j, gridWidth, gridHeight)
--     if i == 0 then
--         return 1
--     elseif i == gridHeight+1 then
--         return -1
--     end
-- end


function wavy.make(att)
    local self = {}
    setmetatable(self, wavy)

    self.grid1 = {}
    self.grid2 = {}

    self.params = {}
    self.params.lineWidth = att.lineWidth or 5
    self.params.lineLength = att.lineLength or 40
    self.params.granularity = att.granularity or 25
    self.params.lineColor = att.lineColor or 'crazy'
    self.params.spinFactor = att.spinFactor or 1
    self.params.initialization = att.initialization or 'radial'
    self.params.fixedAngle = (att.fixedAngle == nil and true) or att.fixedAngle
    self.params.borderMovement = att.borderMovement or false

    local gridWidth = math.ceil(love.graphics.getWidth() / self.params.granularity) - 1
    local gridHeight = math.ceil(love.graphics.getHeight() / self.params.granularity) - 1

    self.initializer = self.initializations[self.params.initialization]
    self.skip = {}
    for i = 0, gridHeight+1 do
        self.grid1[i] = {}
        self.grid2[i] = {}
        self.skip[i] = {}
        for j = 0, gridWidth+1 do
            self.grid1[i][j] = 0
            if i ~= 0 and i ~= gridHeight+1 and j~= 0 and j ~= gridWidth+1 then
                -- not an edge piece
                self.grid1[i][j] = math.pi/2*(math.random()*2-1)
            else
                -- this is an edge piece
                self.grid1[i][j] = self.initializer(i, j, gridWidth, gridHeight)
            end
            self.grid2[i][j] = self.grid1[i][j]
        end
    end
    self.need_to_update = true
    self.t = 0
    self.speed = 1
    return self
end

function wavy:update(dt, iterations)
    local epsilon = 0
    if not self.need_to_update then
        return
    end

    -- Make border more interesting
    self.t = self.t + dt
    if self.params.borderMovement == 'sine' then
        for j = 0, #self.grid1[0] do
            self.grid1[0][j] = math.pi/2*math.sin(self.t)
            self.grid1[#self.grid1][j] = -math.pi/2*math.sin(self.t)
        end
        for i = 0, #self.grid1 do
            self.grid1[i][0] = math.pi/2*math.cos(self.t)
            self.grid1[i][#self.grid1[i]] = -math.pi/2*math.sin(self.t)
        end
    elseif self.params.borderMovement == 'constant' then
        for j = 0, #self.grid1[0] do
            self.grid1[0][j] = self.grid1[0][j] + self.speed*dt
            self.grid1[#self.grid1][j] = self.grid1[#self.grid1][j] + self.speed*dt
        end
        for i = 0, #self.grid1 do
            self.grid1[i][0] = self.grid1[i][0] + self.speed*dt 
            self.grid1[i][#self.grid1[i]] = self.grid1[i][#self.grid1[i]] + self.speed*dt 
        end
    end

    for _ = 1, (iterations or 1) do
        for i = 1, #self.grid1-1 do
            -- print('Tada:', #self.grid1[i])
            for j = 1, #self.grid1[i]-1 do
                -- print(i, j)
                if not self.skip[i][j] then
                    self.grid2[i][j] = 0.25*(
                        self.grid1[i][j-1]
                        + self.grid1[i][j+1]
                        + self.grid1[i-1][j]
                        + self.grid1[i+1][j]
                    )
                    epsilon = epsilon + math.abs(self.grid2[i][j] - self.grid1[i][j])
                else
                    self.grid2[i][j] = self.grid1[i][j]
                end
            end
        end
        self.grid1, self.grid2 = self.grid2, self.grid1

        if epsilon < 1e-9 then
            self.need_to_update = false
            print("Stopping update: ", epsilon)
            break
        end
    end
end

function HSV(h, s, v, a)
    if s <= 0 then return v,v,v end
    h = h - math.floor(h)
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255, a*255
end

function wavy:draw()
    local cx, cy, x1, y1, x2, y2
    love.graphics.setLineWidth(self.params.lineWidth)
    if type(self.params.lineColor) == 'table' then
        love.graphics.setColor(self.params.lineColor)
    end
    for i = 0, #self.grid1 do
        for j = 0, #self.grid1[i] do
            if self.params.lineColor == 'crazy' then
                love.graphics.setColor(HSV(self.grid1[i][j]/math.pi+0.5, 1, 1, 0.5))
            end
            cx = j * self.params.granularity
            cy = i * self.params.granularity

            x1 = cx + self.params.lineLength/2 * math.cos(self.grid1[i][j])
            x2 = cx - self.params.lineLength/2 * math.cos(self.grid1[i][j])

            y1 = cy + self.params.lineLength/2 * math.sin(self.grid1[i][j])
            y2 = cy - self.params.lineLength/2 * math.sin(self.grid1[i][j])
            love.graphics.line(x1, y1, x2, y2)
        end
    end
end

function wavy:getRowColumn(x,y)
    local col = math.floor(0.5 + (x - self.params.granularity) / self.params.granularity) + 1
    local row = math.floor(0.5 + (y - self.params.granularity) / self.params.granularity) + 1
    if col < 1 or col > #self.grid1[0]-1 or row < 1 or row > #self.grid1-1 then
        return nil
    end
    return row, col
end

function wavy:addPoints(points)
    if #points % 2 ~= 0 then
        error("There should've been an even number of points")
        return
    end
    if #points <= 2 then
        error("There should be at least two points")
        return
    end

    local i = 0
    local r,c
    local angle, prev_angle
    for i = 1, #points-3, 2 do
        -- look at the line connecting this point to the next one
        angle = math.atan((points[i+1] - points[i+3])/(points[i] - points[i+2]))
        if i ~= 1 then
            -- average this angle with the previous angle
            angle = (angle + prev_angle)/2
        end
        prev_angle = angle

        -- stick this angle in the correct spot in the grid
        r, c = self:getRowColumn(points[i], points[i+1])
        if r then
            if angle > 0 then angle = angle + self.params.spinFactor*math.pi end
            if angle < 0 then angle = angle - self.params.spinFactor*math.pi end
            self.grid1[r][c] = angle
            if self.params.fixedAngle then
                self.skip[r][c] = true
            end
        end
    end

    self.need_to_update = true
end

function wavy:resize(width, height)
    local gridWidth = math.ceil(width / self.params.granularity) - 1
    local gridHeight = math.ceil(height / self.params.granularity) - 1

    for i = 0, gridHeight+1 do
        self.grid1[i] = {}
        self.grid2[i] = {}
        self.skip[i] = {}
        for j = 0, gridWidth+1 do
            self.grid1[i][j] = 0
            if i ~= 0 and i ~= gridHeight+1 and j~= 0 and j ~= gridWidth+1 then
                -- not an edge piece
                self.grid1[i][j] = math.pi/2*(math.random()*2-1)
            else
                -- this is an edge piece
                self.grid1[i][j] = self.initializer(i, j, gridWidth, gridHeight)
            end
            self.grid2[i][j] = self.grid1[i][j]
        end
    end
end



return wavy