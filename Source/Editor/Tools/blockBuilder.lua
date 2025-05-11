
local INCREMENT = 5
local SHIFT_INCREMENT = 10
local CTRL_INCREMENT = 1

local EditorTool = require("Source.Editor.Classes.editorTool")

local Move = EditorTool:new("Move")
Move.currentIncrement = INCREMENT

Move:edit()
    :setOnEquip(function()
        print("Move tool equipped!")
    end)
    :setOnKeyPressed(function(key)
        if Move.targetObject then
            if Move.targetObject.position == nil then error("Move tool cant move an object with no position!"); return; end
            if Move.targetObject.move == nil then error("Move tool cant move an object with :move(x,y) function!"); return; end
            local input = Vector(0,0)
            if key == 'up' then
                input = input + (Vector(0,-1))
            elseif key == 'down' then
                input = input + (Vector(0,1))
            end

            if key == 'right' then
                input = input + (Vector(1,0))
            elseif key == 'left' then
                input = input + (Vector(-1,0))
            end
            local m = (input * Move.currentIncrement)
            Move.targetObject:move(m.x,m.y)
        else
            print("No target object!")
        end
    end)

return Move