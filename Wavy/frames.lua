local frames = {}
frames.__index = frames

function frames.make(att)
    local self = {}
    setmetatable(self, frames)
    self.min_dt = att.min_dt or 1/60
    self.max_dt = att.max_dt or 1/40
    self.timeFactor = att.timeFactor or 1
    self.leftover = 0
    return self
end

function frames:update()
    self.prev_time = love.timer.getTime()

    local desiredDt = self.min_dt/self.timeFactor
    if     desiredDt < self.min_dt then self.realDt = self.min_dt
    elseif desiredDt > self.max_dt then self.realDt = self.max_dt
    else self.realDt = desiredDt end

    local numFrames = self.realDt/desiredDt
    numFrames = numFrames + self.leftover

    -- Record the fractional part of numFrames
    numFrames, self.leftover = math.modf(numFrames)

    return numFrames
end

function frames:sleep()
    -- Sleep to limit framerate
    local del = love.timer.getTime() - self.prev_time
    if del < self.realDt then
        love.timer.sleep(self.realDt - del)
    end
end

return frames