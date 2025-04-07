local HashTree = require("Source.Core.Classes.hashTree")

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
    self._drawOrder = {}
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
    for layer, object in pairs(self._drawOrder) do
        if object.visible then
            object:draw()
        end
    end
end

function GameObjectHashTree:generateDrawOrder()
    self._drawOrder = {}
    local function generateOrderFromChildren(object)
        local objectsWithChildren = {}
        local runningLayerTotal = 0
        for _,hash in pairs(self:getHash(object.hash).children) do
            local data = self:getHash(hash)
            local children = #data.children
            if children > 0 then
                table.insert(objectsWithChildren,data.object)
            end
            if data.object.layer > 0 and data.object.draw then
                runningLayerTotal = runningLayerTotal + data.object.layer
                self._drawOrder[runningLayerTotal] = data.object
            end
        end
        for _,obj in pairs(objectsWithChildren) do
            generateOrderFromChildren(obj)
        end
    end
    generateOrderFromChildren(self:root())
end

return GameObjectHashTree
