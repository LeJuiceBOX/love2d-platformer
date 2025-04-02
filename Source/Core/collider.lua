

local Collider = Class("Collider")


Collider.ShapeTypes = {
    Rectangle = 1,
    Circle = 2,
}

function Collider:initialize(instance,tag,shape)
    self.enabled = true
    self.shape = shape or error("Failed to setup Collider.")
    self.instance = instance or error("Instance is a required feild for a Collider.")
    self.tag = tag or ""
    local x,y,w,h = self:getDims()
    self.position = Vector(x,y)
    self.size = Vector(w,h)
    -- do this so we can access this instance from a collision event
    self.shape.collider = self
    self.shape.instance = self.instance
end

function Collider:collidingWith(shape)
    return self.shape:collidesWith(shape)
end

function Collider:getCollisions()
    return HC.collisions(self.shape)
end

function Collider:setShape(shape)
    self.shape = shape or error("No shape given.")
    return self
end

function Collider:getDims()
    return self.shape:bbox()
end

function Collider:move(x,y)
    self.shape:move(x,y)
end

function Collider:moveTo(x,y)
    self.shape:moveTo(x,y)
end

function Collider:draw(fillType)
    fillType = fillType or "line"
    if self.shape then
        self.shape:draw(fillType)
    end
end

function  Collider:destroy()
    
end

return Collider