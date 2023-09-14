function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Instakill Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'novios' then

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'pressNote', true); --Miss has no penalties
			end
		end
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == "novios" then
			if noteData == 0 then
				triggerEvent('Play Animation','singLEFT','gf');
				triggerEvent('Play Animation','singLEFT','bf');
			end
			
			if noteData == 1 then
				triggerEvent('Play Animation','singDOWN','gf');
				triggerEvent('Play Animation','singDOWN','bf');
			end
			
			if noteData == 2 then
				triggerEvent('Play Animation','singUP','gf');
				triggerEvent('Play Animation','singUP','bf');
			end
			
			if noteData == 3 then
				triggerEvent('Play Animation','singRIGHT','gf');
				triggerEvent('Play Animation','singRIGHT','bf');
			end
		end
	end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == "novios" then
		if noteData == 0 then
			triggerEvent('Play Animation','singLEFTmiss','gf');
			triggerEvent('Play Animation','singLEFTmiss','bf');
		end
		
		if noteData == 1 then
			triggerEvent('Play Animation','singDOWNmiss','gf');
			triggerEvent('Play Animation','singDOWNmiss','bf');
		end
		
		if noteData == 2 then
			triggerEvent('Play Animation','singUPmiss','gf');
			triggerEvent('Play Animation','singUPmiss','bf');
		end
		
		if noteData == 3 then
			triggerEvent('Play Animation','singRIGHTmiss','gf');
			triggerEvent('Play Animation','singRIGHTmiss','bf');
		end
	end
end