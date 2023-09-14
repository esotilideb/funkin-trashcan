function onCreate()
	makeAnimatedLuaSprite('bg', 'bomba/bg', 475, 375);
	setLuaSpriteScrollFactor('bg', 0.95, 1);
	addAnimationByPrefix('bg', 'bagroun', 'bagroun', 14, true);

	makeLuaSprite('floor', 'bomba/floor', 225, 1775);
	scaleObject('floor', 1, 1.25);

	makeLuaSprite('trash', 'bomba/trash', 725, 1500);
	setLuaSpriteScrollFactor('trash', 0.95, 1);

    makeLuaSprite('basu', 'bomba/basu', 2725, 1600);
	setLuaSpriteScrollFactor('basu', 0.95, 1);

    addLuaSprite('bg', false);
	addLuaSprite("floor", false);
	addLuaSprite('trash', false);
    addLuaSprite('basu', false);
	
	close(true);
end