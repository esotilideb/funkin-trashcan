function onCreate()
	makeLuaSprite('Barra', 'pizza/barra', 0, 0)
	setObjectCamera('Barra', 'hud')
	setScrollFactor('Barra', 0.9, 0.9)
	addLuaSprite('Barra', true)
end

function onCreatePost()
	setProperty('Barra.antialiasing', false)
    setProperty('Barra.alpha',  getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))
    setProperty('Barra.x', getProperty('healthBar.x') - 20)
    setProperty('Barra.angle', getProperty('healthBar.angle'))
    setProperty('Barra.y', getProperty('healthBar.y') - 20)
    setProperty('Barra.scale.x', getProperty('healthBar.scale.x'))
    setProperty('Barra.scale.y', getProperty('healthBar.scale.y'))
    setObjectOrder('Barra', 4)
	setObjectOrder('healthBar', 3)
	setObjectOrder('healthBarBG', 2)
	setProperty('healthBar.y', getProperty('Barra.y') + 12)
	setProperty('healthBar.x', getProperty('Barra.x') + 11)
	scaleObject('healthBar', 1.03, 2.4)

	if hideHud == true then
        setProperty("Barra.alpha", 0)
    end
end