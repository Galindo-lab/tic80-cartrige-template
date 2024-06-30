-- title:   game title	
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
-- menu: Main_Scene ITEM


function colide(r1, r2)
    if rect1.x + rect1.width < rect2.x then return false end
    if rect1.x > rect2.x + rect2.width then return false end
    if rect1.y + rect1.height < rect2.y then return false end
    if rect1.y > rect2.y + rect2.height then return false end
    return true
end

function requireNonNullElse(givenValue, defaultValue)
    if givenValue ~= nil then
        return givenValue
    else
        return defaultValue
    end
end

function forEach(tbl, func)
    for i, v in ipairs(tbl) do
        func(v, i)
    end
end


function createNew(tbl, ...)
    table.insert(tbl.entity, tbl.create(...))
end


Player = {
    entity = {},

    create = function (x, y)
        return {
            frame = 0,
            alive = true,
            x = 96 + requireNonNullElse(x, 0) ,
            y = 24 + requireNonNullElse(y, 0)
        }
    end,

    update = function (ins)
        ins.frame = 1 + (time()/20)%60 // 30 * 2

	    if btn(0) then ins.y=ins.y-1 end
	    if btn(1) then ins.y=ins.y+1 end
	    if btn(2) then ins.x=ins.x-1 end
	    if btn(3) then ins.x=ins.x+1 end

    end,

    draw = function (ins)
        -- no hace nada si esta muerto
        if not ins.alive then return end

        spr(ins.frame,ins.x,ins.y,14,3,0,0,2,2)
    end,

    kill = function (ins)
        ins.alive = false
    end
} 



MainScene = {
	setup = function (self)
        self.message = "HELLO WORLD!"
        createNew(Player, 100)
	end, 
	
	update = function (self)
        forEach(Player.entity, Player.update)
        if btn(4) then 
            forEach(Player.entity, Player.kill) 
        end
	end,
	
	draw = function (self)
        cls(13)
        forEach(Player.entity, Player.draw)
    	print(self.message,84,84)
	end,
}





function Main_Scene()
    changeScene(MainScene)
end

function ITEM2()
    trace("Item 2")
end

GameMenu={Main_Scene,ITEM2}
CURRENT_SCENE = nil

function MENU(i)
 GameMenu[i+1]()
end

function changeScene(scene)
    CURRENT_SCENE = scene
end

function startScene(scene)
    scene:setup()
    CURRENT_SCENE = scene
end

function BOOT() 
    startScene(MainScene)
end

function TIC()
	CURRENT_SCENE:update()
	CURRENT_SCENE:draw()
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

