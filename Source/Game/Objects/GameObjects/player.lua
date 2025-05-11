
local Trail = require("Source.Core.Components.trail")

local DEFAULT_SIZE = Vector(24,42)

local Player = Class("Player",GameObject)

function Player:initialize()
    GameObject.initialize(self)
    --
    self.layer = 0
    --
    self.position = Vector(0,0)
    self.collider = Collider:new(self,'player',HC.rectangle(self.position.x,self.position.y,DEFAULT_SIZE.x,DEFAULT_SIZE.y))
    self.size = DEFAULT_SIZE
    -- phys
    self.velocity = Vector(0,0) -- change to pos 
    self.acceleration = Vector(0,0) -- change this frame
    self.maxRunSpeed = 50 -- the max speed player can reach with player input
    self.terminalVelocity = 100 -- max fall speed
    self.jumpGravity = 200 -- gravity while jump is held
    self.dir = Vector(0,0) -- dir player is heading in based on velocity
    self.turnSpeedMod = 2 -- how easy you can change direction
    self.airturnSpeedMod = 4 -- how easy you can change direction mid air
    self.maxJumps = 1
    self.speed = 250
    self.airSpeed = 50
    self.friction = 150
    self.airFriction = 50
    self.cyoteTime = 0.1
    self.gravity = 300
    self.jumpPower = 100
    self.canJump = true
    self.isGrounded = false
    self.isJumping = false
    self.canJump = false
    -- private
    self._input = Vector.new(0,0)
    self._posDelta = Vector(0,0)
    self._oldPos = self.position
    self._numJumps = 0
    self._timeInAir = 0
    
    
    self.trail = Trail(self,10,function (pos,alpha)
        love.graphics.setColor(0.24,0.24,1,alpha)
        love.graphics.rectangle("fill",pos.x,pos.y,self.size.x,self.size.y)
    end)
    self.trail.enabled = false
end

function Player:OnDestroy()
    self.collider:destroy()
end

function Player:load()
    self.collider = Collider:new(self,'player',HC.rectangle(self.position.x,self.position.y,DEFAULT_SIZE.x,DEFAULT_SIZE.y))
end

function Player:update(dt)
    if self.isGrounded == false then
        self._timeInAir = self._timeInAir + dt
    end
    self:_handleCollisions()
end

function Player:fixedUpdate(dt)
    if self.enabled == false then return; end
    self._posDelta = self.position-self._oldPos
    self._oldPos = self.position
    self._input = collectInput()
    
    -- determin wheather or not the player should still be concidered jumping
    if self.dir.y > 0 and self.isJumping then
        self.isJumping = false
    end

    local accel = Vector.new(0,0)

    -- handle friction
    local stoppedInput = (self._input.x == 0 and self.velocity.x ~= 0)
    local fasterThanWalkspeed = ((self.velocity.x > self.maxRunSpeed) or (self.velocity.x < -self.maxRunSpeed))
    if stoppedInput or fasterThanWalkspeed then
        if self.dir.x > 0 then
            if self.isGrounded then
                self.velocity = self.velocity - (Vector(self.friction,0)*dt)
            else
                self.velocity = self.velocity - (Vector(self.airFriction,0)*dt)
            end
        elseif self.dir.x < 0 then
            if self.isGrounded then
                self.velocity = self.velocity + (Vector(self.friction,0)*dt)
            else
                self.velocity = self.velocity + (Vector(self.airFriction,0)*dt)
            end
        end
    end

    -- handle turning speed modifiers
    local speed = 0
    if self.isGrounded then 
        speed = self.speed
        if self._input.x ~= self.dir.x then
            speed = speed * self.turnSpeedMod
        end
    else
        speed = self.airSpeed 
        if self._input.x ~= self.dir.x then
            speed = speed * self.airturnSpeedMod
        end
    end

    -- apply speed to accel based on input
    if self._input.x ~= 0 then
        accel = accel + (Vector.new(speed*dt,0)*self._input.x)
    end


    local canMultiJump = (self.maxJumps > 1 and self.isGrounded == false and self.isJumping == false)
    local canCyote = (self.isGrounded == false and self.isJumping == false and self._timeInAir < self.cyoteTime)
    self.canJump = ((self.isGrounded or canCyote or canMultiJump) and self._numJumps < self.maxJumps)

    -- jump
    if self.canJump and self._input.y > 0 then
        self._numJumps = self._numJumps + 1
        self.isGrounded = false
        self.isJumping = true
        self.velocity.y = 0 
        accel.y = accel.y - self.jumpPower
    end
    
    -- limit run speed
    if (self.velocity.x > self.maxRunSpeed and accel.x > 0) or (self.velocity.x < -self.maxRunSpeed and accel.x < 0) then
        accel.x = 0
    end

    -- handle trail when going faster than max speed
    self.trail.enabled = ((self.velocity.x > self.maxRunSpeed+5) or (self.velocity.x < -self.maxRunSpeed-5))


    self.velocity = self.velocity + accel

    -- handle gravity
    if self.isGrounded == false then
        local grav = self.gravity
        if self._input.y > 0 then
            grav = self.jumpGravity
        end
        self.velocity = self.velocity + (Vector.new(0,grav)*dt)
    end

    -- cap fall speed
    if self.velocity.y > self.terminalVelocity then
        self.velocity.y = self.terminalVelocity
    end
    
    -- cap vel to max run speed
    if self.dir.x > 0 then        
        if accel.x > self.maxRunSpeed then 
            accel.x = self.maxRunSpeed
        end
    elseif self.dir.x < 0 then
        if accel.x < -self.maxRunSpeed then
            accel.x = -self.maxRunSpeed
        end
    end

    -- changes dir based on when velocity passes or falls below vel X = 0
    if self.dir.x == 1 then
        if self.velocity.x < 0 then
            self.velocity.x = 0
            self.dir.x = 0
        end
    elseif self.dir.x == -1 then
        if self.velocity.x > 0 then
            self.velocity.x = 0
            self.dir.x = 1
        end
    end
    
    -- set x direction based on velocity dir
    if self.velocity.x > 0 then
        self.dir.x = 1
    elseif self.velocity.x < 0 then
        self.dir.x = -1
    end

    -- set y direction based on velocity dir
    if self.velocity.y > 0 then
        self.dir.y = 1
    elseif self.velocity.y < 0 then
        self.dir.y = -1
    end

    -- add vel to pos
    local vel = self.velocity/10
    self:move(vel.x,vel.y)
    self.trail:update(dt)
end

function Player:draw()
    --self.floorCollider:draw()
    self.trail:draw()
    love.graphics.setColor(0.24,0.24,1)
    love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
    love.graphics.setColor(1,1,1)
    --self.collider:draw()
    love.graphics.print("Position: ".."("..tostring(math.floor(self.position.x))..", "..tostring(math.floor(self.position.y))..")",16,16)
    love.graphics.print("XVel: "..tostring(math.floor(self.velocity.x)),16,32)
    love.graphics.print("YVel: "..tostring(math.floor(self.velocity.y)),16,48)
    love.graphics.print("Input: "..tostring(self._input),16,64)
    love.graphics.print("Grounded: "..tostring(self.isGrounded),16,80)
    love.graphics.print("Jumping: "..tostring(self.isJumping),16,96)
    love.graphics.print("Dir: "..tostring(self.dir),16,112)
    love.graphics.print("AirTime: "..tostring(math.floor(self._timeInAir*1000)/1000),16,126)
    love.graphics.print("CanJump: "..tostring(self.canJump),16,142)
end

--=========================================================================================================================================================================

function Player:_handleCollisions()
    local feetCols = self.collider:getCollisions()
    local collidedWithFloor = false
    for shape,delta in pairs(feetCols) do
        if shape.instance.enabled then
            --print(shape.collider.tag)
            if shape.collider.tag == "floor" then
                collidedWithFloor = true
                local move = Vector(delta.x,delta.y)
                -- disables setting x vel to zero based on delta.x alone
                local manuallyHandleVelX = false

                -- account for cases when player is within a pixel of the edge, without this player would teleport off platform
                local pixelSlipMovementPrereq = (delta.x ~= 0 and delta.y == 0 and self.dir.y > 0)
                local pixelSlipPosisitionPrereq = (self.position.y+self.size.y < shape.instance.position.y+self._posDelta.y)
                if pixelSlipMovementPrereq and pixelSlipPosisitionPrereq then
                    --warn("Edge case")
                    manuallyHandleVelX = true
                    local diff = (self.position.y+self.size.y)-shape.instance.position.y
                    print("Prevented pixel slip. ("..tostring(diff)..")")
                    self.isGrounded = true
                    self.velocity.y = 0
                    self:move(0,-diff)
                    self._timeInAir = 0
                    self._numJumps = 0
                elseif delta.y < 0 then -- above 
                    self.velocity.y = 0
                    self.isGrounded = true
                    self._numJumps = 0
                    self._timeInAir = 0
                    self:move(move.x,move.y*0.5)
                elseif delta.y > 0 then -- below
                    self.velocity.y = -self.velocity.y/3
                    self:move(move.x,move.y)
                else
                    self:move(move.x,move.y)

                end
                if delta.x ~= 0 and manuallyHandleVelX == false then
                    self.velocity.x = 0
                end
            end
        end
    end
    if collidedWithFloor == false then
        self.isGrounded = false
    end
end


function Player:move(x,y)
    self.position = self.position + Vector(x,y)
    self.collider:move(x,y)
end

function Player:moveTo(x,y)
    local v = Vector(x or self.position.x,y or self.position.y)
    self.position = v
    self.collider.shape:moveTo(v.x+(self.size.x/2),v.y+(self.size.y/2))
end



function collectInput()
    local axis = Vector.new(0,0)
    if InputService:keyDown("w") then
        axis = axis + Vector.new(0,1)
    end
    if InputService:keyDown("d") then
        axis = axis + Vector.new(1,0)
    end
    if InputService:keyDown("a") then
        axis = axis + Vector.new(-1,0)
    end
    return axis:normalized()
end

return Player