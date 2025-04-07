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
    self._drawTree = {}
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
    for i, object in pairs(self._drawTree) do
        if object.visible and object.draw then
            object:draw()
        end
    end
end

function GameObjectHashTree:generateDrawOrder()
     self._drawTree = {}
     local function addChildrenToList(object)
        local ordered = {}
        for i,hash in pairs(self:getHash(object.hash).children) do
            local data = self:getHash(hash)
            table.insert(ordered,{
                object = data.object,
                hash = data.object.hash,
                layer = data.object.layer,
            })
        end
        table.sort(ordered,function (e1,e2)
            return e1.layer < e2.layer
        end)
        for i,v in pairs(ordered) do
            if #self:getHash(v.hash).children > 0 then
                addChildrenToList(v.object)
            else
                table.insert(self._drawTree,v.object)
            end
        end
     end
     addChildrenToList(self:root())
    --  print("Draw Tree ~")
    --  for i,v in pairs(self._drawTree) do
    --     print(i,v)
    --  end
end

return GameObjectHashTree
