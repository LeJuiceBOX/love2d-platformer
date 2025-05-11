

--===========================================================================================================================================================

local Input = Class("InputService")

Keys = {
    A = "a",
    B = "b",
    C = "c",
    D = "d",
    E = "e",
    F = "f",
    G = "g",
    H = "h",
    I = "i",
    J = "j",
    K = "k",
    L = "l",
    M = "m",
    N = "n",
    O = "o",
    P = "p",
    Q = "q",
    R = "r",
    S = "s",
    T = "t",
    U = "u",
    V = "v",
    W = "w",
    X = "x",
    Y = "y",
    Z = "z",
    A0 = "0",
    A1 = "1",
    A2 = "2",
    A3 = "3",
    A4 = "4",
    A5 = "5",
    A6 = "6",
    A7 = "7",
    A8 = "8",
    A9 = "9",
    Space = "space",
    Exclamation = "!",
    Quote = "\"",
    SingleQuote = "'",
    Hash = "#",
    Dollar = "$",
    Ampersand = "&",
    LeftParenthesis = "(",
    RightParenthesis = ")",
    Comma = ",",
    Period = ".",
    Asterisk = "*",
    Plus = "+",
    Minus = "-",
    Slash = "/",
    Backslash = "\\",
    Colon = ":",
    Semicolon = ";",
    Less = "<",
    Greater = ">",
    Equal = "=",
    Question = "?",
    At = "@",
    LeftSquareBracket = "[",
    RightSquareBracket = "]",
    Caret = "^",
    Underscore = "_",
    Grave = "`",
    Kp0 = "kp0",
    Kp1 = "kp1",
    Kp2 = "kp2",
    Kp3 = "kp3",
    Kp4 = "kp4",
    Kp5 = "kp5",
    Kp6 = "kp6",
    Kp7 = "kp7",
    Kp8 = "kp8",
    Kp9 = "kp9",
    KpDecimal = "kp.",
    KpComma = "kp,",
    KpDivision = "kp/",
    KpMultiplication = "kp*",
    KpSubtraction = "kp-",
    KpPlus = "kp+",
    KpEnter = "kpenter",
    KpEquals = "kp=",
    Up = "up",
    Down = "down",
    Left = "left",
    Right = "right",
    Home = "home",
    End = "end",
    PageUp = "pageup",
    PageDown = "pageup",
    Insert = "insert",
    Backspace = "backspace",
    Tab = "tab",
    Clear = "clear",
    Return = "return",
    Delete = "delete",
    F1 = "f1",
    F2 = "f2",
    F3 = "f3",
    F4 = "f4",
    F5 = "f5",
    F6 = "f6",
    F7 = "f7",
    F8 = "f8",
    F9 = "f9",
    F10 = "f10",
    F11 = "f11",
    F12 = "f12",
    F13 = "f13",
    F14 = "f14",
    F15 = "f15",
    F16  = "f16",
    F17 = "f17",
    F18 = "f18",
    Numlock = "numlock",
    Capslock = "capslock",
    ScrollLock = "scrolllock",
    RightShift = "rshift",
    LeftShift = "lshift",
    RightControl = "rctrl",
    LeftControl = "lctrl",
    RightAlt = "ralt",
    LeftAlt = "lalt",
    Escape = "escape"
}

MouseButtons = {
    Left = 1,
    Right = 2,
    Middle = 3,
    M4 = 4,
    M5 = 5,
    M6 = 6
}


function Input:initialize()
    
    -- public
    self.minimumDragDistance = 20
    -- singals
    self.OnKeyPressed = SignalService:newSignal("Input.KeyPressed")
    self.OnKeyReleased = SignalService:newSignal("Input.KeyReleased")
    self.OnMousePressed = SignalService:newSignal("Input.MousePressed")
    self.OnMouseReleased = SignalService:newSignal("Input.MouseReleased")
    self.OnMouseMoved = SignalService:newSignal("Input.MouseMoved")
    self.OnWheelMoved = SignalService:newSignal("Input.WheelMoved")
    self.OnDragging = SignalService:newSignal("Input.Dragging")
    -- private
    self._dragging = false
    self._mousePosition = Vector()
    self._lmbDown = false
    self._lmbDownPos = Vector
    self._lmbDragDiff = Vector()
    self._lmbDragIsTouch = false
end

--===========================================================================================================================================================

function Input:update(dt)
    self._mousePosition.x, self._mousePosition.y = love.mouse.getPosition()
    if self._dragging then
        local x,y = love.mouse.getPosition()
        self.OnDragging:fire(x,y, self._lmbDragDiff.x,self._lmbDragDiff, self._lmbDragIsTouch)
    end
end

function Input:draw()
    if self._dragging then
        love.graphics.print("Diff: "..tostring(self._lmbDragDiff),0,200)
    end
end

function Input:getMousePosition()
    return self._mousePosition:clone()
end

function Input:setMousePosition(pos)
    assert(Vector.isvector(pos),"Parameter must be of type vector. (got "..typeof(pos)..")")
    love.mouse.setPosition(pos.x,pos.y)
end

function Input:isMousePressed(button,...)
    
end

--===========================================================================================================================================================

function Input:mouseDown(button,...)
    return love.mouse.isDown(button,...)
end


function Input:keyDown(keycode,...)
    return love.keyboard.isDown(keycode,...)
end


function Input:keyPressed(key, scancode, isrepeat)
    self.OnKeyPressed:fire(key,scancode,isrepeat)
end

function Input:keyReleased(key, scancode, isrepeat)
    self.OnKeyReleased:fire(key,scancode,isrepeat)
end

function Input:mouseMoved(x, y, dx, dy, isTouch)
    if self._lmbDown then
        self._lmbDragDiff = self._lmbDragDiff + Vector(dx,dy)
        if math.abs(self._lmbDragDiff.x) > self.minimumDragDistance or math.abs(self._lmbDragDiff.y) > self.minimumDragDistance then
            self._lmbDragIsTouch = isTouch
            self._dragging = true
        end
    end
    self.OnMouseMoved:fire(x, y, dx, dy, isTouch)
end

function Input:mousePressed(x, y, button, istouch, presses)
    if button == MouseButtons.Left then 
        self._lmbDown = true 
        self._lmbDownPos = Vector(x,y)
    end
    self.OnMousePressed:fire(x, y, button, istouch, presses)
end

function Input:mouseReleased(x, y, button, istouch, presses)
    if button == MouseButtons.Left then 
        self._lmbDown = false
        self._dragging = false
        self._lmbDragDiff = Vector()
    end
    self.OnMouseReleased:fire(x, y, button, istouch, presses)
end

function Input:mouseWheelMoved(x, y)
    self.OnWheelMoved:fire(x, y)
end

--===========================================================================================================================================================

return Input