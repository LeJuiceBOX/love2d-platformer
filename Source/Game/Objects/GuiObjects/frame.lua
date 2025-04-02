
local GuiObject = require("Source.Game.Classes.gui_object")

local Frame = Class("Frame",GuiObject)

function Frame:initialize()
    GuiObject.initialize(self)
    self.size = UDim2(0,0,100,100)
    self.color = Color(255,255,255,1)
end

function Frame:draw()
    self.color:set()
    love.graphics.rectangle("fill",self.absolutePosition.x,self.absolutePosition.y,self.absoluteSize.x,self.absoluteSize.y)
    Color:reset()
end


return Frame