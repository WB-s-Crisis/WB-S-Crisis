import funkin.backend.assets.ModsFolder;
import funkin.backend.scripting.GlobalScript;
import funkin.backend.scripting.Script;
import funkin.backend.system.MainState;
import funkin.backend.MusicBeatTransition;
import funkin.backend.MusicBeatState;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.NdllUtil;
import funkin.game.GameOverSubstate;
import funkin.menus.PauseSubState;
import funkin.backend.utils.WindowUtils;
import mobile.funkin.backend.utils.MobileUtil;
import openfl.Lib;

/**
 * 注意事项！
 * 如果出现游戏已进入就出现闪退问题，请率先检查global脚本以及受其关联的addons脚本
 */
importAddons("saves.WBSaver");

//搞储存的，你只需要在这里添加变量就行了
//如果想使用那个变量可以直接调用`gameSaver.变量`即可
//保存可以使用`gameSaver.save()`
public static var gameSaver:WBSaver = new WBSaver({
	forTest: true,
	#if mobile
	mobileControlStyle: "RIGHT_FULL",
	mobileCustomButtonsPos: [
		[0, 0],
		[0, 0],
		[0, 0],
		[0, 0],
		[0, 0]
	],
	buttonExtra: "NONE",
	buttonExtraPos: "TOP",
	#end
	passedWeeks: [],
	passedSongs: []
});

public var globalGameTimer:Float = 0.;

function new() {
	//gameSaver.clear();
	MusicBeatTransition.script = "data/scripts/Transition";
	
	var ctScript:HScript = Script.create(Paths.script("data/cryptoTools"));
	ctScript.load();
}

function postGameStart() {
	var useOne:Bool = false;
	FlxG.switchState(new UnusedVideoState(Paths.video("kaichangbai"), new TitleState(), 1, false, {
		onStart: function(been) {
			Main.instance.framerateSprite.visible = false;
		},
		onFinish: function(been) {
			Main.instance.framerateSprite.visible = true;
		},
		onUpdate: function(been, elapsed:Float) {
			if(been.video.bitmap != null && been.video.bitmap.position > 7.5/9 && !useOne) {
				useOne = true;
				FlxTween.tween(been.skipText, {alpha: 0}, 1);
			}
		}
	}));
}

var directState:Map<String, Class<Dynamic>> = [
	"WB/FreeplayScreen" => FreeplayState,
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
}

function destroy() {
	gameSaver.destroy();
}

/**
 * 很赛雷就对了（funkin有自带的，但我就是要自制一个🤓）
 * .　　         　▃▆█▇▄▖
 * 　　     　▟◤▖　　　◥█▎
 * 　　　◢◤　   ▐　　　　▐▉
 * 　▗◤　　　▂　▗▖　　▕█▎
 * 　◤　▗▅▖◥▄　▀◣　　█▊
 * ▐　▕▎◥▖◣◤　　　　◢██
 * █◣　◥▅█▀　　　　▐██◤
 * ▐█▙▂　　　             ◢██◤
 * 　◥██◣　　　　◢▄◤
 * 　　　▀██▅▇▀
 */
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
