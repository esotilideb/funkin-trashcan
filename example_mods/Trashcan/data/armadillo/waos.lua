function onUpdate(elapsed)
	if not middlescroll then
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

function onUpdatePost(elapsed) --Idk how to code :c
	if curStep == 118 then
	setProperty('defaultCamZoom', 0.9)
	triggerEvent('Camera Follow Pos', 585, 1460)
	end
	
	if curStep == 121 then
	setProperty('defaultCamZoom', 1.2)
	triggerEvent('Camera Follow Pos', 460, 1460)
	end
	
	if mustHitSection == false and curStep >= 128 then
	setProperty('defaultCamZoom', 0.95)
	triggerEvent('Camera Follow Pos', 785, 1450)
	elseif mustHitSection == true and curStep >= 128 then
	setProperty('defaultCamZoom', 0.85)
	triggerEvent('Camera Follow Pos', 690, 1460)
	end
	
	if curStep >= 518 then
	triggerEvent('Camera Follow Pos', 635, 1460)
	end
	
	if mustHitSection == false and curStep >= 582 then
	setProperty('defaultCamZoom', 0.95)
	triggerEvent('Camera Follow Pos', 785, 1450)
	elseif mustHitSection == true and curStep >= 582 then
	setProperty('defaultCamZoom', 0.85)
	triggerEvent('Camera Follow Pos', 690, 1460)
	end
	
	if curStep >= 1286 then
	triggerEvent('Camera Follow Pos', 635, 1460)
	end
	
	if mustHitSection == false and curStep >= 1350 then
	setProperty('defaultCamZoom', 0.95)
	triggerEvent('Camera Follow Pos', 785, 1450)
	elseif mustHitSection == true and curStep >= 1350 then
	setProperty('defaultCamZoom', 0.85)
	triggerEvent('Camera Follow Pos', 690, 1460)
	end
	
	if curStep == 518 or curStep == 1286 then
	doTweenZoom('timethework', 'camGame', 1.4, ((stepCrochet / 1000) * 16) * 6, 'quadIn')
	end
	
	if curStep == 582 or curStep == 1350 then
	cancelTween('timethework')
	end
end

function onGameOver()
    if mustHitSection == true then
		setCharacterX("bf", -50)
        setCharacterY("bf", 1390)
    else
        setCharacterY("bf", 1390)
    end
end

-- Duerman a zozerkul
