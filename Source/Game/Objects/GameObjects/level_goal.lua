


local LevelGoal = Class("LevelGoal",GameObject)

    function LevelGoal:initialize(x,y,r)
        GameObject.initialize(self)
        self.radius = r or 8
        self.position = Vector(x or 0,y or 0)
        self.collider = Collider(self,'goal',HC.circle(self.position.x,self.position.y,self.radius))
        self.player = nil
        self.signal_playerTouchedGoal = nil

        self.OnDestroy = function()
            self.collider:destroy()
            self.signal_playerTouchedGoal:destroy()
        end
    end
    
    function LevelGoal:load()
        self.collider = Collider(self,'goal',HC.circle(self.position.x,self.position.y,self.radius))
        self.signal_playerTouchedGoal = SignalService:newSignal(self.hash.."-PlayerTouchedGoal")
    end

    function LevelGoal:update(dt)
        if self.player == nil then return; end
        local touchingPlayer = self.collider:collidingWith(self.player.collider.shape)
        if touchingPlayer then
            self.signal_playerTouchedGoal:fire()
        end
    end

    function LevelGoal:draw()
        local r,g,b = love.graphics.getColor()
        love.graphics.setColor(0.5,1,0.5)
        self.collider:draw()
        love.graphics.circle("line",self.position.x,self.position.y,self.radius)
        love.graphics.setColor(r,g,b)
    end


return LevelGoal