function onCreate()
	makeLuaSprite('fondo', 'pizza/fondotower', -90, 295)
	makeLuaSprite('suelo', 'pizza/suelotower', -65, 295)

	addLuaSprite('fondo', false)
	addLuaSprite('suelo', false)

	setScrollFactor("fondo", 0.6, 1.0)
end

function onUpdatePost()
	setProperty('fondo.antialiasing', false)
	setProperty('suelo.antialiasing', false)
	setProperty('iconP1.antialiasing', false)
	setProperty('iconP2.antialiasing', false) 
end