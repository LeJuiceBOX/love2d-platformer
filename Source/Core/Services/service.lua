

local Service = Class("Service")


function Service:initialize()
    
end

function Service:uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and self.random(0, 0xf) or self.random(0, 0xb)
        return string.format('%x', v)
    end)
end

return Service