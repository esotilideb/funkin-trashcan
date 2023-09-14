function onUpdatePost()
	if middlescroll then
		for i = 0,3 do
		
			setPropertyFromGroup('strumLineNotes', i, 'alpha', 1.0)
		
		end
		
		for i = 4,7 do
		
			setPropertyFromGroup('strumLineNotes', i, 'alpha', 0.5)
		
		end
		
	end
end

function onGameOver()
	if mustHitSection == true then
		setCharacterX("dad", -120)
		setCharacterY("dad", 400)
	else
		setCharacterX("dad", -220)
		setCharacterY("dad", 400)
	end
end