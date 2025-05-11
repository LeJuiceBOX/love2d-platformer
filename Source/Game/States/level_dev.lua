local GameObjectHashTree = require("Source.Game.Classes.game_object_hashTree")


local Block = require("Source.Game.Objects.GameObjects.level_block")
local Camera = require("Source.Core.Classes.camera")
local Player = require("Source.Game.Objects.GameObjects.player")
local Spawn = require("Source.Game.Objects.GameObjects.level_spawn")
local Goal = require("Source.Game.Objects.GameObjects.level_goal")

local lvl = {}
function lvl:init()
    self.player = nil
    self.workspace = GameObjectHashTree()

    self.connections = {
        OnDragging = InputService.OnDragging:connect(function(x,y,dx,dy)
            self.player:moveTo(x,y)
            self.player.velocity = Vector(0,0)
        end)
    }

    --self.root:addChild(Block:new(32,32,64,64),"Box2")
    --self.root:addChild(Block:new(96,96,124,124),"Box2")
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
    collectgarbage()
    HC.resetHash()
    self.root = self.workspace:root()
    self.spawn = self.root:addChild(Spawn:new(32,400,Vector(100,-150)),"Spawn")
    self.goal = self.root:addChild(Goal:new(1000,500),"Goal")
    self.player = self.root:addChild(Player:new(),"Player")
    self.spawn.player = self.player
    self.goal.player = self.player
    
    self.floor = self.root:addChild(Block:new(0,600,1280,200),"Floor")
    --self.floor2 = self.root:addChild(Block:new(0,700,1280,200),"Floor2")
    --self.floor:destroy()
    self.spawn:resetPlayer()
    self.connections["onGoalReached"] = self.goal.signal_playerTouchedGoal:connect(function()
        self.spawn:resetPlayer()
        print("Goal reached!")
    end)
end
function lvl:leave()
    for _,connection in pairs(self.connections) do
        connection:disconnect()
    end
    self.workspace:destroyAll()
    HC.resetHash()
    collectgarbage()
end

function lvl:update(dt)
    -- handle update
    self.workspace:update(dt)
end

function lvl:draw()
    love.graphics.reset()
    self.workspace:draw()
    love.graphics.setColor(0.1,1,0.1) 
    local ram = math.ceil(collectgarbage('count')/1024)
    love.graphics.print("FPS: "..love.timer.getFPS().."\tGC: "..tostring(ram).." Mb")
end

return lvl
