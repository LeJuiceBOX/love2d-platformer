local HashTreeObjectBase = require("Source.Core.hashTree_object_base")

local GameObject = Class("GameObject",HashTreeObjectBase)

function GameObject:initialize()
    HashTreeObjectBase.initialize(self)
    self.position = Vector(0,0)
end

function GameObject:addChild(object,name)
    local obj = GameObject.super.addChild(self,object,name)
    if obj.load ~= nil then
        obj:load()
    end
    return obj
end

return GameObject