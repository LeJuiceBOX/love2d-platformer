
local Select = Class("Select")

    function Select:initialize()
        self.lastSelectedObject = nil
        self.selectedObject = nil
        self.outline = {
            color = Color(50,100,255),
            position = Vector(0,0),
            size = Vector(0,0),
            width = 4,
            visible = false
        }
    end

    function Select:get()
        return self.selectedObject
    end

    function Select:click(x,y,button)
        local objs = HC.shapesAt(x,y)
        local cols = 0
        for i,v in pairs(objs) do
            self:select(v.instance)
            cols=cols+1
            break
        end
        if cols == 0 then self:select() end
        if self.selectedObject then
            self.outline.position = self.selectedObject.position
            self.outline.size = self.selectedObject.size
            if self.selectedObject then
                self.outline.visible = true
            else
                self.outline.visible = false
            end
        end
    end
    
    function Select:deselect()
        self:select(false)
    end

    function Select:select(obj)
        if obj == nil then return; end
        self.lastSelectedObject = self.selectedObject
        if obj == false then
            self.selectedObject = nil
        elseif self.lastSelectedObject == obj then
            self.selectedObject = nil
        else
            self.selectedObject = obj
        end
    end

    function Select:update(dt)
        if self.selectedObject then
            self.outline.position = self.selectedObject.position
            self.outline.size = self.selectedObject.size
        end
    end

    function Select:draw()
        if self.outline.visible and self.selectedObject then
            self.outline.color:set()
            love.graphics.setLineWidth(self.outline.width)
            love.graphics.rectangle('line',self.outline.position.x,self.outline.position.y,self.outline.size.x,self.outline.size.y)
            love.graphics.setLineWidth(1)
            Color.reset()
        end
    end

return Select