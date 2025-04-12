import haxe.io.Bytes;
import openfl.display.BitmapData;
import flixel.util.FlxDestroyUtil;
import funkin.backend.scripting.Script;

importAddons("shader.Trans");

//不知道什么东西

var loadBG:FlxSprite;
var fanLoad:FlxSprite;
var trans:Trans;

var flashTime:Float = 1.25;

var timer:Float = 0.;
var minLoadingTime:Float = 0.65;

var loadDelay:Bool = false;
var id:String = "1942menu";
var easterID:String = "laoda-tom";

function create(event) {
	if(PlayState.SONG != null) {
		id = switch(PlayState.SONG.meta.name.toLowerCase()) {
			case "friendship broken" | "bloody scissors": "1942menu";
			case "cruel cartoon" | "blood dispute" | "cruel cartoon erect": "1942menu1";
			case "unprovoked" | "nothing" | "last life": "Looneymenu";
			case "murder": "WB1945menu";
			default: "1942menu";
		};
		
		if(sureLaodaDeadDay()) {
			easterID = switch(PlayState.SONG.meta.name.toLowerCase()) {
				case "friendship broken" | "bloody scissors" | "cruel cartoon" | "cruel cartoon erect" | "blood dispute": "laoda-tom";
				case "unprovoked" | "nothing" | "last life": "laoda-bugsBunny";
				case "murder": "laoda-tom";
				default: "laoda-tom";
			}
		}
	}

	if(event.newState is PlayState) {
		event.cancel();
		
		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		transitionCamera.fade(0xFF000000, flashTime, true, function() {
			loadDelay = true;
		});
		
		new FlxTimer().start(flashTime / 9, function(time:FlxTimer) {
			for(obj in [loadBG, fanLoad]) {
				obj.alpha = 1;
			}
		});
	
		if(sureLaodaDeadDay()) {
			loadBG = new FlxSprite().loadGraphic(cryptoTools.base64.getBitmapData(Paths.image("easterEgg/" + easterID)));
		}else {
			loadBG = new FlxSprite().loadGraphic(Paths.image("menus/loadingmenu/" + id));
		}

		loadBG.setGraphicSize(FlxG.width, FlxG.height);
		loadBG.updateHitbox();
		loadBG.cameras = [transitionCamera];
		loadBG.scrollFactor.set();
		loadBG.alpha = 0;
		add(loadBG);
		
		fanLoad = new FlxSprite().loadGraphic(Paths.image("menus/loadingmenu/loading"));
		fanLoad.scale.set(0.45, 0.45);
		fanLoad.updateHitbox();
		
		fanLoad.setPosition(-250, 325);
		
		fanLoad.cameras = [transitionCamera];
		fanLoad.alpha = 0;
		add(fanLoad);
	}else if(event.newState == null && Std.isOfType(FlxG.state, PlayState) && deadState == null) {
		event.cancel();
		
		if(sureLaodaDeadDay()) {
			loadBG = new FlxSprite().loadGraphic(cryptoTools.base64.getBitmapData(Paths.image("easterEgg/" + easterID)));
		}else {
			loadBG = new FlxSprite().loadGraphic(Paths.image("menus/loadingmenu/" + id));
		}
		
		loadBG.setGraphicSize(FlxG.width, FlxG.height);
		loadBG.updateHitbox();
		loadBG.cameras = [transitionCamera];
		loadBG.scrollFactor.set();
		loadBG.alpha = 1;
		add(loadBG);
		
		fanLoad = new FlxSprite().loadGraphic(Paths.image("menus/loadingmenu/loadingFinish"));
		fanLoad.scale.set(0.93, 0.93);
		fanLoad.updateHitbox();
		
		fanLoad.setPosition(-260, 90);
		
		fanLoad.cameras = [transitionCamera];
		fanLoad.alpha = 1;
		add(fanLoad);
		
		new FlxTimer().start(0.5, function(time:FlxTimer) {
			for(obj in [loadBG, fanLoad]) {
				FlxTween.tween(obj, {alpha: 0}, 0.5, {ease: FlxEase.sineOut, onComplete: function(_:FlxTween) {
					if(obj == fanLoad) {
						finish();
					}
				}});
			}
		});
	}else {
		event.cancel();
		
		trans = new Trans();
		transitionCamera.addShader(trans.shader);
		
		if(event.newState != null) {
			if(!Std.isOfType(FlxG.state, PlayState) && !Std.isOfType(event.newState, TitleState) && !Std.isOfType(event.newState, MainMenuState))
				FlxTween.num(0, 0.65, 0.5, {onComplete: (v) -> {FlxTween.num(0.65, 1, 0.25, {ease: FlxEase.backIn, startDelay: 0.25, onComplete: (_) -> finish()}, function(val:Float) {trans.apply = val;});}, ease: FlxEase.backOut}, function(val:Float) {trans.apply = val;});
			else FlxTween.num(0, 1, 0.45, {ease: FlxEase.quadOut, onComplete: (_) -> finish()}, function(val:Float) {trans.apply = val;});
		}else {
			trans.apply = 1;
			FlxTween.num(1, 0, 0.4, {ease: FlxEase.circOut, onComplete: (_) -> finish()}, function(val:Float) {trans.apply = val;});
		}
	}
	
	if(Script.staticVariables.exists("deadState"))
		deadState = null;
}

function update(elapsed:Float) {
	if(Std.isOfType(newState, PlayState) && loadDelay) {
		timer += elapsed;
		
		if(timer > minLoadingTime)
			finish();
	}
}

function destroy() {
	if(event.newState == null && Std.isOfType(FlxG.state, PlayState)) {
		FlxDestroyUtil.destroy(loadBG);
		FlxDestroyUtil.destroy(fanLoad);
	}
}

function sureLaodaDeadDay():Bool {
	var curDate = Date.now();
	return (curDate.getFullYear() == 2020 && curDate.getMonth() == 0 && curDate.getDate() == 26);
}