local Connection = require("Core.Classes.connection")

---@class Signal : Class
local Signal = Class("Signal")

function Signal:__init()
    self.connections = {}
end

function Signal:connect(callback)
    assert(typeof(callback) == "function","Callback must be of type function. (got "..typeof(callback)..")")
    local ind = #self.connections+1
    local c = Connection:new(self,ind,callback)
    self.connections[ind] = c
    return c
end

function Signal:disconnectIndex(index)
    table.remove(self.connections,index)
end

function Signal:disconnectAll()
    local acc = #self.connections
    self.connections = {}
    print("Disconnected "..tostring(acc).." connections.")
end

function Signal:fire(...)
    local acc = 0
    for i,connect in pairs(self.connections) do
        connect.callback(...)
        acc=acc+1
    end
    print("Fired "..tostring(acc).." connections.")
end

function Signal:drawConnections()
    love.graphics.print("Signal Connections ~",10,10)
    local acc = 0
    for i,v in pairs(self.connections) do
        love.graphics.print("  "..tostring(i).." - "..tostring(self.connections[i]),10,26+(16*acc) )
        acc=acc+1
    end
end

function Signal:print()
    print("Signal Connections ~")
    for i,v in pairs(self.connections or {}) do
        print(i,v)
    end
end

return Signal