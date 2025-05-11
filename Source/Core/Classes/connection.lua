
---@class SignalConnection : Class
local SignalConnection = Class("SignalConnection")

function SignalConnection:__init(signal,singalConnectIndex,callback)
    assert(typeof(signal) == "Signal","Parameter must be of type Signal. (got "..typeof(signal)..")")
    assert(typeof(singalConnectIndex) == "number","Parameter must be of type number. (got "..typeof(signal)..")")
    assert(typeof(callback) == "function","Parameter must be of type function. (got "..typeof(callback)..")")
        self.signal = signal
        self.index = singalConnectIndex
        self.callback = callback
end

function SignalConnection:disconnect()
    self.signal:disconnectIndex(self.index)
end

return SignalConnection