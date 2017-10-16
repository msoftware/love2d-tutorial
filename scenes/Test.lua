local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Vector2 = require("lib.Vector2")

local Player = require("../Player")
local Enemy = require("../Enemy")

local T = Scene:derive("Test")

function T:new(scene_mgr) 
    T.super.new(self, scene_mgr)
    self.p = Player()
    self.em:add(self.p)

    self.e = Enemy()
    self.e.spr.tintColor = U.color(255,0,0,255)
    self.e.spr.pos.x = 320
    self.em:add(self.e)

    self.c1 = {x = 200, y = 200, r= 20, c = U.color(255)}
    self.c2 = {x = 320, y = 200, r= 40, c = U.color(255, 200, 200)}
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    local r1 = self.p.spr:rect()
    local r2 = self.e.spr:rect()
    if U.AABBColl(r1, r2) then
        self.p.spr.tintColor = U.color(0,128,128,200)

        local md = r2:minowski_diff(r1)

        --This will give us our separation vector
        -- x > 0 = Left side collision, x < 0 = right side collision
        -- y > 0 = Top side collision, y < 0 = bottom collision
        local sep = md:closest_point_on_bounds(Vector2())
        
        local collision = U.bounds_point_to_collision_side(sep)
        print(collision.bottom)
        print(collision.top)

        self.p.spr.pos.x = self.p.spr.pos.x + sep.x 
        self.p.spr.pos.y = self.p.spr.pos.y + sep.y 
        
    else
        self.p.spr.tintColor = U.color(255)
    end


    --Check if the circles collide
    if U.CirclesCollide(self.c1, self.c2) then
        self.c1.c = U.color(0,128,128,200)
    else
        self.c1.c = U.color(255)
    end

    if Key:key("w") then
        self.c1.y = self.c1.y - 115 * dt
    elseif Key:key("s") then
        self.c1.y = self.c1.y + 115 * dt
    elseif Key:key("a") then
        self.c1.x = self.c1.x - 115 * dt
    elseif Key:key("d") then
        self.c1.x = self.c1.x + 115 * dt
    end

end

function T:draw()
    love.graphics.clear(64,64,255)
    self.super.draw(self)

    love.graphics.setColor(self.c1.c)
    love.graphics.circle("line", self.c1.x,self.c1.y, self.c1.r)

    love.graphics.setColor(self.c2.c)
    love.graphics.circle("line", self.c2.x,self.c2.y, self.c2.r)
end

return T
