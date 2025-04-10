
local GuiObject = require("Source.Game.Classes.gui_object")

local ListLayout = Class("Button",GuiObject)

function ListLayout:initialize()
    GuiObject.initialize(self)
    self.forceSize = UDim2(1,0,0,32)
    self.spacing = 5
    self.filterClassName = false
    self.padding = {
        top = 5,
        bottom = 0,
        left = 5,
        right = 5,
    }
end

function ListLayout:load()
    self.absoluteForceSize = Vector(
        (self:parent().absoluteSize.x*self.forceSize.scale.x)+self.forceSize.offset.x,
        (self:parent().absoluteSize.y*self.forceSize.scale.y)+self.forceSize.offset.y
    )
    self:parent().OnChildAdded:connect(function()
        self:applyLayout()
    end)
end

function ListLayout:applyLayout()
    local children = self:parent():getChildren()
    local ct = 0
    for i,child in pairs(children) do
        local size = self.forceSize:clone()
        size.offset.x = -(self.padding.left+self.padding.right)
        if self.filterClassName then
            if typeof(child) == self.filterClassName then
                child.position = UDim2(0,0,self.padding.left,(self.padding.top+(self.spacing*ct)+(self.absoluteForceSize.y*ct)))
                child.size = size
                ct=ct+1
            end
        else
            if child ~= self then
                child.position = UDim2(0,0,self.padding.left,(self.padding.top+(self.spacing*ct)+(self.absoluteForceSize.y*ct)))
                child.size = size
                ct=ct+1
            end
        end
        --child.position = UDim2(0,self.padding.left,0,self.padding.top+(self.spacing*ct)+(self.absoluteForceSize.y*ct))
    end
end

return ListLayout