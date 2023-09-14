package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import openfl.Lib;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class TrashFreeplay extends MusicBeatState
{
	var songs:Array<SongMetadata2ComoElExe> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
    var accuracyText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	//freeplay shit

	var left:FlxSprite;
	var right:FlxSprite;
	var optionShit:Array<String> = [
		'Armadillo',
		'Nerd Power',
		'Pizza Rat',
		'Infiltred',
		'Misfits',
		'bomba 6',
		'test',
		'test1',
		'test2'
	];
	var personajes:FlxSprite;
	var abg:FlxBackdrop;
	var teclas:Float = 0;
	var continueSelectin:Bool = true;

	override function create()
	{

		Lib.application.window.title = "Funkin' Trashcan - Freeplay";

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory(); //like
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Choosing a song", null);
		#end


		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		bg = new FlxSprite().loadGraphic(Paths.image('menu/freeplayshit/bg', 'trashcan'));
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.scrollFactor.set(0);
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

        var patron = new FlxBackdrop(Paths.image('menu/patron', 'trashcan'));
		patron.alpha = 0.5;
		patron.setGraphicSize(Std.int(patron.width * 0.5));
		patron.scrollFactor.set();
		patron.velocity.set(-80, -80);
		add(patron);

        var barras:FlxSprite = new FlxSprite(50, 0).loadGraphic(Paths.image('menu/freeplayshit/barra_arriba', 'trashcan'));
	//	barras.setGraphicSize(Std.int(bg.width * 1.175));
	    barras.screenCenter(X); //nah para q
		barras.scrollFactor.set(0, 0);
		barras.antialiasing = ClientPrefs.globalAntialiasing;
		add(barras);

		var barras2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menu/freeplayshit/barra_abajo', 'trashcan'));
	//	barras2.setGraphicSize(Std.int(bg.width * 1.175));
		barras2.screenCenter(X); //nah para q
		barras2.scrollFactor.set(0, 0);
		barras2.antialiasing = ClientPrefs.globalAntialiasing;
		add(barras2);

		right = new FlxSprite(950, 0);
        right.frames = Paths.getSparrowAtlas('menu/freeplayshit/flecha_champeada', 'trashcan');
      //  right.scale.set(2, 2);
		right.screenCenter(Y);
		right.scrollFactor.set(0);
        right.antialiasing = true;
        right.animation.addByPrefix('idle', 'Flecha', 30, true);
		right.animation.addByPrefix('push', 'flecha select', 30, true);
        right.animation.play('idle');
        

		left = new FlxSprite(190, 0);
        left.frames = Paths.getSparrowAtlas('menu/freeplayshit/flecha_champeada', 'trashcan');
        //left.scale.set(2, 2);
		left.screenCenter(Y);
        left.flipX = true;
		left.scrollFactor.set(0);
        left.antialiasing = true;
        left.animation.addByPrefix('idle', 'Flecha', 30, true);
		left.animation.addByPrefix('push', 'flecha select', 30, true);
        left.animation.play('idle');

		personajes = new FlxSprite(290,10);
		personajes.loadGraphic(Paths.image('menu/freeplayshit/portraits/' + optionShit[curSelected], 'trashcan'));
		personajes.scrollFactor.set(0, 0);
		//personajes.screenCenter(XY);
		personajes.setGraphicSize(Std.int(personajes.width * 0.65));
		personajes.antialiasing = ClientPrefs.globalAntialiasing;
		add(personajes);
		
		add(left);
		add(right);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(FlxG.width / 2, 640, songs[i].songName, true);
            songText.screenCenter(X);
			songText.changeY = false;
            //songText.targetY = i - curSelected;
            songText.changeX = false;
			//songText.snapToPosition();
			grpSongs.add(songText);

			var maxWidth = 980;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			//songText.snapToPosition();

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(1000, 20, 0, "", 32);
		//scoreText.screenCenter(X);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE);

        accuracyText = new FlxText(30, 20, 0, "", 32);
		//accuracyText.screenCenter(X);
		accuracyText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0;
		add(scoreBG);

		diffText = new FlxText(-506, 5, 0, "", 32);
		diffText.screenCenter(X);
        diffText.visible = false;
		diffText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		add(diffText);

		add(scoreText);
        add(accuracyText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 136).makeGraphic(FlxG.width, 126, 0xFF000000);
		textBG.alpha = 0;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "";
		var size:Int = 16;
		#else
		var leText:String = "";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata2ComoElExe(songName, weekNum, songCharacter, color));
	}


	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
        switch (teclas){
        	case 0:
                if (FlxG.keys.justPressed.L) {
                             teclas += 1;
							 trace('l');
				}
			case 1:
				if (FlxG.keys.justPressed.O) {
							 teclas += 2;
							 PlayState.SONG = Song.loadFromJson('lorax', 'lorax');
							 PlayState.isStoryMode = false;
							 LoadingState.loadAndSwitchState(new PlayState());
							 FlxG.sound.music.stop();
							 trace('o');
				}
			}

		for (item in grpSongs.members)
		{
			item.y = 640;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'Score: ' + lerpScore;
        accuracyText.text = 'Accuracy: ' + ratingSplit.join('.') + '%';
		positionHighscore();

		var upP = controls.UI_LEFT_P;
		var downP = controls.UI_RIGHT_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;
	/*	if (help) {
			FlxG.updateFramerate = 60;
			FlxG.drawFramerate = 60;
		}*/
		
		if(songs.length > 1)
		{
			if (upP)
			{
				trace(optionShit);
				left.animation.play('push');
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					left.animation.play('idle');
				});

				FlxTween.tween(personajes,{x: 800, alpha : 0.5},0.2,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
                    {
						personajes.x = -600;
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								personajes.loadGraphic(Paths.image('menu/freeplayshit/portraits/' + optionShit[curSelected], 'trashcan'));
								FlxTween.tween(personajes,{x: 300, alpha : 1},0.2,{ease:FlxEase.cubeOut});
							});
                    }
                });

				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				trace(optionShit);
				right.animation.play('push');
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					right.animation.play('idle');
				});

                FlxTween.tween(personajes,{x: -600, alpha : 0.5},0.2,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
                    {
						personajes.x = 1200;
						trace(personajes.x);
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								personajes.loadGraphic(Paths.image('menu/freeplayshit/portraits/' + optionShit[curSelected], 'trashcan'));
								FlxTween.tween(personajes,{x: 300, alpha : 1},0.2,{ease:FlxEase.cubeOut});
							});
                    }
                });

				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_RIGHT_P || controls.UI_LEFT_P)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_LEFT_P ? -shiftMult : shiftMult));
					changeDiff();
				}
			}
		}

		if (controls.UI_DOWN_P)
			changeDiff(-1);
		else if (controls.UI_UP_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted)
		{
			FlxFlicker.flicker(personajes, 1.1, 0.15, false);
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (FlxG.keys.pressed.SHIFT){
				LoadingState.loadAndSwitchState(new ChartingState());

			/*}else if (songLowercase == 'fortnite'){
				FlxTween.tween(FlxG.camera, {zoom: 3}, 1.1, {ease: FlxEase.expoIn});
				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						PTTitleScreen.loadAndSwitchState(new PlayState());
						FlxG.sound.music.volume = 0;
					});
				trace('Viva fornai batel royal');*/
			}else{
				LoadingState.loadAndSwitchState(new PlayState());
			}

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '		↑
		' + CoolUtil.difficultyString() + '
				↓';
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
		// selector.y = (70 * curSelected) + 30;

		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata2ComoElExe
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}