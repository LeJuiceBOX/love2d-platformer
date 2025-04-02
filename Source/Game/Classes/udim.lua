
local UDim2 = Class("UDim2")

function UDim2:initialize(sx,sy,ox,oy)
    self.scale = Vector(sx or 0,sy or 0)
    self.offset = Vector(ox or 0,oy or 0)
end

return UDim2