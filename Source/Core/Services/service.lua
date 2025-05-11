

math.randomseed(os.time())
local Service = Class("Service")

 
function Service:initialize()
    self.random = love.math.random
    self._numHashes = 0
end

function Service:uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and self.random(0, 0xf) or self.random(0, 0xb)
        return string.format('%x', v)
    end)
end

function Service:newHash(w)
    self._numHashes = self._numHashes + 1
    return self:uuid():sub(1, 8).."-"..tostring(self._numHashes)
end

return Service