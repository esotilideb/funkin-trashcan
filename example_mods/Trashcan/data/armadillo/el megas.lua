function onCreate()
	makeLuaSprite('Mierdaman', 'armadillo/Mierdaman', 0, 0)
	setObjectCamera('Mierdaman', 'hud')
	setScrollFactor('Mierdaman', 0.9, 0.9)
	addLuaSprite('Mierdaman', true)
end

function onCreatePost()
    setProperty('Mierdaman.alpha',  getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))
    setProperty('Mierdaman.x', getProperty('healthBar.x') - 20)
    setProperty('Mierdaman.angle', getProperty('healthBar.angle'))
    setProperty('Mierdaman.y', getProperty('healthBar.y') - 20)
    setProperty('Mierdaman.scale.x', getProperty('healthBar.scale.x'))
    setProperty('Mierdaman.scale.y', getProperty('healthBar.scale.y'))
    setObjectOrder('Mierdaman', 4)
	setObjectOrder('healthBar', 3)
	setObjectOrder('healthBarBG', 2)
	setProperty('healthBar.y', getProperty('Mierdaman.y') + 18)
	scaleObject('healthBar', 1, 1.65)
end

-- Nunca jugue megaman es un momazo nomas :'v

function onUpdatePost()
    setProperty('iconP1.flipX',true)
    setProperty('iconP2.flipX',true)
    setProperty('healthBar.flipX',true)
	setProperty('iconP2.x', getMidpointX('healthBar')+224)
    setProperty('iconP1.x', getMidpointX('healthBar')-374)
    setProperty('iconP2.y', getMidpointY('healthBar')-75)
    setProperty('iconP1.y', getMidpointY('healthBar')-75)

    if hideHud == true then
        setProperty("Mierdaman.alpha", 0)
    end
end

function opponentNoteHit()
	health = getProperty('health')
	if getProperty ('health') > 0.05 then
	setProperty ('health', health - 0.02);
	end
end
