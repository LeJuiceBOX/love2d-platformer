

local Select = require("editor.classes.select")
local Toolbelt = Class("Toolbelt")

function Toolbelt:initialize()
    self.tools = {}
    self.select = Select()
    self.selectEnabled = true

    self.currentTool = nil
end

function Toolbelt:update(dt)
    self.select:update(dt)
    if self.currentTool then
        self.currentTool:update(dt)
    end
end

function Toolbelt:draw()
    self.select:draw()
    if self.currentTool then
        self.currentTool:draw()
    end
end

function Toolbelt:deselectTool()
    if self.currentTool then
        self.currentTool:unequip()
    end
    self.currentTool = nil
end

function Toolbelt:selectTool(toolName)
    if not self.tools[toolName] then error(("Invalid tool name. (%s)"):format(toolName)) end
    if self.currentTool then
        self.currentTool:unequip()
    end
    self.currentTool = self.tools[toolName]
    self.currentTool:equip()
end

function Toolbelt:mousereleased(x,y,button)
    if button == 1 then
        self.select:click(x,y,button)
        local t = self.select:get()
        for _,tool in pairs(self.tools) do
            tool.targetObject = t
        end
    elseif button == 2 then
        self.select:deselect()
    end
end

function Toolbelt:keypressed(key)
    if self.currentTool then
        self.currentTool:keypressed(key)
    end
end

function Toolbelt:keyreleased(key)
    if self.currentTool then
        self.currentTool:keyreleased(key)
    end
end

function Toolbelt:addTool(name,toolModule)
    self.tools[name] = toolModule
    return self
end

return Toolbelt