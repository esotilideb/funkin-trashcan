package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import sys.io.Process;
import openfl.Lib;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'trash',
		'bios',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var papuMauricio:Int = FlxG.random.int(1, 3);
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	public static var alrEntered:Bool = false;

	override function create()
	{	
		Lib.application.window.title = "Funkin' Trashcan - Main Menu";

		trace(papuMauricio);
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = persistentDraw = true;

		//mira es el trashcan we
		//*8
		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bg', 'trashcan'));
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox(); //te odio fnf mario madness
		//bg.scrollFactor.set(0, yScroll);
		bg.scrollFactor.set(0);
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var patron = new FlxBackdrop(Paths.image('menu/patron_zozer', 'trashcan'));
		patron.alpha = 0.5;
		patron.setGraphicSize(Std.int(patron.width * 0.5));
		patron.scrollFactor.set();
		patron.velocity.set(-80, -80);
		add(patron);

		//170
		var maurice = new FlxSprite(70, 970);
		maurice.frames = Paths.getSparrowAtlas('menu/mainmenu/menuidle' + papuMauricio, 'trashcan');
		//maurice.scale.set(3, 3);
		maurice.scrollFactor.set(0);
		//maurice.screenCenter();
		maurice.antialiasing = false;
		maurice.animation.addByPrefix('pene', 'maurice', 24, true); //nothing
		maurice.animation.play('pene');
		add(maurice);	


		var barras:FlxSprite = new FlxSprite(50, 0).loadGraphic(Paths.image('menu/mainmenu/suicidate_champ', 'trashcan'));
		barras.setGraphicSize(Std.int(barras.width * 1.175));
	//	barras.screenCenter(); //nah para q
		barras.scrollFactor.set(0, 0);
		barras.antialiasing = ClientPrefs.globalAntialiasing;
		add(barras);

		var barras2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menu/title/bar1', 'trashcan'));
		barras2.setGraphicSize(Std.int(bg.width * 1.175));
		barras2.screenCenter(X); //nah para q
		barras2.scrollFactor.set(0, 0);
		barras2.antialiasing = ClientPrefs.globalAntialiasing;
		add(barras2);
		trace('barra de abajo y:' + barras2.y + '  Barra de arriba y:' + barras.y);

		var logoBl = new FlxSprite(-280, -125);
		logoBl.frames = Paths.getSparrowAtlas('menu/logo', 'trashcan');
		//maurice.scale.set(3, 3);
		logoBl.scrollFactor.set(0);
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.3));
	//	logoBl.screenCenter();
       // logoBl.alpha = 0;
		logoBl.antialiasing = false;
		logoBl.animation.addByPrefix('pene', 'logo bumpin', 24, true); //nothing
		logoBl.animation.play('pene');
		add(logoBl);	

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		trace(alrEntered);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/
		for (i in 0...optionShit.length)
		{
			//60
			var offset:Float = 60 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(700, (i * 145)  + offset);
			menuItem.scale.x = scale * 2;
			menuItem.scale.y = scale * 5;
			menuItem.frames = Paths.getSparrowAtlas('menu/mainmenu/menu_' + optionShit[i], 'trashcan');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " Unselect", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " Select", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.235;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.68));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, " ", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("text", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		if (!alrEntered) {

			menuItems.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {x: 1360}, 0.1, {ease: FlxEase.circOut});
					new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							FlxTween.tween(spr, {x: 700}, 1.6, {ease: FlxEase.expoIn});
						});
				});
		}
		else if (alrEntered) {
			menuItems.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {x: 1360}, 0.1, {ease: FlxEase.circOut});
					new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							FlxTween.tween(spr, {x: 700}, 0.5, {ease: FlxEase.expoOut});
						});
				});
		}



			FlxTween.tween(maurice, {y: 180}, 2.6, {ease: FlxEase.expoOut});

		changeItem();


		super.create();
	}


	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
	//	FlxG.camera.zoom = 2;
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				alrEntered = true;
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					alrEntered = true;
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'trash':
										MusicBeatState.switchState(new TrashFreeplay());
										FlxG.sound.music.volume = 0;
								//		MusicBeatState.switchState(new FreeplayState());
									case 'bios':
										MusicBeatState.switchState(new BiosState());
										FlxG.sound.music.volume = 0;
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
										FlxG.sound.music.volume = 0;
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
