

-- create tree root class
local TreeObjectBase = require("Source.Core.hashTree_object_base")

local TreeRoot = Class("TreeRoot",TreeObjectBase)
function TreeRoot:initialize() end


local HashTree = Class("HashTree")

function HashTree:initialize(requiredClassName,rootClassObj)
    rootClassObj = rootClassObj or TreeObjectBase
    math.randomseed(os.time())
    self.random = math.random
    assert(requiredClassName,"Parameter is missing. (requiredClass)")
    assert(typeof(requiredClassName) == 'string',"RequiredClass must be of type 'string'. (got "..typeof(requiredClassName)..")")
    self._queuedForDeletion = {}
    self._treeHash = {}
    self._tags = {}
    self.treeRootHash = nil
    self.rootClassObj = rootClassObj
    self.requiredObjectClass = requiredClassName
    self:createRoot(rootClassObj:new())
end

--=======================================================================================================================================
--// Public
--=======================================================================================================================================

function HashTree:printTree()
    print("-----------------------------------------------------")
    print("Current Tree Hash ~")
    print("-----------------------------------------------------")
    for hash,obj in pairs(self._treeHash) do
        print("[' "..hash.." ']")
        for prop,value in pairs(obj) do
            print("\t|- "..tostring(prop)..": "..tostring(value))
            if typeof(value) == 'table' then
                for i,v in pairs(value) do
                    print("\t\t|- "..tostring(i)..": "..tostring(v))
                end
            end
        end
        print()
    end
    print("-----------------------------------------------------")
end

function HashTree:createRoot(rootObj)
    local newHash = self:newHash()
    self._treeHash[newHash] = {
        id = newHash,
        name = "Root",
        object = rootObj,
        parent = nil,
        children = {}
    }
    rootObj.name = "Root"
    rootObj.hash = newHash
    rootObj.tree = self
    self.treeRootHash = newHash
    print("Created root.")
end

function HashTree:root()
    if self.treeRootHash == nil then print("Tree root not initialized.") return end
    local data = self:getHash(self.treeRootHash)
    return data.object
end
 
function HashTree:getHash(hash)
    assert(hash,"hash is required. (got t:"..typeof(hash).."  v:'"..tostring(hash).."')")
    assert(typeof(hash) == 'string',"hash must be a string. (expected 'string' got "..typeof(hash).."))")
    assert(self:isValidHash(hash),"Malformed hash. (got '"..tostring(hash).."')")
    assert(self._treeHash[hash],"No object attached to this hash. ("..tostring(hash)..")")
    return self._treeHash[hash]
end

function HashTree:renameObject(object,name)
    assert(name,"A name must be given.")
    assert(typeof(name) == 'string',"Name must be a string. (got "..typeof(name)..")")
    assert(self:isValidTreeObject(object),"Given object is not a valid object. (got "..tostring(object)..")")
    self:getHash(object.hash).name = name
    object.name = name
end

function HashTree:addTag(tag,object)
    local hash = object.hash
    if self._tags[tag] == nil then
        self._tags[tag] = {}
    end
    table.insert(self._tags,hash)
end

function HashTree:getTagged(tag)
    --if #children == 0 then return {} end
    if (self._tags[tag] ~= nil or #self._tags[tag] == 0) then return {} end
    local objs = {}
    for i,hash in pairs(self._tags[tag]) do
        table.insert(objs,self:getHash(hash).object)
    end
    return objs
end

function HashTree:getTags(object)
    local tags = {}
    for tagName,data in pairs(self._tags) do
        for _,hash in pairs(data) do
            if hash == object.hash then
                table.insert(tags,tagName)
            end
        end
    end
    return tags
end


function HashTree:isValidHash(hash)
    return (string.match(hash,"^%d+%-%w%w%w%w%w%w%w%w$") ~= nil)
end

function HashTree:isHashRegistered(hash)
    return (self._treeHash[hash] ~= nil)
end

function HashTree:registerObject(name, newObject, parentObject,skipValidation)
    skipValidation = skipValidation or false
    assert(type(name) == 'string' or type(name) == 'nil',"Parameter 1 must be the name of this object or nil. (got "..typeof(name)..")")
    if skipValidation == false then
        self:isValidTreeObject(newObject)
        self:isValidTreeObject(parentObject)
    end
    if self:isHashRegistered(newObject.hash) == true then print("Object is already registered. ("..typeof(newObject)..")") return; end
    if self:isHashRegistered(parentObject.hash) == false then print("Parent is not registered. ("..typeof(parentObject)..")") return; end
    return self:register(name,newObject,parentObject)
end

function HashTree:unregisterObject(object)
    if typeof(object) == "TreeRoot" or object.name == "Root" then return; end
    if object == nil then return; end
    -- detag object
    for tagName,data in pairs(self._tags) do
        for i,hash in pairs(data) do
            if hash == object.hash then
                table.remove(self._tags[tagName],i)
            end
        end
    end
    local hashTreeObj = self:getHash(object.hash)
    -- remove object from parent's children
    if hashTreeObj.parent then
        for i,childHash in pairs(self:getHash(hashTreeObj.parent).children) do
            table.remove(self:getHash(hashTreeObj.parent).children,i)
        end
    end
    -- reparent children to object parent
    for i,childHash in pairs(hashTreeObj.children) do
        self:getHash(childHash).object:setParent(hashTreeObj.parent)
    end
    self._treeHash[object.hash] = nil
end

function HashTree:register(name,newObject,parentObject)
    assert(parentObject,"Cant register this object with no parent object given. (got "..tostring(parentObject)..")")
    local newName = name or typeof(newObject)
    local newHash = self:newHash()
    newObject.hash = newHash
    newObject.tree = self
    newObject.name = newName
    self._treeHash[newHash] = {
        hash = newHash,
        name = newName,
        object = newObject,
        parent = parentObject.hash,
        children = {}
    }
    local parDat = self:getHash(parentObject.hash)
    parDat.children[#parDat.children+1] = newHash
    -- print("Children:")
    -- print(parentObject.name)
    -- for i,v in pairs(self:getHash(parentObject.hash).children) do
    --     print(i,v)
    -- end
    return newHash
end

function HashTree:isValidTreeObject(object,doAssert)
    doAssert = doAssert or true
    assert(object,"Object is nil.")
    --print("Self: "..tostring(self.requiredObjectClass))
    if doAssert then
        assert(isClass(object),"Given object is not an instance of a middleclass class. (got "..typeof(object)..")\nMaybe you passed in a class definition by accident?")
        assert(objectInherits(object,"TreeObjectBase"),"Given object is not a descendant of 'TreeObjectBase' which all tree objects must have. (got "..typeof(object)..")")
        assert(objectInherits(object,self.requiredObjectClass) or typeof(object) == 'TreeRoot',("Given object is not of the required base type. (expected '%s' got '%s')"):format(self.requiredObjectClass,typeof(object)))
    end
    if not isClass(object) then return false end
    local inheritsTreeObj = objectInherits(object,"TreeObjectBase") 
    local inheritsReqObj = objectInherits(object,self.requiredObjectClass)
    return (inheritsTreeObj and inheritsReqObj) or typeof(object) == 'TreeRoot'
end

function HashTree:handleDestructionQueue()
    for hash,data in pairs(self._queuedForDeletion) do
        if data.destroyThisFrame == false then
            self._queuedForDeletion[hash].destroyThisFrame = true
        elseif data.destroyThisFrame == true then
            print("Obj: "..tostring(data.object))
            self:destroyImmediately(data.object)
        end
    end
end

function HashTree:destroyImmediately(object)
    if object.name == "Root" then self._queuedForDeletion[object.hash] = nil; return; end
    object.enabled = false
    if object.destroy then
        object:OnDestroy()
    end
    self._queuedForDeletion[object.hash] = nil
    self:unregisterObject(object)
    collectgarbage()
end

function HashTree:queueDestroy(object)
    if self._queuedForDeletion[object.hash] ~= nil then return end
    self._queuedForDeletion[object.hash] = {
        object = object,
        destroyThisFrame = false
    }
    object.enabled = false
end

function HashTree:update(dt)
    --self:handleDestructionQueue()
end


--=======================================================================================================================================
--// Static
--=======================================================================================================================================

local generatedIds = 0 -- used for id generation
function HashTree:newHash()
    generatedIds = generatedIds + 1
    return string.format("%d-%s", generatedIds, self:uuid():sub(1, 8))
end

function HashTree:uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and self.random(0, 0xf) or self.random(0, 0xb)
        return string.format('%x', v)
    end)
end

return HashTree