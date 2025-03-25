import openfl.display.BlendMode;

import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxAxes;
import openfl.display.BitmapData;

import funkin.backend.utils.DiscordUtil;
import funkin.backend.MusicBeatState;
import funkin.menus.FreeplaySonglist;
import hxIni.IniManager;

import haxe.ds.StringMap;

var curSelected:Int = 0;

var transitioning:Bool = false;
var songs:Array<Any> = [];

var coverGraphics:Map<String, FlxGraphic> = new StringMap();
var cover:FlxSprite;

var bgGraphics:Map<String, FlxGraphic> = new StringMap();
var bg:FlxSprite;
var charactersbg:FlxSprite;
var desc:FlxSprite;
var descTitle:FlxText;
var descText:FlxText;

var songCards:FlxSpriteGroup;
var songCardsY:Float = 0;

function create() {
	DiscordUtil.changePresence("In the Menus", null);
	CoolUtil.playMenuSong();

	var songList = FreeplaySonglist.get();
	songs = songList.songs;

	for (i in 0...songs.length) {
		var path:String = Paths.getPath('songs/' + songs[i].name + '/info.ini');
		if (Assets.exists(path)) {
			var infoData = IniManager.loadFromString(Assets.getText(path));
			songs[i].info = infoData;
		}
		if (Options.freeplayLastSong == songs[i].name) curSelected = i;
	}

	add(bg = new FlxSprite(0, 0));
	bg.antialiasing = Options.antialiasing;

	add(charactersbg = new FlxSprite(0, 0, Paths.image('menus/freeplay/charactersbg')));
	charactersbg.antialiasing = Options.antialiasing;
	charactersbg.setGraphicSize(0, 720);
	charactersbg.updateHitbox();
	charactersbg.screenCenter(FlxAxes.Y);

	var titleFont = Paths.font('vcr.ttf'), descFont = Paths.font('vcr.ttf');
	var lastHeight = -52;
	add(songCards = new FlxSpriteGroup());

	for (i => song in songs) {
		var card:FlxSpriteGroup = new FlxSpriteGroup(18, lastHeight);
		card.ID = i;

		if (song.info != null && song.info.exists("Freeplay") && song.info.get("Freeplay").exists("Cover") && !coverGraphics.exists(song.info.get("Freeplay").get("Cover"))) {
			var path = Paths.image('menus/freeplay/covers/' + song.info.get("Freeplay").get("Cover"));
			
			var graph = null;
			if(!Assets.exists(path)) graph = FlxG.bitmap.add(Paths.image("menus/freeplay/covers/templates"));
			else graph = FlxG.bitmap.add(path);
			graph.useCount++;
			graph.destroyOnNoUse = false;
			coverGraphics.set(song.info.get("Freeplay").get("Cover"), graph);
		}
		
		if(song.info != null && song.info.exists("Freeplay") && song.info.get("Freeplay").exists("Background") && !bgGraphics.exists(song.info.get("Freeplay").get("Background"))) {
			var path = Paths.image("menus/freeplay/BG/" + song.info.get("Freeplay").get("Background"));
			if(Assets.exists(path)) graphic = FlxG.bitmap.add(path);
			else graphic = FlxG.bitmap.add(new BitmapData(FlxG.width, FlxG.height));
			graphic.useCount++;
			graphic.destroyOnNoUse = false;
			bgGraphics.set(song.info.get("Freeplay").get("Background"), graphic);
		}

		var label = new FlxSprite(0, 0, Paths.image('menus/freeplay/label'));
		label.antialiasing = Options.antialiasing;
		label.setGraphicSize(0, 105);
		label.updateHitbox();
		card.add(label);

		var text = new FlxText(0, Math.floor((label.height - 45) / 2), label.width, song.displayName).setFormat(titleFont, 34, FlxColor.WHITE, 'center'
			).setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF142051, 3);
		text.antialiasing = Options.antialiasing;

		card.add(text);

		songCards.add(card);
		lastHeight += 130;
	}

	add(desc = new FlxSprite(0, 0, Paths.image('menus/freeplay/desc')));
	desc.antialiasing = Options.antialiasing;
	desc.setGraphicSize(0, 0);
	desc.updateHitbox();

	add(descText = new FlxText(desc.x + 555, desc.y + 10, desc.width - 34, '').setFormat(descFont, 24, FlxColor.WHITE, 'left'));
	descText.clipRect = FlxRect.get(0, 0, desc.width, desc.height - 52);
	descText.antialiasing = Options.antialiasing;

	add(cover = new FlxSprite(desc.x - -740, desc.y));
	cover.antialiasing = Options.antialiasing;
	cover.setGraphicSize(0, -100);
	cover.updateHitbox();

	changeSelection(0);
	loadStuff();

	#if mobile
    addVirtualPad('UP_DOWN', 'A_B');
    addVirtualPadCamera(false);
    #end
}

function bruv() {
	transitioning = true;

	FlxG.switchState(new MainMenuState());
}

var holdTime:Float = 0.;
var jiange:Bool = true;
function update(elapsed:Float) {
	if (!transitioning) {
		if (controls.UP_P) changeSelection(-1);
		else if (controls.DOWN_P) changeSelection(1);
		else if (FlxG.mouse.wheel != 0) changeSelection(-FlxG.mouse.wheel);
		
		if(controls.UP || controls.DOWN) {
			holdTime += elapsed * 1000;
			
			if(holdTime > 0.5 * 1000 && jiange) {
				changeSelection((controls.UP ? -1 : 1));
				jiange = false;
				
				new FlxTimer().start(0.1, (tmr) -> jiange = true);
			}
		}else holdTime = 0;

		if (controls.BACK) bruv();
		else if (controls.ACCEPT) confirm();
	}

	songCards.y = CoolUtil.fpsLerp(songCards.y, songCardsY, 0.16);
}

function confirm() {
	FlxG.sound.play(Paths.sound('menu/confirm'));
	transitioning = true;

	FlxG.camera.flash(FlxColor.WHITE, 1);
	new FlxTimer().start(1, (_) -> {
		Options.freeplayLastSong = songs[curSelected].name;
		Options.freeplayLastDifficulty = songs[curSelected].difficulties[0];

		PlayState.loadSong(songs[curSelected].name, songs[curSelected].difficulties[0], false, false);
		FlxG.switchState(new PlayState());
	});
}

function changeSelection(add:Int) {
	var prev = curSelected, length = songs.length;

	curSelected = FlxMath.wrap(curSelected + add, 0, length - 1);
	songCardsY = FlxG.height / 2 - curSelected * 130;

	var tween = tweens.get(curSelected);
	if (tween != null) tween.cancel();

	tweens.set(curSelected, FlxTween.tween(songCards.members[curSelected], {x: 68}, 0.8, {ease: FlxEase.expoOut}));

	if (add == 0) return;
	FlxG.sound.play(Paths.sound('menu/scroll'));
	loadStuff();

	tween = tweens.get(prev);
	if (tween != null) tween.cancel();

	tweens.set(prev, FlxTween.tween(songCards.members[prev], {x: 18}, 0.8, {ease: FlxEase.expoOut}));
}

function loadStuff() {
	if (songs[curSelected].info != null && songs[curSelected].info.exists("Freeplay")) {
		if(songs[curSelected].info.get("Freeplay").exists("Cover")) {
			var graphic = coverGraphics.get(songs[curSelected].info.get("Freeplay").get("Cover"));
			
			if(graphic != null) {
				cover.loadGraphic(graphic);
				cover.x = (songs[curSelected].info.get("Freeplay").get("CoverX") != null ? Std.parseFloat(songs[curSelected].info.get("Freeplay").get("CoverX")) : 0);
				cover.y = (songs[curSelected].info.get("Freeplay").get("CoverY") != null ? Std.parseFloat(songs[curSelected].info.get("Freeplay").get("CoverY")) : 0);
				cover.scale.set(0.9, 0.9);
				cover.updateHitbox();
			}
		}
		
		if(songs[curSelected].info.get("Freeplay").exists("Background")) {
			var graphic = bgGraphics.get(songs[curSelected].info.get("Freeplay").get("Background"));
			
			if(graphic != null) {
				bg.loadGraphic(graphic);
				bg.x = (songs[curSelected].info.get("Freeplay").get("BGX") != null ? Std.parseFloat(songs[curSelected].info.get("Freeplay").get("BGX")) : 0);
				bg.y = (songs[curSelected].info.get("Freeplay").get("BGY") != null ? Std.parseFloat(songs[curSelected].info.get("Freeplay").get("BGY")) : 0);
				scaleToGame(bg);
			}
		}
		
		if(songs[curSelected].info.get("Freeplay").exists("Description"))
			descText.text = songs[curSelected].info.get("Freeplay").get("Description");
		else descTest.text = 'By: ???';
	}
}

var tweens:Map<Int, FlxTween> = []; // fake the lerping w tweens
function destroy() {
	for(key=>graphic in coverGraphics) {
		graphic.useCount--;
		graphic.destroyOnNoUse = true;
	}
	for(key=>graphic in bgGraphics) {
		graphic.useCount--;
		graphic.destroyOnNoUse = true;
	}

	coverGraphics = null;
	bgGraphics = null;

	for (tween in tweens) tween.cancel();
	tweens = null;
}

function scaleToGame(spr:FlxSprite) {
	var scale = 1 / Math.min(spr.width / FlxG.width, spr.height / FlxG.height);
	spr.scale.set(scale, scale);
	spr.updateHitbox();
	return spr;
}
//再说一遍，我是橙子