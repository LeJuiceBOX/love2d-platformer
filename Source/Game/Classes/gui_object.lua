
local HashTreeObject = require("Source.Core.hashTree_object_base")

local GuiObject = Class("GuiObject",HashTreeObject)

function GuiObject:initialize()
    HashTreeObject.initialize(self)
    self.anchorPoint = Vector(0,0)
    self.position = UDim2:new(0,0,0,0)
    self.size = UDim2:new(0,0,0,0)
    self.absoluteSize = Vector()
    self.absolutePosition = Vector()
end

function GuiObject:calculateAbsolutes()
    local this = self.tree:getHash(self.hash)
    local parentPosition = Vector()
    local parentSize = Vector()
    if this.parent ~= nil then
        local parent = self.tree:getHash(this.parent)
        parentPosition = parent.object.absolutePosition
        parentSize = parent.object.absoluteSize
    end
    
    local size = Vector(0,0)
    size.x = (parentSize.x * self.size.scale.x) + self.size.offset.x
    size.y = (parentSize.y * self.size.scale.y) + self.size.offset.y
    self.absoluteSize = size
    
    local pos = Vector(0,0)
    pos.x = (parentSize.x * self.position.scale.x) + self.position.offset.x
    pos.y = (parentSize.y * self.position.scale.y) + self.position.offset.y
    self.absolutePosition = (parentPosition + pos) - Vector(self.absoluteSize.x*self.anchorPoint.x,self.absoluteSize.y*self.anchorPoint.y)
    
    for i,hash in pairs(this.children) do
        self.tree:getHash(hash).object:calculateAbsolutes()
    end
end

return GuiObject