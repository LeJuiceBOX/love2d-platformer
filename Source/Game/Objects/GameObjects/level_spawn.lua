


local LevelSpawn = Class("LevelSpawn",GameObject)

    function LevelSpawn:initialize(x,y,initVel)
        GameObject.initialize(self)
        self.initPlayerVelocity = initVel or Vector(0,0)
        self.radius = 8
        self.position = Vector(x or 0,y or 0)
        self.player = nil
    end

    function LevelSpawn:resetPlayer()
        if self.player ~= nil then
            self.player.enabled = true
            self.player.velocity = self.initPlayerVelocity
            self.player:moveTo(self.position.x,self.position.y,true)
        end
    end

    function LevelSpawn:draw()
        local r,g,b = love.graphics.getColor()
        love.graphics.setColor(0.5,0.5,1)
        love.graphics.circle("line",self.position.x,self.position.y,self.radius)
        love.graphics.setColor(r,g,b)
    end


return LevelSpawn