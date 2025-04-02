

local TreeObjectBase = Class("TreeObjectBase")

TreeObjectBase.OnDestroy = function(self) end

function TreeObjectBase:initialize()
    self.tree = nil
    self.hash = nil
    self.name = nil
    -- callbacks
    --self.OnDestroy = nil
    --
    self.visible = true
    self.enabled = true
end


function TreeObjectBase:getTreeData()
    return self.tree:getHash(self.hash)
end

function TreeObjectBase:parent()
    local this = self:getTreeData()
    return self.tree:getHash(this.parent).object
end

function TreeObjectBase:rename(name)
    self.tree:renameObject(self,name)
end

function TreeObjectBase:destroy()
    self.tree:destroyImmediately(self)
end

function TreeObjectBase:findFirstChild(objectName)
    assert(objectName,"An object name is required.")
    assert(type(objectName) == 'string',"Object name must be of type string. (got "..tostring(objectName)..")")
    for i,hash in pairs(self:getTreeData().children) do
        local data = self.tree:getHash(hash)
        if data.name == objectName then
            return data.object
        end
    end
    return nil
end

function TreeObjectBase:findFirstClass(className)
    assert(className,"A class name is required.")
    assert(type(className) == 'string',"Class name must be of type string. (got "..typeof(className)..")")
    for i,hash in pairs(self.tree:getHash(self.hash).children) do
        local data = self.tree:getHash(hash)
        if typeof(data.object) == className then
            return data.object
        end
    end
    return nil
end

function TreeObjectBase:getChildren()
    local children = self.tree:getHash(self.hash).children
    --if #children == 0 then return {} end
    local objs = {}
    for i,hash in pairs(children) do
        table.insert(objs,self.tree:getHash(hash).object)
    end
    return objs
end

function TreeObjectBase:getChildrenOfClass(classname)
    local children = self.tree:getHash(self.hash).children
    --if #children == 0 then return {} end
    local objs = {}
    for i,hash in pairs(children) do
        local data = self.tree:getHash(hash)
        if typeof(data.object) == classname then
            table.insert(objs,data.object)
        end
    end
    return objs
end

function TreeObjectBase:addChild(object,name)
    local hash = self.tree:registerObject(name,object,self)
    return self.tree:getHash(hash).object
end

function TreeObjectBase:setParent(newParentObject)
    self.tree:isValidTreeObject(newParentObject,true)
    local newParentHash = newParentObject.hash
    local this = self.tree:getHash(self.hash)
    for i,hash in pairs(self.tree:getHash(this.parent).children) do
        if hash == self.hash then
            table.remove(self.tree:getHash(this.parent).children,i)
            break
        end
    end
    this.parent = newParentHash
end


return TreeObjectBase