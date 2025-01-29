package funkin.backend.system;

import flixel.FlxGame;
import funkin.backend.system.debugText.DebugPrint;
import openfl.text.TextFormat;

class FunkinGame extends FlxGame {
	public var debugPrintLog:DebugPrint;
	
	var skipNextTickUpdate:Bool = false;
	
	override function create(_) {
		super.create(_);

		var textFormat = new TextFormat(Assets.getFont("COMIC.TTF").fontName, 32);
		debugPrintLog = new DebugPrint(textFormat, true, {color: 0xff3d0000, size: 0.005, fast: true});
		addChild(debugPrintLog);
	}
	
	public override function switchState() {
		super.switchState();
		// draw once to put all images in gpu then put the last update time to now to prevent lag spikes or whatever
		draw();
		_total = ticks = getTicks();
		skipNextTickUpdate = true;
	}

	public override function onEnterFrame(t) {
		if (skipNextTickUpdate != (skipNextTickUpdate = false))
			_total = ticks = getTicks();
		super.onEnterFrame(t);
	}

	public function debugPrint(text:String, ?delayTime:Float = 1) {
		debugPrintLog.debugPrint(text, {delayTime: delayTime, style: NORMAL});
	}
}
