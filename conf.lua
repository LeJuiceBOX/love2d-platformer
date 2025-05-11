-- conf.lua
-- Love2D configuration file (runs before love.load)

function love.conf(t)
    -- Custom configuration
    t.debugMode = true
    -- Basic configuration
    t.identity = "phrawg-platformer"                     -- Save directory name (in AppData)
    t.appendidentity = false                   -- Search files in source then save directory
    t.version = "11.4"                         -- Target Love2D version (11.4 recommended)
    t.console = true                           -- Enable console (Windows only)
    
    -- Window Settings
    t.window.title = "Game"                    -- Window title
    t.window.width = 1280                      -- Window width (px)
    t.window.height = 720                      -- Window height (px)
    t.window.borderless = false                -- Remove window border
    t.window.resizable = false                  -- Allow window resizing
    t.window.minwidth = 640                    -- Minimum window width
    t.window.minheight = 360                   -- Minimum window height
    t.window.fullscreen = false                -- Start in fullscreen
    t.window.fullscreentype = "desktop"        -- "desktop" or "exclusive"
    t.window.vsync = 1                         -- Enable vertical sync (0 to disable)
    t.window.msaa = 0                          -- Multi-sampling anti-aliasing (0, 2, 4, 8)
    t.window.highdpi = false                   -- Enable high-DPI mode
    t.window.x = nil                           -- Window x position (nil = centered)
    t.window.y = nil                           -- Window y position (nil = centered)
    t.window.display = 1                       -- Monitor number

    -- Modules
    t.modules.audio = true                     -- Sound system
    t.modules.data = true                      -- Data saving/loading
    t.modules.event = true                     -- Event handling
    t.modules.font = true                      -- Font system
    t.modules.graphics = true                  -- Graphics rendering
    t.modules.image = true                     -- Image loading
    t.modules.joystick = false                  -- Joystick/gamepad support
    t.modules.keyboard = true                  -- Keyboard input
    t.modules.math = true                      -- Math module
    t.modules.mouse = true                     -- Mouse input
    t.modules.physics = false                   -- Physics system (Box2D)
    t.modules.sound = true                     -- Sound playback
    t.modules.system = true                    -- System functions
    t.modules.thread = true                    -- Threading
    t.modules.timer = true                     -- Timing functions
    t.modules.touch = true                     -- Touch input
    t.modules.video = false                    -- Video playback (disabled by default)
    t.modules.window = true                    -- Window management

    -- Advanced Graphics
    t.window.depth = 0                         -- Depth buffer bits (0, 16, 24)
    t.window.stencil = 0                       -- Stencil buffer bits (0, 8)
    t.window.usedpiscale = true                -- Account for DPI scaling
    t.window.gammacorrect = false              -- Gamma correction

    warn = function(...) -- Redirect prints to console
        if t.console and t.debugMode then
            local args = {...}
            for i = 1, #args do args[i] = tostring(args[i]) end
            local buttons = {"Continue","Quit",escapeButton = 2}
            local pressedButton = love.window.showMessageBox("Warn", table.concat(args, "\t"), buttons, "warning")
            print("[Warn]  "..table.concat(args, "\t"))
            if pressedButton == buttons.escapeButton then
                love.event.push('quit')
            end
        end
    end
    errorBox = function(...) -- Redirect prints to console
        if t.console and t.debugMode then
            local args = {...}
            for i = 1, #args do args[i] = tostring(args[i]) end
            local buttons = {"Continue","Quit",escapeButton = 2}
            local pressedButton = love.window.showMessageBox("Error", table.concat(args, "\t"), buttons, "error")
            print("[ERROR]  "..table.concat(args, "\t"))
            if pressedButton == buttons.escapeButton then
                love.event.push('quit')
            end
        end
    end
    
    isClass = function(object)
        if type(object) == 'table' then
            if object.class then
                if object.class.name then
                    return true
                end
            end
        end
        return false
    end
    
    
    typeof = function(var)
        if isClass(var) then
            return var.class.name
        end
        return type(var)
    end
    
    objectInherits = function(object,inheritsClassName)
        assert(not (object.name and object.static and object.subclasses),"Create an instance before checking inheritance.")
        assert(object.class and object.class.name,"Object given must be a class created via middleclass.")
        assert(inheritsClassName or inheritsClassName ~= "","Required field not given, inheritsClassName. ("..tostring(inheritsClassName)..")")
        assert(type(inheritsClassName) == 'string',"Invalid type for parameter 'inheritsClassName'. (expected 'string' got '"..typeof(inheritsClassName).."')")
        if typeof(object) == inheritsClassName then return true; end
        local head = object.class.super
        while head ~= nil do
            if object.class and object.class.name then
                if head.name == inheritsClassName then
                    return true
                else
                    head = head.super
                end
            end
        end
        return false
    end
    
    Class = require("Source.Core.middleclass")
    Vector = require("Source.Core.Classes.vector")
    UDim2 = require("Source.Game.Classes.udim")
    GameObject = require("Source.Game.Classes.game_object")
end

