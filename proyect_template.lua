-- title:   game title	
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

function colide(r1, r2)
   if rect1.x + rect1.width < rect2.x then return false end
   if rect1.x > rect2.x + rect2.width then return false end
   if rect1.y + rect1.height < rect2.y then return false end
   if rect1.y > rect2.y + rect2.height then return false end
   return true
end

function requireNonNullElse(givenValue, defaultValue)
   if givenValue ~= nil then return givenValue else return defaultValue end
end

function forEach(tbl, func)
   for i, v in ipairs(tbl) do func(v, i) end
end

----- Entity -----

local Entity = {} 
Entity.__index = Entity

function Entity:new(args)
   local ins = setmetatable({}, Entity)
   ins.__entity = {}
   ins.__create = args.create
   ins.__update = args.update
   ins.__draw = args.draw
   return ins
end

function Entity:create(...) table.insert(self.__entity, self:__create(...)) end
function Entity:update() forEach(self.__entity, self.__update) end
function Entity:draw() forEach(self.__entity, self.__draw) end
function Entity:delete() self.__entity = {} end

----- Scene -----

local Scene = {}
Scene.__index = Scene

function Scene:new(args)
   local ins = setmetatable({}, Scene)
   ins.__entities = {}
   ins.__create = args.create
   ins.__update = args.update
   ins.__draw = args.draw

   args.preload(ins)
   
   return ins
end

function Scene:registerEntity(entity)
   table.insert(self.__entities, entity)
end

function Scene:start()
   self:__create()
   TIC = function()
      self:__update();
      self:__draw();
   end
end

function Scene:change(scene)
   forEach(self.__entities, function(e) e:delete() end)
   trace("AA")
   scene:start()
end















Player = Entity:new(
   {
      create = function (self, x, y)
         return {
            frame = 0,
            alive = true,
            x = 96 + requireNonNullElse(x, 0),
            y = 24 + requireNonNullElse(y, 0)
         }
      end,
      
      update = function (self)
         self.frame = 1 + (time()/20)%60 // 30 * 2

         if btn(0) then self.y=self.y-1 end
         if btn(1) then self.y=self.y+1 end
         if btn(2) then self.x=self.x-1 end
         if btn(3) then self.x=self.x+1 end
      end,
      
      draw = function (self)
         -- no hace nada si esta muerto
         if not self.alive then return end

         spr(self.frame,self.x,self.y,14,3,0,0,2,2)
      end
   }
)


TestScene = Scene:new(
   {
      preload = function(self)
         self.static = "Static"
      end,

      create = function(self)
      end,

      update = function(self)
         if btnp(5) then self:change(MainScene) end
      end,

      draw = function(self)
         print(self.static)
      end
   }
)

MainScene = Scene:new(
   {
      preload = function (self)
         self.message = "HELLO WORLD!"
         self:registerEntity(player)
      end,

      create = function (self)
         player:create(0,0)
      end,
      
      update = function (self)
         player:update()

         if btnp(4) then player:create(0,0) end
         if btnp(5) then self:change(TestScene) end
      end,
      
      draw = function (self)
         cls(13)
         player:draw()
         print(self.message,84,84)
      end,
   }
)


function TIC()
   MainScene:start()
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

