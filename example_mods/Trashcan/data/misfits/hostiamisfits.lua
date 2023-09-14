playVideo = true;

function onCreate()
	setHealthBarColors("FF0000", "66FF33")
	setObjectOrder('gfGroup', 8)
end

function onStartCountdown()
	timethework = getRandomInt(1, 100);

	if playVideo and timethework == 100 then
		startVideo('timethework'); --Play video file from "videos/" folder
		playVideo = false;
		return Function_Stop; --Prevents the song from starting naturally
	end

	if playVideo and timethework <= 99 then
		startVideo('nomamelamisfit');
		playVideo = false;
		return Function_Stop;
	end

	return Function_Continue; --Played video and dialogue, now the song can start normally
end

function onUpdatePost(elapsed)
	setProperty('iconP2.x', getProperty("iconP1.x")-125)
	setProperty('iconP1.x', getProperty("iconP2.x")+135)
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if curStep <= 478 or curStep >= 488 then
		if noteType == '' then
			runHaxeCode("game.iconP2.changeIcon('ogorki');");
		end
	end

	if noteType == 'harry' then
		runHaxeCode("game.iconP2.changeIcon('harry');");
	end

	if noteType == 'novies' then
		runHaxeCode("game.iconP2.changeIcon('bootleg');");
	end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if curStep <= 606 or curStep >= 616 then
		if noteType == '' then
			runHaxeCode("game.iconP1.changeIcon('coldsteel');");
		end
	end

	if noteType == 'GF Sing' then
		runHaxeCode("game.iconP1.changeIcon('soniku');");
	end

	if noteType == 'novios' then
		runHaxeCode("game.iconP1.changeIcon('recolor');");
	end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
	if curStep <= 606 or curStep >= 616 then
		if noteType == '' then
			runHaxeCode("game.iconP1.changeIcon('coldsteel');");
		end
	end

	if noteType == 'GF Sing' then
		runHaxeCode("game.iconP1.changeIcon('soniku');");
	end

	if noteType == 'novios' then
		runHaxeCode("game.iconP1.changeIcon('recolor');");
	end
end