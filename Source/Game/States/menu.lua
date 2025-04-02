local Spawn = require("Source.Game.Objects.GameObjects.level_spawn")
local Goal = require("Source.Game.Objects.GameObjects.level_goal")

local Gui = require("Source.Game.Classes.gui_hashTree")
local Frame = require("Source.Game.Objects.GuiObjects.frame")
local Label = require("Source.Game.Objects.GuiObjects.label")
local Button = require("Source.Game.Objects.GuiObjects.button")


local menu = {}

menu.buttons = {
    {
        text = "Start",
        callback = function()
            Gamestate.switch(require("Source.Game.States.Levels.level_1"))
        end
    },
    {
        text = "Level Editor",
        callback = function()
            Gamestate.switch(require("Source.Game.States.levelEditor"))
        end
    },
    {
        text = "Dev Level",
        callback = function()
            Gamestate.switch(require("Source.Game.States.level_dev"))
        end
    }
}

function menu:init()
    self.gui = Gui()

    self.window = self.gui:root():addChild(Frame(),"Window")-- scale doesnt work on the root for some reason, wrap everything in another frame to work normally
    self.window.size = UDim2(0,0,1280,720)
    self.window.color = Color(255,255,255,0)

    self.frame = self.window:addChild(Frame(),"Frame")
    self.frame.size = UDim2(0.2,1,0,0)

    self.test = self.window:addChild(Frame(),"TestFrame")
    self.test.anchorPoint = Vector(0.5,0.5)
    self.test.size = UDim2(0.1,0.1,0,0)
    self.test.position = UDim2(0.5,0.5,0,0)

    self.label = self.test:addChild(Label("Testing"),"Label")
    self.label.anchorPoint = Vector(0.5,0.5)
    self.label.position = UDim2(0.5,0.5,0,0)
    self.label.textColor = Color(0,0,0)



    for i,v in pairs(menu.buttons) do
        local o = self.frame:addChild(Button(),"Button")
        o.position = UDim2:new(0,0,8,8+(40*(i-1)))
        o.size = UDim2(1,0,-16,32)
        o.text = v.text
        o.OnClick = v.callback
        menu.buttons[i].buttonObj = o
    end




    --self.gui:calculateAbsolutes()
    self.gui:printTree()
end

function menu:enter()

end

function menu:leave()
    
end

function menu:keypressed(key)
    if key == 'space' then
        print(self.frame.absoluteSize)
    end
end

function menu:update(dt)
    self.gui:update(dt)
end

function menu:draw()
    self.gui:draw()
end

return menu