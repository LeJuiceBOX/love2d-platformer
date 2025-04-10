local GameObjectHashTree = require("Source.Game.Classes.game_object_hashTree")

local Block = require("Source.Game.Objects.GameObjects.level_block")
local Camera = require("Source.Core.Classes.camera")
local Player = require("Source.Game.Objects.GameObjects.player")
local Spawn = require("Source.Game.Objects.GameObjects.level_spawn")
local Goal = require("Source.Game.Objects.GameObjects.level_goal")

local lvl = {}
function lvl:init()
    self.workspace = GameObjectHashTree:new()
    self.root = self.workspace:root()
    self.player = nil

    self.connections = {
        OnDragging = InputService.OnDragging:connect(function(x,y,dx,dy)
            self.player:moveTo(x,y)
            self.player.velocity = Vector(0,0)
        end)
    }

    -- insert all loaded map objs to self.workspace

end

function lvl:keypressed(key)
    if key == 'r' then
        print("Respawn!")
        self.spawn:resetPlayer()
    elseif key == 't' then
        self.workspace:printTree()
    end
    
end

function lvl:enter()
    HC.resetHash()
    self.mapObjects = self.root:addChild(GameObject(),"MapObjects")
    self.mapObjects.layer = 1
    for name,object in pairs(LevelSaver.loadMapObjectsFromFile("Source/Game/Data/Maps/dev.json")) do
        self.mapObjects:addChild(object,name)
    end
    self.goal = self.mapObjects:findFirstChild("LevelGoal")
    self.spawn = self.mapObjects:findFirstChild("LevelSpawn")
    self.player = self.root:addChild(Player:new(),"Player")
    
    self.spawn.player = self.player
    self.goal.player = self.player

    self.spawn:resetPlayer()
    self.connections.onGoalReached = self.goal.signal_playerTouchedGoal:connect(function()
        self.spawn:resetPlayer()
        print("Goal reached!")
    end)

    self.workspace:generateDrawOrder()
end
function lvl:leave()
    for _,connection in pairs(self.connections) do
        connection:disconnect()
    end
    self.workspace:destroyAll()
    collectgarbage()
    -- any shapes left?

end

function lvl:update(dt)
    -- handle update
    self.workspace:update(dt)
end

function lvl:draw()
    love.graphics.reset()
    self.workspace:draw()
    love.graphics.setColor(0.1,1,0.1) 
    local gc = math.ceil(collectgarbage('count')/1024)
    love.graphics.print("FPS: "..love.timer.getFPS().."\tGC: "..tostring(gc).." Mb")
end


return lvl
