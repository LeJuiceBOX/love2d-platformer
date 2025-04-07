local GameObjectHashTree = require("Source.Game.Classes.game_object_hashTree")
local Camera = require("Source.Core.Classes.camera")
local Select = require("Source.Editor.Classes.select")

local ToolModules = {
    Move = require("Source.Editor.Tools.move"),
    Resize = require("Source.Editor.Tools.resize"),
}

local EditorObjects = {
    Block = require("Source.Game.Objects.GameObjects.level_block")
}

local cameraSpeed = 150


local state = {}

function state:init()
    self.levelWorkspace = GameObjectHashTree:new()
    self.levelWorkspace:root():addChild(EditorObjects.Block:new(400,200,64,64),"DefaultSquare")
    self.selectionHandler = Select:new()
    camera = Camera(0,0)
    -- setup tool frame
end

function state:update(dt)
    local speed = cameraSpeed

    if love.keyboard.isDown('w') then
        camera:move(0,-speed*dt)
    elseif love.keyboard.isDown('s') then
        camera:move(0,speed*dt)
    end
    if love.keyboard.isDown('d') then
        camera:move(speed*dt,0)
    elseif love.keyboard.isDown('a') then
        camera:move(-speed*dt,0)
    end
    --Block:update(dt)

    self.levelWorkspace:update(dt)
end

function state:draw()
    --camera:attach()
    Color(255,255,255,0.5):set()
    love.graphics.line(0,-720,0,720)
    love.graphics.line(-1280,-0,1280,0)
    love.graphics.print("(0,0)",4,4)

    Color.reset()
    self.levelWorkspace:draw()
    --camera:detach()


    -- --if ToolBelt.currentTool then
    --     love.graphics.print("CurrentTool: "..ToolBelt.currentTool.name)
    -- else
    --     love.graphics.print("CurrentTool: none")
    -- end
end

function state:keypressed(key)
    if key == 'r' then
        return
    end

end

function state:keyreleased(key)

end

function state:mousereleased(x,y,button)

end

return state