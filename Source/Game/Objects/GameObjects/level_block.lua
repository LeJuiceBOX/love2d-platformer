


local LevelBlock = Class("LevelBlock",GameObject)


    function LevelBlock:initialize(x,y,w,h)
        GameObject.initialize(self)
        self.position = Vector(x or 0,y or 0)
        self.size = Vector(w or 1,h or 1) -- size set to 1 so we can scale the collider
        self.collider = Collider:new(self,"floor",HC.rectangle(self.position.x,self.position.y,self.size.x,self.size.y))
        self.layer = 1
    end

    function LevelBlock:OnDestroy()
        assert(self ~= nil, "Call 'LevelBlock.OnDestroy' using ':' instead of '.'.")
        self.collider:destroy()
        self = nil
        collectgarbage()
    end
    
    function LevelBlock:moveTo(x,y)
        self.position = Vector(x,y)
        self.collider:moveTo(x+self.size.x/2,y+self.size.y/2)
    end
    
    function LevelBlock:move(x,y)
        x = x or 0
        y = y or 0
        self.position = self.position + Vector(x,y)
        self.collider:move(x,y)
    end
    
    
    function LevelBlock:resize(w,h)
        local old = self.size
        self.size = old + Vector(w,h)
        self:resizeTo(self.size.x,self.size.y)
    end
    
    
    function LevelBlock:resizeTo(w,h)
        self.size = Vector(w,h)
        self.collider = Collider:new(self,"floor",HC.rectangle(self.position.x,self.position.y,self.size.x,self.size.y))
    end
    
    function LevelBlock:load()
        self:resizeTo(self.size.x,self.size.y)
    end
    
    function LevelBlock:draw()
        Color.reset()
        self.collider:draw('line')
    end


return LevelBlock