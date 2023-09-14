-- Thanks to Nickobelit for the script :)
-- https://twitter.com/nickobelityt

local allowCountdown = false
inCharSelect = false
jugadorSeleccion = 2
local SelectorX = 865
local SelectorY = 65
local LimiteMaximo = 2
local LimiteMinimo = 1
local UsarSelector = 1
local Pou = 0

function onStartCountdown()
    if not allowCountdown and not seenCutscene then
		setProperty('inCutscene', true)
 	    runTimer('holaSelector', 0.2)
        setProperty('camHUD.visible', false)

        makeLuaSprite('blackBg','',0,0)
        makeGraphic('blackBg',1280,720,'000000')
        scaleObject('blackBg',3,3);
	    setObjectCamera("blackBg", 'other')
	    addLuaSprite('blackBg', true)

		makeLuaSprite('bgSelector', 'nerd/unpng', -225, -25)
		addLuaSprite('bgSelector', true)
	    setObjectCamera('bgSelector', 'other')
		scaleObject('bgSelector', 0.57, 0.57);

        makeLuaSprite('pou', 'nerd/pou', 210, 0)
		addLuaSprite('pou', true)
	    setObjectCamera('pou', 'other')
	    setProperty('pou.antialiasing',false)
		setProperty('pou.alpha', 0)
	    scaleObject('pou', 3, 3)

        makeAnimatedLuaSprite('AVGN', 'characters/avgn', 200, 223)
        addAnimationByPrefix('AVGN', 'idle', 'idle', 24, true)
		addAnimationByPrefix('AVGN', 'right', 'right', 24, false)
		addAnimationByPrefix('AVGN', 'missleft', 'missleft', 24, false)
		scaleObject('AVGN', 0.7, 0.7)
		addLuaSprite('AVGN', true)
		setObjectCamera('AVGN', 'other')

		makeAnimatedLuaSprite('NC', 'characters/nc', 800, 220)
		addAnimationByPrefix('NC', 'idle', 'idle', 24, true)
		addAnimationByPrefix('NC', 'missright', 'missright', 24, false)
		addAnimationByPrefix('NC', 'left', 'left', 24, false)
		scaleObject('NC', 0.7, 0.7)
		addLuaSprite('NC', true)
		setObjectCamera('NC', 'other')

     allowCountdown = true
		return Function_Stop
	end
	return Function_Continue
end

function onUpdate()
	if inCharSelect == true and UsarSelector == 1 then
		makeAnimatedLuaSprite("flecha", "nerd/mouse", SelectorX, SelectorY)
		addAnimationByPrefix("flecha", "seleccionar", "flecha select", 24, false)
	    addLuaSprite('flecha', true)
	    setObjectCamera('flecha', 'other')
		scaleObject("flecha", 0.7, 0.7)

       if keyJustPressed('right') or keyJustPressed('left') then
			if jugadorSeleccion >= LimiteMaximo and keyJustPressed('right') then
				playSound('scrollMenu', 1)
				jugadorSeleccion = 1
			elseif jugadorSeleccion <= LimiteMinimo and keyJustPressed('left') then
				playSound('scrollMenu', 1)
				jugadorSeleccion = 2
			else

				if keyJustPressed('right') then
					playSound('scrollMenu', 1);
					jugadorSeleccion = jugadorSeleccion + 1
				end

				if keyJustPressed('left') then
					playSound('scrollMenu', 1);
			        jugadorSeleccion = jugadorSeleccion - 1
				end
			end

            if jugadorSeleccion == 1 then
				SelectorX = 275
				SelectorY = 65
				elseif jugadorSeleccion == 2 then
				SelectorX = 865
				SelectorY = 65
			end
		end

		if keyJustPressed('accept') then
			UsarSelector = 0
			if jugadorSeleccion == 1 then
				setProperty('AVGN.x', 155)
				setProperty('AVGN.y', 258)
				setProperty('NC.x', 845)
				setProperty('NC.y', 223)
				playAnim("NC", "missright", false, false, 0)
				playAnim("AVGN", "right", false, false, 0)
				playSound('poopy head')
				runTimer('chau', 1)
				runTimer('AVGN', 1)
			end

			if jugadorSeleccion == 2 then
				setProperty('NC.x', 692)
				setProperty('NC.y', 247)
				setProperty('AVGN.x', 120)
				setProperty('AVGN.y', 223)
				playAnim("NC", "left", false, false, 0)
				playAnim("AVGN", "missleft", false, false, 0)
				playSound('ass whoopin')
				runTimer('chau', 1)
				runTimer('NC', 1)
			end
		end

		if UsarSelector == 1  then
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.P') and Pou == 0 then
				Pou = 1
			elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.O') and Pou == 1 then
				Pou = 2
			elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.U') and Pou == 2 then
				Pou = 3
			elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.P') or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.U') and Pou == 1 then
				Pou = 0
			elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.P') or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.O') and Pou == 2 then
				Pou = 0
			end
		end

		if Pou == 3 and UsarSelector == 1 then
			setProperty('pou.alpha', 1)
			setProperty('bgSelector.alpha', 0)
		end
	end
end

function onTimerCompleted(tag)
	if tag == 'holaSelector' then
		inCharSelect = true
	end

	if tag == 'chau' then
		inCharSelect = false
		setProperty('camHUD.visible', true)
		doTweenAlpha('flecha', 'flecha', 0, 1)
		doTweenAlpha('AVGN', 'AVGN', 0, 1)
		doTweenAlpha('NC', 'NC', 0, 1)
		doTweenAlpha('blackBg', 'blackBg', 0, 1)
		doTweenAlpha('bgSelector', 'bgSelector', 0, 1)
		doTweenAlpha('pou', 'pou', 0, 1)
		startCountdown()
	end

	if tag == 'NC' then
		addLuaScript('waos/alo')
	end

	if tag == 'AVGN' then
		addLuaScript('waos/PlayAsOpponent')
		addLuaScript('waos/ola')
	end

	if tag == 'AVGN' and middlescroll then
		setPropertyFromGroup('playerStrums', 0, 'x', defaultOpponentStrumX0)
        setPropertyFromGroup('playerStrums', 1, 'x', defaultOpponentStrumX1)
        setPropertyFromGroup('playerStrums', 2, 'x', defaultOpponentStrumX2)
        setPropertyFromGroup('playerStrums', 3, 'x', defaultOpponentStrumX3)
        setPropertyFromGroup('playerStrums', 4, 'x', defaultOpponentStrumX4)
        setPropertyFromGroup('opponentStrums', 0, 'x', defaultPlayerStrumX0 + 0)
        setPropertyFromGroup('opponentStrums', 1, 'x', defaultPlayerStrumX1 + 0)
        setPropertyFromGroup('opponentStrums', 2, 'x', defaultPlayerStrumX2 + 0)
        setPropertyFromGroup('opponentStrums', 3, 'x', defaultPlayerStrumX3 + 0)
        setPropertyFromGroup('opponentStrums', 4, 'x', defaultPlayerStrumX4 + 0)
	end
end

function onTweenCompleted(tag)
	if tag == 'pou' then
		removeLuaSprite("flecha", true)
		removeLuaSprite('AVGN', true)
		removeLuaSprite('NC', true)
		removeLuaSprite('blackBg', true)
		removeLuaSprite('bgSelector', true)
		removeLuaSprite('pou', true)
	end
end