local HashTreeObjectBase = require("Source.Core.Classes.hashTree_object")

local GameObject = Class("GameObject",HashTreeObjectBase)

function GameObject:initialize()
    HashTreeObjectBase.initialize(self)
    self.layer = 0
    self.position = Vector(0,0)
end

function GameObject:addChild(object,name)
    local obj = GameObject.super.addChild(self,object,name)
    if obj.load ~= nil then
        obj:load()
    end
    self.tree:generateDrawOrder()
    return obj
end

return GameObject