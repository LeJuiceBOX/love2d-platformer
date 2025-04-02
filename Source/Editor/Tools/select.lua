
local EditorTool = require("Source.Editor.Classes.editorTool")

local Select = EditorTool("Select")
Select.lastSelected = nil
Select.selected = nil



local outline = {
    position = Vector(0,0),
    size = Vector(0,0),
    width = 3,
    visible = false,
    color = Color(155,155,255)
}


Select:edit()
    :setOnClick(function(x,y)
        local objs = EditorTool.getObjectAt(x,y)
        for i,v in pairs(objs) do
            SelectObject(v.instance)
            break
        end
    end)
    :setOnUpdate(function(dt)
        if Select.selected then
            outline.position = Select.selected.position
            outline.size = Select.selected.size
            outline.visible = true
        else
            outline.visible = false
        end
    end)
    :setOnDraw(function()
        if outline.visible then
            outline.color:set()
            love.graphics.setLineWidth(outline.width)
            love.graphics.rectangle('line',outline.position.x,outline.position.y,outline.size.x,outline.size.y)
            love.graphics.setLineWidth(1)
            Color.reset()
        end
    end)

function SelectObject(obj)
    -- deselect
    Select.lastSelected = Select.selected
    if Select.lastSelected == obj then
        Select.selected = nil
    else
        Select.selected = obj
    end
end

return Select