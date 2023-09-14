function onCreate()
    if songName == 'Misfits' then
        setPropertyFromClass('GameOverSubstate', 'characterName', 'whenmueres')
        setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'morido')
    else
	    setPropertyFromClass('GameOverSubstate', 'characterName', 'gameover')
        setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'basurero')
    end
end
