local Spawn = require("Source.Game.Objects.GameObjects.level_spawn")
local Goal = require("Source.Game.Objects.GameObjects.level_goal")

local GameObjectHashTree = require("Source.Game.Classes.game_object_hashTree")
local GuiHashTree = require("Source.Game.Classes.gui_hashTree")

local ToolBelt = require("Source.Editor.Classes.toolBelt")

local Camera = require("Source.Core.Classes.camera")
local Frame = require("Source.Game.Objects.GuiObjects.frame")
local ListLayout = require("Source.Game.Objects.GuiObjects.listLayout")
local Label = require("Source.Game.Objects.GuiObjects.label")
local Button = require("Source.Game.Objects.GuiObjects.button")

local cameraSpeed = 150
local gridSpacing = 16

local EditorObjects = {
    Block = require("Source.Game.Objects.GameObjects.level_block")
}


local ToolBeltItems = {
    BlockBuilder = require("Source.Editor.Tools.blockBuilder")
}



local editor = {}

function editor:init()
    self.levelWorkspace = GameObjectHashTree:new()
    self.connections = {}
    self.camera = Camera(0,0)
    self.buttonData = {
        BlockBuilder = {
            text = "Block Builder",
            button = nil,
            onClick = function()
                print("Hello!")
            end
        }
    }
    
    self.gridLockedCursor = {
        position = Vector(0,0),
        targetPosition = Vector(0,0),
        lerpAlpha = 0.05,
        radius = 2,
        color = Color(255,55,55,1),
    }
    -- Setup workspace
    SignalService:print()
end

function editor:enter()  
    self.levelWorkspace:root():addChild(EditorObjects.Block:new(400,200,64,64),"DefaultSquare")
    
    -- setup gui
    self.gui = GuiHashTree()
    
    self.window = self.gui:root():addChild(Frame(),"Window")-- scale doesnt work on the root for some reason, wrap everything in another frame to work normally
    self.window.size = UDim2(0,0,1280,720)
    self.window.color = Color(255,255,255,0)
    
    self.frame = self.window:addChild(Frame(),"Frame")
    self.frame.color = Color(15,15,55,1)
    self.frame.size = UDim2(0.2,1,0,0)
    
    self.listLayout = self.frame:addChild(ListLayout())
    
    -- setup buttons
    for name, data in pairs(self.buttonData) do
        local b = self.frame:addChild(Button(),"button_"..tostring(name))
        self.buttonData[name].button = b
        b.text = data.text
        b.OnClick = data.onClick
    end
end

function editor:leave()
    self.gui:destroyAll()
    for i,v in pairs(self.connections) do
        v:disconnect()
    end
end

function editor:keypressed(key)
    if key == 'space' then
        print(self.frame.absoluteSize)
    end
end

function editor:update(dt)
    local speed = cameraSpeed

    if love.keyboard.isDown('w') then
        self.camera:move(0,-speed*dt)
    elseif love.keyboard.isDown('s') then
        self.camera:move(0,speed*dt)
    end
    if love.keyboard.isDown('d') then
        self.camera:move(speed*dt,0)
    elseif love.keyboard.isDown('a') then
        self.camera:move(-speed*dt,0)
    end

    -- update gridLockedCursor position
    local wx,wy = self.camera:mousePosition()
    self.gridLockedCursor.targetPosition = snapCoordinateToGrid(Vector(wx,wy))
    self.gridLockedCursor.position.x = lerp(self.gridLockedCursor.position.x, self.gridLockedCursor.targetPosition.x, self.gridLockedCursor.lerpAlpha)
    self.gridLockedCursor.position.y = lerp(self.gridLockedCursor.position.y, self.gridLockedCursor.targetPosition.y, self.gridLockedCursor.lerpAlpha)
    --Block:update(dt)
    self.levelWorkspace:update(dt)
    self.gui:update(dt)
end

function editor:draw()
    self.camera:attach()
    Color(200,200,200,0.5):set()
    love.graphics.line(0,-720,0,720)  -- horiz origin 
    love.graphics.line(-1280,-0,1280,0) -- vert origin 
    love.graphics.print("(0,0)",4,4)
    Color(200,200,200,0.1):set()
    for i = 1, ((1280*2)/gridSpacing) do
        local x = gridSpacing*i
        love.graphics.line(x-1280,-720,x-1280,720) 
    end
    for i = 1, ((720*2)/gridSpacing) do
        local y = gridSpacing*i
        love.graphics.line(-1280,y-720,1280,y-720) -- vert origin 
    end
    Color.reset()
    self.levelWorkspace:draw()
    self.gridLockedCursor.color:set()
    love.graphics.circle('fill',self.gridLockedCursor.position.x,self.gridLockedCursor.position.y,self.gridLockedCursor.radius)
    self.camera:detach()
    Color.reset()
    self.gui:draw()
end

function snapCoordinateToGrid(pos)
    assert(Vector.isvector(pos), "snapCoordinateToGrid expects a vector. (got "..typeof(pos)..")")
    local x = math.floor( pos.x / gridSpacing ) * gridSpacing
    local y = math.floor( pos.y / gridSpacing ) * gridSpacing
    return Vector(x,y)
end

function lerp(value, targetValue, alpha)
	return value + (targetValue - value) * alpha
end


return editor