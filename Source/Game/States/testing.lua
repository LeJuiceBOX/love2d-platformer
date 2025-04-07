

local placeTrailInterval = 1/60

local testing = {}

function testing:init()
    self.obj = {
        position = Vector(),
        rad = 16
    }
    self.Trail = require("Source.Core.Components.trail")(self.obj,10,function (pos,alpha)
        --love.graphics.setColor(1,1,1,alpha)
        love.graphics.circle("fill",pos.x,pos.y,self.obj.rad)
    end)

end

function testing:enter()

end

function testing:leave()
    
end

function testing:keypressed(key)

end

function lerp(value, targetValue, alpha)
	return value + (targetValue - value) * alpha
end



local trailTimer = 0
local trailInc = 1
function testing:update(dt)
    self.obj.position = Vector(love.mouse.getPosition())
    self.Trail:update(dt)
end

function testing:draw()
    self.Trail:draw()
    Color:reset()
    love.graphics.circle("fill",self.obj.position.x,self.obj.position.y,self.obj.rad)
end

return testing