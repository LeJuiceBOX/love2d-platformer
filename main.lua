
FIXED_FRAMERATE = 1/60 -- run fixed update 60 times/s
DRAW_FRAMERATE = 60

HC = require("Source.Core.HardonCollider")
-- Load core into game
SignalService = require("Source.Core.Services.signals"):new()
InputService = require("Source.Core.Services.input"):new()
Color = require("Source.Core.Classes.color")
Assets = require("Source.Core.Services.assets")
Json = require("Source.Core.Libraries.json")
Gamestate = require("Source.Core.Services.gamestate")
-- Load game core
LevelSaver = require("Source.Game.Libraries.levelSaver")
Collider = require("Source.Core.Components.collider")

States = {
    Menu = require("Source.Game.States.menu"),
    LevelEditor = require("Source.Game.States.editor"),
    Dev = require("Source.Game.States.level_dev"),
    Level_1 = require("Source.Game.States.Levels.level_1")
}


function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(States.Menu)
end

function love.update(dt)
    InputService:update(dt)
end

function love.draw(dt)
    InputService:draw()
    SignalService:draw()
end

function love.keypressed(key, scancode, isrepeat)
    InputService:keyPressed(key, scancode, isrepeat)
    if key == 'q' then  
        love.event.push("quit")
    elseif key == 'escape' then
        Gamestate.switch(States.Menu)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    InputService:keyReleased(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, istouch, presses)
    InputService:mousePressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    InputService:mouseReleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, isTouch)
    InputService:mouseMoved(x, y, dx, dy, isTouch)
end