local Color = Class("Color")

    Color.reset = function()
        love.graphics.setColor(1,1,1,1)
    end

    function Color:initialize(r,g,b,a)
        self.rgb = {r or 1,g or 1,b or 1}
        self.alpha = a or 1
    end

    function Color:set()
        love.graphics.setColor(self.rgb[1]/255,self.rgb[2]/255,self.rgb[3]/255,self.alpha)
    end

    function Color:unpack()
        return self.rgb[1]/255,self.rgb[2]/255,self.rgb[3]/255
    end

    function Color:unpackRGB()
        return self.rgb[1],self.rgb[2],self.rgb[3]
    end

return Color