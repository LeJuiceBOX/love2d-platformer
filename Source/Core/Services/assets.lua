
local DEBUG_IMAGE_PATH = "Source/Game/Data/Graphics/imageloaderror.png"
local DEBUG_IMAGE = love.graphics.newImage(DEBUG_IMAGE_PATH)

local module = {}

module.images = {}

module.LoadImage = function(name,imagePath)
    if not love.filesystem.getInfo(imagePath) then
        error("Image path:\n'"..imagePath.."'\n\nDoes NOT exist, loading debug image instead.")
        imagePath = DEBUG_IMAGE_PATH
    end
    module.images[name] = love.graphics.newImage(imagePath)
end

module.GetImage = function(name)
    if module.images[name] == nil then
        error("Image named '"..name.."' doesn't exist in Assets.images \ndictionary, how would you like to proceed?")
        return DEBUG_IMAGE
    end
    return module.images[name]
end

return module