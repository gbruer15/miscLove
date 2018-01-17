local wavy = {}
wavy.__index = wavy

function wavy.make(att)
    local self = {}
    setmetatable(self, wavy)

    self.grid1 = {}
    self.grid2 = {}

    self.params = {}
    self.params.lineWidth = att.lineWidth or 5
    self.params.lineLength = att.lineLength or 40
    self.params.granularity = att.granularity or 25
    self.params.lineColor = att.lineColor or {255, 255, 255, 150}

    local gridWidth = math.ceil(love.graphics.getWidth() / self.params.granularity)
    local gridHeight = math.ceil(love.graphics.getHeight() / self.params.granularity)

    for i = 0, gridWidth+1 do
        self.grid1[i] = {}
        self.grid2[i] = {}
        for j = 0, gridHeight+1 do
            self.grid1[i][j] = 0
            if j % 3 == 0 then
                self.grid1[i][j] = 1
            end
            self.grid2[i][j] = self.grid1[i][j]
        end
    end

    self.need_to_update = true
    return self
end

function wavy:update()
    local epsilon = 0
    if not self.need_to_update then
        return
    end
    -- print('Tada:', #self.grid1, #self.grid2)
    for i = 1, #self.grid1-1 do
        -- print('Tada:', #self.grid1[i])
        for j = 1, #self.grid1[i]-1 do
            -- print(i, j)
            self.grid2[i][j] = 0.25*(
                self.grid1[i][j-1]
                + self.grid1[i][j+1]
                + self.grid1[i-1][j]
                + self.grid1[i+1][j]
            )
            epsilon = epsilon + math.abs(self.grid2[i][j] - self.grid1[i][j])
        end
    end
    self.grid1, self.grid2 = self.grid2, self.grid1

    if epsilon < 1e-9 then
        self.need_to_update = false
        print("Stopping update: ", epsilon)
    end
end

function wavy:draw()
    local cx, cy, x1, y1, x2, y2
    love.graphics.setLineWidth(self.params.lineWidth)
    love.graphics.setColor(self.params.lineColor)
    for i = 1, #self.grid1 do
        for j = 1, #self.grid1[i] do
            cx = i * self.params.granularity
            cy = j * self.params.granularity

            x1 = cx + self.params.lineLength/2 * math.cos(self.grid1[i][j])
            x2 = cx - self.params.lineLength/2 * math.cos(self.grid1[i][j])

            y1 = cy + self.params.lineLength/2 * math.sin(self.grid1[i][j])
            y2 = cy - self.params.lineLength/2 * math.sin(self.grid1[i][j])
            love.graphics.line(x1, y1, x2, y2)
        end
    end
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
    -- TODO: implement this
    self.need_to_update = true
end





return wavy