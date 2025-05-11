
local HashTree = require("Source.Core.Classes.hashTree")

local GuiHashTree = Class("GuiHashTree",HashTree)

function GuiHashTree:initialize()
    HashTree.initialize(self,"GuiObject",require("Source.Game.Classes.gui_object"))
end

function GuiHashTree:createRoot(rootObj)
    local newHash = self:newHash()
    local rootObj = rootObj
    rootObj.name = "Root"
    rootObj.hash = newHash
    rootObj.tree = self
    rootObj.size = UDim2(0,0,love.graphics.getWidth(),love.graphics.getHeight())

    self._treeHash[newHash] = {
        id = newHash,
        name = "Root",
        object = rootObj,
        parent = nil,
        children = {}
    }
    self.treeRootHash = newHash
    print("Created root.")
end

function GuiHashTree:destroyAll()
    print("Destroying all gameObjects...")
    for hash,data in pairs(self._treeHash) do
        --print(data.object)
        self:destroyCleanly(data.object)
    end
end

function GuiHashTree:registerObject(name, newObject, parentObject,skipValidation)
    local obj = HashTree.registerObject(self,name, newObject, parentObject,skipValidation)
    self:calculateAbsolutes()
    return obj
end

function GuiHashTree:calculateAbsolutes()
    local root = self:getHash(self.treeRootHash).object
    root:calculateAbsolutes()
end

function GuiHashTree:update(dt)
    self:handleDestructionQueue()
    self:calculateAbsolutes()

    for hash,data in pairs(self._treeHash) do
        local object = data.object
        if object.update then
            if object.enabled then
                object:update(dt)
            end
        end
    end
end

function GuiHashTree:draw()

    local function drawObjectAndChildren(objectHash)
        local this = self:getHash(objectHash)
        if this.object.draw then
            if this.parent then
                if self:getHash(this.parent) then
                    local parent = self:getHash(this.parent)
                    if parent.object.visible and this.object.visible then
                        this.object:draw()
                    end
                end
            else
                this.object:draw()
            end
        else
        end
        for _,hash in pairs(this.children) do
            drawObjectAndChildren(hash)
        end
    end

    drawObjectAndChildren(self.treeRootHash)
end
return GuiHashTree