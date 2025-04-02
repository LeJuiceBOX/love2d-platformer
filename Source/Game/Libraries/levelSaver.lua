
local module = {}


module.propertiesToSave = {
    "position",
    "size",
    "radius",
    "initPlayerVelocity",
}

module.objectClassMap = {
    --["Player"] = require("Source.Game.Objects.GameObjects.player"),
    ["LevelBlock"] = require("Source.Game.Objects.GameObjects.level_block"),
    ["LevelSpawn"] = require("Source.Game.Objects.GameObjects.level_spawn"),
    ["LevelGoal"] = require("Source.Game.Objects.GameObjects.level_goal"),
}

module.saveMapObjects = function(objects)
    local saveObjectsTable = collectProperties(objects)
    local encodedObjectTable = Json.encode(saveObjectsTable)
    return encodedObjectTable
end

module.loadMapObjectsFromFile = function(jsonMapFile)
   local json = module.getJsonFromFile(jsonMapFile)
   return module.loadMapObjectsFromString(json)
end

module.loadMapObjectsFromString = function(saveJson)
    local saveData = Json.decode(saveJson)
    local map = {}
    for objectName,object in pairs(saveData) do
        local ObjectClass = module.objectClassMap[object.OBJECTCLASS]
        if ObjectClass then
            map[objectName] = ObjectClass:new()
            for property,value in pairs(object) do
                if property ~= "OBJECTCLASS" then
                    local v = value
                    if type(value) == 'table' and value.x and value.y then
                        v = tableToVector(value)
                    end 
                    map[objectName][property] = v
                end
            end
        end
    end
    return map
end

module.isValidProperty = function (name)
    for i,v in pairs(module.propertiesToSave) do
        if v == name then
            return true
        end
    end
    return false
end


module.getJsonFromFile = function(filename)
    -- Check if the file exists
    if not love.filesystem.getInfo(filename) then
        return nil, "File not found: " .. filename
    end

    -- Read the file content
    local content, error = love.filesystem.read(filename)
    
    if not content then
        return nil, "Error reading file: " .. (error or "unknown error")
    end

    return content
end

function loadObject(class,properties)
    local object = class:new()
    for property,value in pairs(object) do
        if property ~= "OBJECTCLASS" then
            local v = value
            if type(value) == 'table' then
                v = tableToVector(value)
            end 
            map[instanceIndex][property] = v
        end
    end
end

function tableToVector(table)
    if typeof(table) == "table" then
        if type(table.x) == 'number' and type(table.y) == 'number' then
            return Vector(table.x,table.y)
        end
    else
        return table
    end
end

function collectProperties(objects)
    local save = {}
    local similarObjectCount = {}
    for _,obj in pairs(objects) do
        local className = obj.class.name

        if similarObjectCount[className] == nil then similarObjectCount[className] = 0 end
        similarObjectCount[className] = similarObjectCount[className] + 1

        local saveObjName = className
        if similarObjectCount[className] > 1 then
            saveObjName = saveObjName..tostring(similarObjectCount[className])
        end

        save[saveObjName] = {
            OBJECTCLASS = className
        }
        
        for prop,val in pairs(obj) do
            if module.isValidProperty(prop) then
                local v = val
                save[saveObjName][prop] = v
            end 
        end
    end

    -- print table
    print("Collected Properties ~")
    for i,v in pairs(save) do
        print()
        print(tostring(i).." - [")
        for prop,val in pairs(v) do
            print("\t"..tostring(prop)..":   "..tostring(val))
        end
    end
    print("]")

    return save
end




return module