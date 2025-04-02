local HashTree = require("Source.Core.hashTree")

local GameObjectHashTree = Class("GameObjectHashTree",HashTree)

function GameObjectHashTree:initialize()
-- HashTreeObject
    -- self.tree = nil
    -- self.hash = nil
    -- self.name = nil
    -- -- callbacks
    -- self.OnDestroy = nil
    -- --
    -- self.visible = true
    -- self.enabled = true
-- GameObjectHashTree
    HashTree.initialize(self,"GameObject",GameObject)
    self.requiredObjectClass = "GameObject"
    self._fdt = 0
end


function GameObjectHashTree:destroyAll()
    print("Destroying all gameObjects...")
    for hash,data in pairs(self._treeHash) do
        self:destroyImmediately(data.object)
    end
end

function GameObjectHashTree:update(dt)
    for hash, data in pairs(self._treeHash) do
        local obj = data.object
        if obj.enabled then
            if obj.update ~= nil then
                obj:update(dt)
            end 
        end
    end
    self._fdt = self._fdt + dt
    if self._fdt >= (1/60) then
        -- call fixed update on children
        for hash, data in pairs(self._treeHash) do
            local obj = data.object
            if obj.enabled then
                if obj.fixedUpdate ~= nil then
                    obj:fixedUpdate(self._fdt)
                end
            end
        end
        self:handleDestructionQueue()
        self._fdt = self._fdt - (1/60)
    end
end

function GameObjectHashTree:draw()
    for hash, data in pairs(self._treeHash) do
        local obj = data.object
        if obj.visible then
            if data.object.draw ~= nil then
                obj:draw()
            end 
        end
    end
end

return GameObjectHashTree
