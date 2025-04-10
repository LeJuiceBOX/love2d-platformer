
local UDim2 = Class("UDim2")

function UDim2:initialize(sx,sy,ox,oy)
    self.scale = Vector(sx or 0,sy or 0)
    self.offset = Vector(ox or 0,oy or 0)
end

function UDim2:clone()
    return UDim2(self.scale.x,self.scale.y,self.offset.x,self.offset.y)    
end

function UDim2:__add(other)
    assert(typeof(other)=="UDim2","Cant add a non UDim2.")
    self.scale = self.scale + other.scale
    self.offset = self.offset + other.offset
end
function UDim2:__sub(other)
    assert(typeof(other)=="UDim2","Cant add a non UDim2.")
    self.scale = self.scale - other.scale
    self.offset = self.offset - other.offset
end


return UDim2