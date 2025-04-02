
LabelFonts = {
    OpenSans_Regular = "Source/Game/Data/Fonts/OpenSans-Regular.ttf"
}

local GuiObject = require("Source.Game.Classes.gui_object")

local Label = Class("Label",GuiObject)

function Label:initialize(text)
    GuiObject.initialize(self)
    self.text = text or "New label"
    self.font = LabelFonts.OpenSans_Regular
    self.fontSize = 13
    self.fontColor = Color(0,0,0)
    self._currentFont = nil
    self:refreshFont()
end

function Label:refreshFont()
    self._currentFont = love.graphics.newFont(self.font,self.fontSize)
    self.size = UDim2(0,0,self._currentFont:getWidth(self.text),self._currentFont:getHeight())
end

function Label:draw()
    local old = love.graphics.getFont()
    love.graphics.setFont(self._currentFont)
    self.fontColor:set()
    love.graphics.print(self.text,self.absolutePosition.x,self.absolutePosition.y)
    love.graphics.setFont(old)
    Color:reset()
end

return Label