
FIXED_FRAMERATE = 1/60 -- run fixed update 60 times/s
DRAW_FRAMERATE = 60

HC = require("Source.Core.HC")
-- Load core into game
Color = require("Source.Core.color")
Assets = require("Source.Core.assets")
Json = require("Source.Core.Libraries.json")
Gamestate = require("Source.Core.gamestate")
-- Load game core
LevelSaver = require("Source.Game.Libraries.levelSaver")
Collider = require("Source.Core.collider")

States = {
    Menu = require("Source.Game.States.menu"),
    LevelEditor = require("Source.Game.States.levelEditor"),
    Dev = require("Source.Game.States.level_dev"),
    Level_1 = require("Source.Game.States.Levels.level_1")
}

function love.keypressed(key)
    if key == 'q' then
        love.event.push("quit")
    elseif key == 'escape' then
        Gamestate.switch(States.Menu)
    end
end

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(States.Menu)
end

function love.update(dt) end
function love.draw(dt) end