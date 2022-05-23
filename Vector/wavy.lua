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

    self.params = {}
    self.params.div = att.div or 1
    self.params.curl = att.curl or 2
    self.params.lineWidth = att.lineWidth or 5

    self.params.lineLength = att.lineLength or 40
    self.params.granularity = att.granularity or 25
    self.params.lineColor = att.lineColor or 'crazy'
    self.params.spinFactor = att.spinFactor or 1
    self.params.initialization = att.initialization or 'radial'
    self.params.fixedAngle = (att.fixedAngle == nil and true) or att.fixedAngle
    self.params.movement = att.movement or false

    self.f = self.params.div / 2
    self.g = self.params.curl / 2

    self.initializer = self.initializations[self.params.initialization]
    self:resize(love.graphics.getWidth(), love.graphics.getHeight())

    self.need_to_update = true
    self.t = 0
    self.speed = 1
    return self
end

function wavy:get_vec(i, j, gridWidth, gridHeight)
    local x = j - gridWidth/2 
    local y = i - gridHeight/2
    local f = self.f
    local g = self.g
    local l = {x=f*x - g*y, y=f*y + g*x}
    l.d = math.sqrt(l.x*l.x + l.y*l.y)
    return l
end

function wavy:update(dt, iterations)
    local epsilon = 0
    if not self.need_to_update then
        return
    end

    self.t = self.t + dt

    if false then
        local r = self.t
        local dd = r - math.floor(r) -- in [0, 1)
        dd = -dd*2 + 1 -- in [1, -1)

        self.f = self.params.div / 2 * dd
    else
        self.f = self.params.div / 2 * math.cos(self.t)
        self.g = self.params.curl / 2 * math.sin(self.t)
        -- local r = self.t
        -- local dd = r - math.floor(r) -- in [0, 1)
        -- dd = -dd*2 + 1 -- in [1, -1)

        -- self.f = self.params.div / 2 * dd
        -- self.g = self.params.curl / 2 * math.cos(1.1*self.t)
    end

    -- print(self.f, self.g)

    self:resize(nil, nil)
    v = self.grid1[0][0]
    -- print('self.grid1[0][0]', v.x, v.y, v.d)
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
    local cx, cy, x1, y1, x2, y2, v
    local max_length, length_scale
    love.graphics.setLineWidth(self.params.lineWidth)
    if type(self.params.lineColor) == 'table' then
        love.graphics.setColor(self.params.lineColor)
    end
    max_length = 0
    for i = 0, #self.grid1 do
        for j = 0, #self.grid1[i] do
            v = self.grid1[i][j]
            max_length = math.max(max_length, v.d)
        end
    end
    length_scale = 1 or self.params.lineLength / max_length
    for i = 0, #self.grid1 do
        for j = 0, #self.grid1[i] do
            cx = j * self.params.granularity
            cy = i * self.params.granularity

            v = self.grid1[i][j]

            if self.params.lineColor == 'crazy' then
                h = v.d / max_length
                love.graphics.setColor(HSV(h, 1, 1, 0.5))
            end
            x1 = cx + v.x/2 * length_scale
            x2 = cx - v.x/2 * length_scale

            y1 = cy + v.y/2 * length_scale
            y2 = cy - v.y/2 * length_scale
            -- if i == 0 and j == 0 then
            --     print('x1, x2', x1, x2)
            -- end
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
    if true then
        return
    end

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

function wavy:resize(width, height, grid)
    width = width or love.graphics.getWidth()
    height = height or love.graphics.getWidth()
    local gridWidth = math.ceil(width / self.params.granularity) - 1
    local gridHeight = math.ceil(height / self.params.granularity) - 1

    if grid then
        grid_to_update = grid
    else
        self.skip = {}
        self.grid1 = {}
        self.grid2 = {}
        grid_to_update = self.grid1
    end

    for i = 0, gridHeight+1 do
        if not grid then
            self.grid1[i] = {}
            self.grid2[i] = {}
            self.skip[i] = {}
        end
        for j = 0, gridWidth+1 do
            self.grid1[i][j] = self:get_vec(i, j, gridWidth, gridHeight)
        end
    end
end



return wavy