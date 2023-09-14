function onCreate()
setProperty('healthBar.alpha', tonumber(0))
setProperty('iconP1.alpha', tonumber(0))
setProperty('iconP2.alpha', tonumber(0))

	setProperty('skipCountdown', true)
end

function onUpdatePost()
	triggerEvent('Camera Follow Pos', '640', '360')
end

function onCreatePost()
	setProperty('debugKeysChart', null);
end

function onUpdate(elapsed)
triggerEvent('Camera Follow Pos', '640', '360')
setProperty('health',1)
    for i=0,3 do
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 0.3)
        noteTweenAlpha(i+16, i, math.floor(curStep/9999), 4-7)
    end
end

function onGameOver()
	io.popen('start mods/Trashcan/videos/doyouloveme.mp4')
	os.exit();
end

function onPause()
	return Function_Stop
end

function onEndSong()
	os.exit();
end