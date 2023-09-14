package;

#if desktop
import sys.thread.Thread;
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;

class TrashcanTitle extends MusicBeatState
{

    var bg:FlxSprite;
    var barra1:FlxSprite;
    var barra2:FlxSprite;
    var barra3:FlxSprite;
    var barra4:FlxSprite;
    var patron:FlxBackdrop;

    var canSpin:Bool = true;
    var logoBl:FlxSprite;
    var titleText:FlxSprite;
    var skipTransition:Bool = false;
    public static var skippedIntro:Bool = false;
    var canPressEnter:Bool = false;

override public function create()
	{
        #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("¡Welcome to the Trashcan!", null);
		#end

        if(FlxG.sound.music == null) {
            FlxG.sound.playMusic(Paths.music('trashmenu', 'trashcan'), 1);
        }

        bg = new FlxSprite();
        bg.loadGraphic(Paths.image('menu/bg', 'trashcan'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        bg.alpha = 0;
        //	bg.setGraphicSize(Std.int(bg.width * 0.6));
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        patron = new FlxBackdrop(Paths.image('menu/patron_zozer', 'trashcan'));
		patron.alpha = 0;
		patron.scrollFactor.set();
        patron.setGraphicSize(Std.int(patron.width * 0.5));
		patron.velocity.set(-80, -80);
		add(patron);

        barra1    = new FlxSprite(0, -100).loadGraphic(Paths.image('menu/title/bar1', 'trashcan'));
        //barra1   .setGraphicSize(Std.int(bg.width * 1.175));
        barra1   .screenCenter(); //nah para q
        barra1   .scrollFactor.set(0, 0);
        barra1   .visible = false;
        barra1   .antialiasing = ClientPrefs.globalAntialiasing;
        add(barra1   );

        barra2    = new FlxSprite(0, -100).loadGraphic(Paths.image('menu/title/bar2', 'trashcan'));
        //barra2   .setGraphicSize(Std.int(bg.width * 1.175));
        barra2   .screenCenter(); //nah para q2
        barra2   .scrollFactor.set(0, 0);
        barra2   .antialiasing = ClientPrefs.globalAntialiasing;
        barra2   .visible = false;
        add(barra2   );

        barra3    = new FlxSprite(0, -300).loadGraphic(Paths.image('menu/mainmenu/suicidate_champ', 'trashcan'));
        //barra3   .setGraphicSize(Std.int(bg.width * 1.175));
        barra3   .screenCenter(X); //nah para q2
        barra3   .scrollFactor.set(0, 0);
        barra3   .antialiasing = ClientPrefs.globalAntialiasing;
        barra3   .visible = false;
        add(barra3   );

      /*  logoBl = new FlxSprite();
        logoBl.frames = Paths.getSparrowAtlas('menu/logo', 'trashcan');
        logoBl.antialiasing = ClientPrefs.globalAntialiasing;
        logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
        logoBl.animation.play('bump');
        logoBl.alpha = 0;
        logoBl.screenCenter();
        add(logoBl);*/

        logoBl = new FlxSprite();
		logoBl.frames = Paths.getSparrowAtlas('menu/logo', 'trashcan');
		//maurice.scale.set(3, 3);
		logoBl.scrollFactor.set(0);
		logoBl.screenCenter();
        logoBl.alpha = 0;
		logoBl.antialiasing = false;
		logoBl.animation.addByPrefix('pene', 'logo bumpin', 24, true); //nothing
		logoBl.animation.play('pene');
		add(logoBl);	

        new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                startIntro();
            });
    }

    
    function startIntro():Void
        {
            logoBl.animation.play('bump');
            if (!skippedIntro)
            {
                
                    FlxTween.tween(bg, {alpha: 1}, 10);
                    FlxTween.tween(logoBl, {alpha: 1}, 10);
                    
                    new FlxTimer().start(8, function(tmr:FlxTimer)
                        {
                            if (!skippedIntro) {
                                logoBl.angle = -3;
                                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                                    {
                                        if (canSpin) {
                                            if (logoBl.angle == -3)
                                                FlxTween.angle(logoBl, logoBl.angle, 3, 3, {ease: FlxEase.quartInOut});
                                            if (logoBl.angle == 3)
                                                FlxTween.angle(logoBl, logoBl.angle, -3, 3, {ease: FlxEase.quartInOut});
                                        }
                                    }, 0);
                                    skippedIntro = true;
                                    FlxG.camera.flash(FlxColor.WHITE, 2);
                                    logoBl.alpha = 1;
                                    barra1.visible = true;
                                    barra2.visible = true;
                                    patron.alpha = 1;
                                    bg.alpha = 1;
                            }
                        });
    
                    transitioning = true;
                    //FlxG.sound.music.fadeIn(4, 0, 0.7);
                    transitioning = false;
            }
            else if (skippedIntro) {
                FlxG.camera.flash(FlxColor.WHITE, 1);
                logoBl.alpha = 1;
                barra1.visible = true;
                barra2.visible = true;
                patron.alpha = 1;
                bg.alpha = 1;
            }
        }

    var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;
    public static var closedState:Bool = false;
    var transitioning:Bool = false;

    override function update(elapsed:Float)
        {
            trace(skippedIntro);
            if (controls.ACCEPT && !skippedIntro)
				{
					skippedIntro = true;
                    trace('pene');
				}
			if(controls.ACCEPT && skippedIntro && !canPressEnter)
			{
                new FlxTimer().start(0.5, function(tmr:FlxTimer)
                    {
                        canPressEnter = true;
                    });
                    
			//	FlxTween.tween(titleText, {y: 999}, 3, {ease: FlxEase.circOut});
				FlxTween.tween(barra1   , {y: 150}, 2, {ease: FlxEase.circOut});
				FlxTween.tween(barra2   , {y: -999}, 35, {ease: FlxEase.circOut});

				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
                    Transition();
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
            if(controls.ACCEPT && skippedIntro && canPressEnter)
                {
                    MusicBeatState.switchState(new MainMenuState());
                }
			super.update(elapsed);
        }

        function Transition():Void
            {
                FlxTween.tween(logoBl, {"scale.x": 0.3, "scale.y": 0.3}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(logoBl, {x: -280,y: -125}, 1, {ease: FlxEase.expoIn});
                barra3.visible = true;
                barra1.visible = true;
                FlxTween.tween(barra3, {y: -50}, 1, {ease: FlxEase.circOut});
                FlxTween.tween(barra1, {y: 50}, 1, {ease: FlxEase.circOut});
				new FlxTimer().start(2, function(tmr:FlxTimer)
                    {
                        MusicBeatState.switchState(new MainMenuState());
                    });
            }
}
