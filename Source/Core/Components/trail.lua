


local Trail = Class("Trail")

function Trail:initialize(object,trailLength,drawCallback)
    self.enabled = true
    self.drawInterval = 1/60
    self.fadeIncrement = 1/25
    self.object = object
    self.trailObjects = {}
    self.drawCallback = drawCallback

    for i = 1, trailLength do
        self.trailObjects[i] = {
            position = Vector(0,0),
            alpha = 0
        }
    end

end

function Trail:setDraw(callback)
    self.drawCallback = callback
end

local timer = 0
local trailInc = 1
function Trail:update(dt)
    if timer > self.drawInterval then
        -- if enabled update positions and alpha
        if self.enabled then
            self.trailObjects[trailInc].position = self.object.position
            self.trailObjects[trailInc].alpha = 0.5
            trailInc = trailInc + 1
            if trailInc > #self.trailObjects then
                trailInc = 1
            end
        end
        -- make trails fade
        for i,trail in pairs(self.trailObjects) do
            if trail.alpha > 0 then
                --trail.alpha = lerp(trail.alpha,0,0.1)
                trail.alpha = trail.alpha - self.fadeIncrement
            elseif trail.alpha < 0 then
                trail.alpha = 0
            end
        end
        timer = 0
    end
    timer = timer + dt
end

function Trail:draw()
    local defBlendMode = love.graphics.getBlendMode()
    love.graphics.setBlendMode("alpha")
    for i,v in pairs(self.trailObjects) do
        --print(v.alpha)
        if v.alpha > 0 then
            self.drawCallback(v.position,v.alpha)
        end
    end
    love.graphics.setBlendMode(defBlendMode)
end

return Trail