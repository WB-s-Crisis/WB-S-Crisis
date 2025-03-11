import Reflect;
import Sys;
import funkin.backend.MusicBeatState;
import hxvlc.flixel.FlxVideoSprite;

var minTime:Float = 1.5;
var cutVideo:FlxVideo;

var allowPlay:Bool = false;
var canPlay:Bool = false;
var started:Bool = false;
var ended:Bool = false;
var preEnded:Bool = false;

var useOne:Int = 0;
function create() {
	if(FlxG.sound.music != null)
		FlxG.sound.music.stop();
	
	MusicBeatState.skipTransIn = true;
	
	Main.instance.framerateSprite.visible = false;
	
	//Application.current.window.alert(data);

	if(Assets.exists(data.videoPath)) {
		new FlxTimer().start(minTime, (_:FlxTimer) -> {
			allowPlay = true;
		
			cutVideo = new FlxVideoSprite();
			cutVideo.autoVolumeHandle = false;
			cutVideo.bitmap.onFormatSetup.add(function() {
				if(cutVideo.bitmap != null && cutVideo.bitmap != null && useOne == 0) {
					cutVideo.setGraphicSize(FlxG.width, FlxG.height);
					cutVideo.updateHitbox();
					cutVideo.screenCenter();
				}
			});
			cutVideo.bitmap.onEndReached.add(function() {
				ended = true;
			
				if(!preEnded) finish();
			});
			cutVideo.bitmap.onPlaying.add(function() {
				started = true;
			});
		
			add(cutVideo);
		
			if(cutVideo.load(data.videoPath)) {
				canPlay = true;
			
				new FlxTimer().start(0.001, (_:FlxTimer) -> {
					cutVideo.play();
				});
			}
		});
	}
}

#if mobile
var clickCount:Int = 0;
#end
var canClick:Bool = true;
function update(elapsed) {
	if(allowPlay && canPlay && started && !ended && !preEnded) {
		#if mobile
		if(canClick) {
			for(sb in FlxG.touches.list) {
				if(sb.justPressed)
					clickCount++;
			}
		}
		#end
	
		#if desktop
		if(FlxG.keys.justPressed.ENTER && canClick)
		#elseif mobile
		if((canClick && clickCount > 2)
		#if mobile
		|| FlxG.android.justReleased.BACK
		#end
		)
		#end
		{
			canClick = false;
			
			preEnded = true;
			FlxTween.tween(cutVideo, {alpha: 0}, 1.5, {onComplete: function(fw:FlxTween) {
				finish();
			}});
			FlxTween.num(100, 0, 1.5, null, function(num:Float) {
				cutVideo.bitmap.volume = Math.floor(num);
			});
		}
	}
}

function finish() {
	canPlay = false;
	cutVideo.destroy();

	MusicBeatState.skipTransIn = false;
	new FlxTimer().start(minTime, (_:FlxTimer) -> {
		if(Reflect.hasField(data, "nextState") && data.nextState != null) {
			if((Reflect.hasField(data, "week") && data.week != null) && (Reflect.hasField(data, "difficulty") && data.difficulty != null)) {
				PlayState.loadWeek(data.week, data.difficulty);
			}else {
				Application.current.window.alert("所需启动游戏的数据不存在！！关闭此窗口以来返回主界面", "错误！！");
				FlxG.switchState(new MainMenuState());
				
				return;
			}
			FlxG.switchState(data.nextState);
			Main.instance.framerateSprite.visible = true;
		}else {
			Application.current.window.alert("目标State不存在，关闭此窗口以来放回主界面", "错误！！！");
			FlxG.switchState(new MainMenuState());
		}
	});
}