
local INCREMENT = 5
local SHIFT_INCREMENT = 10
local CTRL_INCREMENT = 1


local EditorTool = require("Source.Editor.Classes.editorTool")

local Resize = EditorTool:new("Resize")
Resize.currentIncrement = INCREMENT
Resize.shiftDown = true
Resize:edit()
    :setOnEquip(function()
        print("Resize tool equipped!")
    end)
    :setOnUpdate(function()
            Resize.shiftDown = love.keyboard.isDown('lshift')
    end)
    :setOnKeyPressed(function(key)
        if Resize.targetObject then
            if Resize.targetObject.position == nil then error("Move tool cant move an object with no position!"); return; end
            if Resize.targetObject.move == nil then error("Move tool cant move an object with :move(x,y) function!"); return; end
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
            local m = (input * Resize.currentIncrement)
            if Resize.shiftDown then
                if m.x > 0 then
                    Resize.targetObject:move(m.x,0)
                    m.x = -math.abs(m.x)
                end
                if m.y > 0 then
                    Resize.targetObject:move(0,m.y)
                    m.y = -math.abs(m.y)
                end
            else
                if m.x < 0 then
                    Resize.targetObject:move(m.x,0)
                    m.x = math.abs(m.x)
                end
                if m.y < 0 then
                    Resize.targetObject:move(0,m.y)
                    m.y = math.abs(m.y)
                end
            end
            m = m + Resize.targetObject.size
            Resize.targetObject:resizeTo(m.x,m.y)
        else
            print("No target object!")
        end
    end)
return Resize