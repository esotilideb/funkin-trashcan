function onCreate()

	makeLuaSprite('bgX', 'armadillo/bgX', -251, 424);
	setScrollFactor('bgX', 1, 1)
	scaleObject('bgX', 1.1, 1.1)

	makeLuaSprite('Shader', 'armadillo/Shader', -275, -255);
	setScrollFactor('Shader', 0, 0)
	scaleObject('Shader', 2, 1.22)

	makeLuaSprite('borders', 'armadillo/borders', -150, -64);
	setObjectCamera('borders', 'hud')
	setObjectOrder('borders', 1)

	addLuaSprite('bgX', false)
	addLuaSprite('Shader', true)
	addLuaSprite('borders', true)

	setBlendMode("Shader", "add")
	setProperty("Shader.alpha", "0.7")

    close(true);
end
