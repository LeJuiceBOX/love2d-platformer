
local GuiObject = require("Source.Game.Classes.gui_object")

local Button = Class("Button",GuiObject)

function Button:initialize(text)
    GuiObject.initialize(self)
    self.text = text or "New Button"
    self.size = UDim2(0,0,96,32)
    self.mouseDownOnMe = true
    self.colors = {
        textColor = Color(255,255,255),
        default = Color(80,80,255),
        hover = Color(95,95,255),
        mouseDown = Color(70,70,200),
    }
    self.OnClick = nil
end

function Button:update(dt)
    if self:IsHovering() then
        if love.mouse.isDown(1) then
            self:use()
        end
    end
end

function Button:use()
    if self.OnClick then
        self.OnClick()
    end
end

function Button:draw()
    if self:IsHovering() then
        if love.mouse.isDown(1) then
            self.colors.mouseDown:set()
        else
            self.colors.hover:set()
        end
    else
        self.colors.default:set()
    end
    love.graphics.rectangle('fill',self.absolutePosition.x,self.absolutePosition.y,self.absoluteSize.x,self.absoluteSize.y)
    self.colors.textColor:set()
    love.graphics.print(self.text,self.absolutePosition.x,self.absolutePosition.y)
end

function Button:IsHovering()
    local x,y = love.mouse.getPosition()
    local s = self.absoluteSize
    local p = self.absolutePosition
    if x > p.x and x < p.x+s.x then
        if y > p.y and y < p.y+s.y then
            return true
        end
    end
    return false
end

return Button