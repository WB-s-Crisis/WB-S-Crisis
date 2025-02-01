import Array;
import Sys;

import funkin.backend.scripting.GlobalScript;
import funkin.backend.scripting.Script;
import funkin.backend.system.MainState;
import funkin.backend.MusicBeatTransition;
import funkin.backend.MusicBeatState;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.NdllUtil;

import hxvlc.flixel.FlxVideo;

import lime.system.System as LimeSystem;

import openfl.Lib;

public var globalGameTimer:Float = 0.;

var playVideo:Bool = true;

var onceTime:Bool = true;
var playBool:Bool = false;

var kaichangVideo:FlxVideo;

function new() {
	//addonsScript
	var addonsManager:HScript = Script.create(Paths.script("data/addonsManager"));
	GlobalScript.scripts.add(addonsManager);
	addonsManager.load();
	
	MusicBeatTransition.script = "data/scripts/transition";
	
	Conductor.onBPMChange.add(function(bpm:Float) {
		if(bpm == 102) {
			Conductor.bpm = 100;
		}
	});
}

function postGameStart() {
	if(playVideo) {
		FlxG.switchState(new MusicBeatState());
		//breakOriginFramerate();
	
		kaichangVideo = new FlxVideo();
		kaichangVideo.autoVolumeHandle = false;
		kaichangVideo.onEndReached.add(function() {
			kaichangVideo.dispose();
			playBool = false;
			FlxG.game.removeChild(kaichangVideo);
			FlxG.switchState(new TitleState());
		});
		FlxG.game.addChild(kaichangVideo);
	}
}

var directState:Map<String, Class<Dynamic>> = [
	"WB/MainMenu" => MainMenuState
];

function preStateSwitch() {
	for(key in directState.keys()) {
		if(Std.isOfType(FlxG.game._requestedState, directState.get(key))) {
			FlxG.game._requestedState = new ModState(key);
		}
	}
}

//不是哥们，故意不给我使用FlxTimer是吧？
function update(elapsed:Float) {
	globalGameTimer += elapsed * 1000;
	
	if(playVideo) {
		if(globalGameTimer >= 1000 && onceTime) {
			if(kaichangVideo != null)
				startKaichangVideo();
		
			onceTime = false;
		}
	
		if(playBool) {
			var startTransform:Float = 0.1;
			var endTransform:Float = 0.85;
		
			var percent:Float = kaichangVideo.time / kaichangVideo.length;
			if(percent < startTransform) {
				kaichangVideo.alpha += (elapsed / (1 - startTransform));
				kaichangVideo.volume += Std.int((elapsed / (1 - startTransform)) * 100);
			}else if(percent > endTransform) {
				kaichangVideo.alpha -= (elapsed / endTransform);
				kaichangVideo.volume -= Std.int((elapsed / endTransform) * 100);
			}
		}
	}
}

function startKaichangVideo() {
	if(kaichangVideo.load(Paths.video("kaichangbai"))) {
		playBool = kaichangVideo.play();
		kaichangVideo.volume = 0;
		kaichangVideo.alpha = 0;
	}else {
		FlxG.switchState(new TitleState());
		FlxG.game.removeChild(kaichangVideo);
	}
}

//很赛雷就对了（funkin有自带的，但我就是要自制一个🤓）
public static function floatToStringPrecision(n:Float, prec:Int) {
	n = Math.round(n * Math.pow(10, prec));

	var str = '' + n;
	var len = str.length;

	if(len <= prec) {
		while(len < prec) {
			str = '0'+str;
			len++;
		}

		var decimal:String = '.' + str;
		
		var preDecimal:String = str;
		for(i in 0...prec) {
			if(StringTools.endsWith(preDecimal, '0')) {
				preDecimal = preDecimal.substr(0, prec - i - 1);
				decimal = (preDecimal == '' ? '' : '.' + preDecimal);
			}else break;
		}
		
		return '0' + decimal;
	}
	else {
		var decimal:String = '.' + str.substr(str.length-prec);
		
		var preDecimal:String = str.substr(str.length-prec);
		for(i in 0...prec) {
			if(StringTools.endsWith(preDecimal, '0')) {
				preDecimal = preDecimal.substr(0, prec - i - 1);
				decimal = (preDecimal == '' ? '' : '.' + preDecimal);
			}else break;
		}
		
		return str.substr(0, str.length-prec) + decimal;
	}
}

@:noCompletion
function breakOriginFramerate():Void {
	for(child in [Framerate.instance.fpsCounter, Framerate.instance.memoryCounter, Framerate.instance.codenameBuildField, Framerate.instance.bgSprite, Framerate.instance.categories]) {
		if(child is Array) {
			for(man in child) {
				Framerate.instance.removeChild(man);
			}
			continue;
		}
		
		Framerate.instance.removeChild(child);
	}
}
