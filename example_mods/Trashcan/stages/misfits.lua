function onCreate()
        makeLuaSprite("tiendas", "misfits/shop", -330.0, -130.0)
        makeAnimatedLuaSprite("tanic", "misfits/tanic", 880.0, 100.0)
        addAnimationByPrefix("tanic", "idle", "tanic bumping", 24, false)
        makeLuaSprite("edificio", "misfits/building", -470.0, -200.0)
        makeLuaSprite("piso", "misfits/floor", -950.0, 580.0)
        makeLuaSprite("cantar", "misfits/sing", -500.0, 470.0)
        makeLuaSprite("capa1", "misfits/Addlayer1", -340.0, -350.0)
        makeLuaSprite("capa2", "misfits/multiplylayer", -470.0, -100.0)
        makeLuaSprite("capa3", "misfits/multiplylayer2", -800.0, -500.0) 

        scaleObject("tiendas", 0.75, 0.75)
        scaleObject("tanic", 0.7, 0.7)
        scaleObject("piso", 0.8, 0.9)
        scaleObject("edificio", 0.6, 0.6)
        scaleObject("cantar", 0.6, 0.6)
        scaleObject("capa1", 0.6, 0.8)
        scaleObject("capa2", 0.8, 0.6)

        addLuaSprite("tiendas", false)
        addLuaSprite("tanic", false)
        addLuaSprite("piso", false)
        addLuaSprite("edificio", false)
        addLuaSprite("cantar", false)
        addLuaSprite("capa1", true)
        addLuaSprite("capa2", true)
        addLuaSprite("capa3", true)

        setScrollFactor("tiendas", 0.7, 0.7)

        setBlendMode("capa1", "add")
        setBlendMode("capa2", "multiply")
        setBlendMode("capa3", "multiply")

        setProperty('cantar.flipX', true) 
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim("tanic", "idle", true, false, 0)
	end
end

function onCountdownTick(counter)
	if counter % 2 == 0 then
		playAnim("tanic", "idle", false, false, 0)
	end
end