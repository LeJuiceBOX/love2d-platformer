
local EditorTool = Class("EditorTool")

    --============================================================================================================================================================

    function EditorTool:initialize(name)
        self.name = name
        self.mouseCollider = Collider(self,"EditorTool",HC.point(love.mouse.getPosition()))
        self.targetObject = nil
        self.callbacks = {
            onDraw = function () end,
            onUpdate = function (dt) end,
            onClick = function (x,y,button) end,
            onKeyPressed = function (key) end,
            onKeyReleased = function (key) end,
            onEquip = function () end,
            onUnequip = function () end,
        }
    end

    --============================================================================================================================================================
    --// Public
    --============================================================================================================================================================

    function EditorTool:getTargetObject()
        return self.targetObject
    end

    function EditorTool:setTargetObject(obj)
        self.targetObject = obj
    end

    --============================================================================================================================================================
    --// Love
    --============================================================================================================================================================

    function EditorTool:update(dt)
        if self.callbacks.onUpdate then
            self.callbacks.onUpdate(dt)
        end
    end

    function EditorTool:draw()
        if self.callbacks.onDraw then
            self.callbacks.onDraw()
        end
    end

    function EditorTool:equip()
        if self.callbacks.onEquip then
            self.callbacks.onEquip()
        end
    end

    function EditorTool:unequip()
        if self.callbacks.onUnequip then
            self.callbacks.onUnequip()
        end
    end

    function EditorTool:keypressed(key)
        if self.callbacks.onKeyPressed then
            self.callbacks.onKeyPressed(key)
        end
    end

    function EditorTool:keyreleased(key)
        if self.callbacks.onKeyReleased then
            self.callbacks.onKeyReleased(key)
        end
    end

    --============================================================================================================================================================
    --// Utility Functions  
    --============================================================================================================================================================

    EditorTool.getObjectAt = function(x,y)
        return HC.shapesAt(x,y)
    end

    --============================================================================================================================================================
    --// Builder Functions  
    --============================================================================================================================================================

    function EditorTool:edit() -- enters the builder chain
        return self
    end

    function EditorTool:setOnDraw(func)
        self.callbacks.onDraw = func
        return self
    end

    function EditorTool:setOnUpdate(func) -- x, y
        self.callbacks.onUpdate = func
        return self
    end

    function EditorTool:setOnClick(func) -- x, y
        self.callbacks.onClick = func
        return self
    end

    function EditorTool:setOnKeyPressed(func) -- key
        self.callbacks.onKeyPressed = func
        return self
    end

    function EditorTool:setOnKeyReleased(func) -- key
        self.callbacks.onKeyReleased = func
        return self
    end

    function EditorTool:setOnEquip(func) -- key
        self.callbacks.onEquip = func
        return self
    end

    function EditorTool:setOnUnequip(func) -- key
        self.callbacks.onUnequip = func
        return self
    end
return EditorTool