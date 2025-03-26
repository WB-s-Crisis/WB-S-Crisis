import flixel.text.FlxTextFormat;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.system.framerate.Framerate;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import openfl.display.BitmapData;

var pauseCam:FlxCamera;
var bg:FlxSprite;

var board:FlxSprite;
var record:FlxSprite;
var art:FlxSprite;

var songName = PlayState.SONG.meta.name;
var pauseSound:FlxSound = FlxG.sound.load(Paths.sound("menu/pauseSound"));
var jsSound:FlxSound = FlxG.sound.load(cryptoTools.base64.getSound(Paths.sound("easterEgg/jumpScared3")));

var resumeTxt:FunkinText;
var restartTxt:FunkinText;
var optionsTxt:FunkinText;
var botplayTxt:FunkinText;
var exitTxt:FunkinText;
var displayBotplay:FunkinText;

var easterEgg:FunkinSprite;

var jumpOffset:FlxPoint = FlxPoint.get();
var startingJumpScared:Bool = false;
var allowSelected:Bool = false;

var defPosEaster:FlxPoint = FlxPoint.get();


function create(event)
{
	event.options = ['Resume', 'Restart Song', 'Change Options', "Botplay", 'Exit to menu'];

	event.cancel();
	//pauseMusic.volume = 1;
	cameras = [];

	pauseCam = new FlxCamera();
	pauseCam.bgColor = 0;

	bg = new FlxSprite();
	bg.makeGraphic(FlxG.width + 10, FlxG.height + 10, FlxColor.BLACK);
	bg.alpha = 0.001;
	
	record = new FlxSprite(16, -800).loadGraphic(Paths.image('pause/record player'));
	record.scale.set(0.55, 0.55);
	record.antialiasing = true;
	record.alpha = 0.001;
	var artCenterPos = record.y;
	record.updateHitbox();

	FlxG.cameras.add(pauseCam, false);

	board = new FlxSprite(16, -800).loadGraphic(Paths.image('pause/board'));
	board.scale.set(0.55, 0.55);
	board.antialiasing = true;
	board.updateHitbox();

	cameras = [pauseCam];

	art = new FlxSprite().loadGraphic(Paths.image('pause/record/' + songName));
	art.antialiasing = true;
	art.alpha = 0.001;
	art.screenCenter();
	var artCenterPos = art.x;
	var artCenterPos = art.y;
	art.y += 300;
	art.x += -300;

	#if mobile
    addVirtualPad('UP_DOWN', 'A_B');
    addVirtualPadCamera(false);
    #end
    
    var easterBitmapData = cryptoTools.base64.getBitmapData(Paths.image("easterEgg/GoodJerry"));
    easterEgg = new FunkinSprite().loadGraphic(easterBitmapData);
    easterEgg.alpha = 0;
    easterEgg.visible = false;
    easterEgg.scale.set(0.5, 0.5);
    easterEgg.updateHitbox();
    easterEgg.screenCenter();
    easterEgg.y += 35;
    defPosEaster.set(easterEgg.x, easterEgg.y);
    easterEgg.antialiasing = true;
    easterEgg.cameras = [pauseCam];

	for (i=>text in [resumeTxt, restartTxt, optionsTxt, botplayTxt, exitTxt]){
		var tempText = new FunkinText(0,0, 300, switch(i){
			case 0: "Resume";
			case 1: "Restart";
			case 2: "Options";
			case 3: "Botplay";
			case 4: "Exit";
		}, 16);
		tempText.setFormat(Paths.font("vcr.ttf"), 62, null, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		tempText.borderSize = 2;
		tempText.borderQuality = 6;
		switch(i){
			case 0: resumeTxt = tempText;
			case 1: restartTxt = tempText;
			case 2: optionsTxt = tempText;
			case 3: botplayTxt = tempText;
			case 4: exitTxt = tempText;
		}
	}

	for (i in [bg, board, record, art, resumeTxt])
		i.cameras = [pauseCam];

	add(bg);
	
	add(record);
	add(board);
	add(art);

	for (text in [resumeTxt, restartTxt, optionsTxt, botplayTxt, exitTxt])
		add(text);

	add(easterEgg);

	var levelInfo:FlxText = new FunkinText(20, 15, 0, PlayState.SONG.meta.displayName, 32);
	var deathCounter:FlxText = new FunkinText(20, 15, 0, "Blue balled: " + PlayState.deathCounter, 32);
	displayBotplay = new FunkinText(20, 15, 0, "Botplay", 32);
	displayBotplay.visible = game.scripts.publicVariables.get("cpuControlled");

    for(k=>label in [levelInfo, deathCounter, displayBotplay]) {
		label.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.fromRGB(255, 255, 255), FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		label.borderSize = 2;
		label.borderQuality = 6;
		label.alpha = 0;
          label.x = 30;
          label.y = 20 + (30 * k);
          FlxTween.tween(label, {alpha: 1, y: label.y - 10}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.6 + (0.45 *k)});
          add(label);
    }


	pauseSound.play(true);
	FlxTween.tween(board, {y: -290}, 1, {ease: FlxEase.elasticOut});
	FlxTween.tween(bg, {alpha: 0.7}, 0.3, {
		onComplete: function(t)
		{
			FlxTween.tween(art, {y: artCenterPos, alpha: 1}, 0.55, {ease: FlxEase.quartOut});
			FlxTween.tween(record, {y: artCenterPos, alpha: 1}, 0.55, {ease: FlxEase.quartOut, onComplete: function(t) {
				allowSelected = true;
			}});
		}
	});

	changeSelection(0,true);
	
	if(Framerate.instance.alpha > 0.35) Framerate.instance.alpha = 0.35;

}

function postCreate() {
	pauseMusic.volume = 1;
}

var active = true;
function update(elapsed)
{
	if (!active)
		return;

	for (i=>text in [resumeTxt, restartTxt, optionsTxt, botplayTxt, exitTxt]){
		text.setPosition(board.x + 950,board.y + 550 + (60 * i));
	}

	if(allowSelected) {
		if (controls.DOWN_P)
			changeSelection(1, false);
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.ACCEPT)
		{
			if((curSelected == 0 || curSelected == 1 || curSelected == 2 || curSelected == 4) && !Framerate.instance.alpha > 0.35) 
				Framerate.instance.alpha = 1;
			selectOption();
		}
	}
	
	if(!gameSaver.passedSongs.contains(songName)) {
		botplayTxt.color = 0xFFFF0000;
		botplayTxt.offset.set(FlxG.random.float(-5, 5), FlxG.random.float(-5, 5));
	}
	
	var needOffset = 10;
	if(startingJumpScared) {
		easterEgg.setPosition(defPosEaster.x + FlxG.random.float(-needOffset, needOffset), defPosEaster.y + FlxG.random.float(-needOffset, needOffset));
	}
}

function destroy()
{
	FlxG.cameras.remove(pauseCam);
	pauseSound.stop();
	defPosEaster.put();
}

function onSelectOption(event) {
	if(event.name == "Botplay") {
		if(gameSaver.passedSongs.contains(songName)) {
			game.scripts.publicVariables.set("cpuControlled", !game.scripts.publicVariables.get("cpuControlled"));
			displayBotplay.visible = game.scripts.publicVariables.get("cpuControlled");
		}else {
			allowSelected = false;
			
			pauseMusic.stop();
			easterEgg.scale.set(2, 2);
			new FlxTimer().start(1.5, startJumpScared);
		}
	}
}

var scrollSound:FlxSound = FlxG.sound.load(Paths.sound("menu/scrollShit"));
scrollSound.volume = 0.25;
function changeSelection(change, ?mute:Bool = false)
{
	scrollSound.pitch = FlxG.random.float(0.99,1.02);
	if (!mute)
		scrollSound.play(true);

	curSelected += change;

	if (curSelected < 0)
		curSelected = menuItems.length - 1;
	if (curSelected >= menuItems.length)
		curSelected = 0;

	for (i=>text in [resumeTxt, restartTxt, optionsTxt, botplayTxt, exitTxt]){
		if (i != curSelected){
			text.alpha = 0.4;
		}
		else{
			text.alpha = 1;
		}
	}
}

function startJumpScared(tmr:FlxTimer) {
	jsSound.play();
	#if mobile
	removeVirtualPad();
	#end
	Framerate.instance.visible = false;
	game.persistentUpdate = false;
	game.persistentDraw = false;
	for(sb in [game.camGame, game.camHUD, game.scripts.publicVariables.get("camOther")]) {
		if(sb._filters != null && sb._filters.length > 0)
			sb._filters = [];
	}
	
	pauseCam.shake(0.02, 5);
	pauseCam.flash(0xFFFF0000, 0.175);
	pauseCam.zoom += 0.05;
	FlxTween.tween(pauseCam, {zoom: pauseCam.zoom + 0.25}, 0.15, {startDelay: 0.1, ease: FlxEase.quadOut});
	easterEgg.visible = true;
	easterEgg.alpha = 1;
	FlxTween.tween(easterEgg.scale, {x: 0.5, y: 0.5}, Conductor.stepCrochet / 1000, {ease: FlxEase.sineOut, onComplete: function(tmr) {
		startingJumpScared = true;
	}});
	FlxTween.tween(easterEgg.scale, {x: 2, y: 2}, Conductor.stepCrochet / 1000, {startDelay: Conductor.stepCrochet / 1000 + jsSound.length / 1000 / 2, onStart: function(tmr) {startingJumpScared = false;}, ease: FlxEase.quadIn, onComplete: function(tmr) {
		Sys.exit(0);
	}});
}