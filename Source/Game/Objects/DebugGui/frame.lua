
local Frame = Class("Frame")


function Frame:initialize(x,y,w,h)
    self.position = Vector(x or 0,y or 0)
    self.size = Vector(w or 32,h or 32)
    self.canvas = love.graphics.newCanvas(w,h)
    self.color = Color(120,120,120)
    self.visible = false
    self.elements = {}

    self._classCt = {}

    self.canvas:setFilter('linear','linear')
end

function Frame:setSize(w,h)
    self.size = Vector(w,h)
    self.canvas = love.graphics.newCanvas(self.position.x,self.position.y,w,h)
end

function Frame:setColor(color)
    self.color = color
    return self
end

function Frame:setVisible(state)
    self.visible = state
    return self
end

function Frame:add(uniqueName,element)
    self:insertElement(uniqueName,element)
    return self
end

function Frame:insertElement(uniqueName,element)
    self.elements[uniqueName] = element
    return self.elements[uniqueName]
end

function Frame:load()
    for name,element in pairs(self.elements) do
        if element.load then
            element:load()
        end
    end
end

function Frame:draw()
    --love.graphics.clear()
    --love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.canvas, 0,0)
    self.canvas:renderTo(function()
        if self.visible then
            self.color:set()
            love.graphics.rectangle('fill',0,0,self.size.x,self.size.y)
            Color.reset()
        end
        for name,element in pairs(self.elements) do
            if element.draw then
                element:draw()
            end
        end
    end)
    Color.reset()
end

function Frame:update(dt)
    for name,element in pairs(self.elements) do
        if element.update then
            element:update(dt)
        end
    end
end

return Frame