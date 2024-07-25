-- title:   game title	
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

----- Lenguaje extensions -----

function requireNonNullElse(givenValue, defaultValue)
   if givenValue ~= nil then
      return givenValue
   end
   
   return defaultValue
end

function forEach(tbl, func)
   for i, v in ipairs(tbl) do func(v, i) end
end

function rotate(x,y,a)
   return
      x*math.cos(a)-y*math.sin(a),
      x*math.sin(a)+y*math.cos(a)
end

----- Math -----

function colide(r1, r2)
   if rect1.x + rect1.width < rect2.x then return false end
   if rect1.x > rect2.x + rect2.width then return false end
   if rect1.y + rect1.height < rect2.y then return false end
   if rect1.y > rect2.y + rect2.height then return false end
   return true
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
   TIC = function() self:__update(); self:__draw(); end
end

function Scene:change(scene)
   forEach(self.__entities, function(e) e:delete() end)
   scene:start()
end










player = Entity:new(
   {
      create = function (self, x, y)
         return {
            alive = true,
            ang = 0,
            x = 96 + requireNonNullElse(x, 0),
            y = 24 + requireNonNullElse(y, 0),
            width = 8,
            height = 8
         }
        
      end,
      
      update = function (self)
         if btn(2) then self.ang=self.ang-0.05 end
         if btn(3) then self.ang=self.ang+0.05 end

         if btn(0) then
            local dx, dy = rotate(0, -1, self.ang)
            self.x, self.y = self.x + dx, self.y + dy
         end
      end,
      
      draw = function (self)
         -- no hace nada si esta muerto
         if not self.alive then return end

         circb (self.x, self.y, 5, 12)

         local dx, dy = rotate(0, -10, self.ang)
         line(self.x, self.y, self.x + dx, self.y + dy, 12)
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
         cls(7)
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

-- <SPRITES>
-- 000:00c440200c44440204484802434444023dcccc4240ddc00200edd002000e0020
-- 001:0000000000000000000000000400000000333340040000000000000000000000
-- 002:0088808008888808088888088888880888888888808880080088800808080080
-- 003:00ddd0d00d000d0d0d000d0dd0000d0ddd000dddd0d0d00d00d0d00d0d0d00d0
-- 004:0000000000000000000000000000000000000000000000000cc4430000000000
-- 005:00ccccc00cc000c00c00000c0e000000000eeccc0000000c0000eecc0000e0e0
-- 006:000cc00000ccfcc00ccffc000cffee000cffee000ccee0000000000000000000
-- 007:00000000c0000000c0c00c00cceeeec0cee0e0e0ee0000e00000000000000000
-- 008:000ccc0000ccfc000ccffc000efccc000eee000000e000000000000000000000
-- 009:0000000000c40000000c4000000c4000000c400000c4e0000c4e000000000000
-- 010:fccccccfceeeeeeceffeeffefffeffffffffffffffffffffffffffffffffffff
-- 011:ffcccccffccffffefcffffeefeefffeffeffffffffffffffffffffffffffffff
-- 012:fffccccfffccffffffccffffffceeffffffeefffffffefffffeeffffffffffff
-- 013:fffcccccfccceffcccfeefffcffeefffffffeffffffeffffffffffffffffffff
-- 014:ffffffffffffccccfffcccdcffccccccfcccccccfcccccccfcecccecfccccccc
-- 015:ffffffffccccffffcccccfffccccccffcccfccdfccccccdfcccccdefcccccdef
-- 016:00ccccc00cccccccc2ccc2cec20c20ee0ccfeee0000eee0000000000000cee00
-- 017:00ccccc00cccccccc22c22cec20c20ee0ccfeee0000eee00000cee0000000000
-- 018:03003000300330000333330003ccc3303c0c0e333cc0ee4333cee4430342243f
-- 019:00030030000330300033333003ccc3303c0c0e333cc0ee4333c0e443f342243f
-- 020:00000600002224600000060600000006cf0cf006ff6ff0600666660006ff6066
-- 021:0000060002222460000006060000000600000006ff6ff0600666660006f66066
-- 022:000000000f0000f0f000000ff0fc3f0fff0320fff000000f0f0000f000000000
-- 023:0f0000f0f000000ff000000fff0000fff0fc3f0f0f0320f00000000000000000
-- 024:000000000f0000f0fff00ffff02f2f0f000ff000000000000000000000000000
-- 025:0000000000000000000000000f2f20f0fffffffff0f00f0f0000000000000000
-- 026:fffffffff3333ffffffff32fc0fc0ff200300220fff3220ffffffff0ff32200f
-- 027:fffffffffffffffff333332fc0fc0ff200300220fff3220fff322ff0fffff00f
-- 028:ffdd99fff009900ffc399c3fd3299328d999998f9999988ff99008ffff88ffff
-- 029:0fdd99f0f099990ffc09903fd3299328d999998f99cccc8ff90000ffffccccff
-- 030:fcccccccfcccccccfcfcccfcfcccccccffccccccfffcccddffffddeeffffffff
-- 031:cfccdeffccccdeffcccdeeffccdeefffddeeffffeeefffffffffffffffffffff
-- 032:000000000000c00000ccfc000c0cc000000cc00000cfcc00000c000000000000
-- 033:0000000000000000000c0000000cc00000cc0000000000000000000000000000
-- 034:0000000d000000dd00000dd90000d000000d001100d001230d901234dd90134c
-- 035:d0000000dd0000009dd00000000d000021009000321009004321089043310888
-- 036:ff0020fff023320f02344320034c43302344433002333320f023320fff0020ff
-- 037:ff0000fff002220f00223332022344320234c43202344333f033333fff2223ff
-- 038:ff0000fff000000f00000222000023320002344300234c43f023443fff2233ff
-- 039:feeeeeefed9ed98ee98e988eeeeefffeed98f990eeefff00e9e99080ffff000f
-- 040:ff3332fff344330f34c43320344333203333322023332200f022200fff0000ff
-- 041:ff4432fffc43322f44332220433222003322200022220000f220000fff0000ff
-- 050:dd9023440d90123300d001230009001100009000000009880000009800000008
-- 051:4331088833210880321008002100800000080000888000008800000080000000
-- 194:000c0000000cc000000ccc00000cccc0000ccc0c000cc0cc000c0ccc0000cccc
-- 195:000c000000cc00000ccc0000cccc00000ccc0000c0cc0000cc0c0000ccc00000
-- 209:00000000000000000000000c000000cc00000ccc0000cccc000ccccc0000cccc
-- 210:0c00cccccc0c0ccccc0cc0cccc0ccc0ccc0cccc0cc0ccccccc0ccccccc0cccc0
-- 211:ccc00000cc000000c00000000000000000000000000000000000000000000000
-- 225:000c0ccc000cc0cc000ccc0c000cccc0000ccccc000ccccc000ccccc000ccccc
-- 226:cc0ccc00cc0cc000cc0c0000cc0000000c000000c0000000cc000000ccc00000
-- 240:00000000000000000000000000000000000000fc00000fcc0000fccc000fcccc
-- 241:000ccccc000ccccc000ccccc00000000ccccccc0cccccc00ccccc000cccc0000
-- 242:cccc0000ccccc000cccccc000000000000000000000000000000000000000000
-- </SPRITES>

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

