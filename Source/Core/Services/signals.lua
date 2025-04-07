
--=================================================================================================================================

local SignalConnection = Class("SignalConnection")

function SignalConnection:initialize(signalSystem,signal,connectionHash,callback)
    assert(typeof(signalSystem) == 'SignalService', "An instance of 'SignalService' must be the first parameter. (got '"..typeof(signalSystem).."')")
    assert(typeof(signal) == 'Signal', "A signal must be the second parameter. (got '"..typeof(signal).."')")
    assert(typeof(callback) == 'function', "A function must be the fourth parameter. (got '"..typeof(callback).."')")
    self.signalSystem = signalSystem
    self.signal = signal
    self.callback = callback
    self.connectionHash = connectionHash
end

function SignalConnection:disconnect()
    self.signal.connections[self.connectionHash] = nil
    self = nil
end

--=================================================================================================================================

local Signal = Class("Signal")

function Signal:initialize(signalSystem,signalName)
    assert(typeof(signalSystem) == 'SignalService', "An instance of 'SignalService' must be the first parameter. (got "..typeof(signalSystem)..")")
    math.randomseed(os.time())
    self.random = math.random
    self.signalSystem = signalSystem
    self.signalName = signalName
    self.connections = {}
end

function Signal:fire(...)
    for hash,connection in pairs(self.connections) do
        if connection then
            connection.callback(...)
        else
            error("A connection is nil?")
        end
    end
end

function Signal:disconnectAll()
    for hash,connection in pairs(self.connections) do
        if connection then
            connection:disconnect()
        else
            print("Tried to disconnect all, connection of hash '"..tostring(hash).."' was nil?")
        end
    end
end

function Signal:connect(callback)
    local hash = self.signalSystem:newHash(self.random)
    self.connections[hash] = SignalConnection:new(self.signalSystem,self,hash,callback)
    return self.connections[hash]
end

function Signal:destroy()
    self:disconnectAll()
    self.signalSystem[self.signalName] = nil
    self = nil
end


--=================================================================================================================================

local SignalService = Class("SignalService")

function SignalService:initialize()
    self._signals = {}
end

function SignalService:print()
    for i,v in pairs(self._signals) do
        print(i,v)
    end
end

function SignalService:newSignal(signalName)
    assert(self._signals[signalName] == nil,"Signal already exists. ('"..tostring(signalName).."')")
    self._signals[signalName] = Signal:new(self,signalName)
    return self._signals[signalName]
end

function SignalService:getSignal(signalName)
    assert(self._signals[signalName] ~= nil,"Signal doesnt exist. ('"..tostring(signalName).."')")
    return self._signals[signalName]
end


function SignalService:uuid(randomFunction)
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and randomFunction(0, 0xf) or randomFunction(0, 0xb)
        return string.format('%x', v)
    end)
end
function SignalService:newHash(randomFunction)
    return self:uuid(randomFunction):sub(1, 8)
end

return SignalService