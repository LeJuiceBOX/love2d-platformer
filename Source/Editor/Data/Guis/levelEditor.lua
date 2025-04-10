local GuiHashTree = require("Source.Game.Classes.gui_hashTree")

local Frame = require("Source.Game.Objects.GuiObjects.frame")

local gui = GuiHashTree()

local toolsFrame = gui:root():addChild(Frame(),"ToolsFrame")
toolsFrame.size = UDim2(0,302,0,320)
toolsFrame.position = UDim2(0,0,0,0)
toolsFrame.color = Color(255,255,255,1)

return gui