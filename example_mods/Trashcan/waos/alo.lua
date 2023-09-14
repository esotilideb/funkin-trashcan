function onGameOver()
	if mustHitSection == true then
		setCharacterX("bf", -155)
		setCharacterY("bf", 400)
	else
		setCharacterX("bf", -275)
		setCharacterY("bf", 400)
	end
end