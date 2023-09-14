package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import openfl.Lib;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class BiosState extends MusicBeatState
{
	var songs:Array<SongMetadatatwo> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var personajes:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	var isEnglish:Bool = true;

	private var iconArray:Array<HealthIcon> = [];

	var optionShit:Array<String> = [
		'x',
		'armadillo_funkin_trashcan_fnf_zozerkul',
		'nerd',
		'power',
		'gustavo',
		'brick',
		'Sonis.',
		'lorax',
		'coldsteel',
		'soniku',
		'ogorki',
		'harry',
		'bomba6',
		'boyfriend6',
	];

	var bg:FlxSprite;
	var text:FlxText;
	var frase:FlxText;
	var espanatio:String;
	var leText:String;
	var ctrlThing:FlxSprite;
	var intendedColor:Int;
	var coolInt:Int = 500;
	var colorTween:FlxTween;

	static var penesuela:Int = FlxG.random.int(0, 25);

	override function create()
	{
		trace(penesuela);
		Lib.application.window.title = "Funkin' Trashcan - Bios";
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Seeing the bios.", null);
		#end

		addSong('X', 1, 'x', FlxColor.fromRGB(255, 66, 200));
		addSong('Armored\nArmadillo', 1, 'armadillo', FlxColor.fromRGB(255, 66, 200));
		addSong('Angry Video\nGame Nerd', 1, 'avgn', FlxColor.fromRGB(255, 66, 200));
		addSong('Nostalgia\nCritic', 1, 'nc', FlxColor.fromRGB(255, 66, 200));
		addSong('Gustavo', 1, 'gustavo', FlxColor.fromRGB(255, 66, 200));
		addSong('Brick', 1, 'brick', FlxColor.fromRGB(255, 66, 200));
		addSong('Sonic', 1, 'sos', FlxColor.fromRGB(255, 66, 200));
		addSong('Robotnik', 1, 'webos', FlxColor.fromRGB(255, 66, 200));
		addSong('Coldsteel', 1, 'coldsteel', FlxColor.fromRGB(255, 66, 200));
		addSong('Soniku', 1, 'soniku', FlxColor.fromRGB(255, 66, 200));
		addSong('Ogorki', 1, 'ogorki', FlxColor.fromRGB(255, 66, 200));
		addSong('Harry Poter\nObama Sonic 10', 1, 'harry', FlxColor.fromRGB(255, 66, 200));
		addSong('Whitty', 1, 'Whitty', FlxColor.fromRGB(255, 66, 200));
		addSong('BF & GF', 1, 'bf6', FlxColor.fromRGB(255, 66, 200));


		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.visible = false;
		add(bg);
		bg.screenCenter();

		FlxG.sound.playMusic(Paths.music('trashbio', 'trashcan'), 1);
		
		//optionShit.push(CoolUtil.coolTextFile(Paths.getLibraryPath('images/bios/orden.txt', 'trashcan')));
		trace(optionShit[curSelected]);

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

		var bg2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bios/bg', 'trashcan'));
		//bg2.setGraphicSize(Std.int(bg2.width * 1.175));
		bg2.updateHitbox();
		bg2.scrollFactor.set(0);
		bg2.screenCenter();
		bg2.color = FlxColor.GRAY;
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg2);

        var patron = new FlxBackdrop(Paths.image('menu/patron_zozer', 'trashcan'));
		patron.alpha = 0.5;
		patron.setGraphicSize(Std.int(patron.width * 0.5));
		patron.scrollFactor.set();
		patron.velocity.set(-80, -80);
		add(patron);
		add(barra1);
		add(barra2);

		personajes = new FlxSprite(-100,-100);
		personajes.loadGraphic(Paths.image('bios/' + optionShit[curSelected], 'trashcan'));
		personajes.scrollFactor.set(0, 0);
		//personajes.screenCenter(XY);
		personajes.setGraphicSize(Std.int(personajes.width * 0.65));
		personajes.antialiasing = ClientPrefs.globalAntialiasing;
		add(personajes);

		var bg2:FlxSprite = new FlxSprite(600, 50).makeGraphic(650, 630, FlxColor.WHITE);
		bg2.scrollFactor.set();
		add(bg2);

		var bg:FlxSprite = new FlxSprite(620, 65).makeGraphic(610, 600, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(50, 550, songs[i].songName, true);
			songText.isMenuItem = true;
			songText.changeY = false;
			songText.targetY = i - curSelected;
			grpSongs.add(songText);

			var maxWidth = 400;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			songText.snapToPosition();

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

		text = new FlxText(645, 70, 550, "", 23);
		text.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.scrollFactor.set();
		text.borderSize = 1.5;
		text.visible = true;
		add(text);

		frase = new FlxText(620, 560, 600, "", 23);
		frase.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		frase.scrollFactor.set();
		frase.borderSize = 1.5;
		frase.visible = true;
		add(frase);

		ctrlThing = new FlxSprite(-200, -140).loadGraphic(Paths.image('bios/ctrlesp', 'trashcan'));
		ctrlThing.setGraphicSize(Std.int(ctrlThing.width * 0.35));
		ctrlThing.scrollFactor.set(0);
		ctrlThing.antialiasing = ClientPrefs.globalAntialiasing;
		add(ctrlThing);


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

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadatatwo(songName, weekNum, songCharacter, color));
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

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var leftP = controls.UI_UP_P;
		var rightP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (ctrl) {
			new FlxTimer().start(0.1, function(deadTime:FlxTimer)
				{
					if (penesuela == 25)
						ctrlThing.loadGraphic(Paths.image('bios/ctrlven', 'trashcan'));
					else
						ctrlThing.loadGraphic(Paths.image('bios/ctrlesp', 'trashcan'));

					isEnglish = true;
				});
			
			trace(isEnglish);
		}
		if(ctrl && isEnglish) {
			
			new FlxTimer().start(0.1, function(deadTime:FlxTimer)
				{
					isEnglish = false;
					ctrlThing.loadGraphic(Paths.image('bios/ctrleng', 'trashcan'));
				});
				
			trace(isEnglish);
		}

		if(songs.length > 1)
		{
		/*	if (leftP || rightP)
				{
					FlxTween.tween(personajes,{x: 800, alpha : 0},0.2,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
						{
							personajes.loadGraphic(Paths.image('bios/' + optionShit[curSelected], 'trashcan'));
							FlxTween.tween(personajes,{x: -100, alpha : 1},0.2,{ease:FlxEase.cubeOut});
						}
					});
				}*/

			if (leftP)
			{
				curSelected + 1;
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (rightP)
			{
				curSelected - 1;
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_LEFT || controls.UI_RIGHT)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_LEFT ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

		}

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		//español - LISTO
	if (!isEnglish) {
		if (curSelected == 0){ //X
			text.text ="	
			X es el mejor y más reciente trabajo del Dr Light, capaz de sentir y pensar como un humano, fue redescubierto 100 años después por el Dr Cain y fue usado para crear a los Reploids, cuando algunos de los reploids se empiezan a revelar y atacan a los humanos en lugar de protegerlos, X y su compañero Zero deberán de salvar al mundo.
			";

			frase.text = "“I will end this! Right here, Right now, I will defeat you, Sigma!”";

			/*if (controls.UI_LEFT_P) {
				curSelected = 11;
			}*/
		}
		else if (curSelected == 1){ //armadillo friday night trashcan coconutmall
			text.text = "
			Alguna vez fue uno de los Maverick Hunters de la 8va división blindada bajo las órdenes de Sigma, cuando este se rebeló contra la humanidad, Armored Armadillo hizo lo mismo por lealtad.
			";

			frase.text = "“There’s nothing Maverick about following orders, We're not in the wrong, X.”";
		}
		else if (curSelected == 2){ //nerd avgn
			text.text = "
			Un gran sabelotodo de todo lo que sea de videojuegos antiguos, tener tanta rabia acumulada en juegos viejos de mierda eventualmente te trae enemigos, y parece que hoy se enfrenta a uno con tantos problemas de ira como él. 
			";

			frase.text = "“I'm gonna take you back to the past, again!”";
		}
		else if (curSelected == 3){ //power nc (newcrounds)
			text.text = "
			Un gran fan con complejo de dios de todo tipo de películas nostálgicas que quizás recuerdes mejor de lo que en realidad son, su ira y ganas de criticar con odio todo lo que quisiera pronto lo llevaron a una rivalidad con otro nerd enojón como él.
			";

			frase.text = "“I'm the Nostalgia Critic and i remember it so you don't have to!”";
		}
		else if (curSelected == 4){ //gustavo
			text.text = "
			Mejor amigo de Peppino Spaghetti y único fiel acompañante suyo en el local Peppino's Pizza. Puede parecer amargado algunas veces, pero él siempre está ahí para ayudar a Peppino sin importar que tantos problemas se encuentren en su camino, como por ejemplo una cierta rivalidad con cierta rata que con el paso del tiempo se convertiría en una fuerte amistad.
			";

			frase.text = "“Nobody has seen him since he crawled into the Pizza Dungeon”";
		}
		if (curSelected == 5){ //brick in spanish
			text.text = " 
			Una simple rata estúpida inicialmente decidida en hacerle la vida imposible a Gustavo, cosa que cambiaria poco a poco durante la travesía de Gustavo dentro de la Torre de Pizza. La inocente rata finalmente dejaría todo de lado para volverse una fiel aliada de los cocineros italianos, ayudando a su pasado “archienemigo” durante Gnome Forest y The Pig City.
			";

			frase.text = "“Brick Rolling”";
		}
		else if (curSelected == 6){ //sonic
			text.text = "
			Sonic el Erizo, bueno, no exactamente...
			Con una voz interpretada por SergioGiL, Sonic ha sido partícipe de miles aventuras a lo largo de todos sus juegos, intentando soportar todo Flicky vengativo y personaje de spin-off innecesario que se ponga en su camino. El día de hoy nuestro erizo español azulado favorito se encuentra con su archienemigo, el Doctor Ivo Robotnik, haciendo un acto de pena ajena al intentar camuflarse como uno de sus secuaces en Star Light Zone.
			";

			frase.text = "“Que triste...”";
		}
		else if (curSelected == 7){ //manolo cabeza de huevo
			text.text = "
			Icónico genio maquiavélico interpretado por Sotsim Brawlfan. Después de tener miles de sus planes totalmente frustrados por el erizo azul, decide participar en el programa de “El Jefe Final Infiltrado” con el objetivo de mejorar la calidad de sus tropas. Tarde fue cuando el científico se dio cuenta de que había sido estafado, quedando cara a cara ante Sonic con un humillante disfraz de Orbinaut que no le serviría de nada más que para mover sus bolas...";

			frase.text = "“MIRA COMO SE MUEVEN MIS BOLAS”";
		}
		else if (curSelected == 8){ //coldsteel
			text.text = "
			Nacido con Poderes Espesiales y el más fuerte de todos sus compañeros de clase en la academia de peleas sonic, después de pasarse al lado oscuro unirce a Shadow en la guerra y matar a Sonic perderia su oreja (si es por eso no selo pregunten mas) cosa que haria jurarle su odio eterno al usuario conocido como khaoskid663 (puto trader pokemon de mierda). Un dia dark y no corriente se encontraba paseando con su acosadora personal (“novia), solo para ser sorprendido y enfrentado por…. bootelgs??";

			frase.text = "“NOTHING PERSONEL KID”";
		}
		else if (curSelected == 9){ //soniku
			text.text = "
			una mitad erizo mitad hermosa de 7000 años, que a pesar de su cuestionable personalidad fria y calculadora, conto con la suficiente amabilidad y ternura como para ingeniarselas para ser la novia (acosadora) y acompañante mas leal de Coldsteel, con quien estaba teniendo el mejor dia de su vida hasta que 2 cosas amorfas que no se que son aparecieron de la nada para molestar, ella no tendra miedo de matarlos si es necesario…es una chicha muy dark
			";

			frase.text = "“Poderes: si”";
		}
		else if (curSelected == 10){ //ogorki
			text.text = "
			Mascota mas iconica de la marca Galileo 2000 y el menor de sus otros dos hermanos Papryka y Salatka, nacido de los pepinillos y con un rencor muy grande hacia los que se burlaron de él y su amigo Obama, decide frustrar el dia a Coldsteel y compañía!";

			frase.text = "“Nasz Smoczek poleca smaczne ., ogóraski . chrupaski”";
			
		}
		else if (curSelected == 11){ //harry poter sonic obama 10
			text.text = "
			HARRY POTER 10 OBAMA ! MOCHILA SONIC HERIZO ! GARBAGE GROOVING! 123 EN UNO SEGA MEGADRIVE 2 PASADO CONTRINCANTE POLYSTATION Y BOOTLEG PREFERIDO TODOS HOTMETAL MATAR, puede que el mundo se haya burlado de él pero es más capaz de lo que parece… creo.";
			frase.text = "“This is your former president Obama and i just want to tell you that i know how to beatbox”";
		}

		else if (curSelected == 11 + 2){ //Boyfriend Friday Night Funkin WEEEK 8 OFFICIAL FULL WEEK
			text.text = "
			Tú ya sabes quién es este imbécil.";

			frase.text = "";
		}
		
		else if (curSelected == 12){ //Whitty Friday Night Whitty UPDATE 2 PSYCH ENGINE SILVVAGUNER FULL WEEK (GF/GF SCARED)
			text.text = "
			Una creación del culto del caos, fue mantenido completamente solo y tuvo que huir de Updike y del grupo “The Greater Good”, el cual busca eliminar a aquellos como él, ha logrado mantenerse lejos de su alcance hasta ahora y aún mantiene un perfil bajo, pero como sabemos, hay alguien capaz de arruinarle su paz. ";
		
			frase.text = "...";
		}
	}



	//ENGLISH - 100%

	else if(isEnglish) {
		if (curSelected == 0){ //x
			text.text = "
			X is the best and most recent work of Dr Light, a robot with a human-like mind with feelings and thinkings. He was rediscovered 100 years after his creation by Dr Cain and was used to create the Reploids, when some of them started to revel and become a menace to the world, X and his friend Zero had no other choice but to save their people.";

			frase.text = "“I will end this! Right here, Right now, I will defeat you, Sigma!”";
		}
		
		else if (curSelected == 1){ //armored armadillo
			text.text = "
			He once was one of the Maverick Hunters of the 8th armored unit, when Sigma revealed against humanity, Armored Armadillo followed him out of loyalty.";

			frase.text = "“There’s nothing Maverick about following orders, We're not in the wrong, X.”";
		}
		else if (curSelected == 2){ //avgn
			text.text = "
			A big smart ass of everything old games related, so much rage accumulated on shitty old games eventually brings enemies, and it looks like today he’s facing one with as many anger issues as him.";

			frase.text = "“I'm gonna take you back to the past, again!”";
		}
		else if (curSelected == 3){ //nc
			text.text = "
			A big fan with a god complex of all kinds of nostalgic movies that you may remember better than they actually are, his hatred and desire to criticize everything ended up getting him into a rivalry with another angry nerd like him.";

			frase.text = "“I'm the Nostalgia Critic and i remember it so you don't have to!”";
		}
		else if (curSelected == 4){ //gustavo
			text.text = "
			Peppino Spaghetti's best friend and his only faithful companion at the local Peppino's Pizza. He may seem bitter at times, but he is always there to help Peppino no matter how many problems come his way, such as a certain rivalry with a certain rat that, over time, would become a strong friendship.";

			frase.text = "“Nobody has seen him since he crawled into the Pizza Dungeon”";
		}
		if (curSelected == 5){ //brick
			text.text = "
			A simple, stupid rat that was initially determined to make Gustavo's life impossible, something that would change as time passed during Gustavo's journey inside the Pizza Tower. The innocent rat would eventually put everything aside to become a faithful ally of the Italian cooks, helping his past “archenemy” during Gnome Forest and The Pig City.";

			frase.text = "“Brick Rolling”";
		}
		else if (curSelected == 6){ //sonic
			text.text = "
			Sonic the Hedgehog, well, not exactly... 
			With his voice being performed by SergioGiL, Sonic has been part of thousands of adventures throughout all his games, trying to tolerate any vengeful Flicky and unnecessary spin-off character that may get in his way. Today, our favorite blueish Spanish hedgehog meets his archenemy, Doctor Ivo Robotnik, doing an act of shame by trying to disguise himself as one of his troops in Star Light Zone. ";

			frase.text = "“Que triste...”";
		}
		else if (curSelected == 7){ //robotnik
			text.text = "
			Iconic machiavellian genius voiced by Sotsim Brawlfan. After having thousands of his plans completely frustrated by Sonic, he decides to participate in the “Undercover Final Boss” program with the objective of improving the quality of his troops. It was too late when the scientist realized he was face to face with Sonic in a humiliating Orbinaut costume, leaving him no choice other than to move his balls.";

			frase.text = "“MIRA COMO SE MUEVEN MIS BOLAS”";
		}
		else if (curSelected == 8){ //coldsteel
			text.text = "
			Born with Special Powers and the strongest of all his clasmates at the sonic fighting academy, after turning to the dark side and joinin Shadow in the war and killing Sonic he would lose his ear (that’s why don't ask him anymore) which would make him proclaim his eternal hatred to the user known as khaoskid663 [Fella]*. One dark and unusual day he was out walking with his personel stalker (thats what they call a “girlfriend i think ), only to be surprised and confronted by…. bootelgs??.";

			frase.text = "“NOTHING PERSONEL KID”";
		}
		else if (curSelected == 9){ //soniku
			text.text = "
			a 7000 year old half hedgehog half beautiful, who ,despite her questionable cold and calculating personality, had enough kindness and cuteness to be Coldsteel's most loyal girlfriend (stalker) and companion, with whom he was having the best day of her life until 2 amorphous things that I don't know wtf they are appeared out of nowhere to annoy them, we know she won't be afraid to kill who’s opposing to her perfect date if necessary...she's a very dark girl.";

			frase.text = "“Poderes: si”";
		}
		else if (curSelected == 10){ //ogorki
			text.text = "
			Najbardziej kultowa maskotka marki Galileo 2000 i najmłodszy z jego dwóch pozostałych braci Papryka i Salatka, zrodzony z ogórków kiszonych i żywiący ogromną urazę do tych, którzy naśmiewali się z niego i jego przyjaciela Obamy, postanawia sfrustrować Coldsteel i spółkę na dzień.!.";

			frase.text = "“Nasz Smoczek poleca smaczne ., ogóraski . chrupaski”";
		}
		else if (curSelected == 11){ //harry
			text.text = "
			HARRY POTER 10 OBAMA ! SCHOOLBAG SONIC HEDGEHOG ! GARABAGE GROOVING! ALL IN ONE SEGA MEGADRIVE 2 OLD RIVAL POLYSTATION AND FAVORITE BY ALL BOOTLEG HOTMETAL KILL, maybe the world laughed at him but he’s more capable than you may think…";

			frase.text = "“This is your former president Obama and i just want to tell you that i know how to beatbox”";
		}
		else if (curSelected == 12){ //whitty
			text.text = "
			A creation of a chaos cult, he was kept completely alone and had to flee from Updike and the group “The Greater Good“ that seeks to eliminate those like him, he has managed to stay out of their grasp until now and still keeps a low profile, but as we know, there is someone capable of ruining his peace.";

			frase.text = "...";
		}
		else if (curSelected == 11 + 2){ //bf
			text.text = "
			You already know who's this idiot.";

			frase.text = " ";
		}
	}
		else{
			curSelected == 0;
		}

		if (curSelected == 9 || curSelected == 8)
			frase.y = 600;
		else if (curSelected == 6)
			frase.y = 580;
		else if (curSelected == 7) {
			if (isEnglish)
				frase.y = 550;
			else
				frase.y = 600;
		}
		else
			frase.y = 560;


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
	{}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
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

		// selector.y = (70 * curSelected) + 30;


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
			item.y = 550;
		}
		
		personajes.loadGraphic(Paths.image('bios/' + optionShit[curSelected], 'trashcan'));

		personajes.y = 0;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(personajes, {y : personajes.y - 65}, 0.25, {ease: FlxEase.sineOut});

		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
	}
}

class SongMetadatatwo
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