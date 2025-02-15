package funkin.extra;

import flixel.FlxState;
import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideoSprite;
import flixel.util.FlxTimer;

/**
 * 废物东西
 */
class UnusedVideoState extends FlxState {
	public var video:FlxVideoSprite;
	var started:Bool = false;
	var finished:Bool = false;
	
	var startDelay:Float = 0.001;

	var path:String;
	var callbackOptions:CallbackOptions;

	public function new(path:String, ?startDelay:Float = 0.001, ?callbackOptions:CallbackOptions) {
		super();
		
		this.path = path;
		if(callbackOptions != null)
			this.callbackOptions = callbackOptions;
		
		if(startDelay >= 0.001)
			this.startDelay = startDelay;
	}
	
	public override function create() {
		video = new FlxVideoSprite(0, 0);
		video.antialiasing = true;
		video.bitmap.onFormatSetup.add(function() {
			if(video.bitmap != null && video.bitmap.bitmapData != null) {
				video.setGraphicSize(FlxG.width, FlxG.height);
				video.updateHitbox();
			}
		});
		video.bitmap.onEndReached.add(() -> {
			finished = true;
			video.destroy();
			if(Reflect.hasField(this.callbackOptions, "onFinish") && this.callbackOptions.onFinish != null) {
				this.callbackOptions.onFinish(video);
			}
		});
		video.bitmap.onPlaying.add(() -> {
			started = true;
			if(Reflect.hasField(this.callbackOptions, "onStart") && this.callbackOptions.onStart != null) {
				this.callbackOptions.onStart(video);
			}
		});
	
		if(video.load(this.path))
			new FlxTimer().start(this.startDelay, function(tmr:FlxTimer) {
				video.play();
			});
	
		add(video);
	
		super.create();
	}
	
	public override function update(elapsed:Float) {
		super.update(elapsed);
		
		if(started && !finished) {
			if(Reflect.hasField(this.callbackOptions, "onUpdate") && this.callbackOptions.onUpdate != null) {
				this.callbackOptions.onUpdate(video, elapsed);
			}
		}
	}
}

typedef CallbackOptions = {
	var ?onFinish:FlxVideoSprite->Void;
	var ?onStart:FlxVideoSprite->Void;
	var ?onUpdate:FlxVideoSprite->Float->Void;
}
