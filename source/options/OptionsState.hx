package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import flixel.addons.display.FlxBackdrop;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import openfl.Lib;

using StringTools;

class OptionsState extends MusicBeatState
{
	
	var options:Array<String> = ['Controls', 'Graphics', 'Visuals & UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	
	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals & UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	public static var fromFreeplay:Bool = false;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		Lib.application.window.title = "Funkin' Trashcan - Options";

		FlxG.sound.playMusic(Paths.music('trashbio', 'trashcan'), 1);
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bg', 'trashcan'));
		bg.color = 0xffb3b3b3;
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var barra1  = new FlxSprite(0, -100).loadGraphic(Paths.image('menu/title/bar1', 'trashcan'));
        //barra1.setGraphicSize(Std.int(bg.width * 1.175));
        barra1.screenCenter(); //nah para q
        barra1.scrollFactor.set(0, 0);
        barra1.antialiasing = ClientPrefs.globalAntialiasing;

        var barra2 = new FlxSprite(0, -100).loadGraphic(Paths.image('menu/title/bar2', 'trashcan'));
        //barra2.setGraphicSize(Std.int(bg.width * 1.175));
        barra2.screenCenter(); //nah para q2
        barra2.scrollFactor.set(0, 0);
        barra2.antialiasing = ClientPrefs.globalAntialiasing;

		var patron = new FlxBackdrop(Paths.image('menu/patron_zozer', 'trashcan'));
		patron.alpha = 0.5;
		patron.color = 0xffb3b3b3;
		patron.setGraphicSize(Std.int(patron.width * 0.5));
		patron.scrollFactor.set();
		patron.velocity.set(-80, -80);
		add(patron);
		add(barra1);
		add(barra2);

		var maurice = new FlxSprite(70, 970);
		maurice.frames = Paths.getSparrowAtlas('menu/mainmenu/menuidle2', 'trashcan');
		//maurice.scale.set(3, 3);
		maurice.scrollFactor.set(0);
		maurice.screenCenter(Y);
		maurice.antialiasing = false;
		maurice.animation.addByPrefix('pene', 'maurice', 24, true); //nothing
		maurice.animation.play('pene');
		add(maurice);	

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(600, 0, options[i], true);
			optionText.screenCenter(Y);
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			if (fromFreeplay) {
				LoadingState.loadAndSwitchState(new PlayState());
				fromFreeplay = false;
				trace(fromFreeplay);
				FlxG.sound.play(Paths.sound('cancelMenu'));
				}
			else {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}