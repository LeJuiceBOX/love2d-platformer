
local Button = Class("Button")

    function Button:initialize(text,x,y,w,h,onClick)
        self.position = Vector(x or 0,y or 0)
        self.size = Vector(w or 32,h or 32)
        self.callback = onClick or function() print("Button callback undefined!") end
        self.text = text or ""
        self.delay = 0.2

        self.buttonColor = Color(20,20,50)
        self.hoverColor = Color(40,40,70)
        self.clickColor = Color(30,30,60)
        self.textColor = Color(255,255,255)

        self.callbacks = {
            onClick = onClick or function() print("Button callback undefined!") end,
            onHoverEnter = function() end,
            onHoverLeave = function() end,
            onMouseDown = function() end,
            onMouseUp = function() end,
        }
        self._mouseHovering = false
        self._canClick = true
        self._lastClicked = 0
        self._currentButtonColor = self.buttonColor
    end

    
    function Button:update(dt)
        local isHovering = self:_isHovering()
        if isHovering and love.mouse.isDown(1) then
            self._currentButtonColor = self.clickColor
            if love.timer.getTime() - self._lastClicked > self.delay then
                self:activate()
            end
        elseif isHovering then
            self._currentButtonColor = self.hoverColor
        elseif isHovering == false then
            self._currentButtonColor = self.buttonColor
        end
    end

    function Button:activate()
        self._lastClicked = love.timer.getTime()
        self.callback()
    end

    function Button:draw()
        self._currentButtonColor:set()
        love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
        self.textColor:set()
        love.graphics.print(self.text,self.position.x,self.position.y)
        self.buttonColor:set()
    end

    function Button:_isHovering()
        local x,y = love.mouse.getPosition()
        if x > self.position.x and x < self.position.x+self.size.x then
            if y > self.position.y and y < self.position.y+self.size.y then
                return true
            end
        end
        return false
    end

return Button