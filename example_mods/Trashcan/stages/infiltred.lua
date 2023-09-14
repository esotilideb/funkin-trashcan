function onCreate()
	-- esta verga tomo 2 horas
        -- Esto lo hizo zozer jaja que malo
	makeLuaSprite('Bg', 'infiltred/cieloinfiltred', -1650, -787)
	setScrollFactor('Bg', 0.5, 0.5)

        makeAnimatedLuaSprite('luces', 'infiltred/luces', -175, 840)
        addAnimationByPrefix('luces', 'luces', 'luces', 24, true)
	setScrollFactor('luces', 0.9, 0.9)

	makeLuaSprite('suelo', 'infiltred/sueloinfiltred', -1650, -1187)
	setScrollFactor('suelo', 0.9, 0.9)

	addLuaSprite('Bg', false)
        addLuaSprite('luces', false)
	addLuaSprite('suelo', false)
end

function onUpdatePost()
        setProperty('Bg.antialiasing', false)
        setProperty('luces.antialiasing', false)
        setProperty('suelo.antialiasing', false)
        setProperty('iconP1.antialiasing', false)
        setProperty('iconP2.antialiasing', false) 
end