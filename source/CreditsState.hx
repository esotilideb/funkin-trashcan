package;

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
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import openfl.Lib;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var bg2:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var message:FlxText;
	var personajes:FlxSprite;
	var cuadroChudChudChud:FlxSprite;
	var patron:FlxBackdrop;

	//special stuff
	var cacaca:FlxSprite; 			//yo
	var jackBoxReference:FlxSprite; //coco
	var roblox:FlxSprite;  			//zozer
	var codigo:FlxSprite;  			//andree1x

	var offsetThing:Float = -75;

	override function create()
	{

		Lib.application.window.title = "Funkin' Trashcan - Credits";

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		
		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menu/creditos/bg', 'trashcan'));
		add(bg);
		bg.screenCenter();

		bg2 = new FlxSprite().loadGraphic(Paths.image('menu/creditos/special-stuff/hola adictos al sexo', 'trashcan'));
		add(bg2);
		bg2.visible = false;
		bg2.screenCenter();
		
		patron = new FlxBackdrop(Paths.image('menu/patron_zozer', 'trashcan'));
		patron.scrollFactor.set();
        patron.setGraphicSize(Std.int(patron.width * 0.5));
		patron.velocity.set(-80, -80);
		add(patron);

		var barra1    = new FlxSprite(0, -100).loadGraphic(Paths.image('menu/title/bar1', 'trashcan'));
        //barra1   .setGraphicSize(Std.int(bg.width * 1.175));
        barra1   .screenCenter(); //nah para q
        barra1   .scrollFactor.set(0, 0);
        barra1   .antialiasing = ClientPrefs.globalAntialiasing;

       var barra2    = new FlxSprite(0, -100).loadGraphic(Paths.image('menu/title/bar2', 'trashcan'));
        //barra2   .setGraphicSize(Std.int(bg.width * 1.175));
        barra2   .screenCenter(); //nah para q2
        barra2   .scrollFactor.set(0, 0);
        barra2   .antialiasing = ClientPrefs.globalAntialiasing;

		cacaca = new FlxSprite(0, 0).loadGraphic(Paths.image('menu/creditos/special-stuff/8 29 una cacaca', 'trashcan'));
        //cacaca.setGraphicSize(Std.int(bg.width * 1.175));
        cacaca.screenCenter();
		cacaca.scale.y = 0.5;
        cacaca.scrollFactor.set(0, 0);
		cacaca.visible = false;
        cacaca.antialiasing = ClientPrefs.globalAntialiasing;

		jackBoxReference = new FlxSprite(0, 0);
		jackBoxReference.frames = Paths.getSparrowAtlas('menu/creditos/special-stuff/coco', 'trashcan');
		jackBoxReference.scale.set(1, 0.15);
		jackBoxReference.scrollFactor.set(0);
		jackBoxReference.screenCenter();
		jackBoxReference.antialiasing = false;
		jackBoxReference.animation.addByPrefix('pene', 'anim_1_3_0-', 24, true); //nothing
		jackBoxReference.animation.play('pene');

		roblox = new FlxSprite(0, 0);
		roblox.frames = Paths.getSparrowAtlas('menu/creditos/special-stuff/zozer', 'trashcan');
		roblox.scale.set(1, 0.4);
		roblox.scrollFactor.set(0);
		roblox.screenCenter();
		roblox.antialiasing = false;
		roblox.visible = false;
		roblox.animation.addByPrefix('pene', 'Lolamao-', 24, true); //nothing
		roblox.animation.play('pene');

		codigo = new FlxSprite(0, 0);
		codigo.frames = Paths.getSparrowAtlas('menu/creditos/special-stuff/codigoandree1x', 'trashcan');
		codigo.scale.set(1, 0.3);
		codigo.scrollFactor.set(0);
		codigo.screenCenter();
		codigo.antialiasing = false;
		codigo.visible = false;
		codigo.animation.addByPrefix('pene', 'codigoandree1x-', 24, true); //nothing
		codigo.animation.play('pene');
		

		personajes = new FlxSprite(500,25);
		personajes.loadGraphic(Paths.image('menu/creditos/maurice-dibujos/coco', 'trashcan'));
		personajes.scrollFactor.set(0, 0);
		personajes.setGraphicSize(Std.int(personajes.width * 0.7));
		personajes.antialiasing = ClientPrefs.globalAntialiasing;

		cuadroChudChudChud = new FlxSprite(0,-50);
		cuadroChudChudChud.loadGraphic(Paths.image('menu/creditos/maurice-dibujos/cuadro-cabox', 'trashcan'));
		cuadroChudChudChud.scrollFactor.set(0, 0);
		cuadroChudChudChud.visible = false;
		cuadroChudChudChud.alpha = 0;
		cuadroChudChudChud.angularVelocity = 30;
		cuadroChudChudChud.setGraphicSize(Std.int(cuadroChudChudChud.width * 0.7));
		cuadroChudChudChud.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(cuadroChudChudChud, {y: cuadroChudChudChud.y - 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - Message
			[''],
			['CoconutMall','coco','Director and Voice Actor. ','https://twitter.com/_Coconut_Mall_',	''], //Hay 5 casos que me puedo imaginar en donde este mod termina cancelado y 3 de ellos involucran a las torres gemelas
			['Zozerkul','zozer','Director, Composer and Artist.','https://twitter.com/F0xer_Kuul?t=bUQGQ34iFJb5l3DGaNxw8Q&s=09',	''], //El mod es MIO no crean nada de lo que dice COCONUTMALL
			['Iseta', 'Iseata','Artist','https://twitter.com/Iseta__',	'Mas buena yo'],
			['Kande', 'kande','Artist','https://twitter.com/Kande_lier',	'Zozer eres un idiota la próxima vez los sprites los haces tú cómo me vas a decir que los separe cuando ya los ter...'],
			['Cabox', 'trasquabox','Coder','https://twitter.com/MJejejojo',	'8:29 una cacaca'],
			['Faro', 'quien','Artist','https://twitter.com/SHG4313',	'Hola adictos del sexo nomas alcance para arte de bio :)'],
			['Champ', 'champ y ya','Artist','https://twitter.com/Cham0i_',	'El café con leche es como el café pero con leche'],
			['Rush', 'rush','Artist','https://www.youtube.com/watch?v=ywlKn36RfOQ&t=17s',	'hola soy rush, este es mi mensaje, mira mi hamster. No viste a mi hamster, este fue mi mensaje, te amo'],
			['Missy', 'missy','Artist','https://linktr.ee/momazosm',	'2 perros + refresco por 1$'],
			['Andree1x', 'Andree1x','Charter and coder','https://twitter.com/Andree1x',	''], //Codigo ANDREE1X en la tienda de fortnite

			['              SUPPORT'],
			['MeloXD', 'melo','funkintrashcan/trasquad funny moments','https://twitter.com/MelocXD',	'Pasame ese arbol\nGracias'],
			['Dani', 'dani',' ','https://twitter.com/x_L3opardGexk0',	' '],
			['Alex N.', 'neitor','esta chistosa','https://twitter.com/Alexnietor',	' '],
			
			//['TheCapM', 'cap','fanboy de t4ilskuus','',	' '], chao cap te ira mejor en el bote...

			['              SP. THANKS'],
			['Sock.clip', 'sock','Whitty Creator','https://gamebanana.com/members/2115605',	''],
			['Nate anim8', 'nateanim8','Whitty 2','https://gamebanana.com/members/1778429',	''],
			['BBPanzu', 'bebepanson','Whitty Chromatic Creator','https://www.youtube.com/@bbpanzuRulesSoSubscribeplz123',	''],
			['Nickobelit', 'nicobelit','Creator of the original Character Selector Script','https://www.youtube.com/@TeamSanityFNF',	''],

			['Its_Capp', 'capp','Multiple Characters Script','https://gamebanana.com/members/2026070',	''],
			['Super Hugo', 'hugo','Opponent Play Script','https://gamebanana.com/members/2151945',	''],
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(60, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;

			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else optionText.alignment = CENTERED;
		}
	
		
		add(cuadroChudChudChud);
		add(personajes);
		add(barra1   );
		add(barra2   );

		descText = new FlxText(50, FlxG.height + offsetThing, 1200, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		add(descText);

		message = new FlxText(50, FlxG.height + offsetThing - 620, 1200, "", 32);
		message.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		message.scrollFactor.set();
		message.screenCenter(X);
		//message.borderSize = 2.4;
		//message.y = 0;
		add(message);

		add(cacaca);
		//toll 🕴

		add(jackBoxReference);	
		//esto de los gifs e imagenes fue gracias al niño jackbox digo coconutmall

		add(roblox);	
		//mas malo tu

		add(codigo);
		//andree1x en al tienda de fornais

		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{

		if (creditsStuff[curSelected][1] == "quien") 
			bg.loadGraphic(Paths.image('menu/creditos/special-stuff/hola adictos al sexo', 'trashcan'));
		else {
			bg.loadGraphic(Paths.image('menu/creditos/bg', 'trashcan'));
		}
		
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (creditsStuff[curSelected][1] == "trasquabox") {
			cuadroChudChudChud.visible = true;
			cacaca.visible = true;
		}

		else if (creditsStuff[curSelected][1] == "zozer") {
			roblox.visible = true;
			jackBoxReference.visible = false;
		}
		else if (creditsStuff[curSelected][1] == "coco") {
			jackBoxReference.visible = true;
			roblox.visible = false;
		}

		else if (creditsStuff[curSelected][1] == "Andree1x") {
			codigo.visible = true;
		}
			
			
		else {
			roblox.visible = false;
			codigo.visible = false;
			jackBoxReference.visible = false;
			cacaca.visible = false;
			cuadroChudChudChud.visible = false;
		}
			
		
		if (creditsStuff[curSelected][1] == "nothing" || creditsStuff[curSelected][1] == "nicobelit" || creditsStuff[curSelected][1] == "bebepanson" || creditsStuff[curSelected][1] == "capp" || creditsStuff[curSelected][1] == "hugo" || creditsStuff[curSelected][1] == "neitor" || creditsStuff[curSelected][1] == "sock" || creditsStuff[curSelected][1] == "nateanim8")  
			personajes.visible = false;
		else
			personajes.visible = true;

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP || downP) {
						FlxTween.tween(personajes,{x: 600, alpha : 0},0.15,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
							{
								if (creditsStuff[curSelected][1] == "rush")
									FlxTween.tween(personajes,{x: 350, alpha : 1},0.15,{ease:FlxEase.cubeOut});

								else if (creditsStuff[curSelected][1] == "melo")
									FlxTween.tween(personajes,{x: 500, y: -10, alpha : 1},0.15,{ease:FlxEase.cubeOut});

								else
									FlxTween.tween(personajes,{x: 500, y: 25, alpha : 1},0.15,{ease:FlxEase.cubeOut});
								
								if (creditsStuff[curSelected][1] == "nothing" || creditsStuff[curSelected][1] == "nicobelit" || creditsStuff[curSelected][1] == "bebepanson")  
									personajes.loadGraphic(Paths.image('menu/creditos/maurice-dibujos/nothing', 'trashcan'));

								else
									personajes.loadGraphic(Paths.image('menu/creditos/maurice-dibujos/' + creditsStuff[curSelected][1], 'trashcan'));

								FlxTween.tween(cuadroChudChudChud,{x: 400, alpha : 1},0.15,{ease:FlxEase.cubeOut});
							}
						});

						FlxTween.tween(cuadroChudChudChud,{x: 600, alpha : 0},0.15,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(cuadroChudChudChud,{x: 400, alpha : 1},0.15,{ease:FlxEase.cubeOut});
							}
						});

				}

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
				//	var lastX:Float = item.x;
				//	item.screenCenter(X);
				//	item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
				}
				else
				{
				//	item.x = FlxMath.lerp(item.x, 50 + -40 * Math.abs(item.targetY), lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null; //text
	var moveTween2:FlxTween = null;//message
	var moveTween3:FlxTween = null;//8:29 una cacaca
	var moveTween4:FlxTween = null;//la jackbox referencia...
	var moveTween5:FlxTween = null;//mas malo el zozerkul
	var moveTween6:FlxTween = null;//codigo andree1x en la tienda de fortnite chavales!!!

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		message.text = creditsStuff[curSelected][4];
		descText.y = FlxG.height - descText.height + offsetThing + 15;
		message.y = FlxG.height + offsetThing - 610;
		cacaca.y = message.y - 50;
		roblox.y = message.y - 50;
		codigo.y = message.y - 140;
		jackBoxReference.y = message.y - 225;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 37.5}, 0.25, {ease: FlxEase.sineOut});

		if(moveTween2 != null) moveTween2.cancel();
		moveTween2 = FlxTween.tween(message, {y : message.y - 25}, 0.25, {ease: FlxEase.sineOut});

		if(moveTween3 != null) moveTween3.cancel();
		moveTween3 = FlxTween.tween(cacaca, {y : cacaca.y - 25}, 0.25, {ease: FlxEase.sineOut});

		if(moveTween4 != null) moveTween4.cancel();
		moveTween4 = FlxTween.tween(jackBoxReference, {y : jackBoxReference.y - 25}, 0.25, {ease: FlxEase.sineOut});

		if(moveTween5 != null) moveTween5.cancel();
		moveTween5 = FlxTween.tween(roblox, {y : roblox.y - 25}, 0.25, {ease: FlxEase.sineOut});

		if(moveTween6 != null) moveTween6.cancel();
		moveTween6 = FlxTween.tween(codigo, {y : codigo.y - 25}, 0.25, {ease: FlxEase.sineOut});
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
	/*	var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);*/
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}