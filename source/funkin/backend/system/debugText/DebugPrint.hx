package funkin.backend.system.debugText;

import openfl.display.Sprite;
import flixel.util.FlxColor;

/**
 * 暂时先开个头
 */
class DebugPrint extends Sprite {
    public static function debugPrint(text:String, textOptions:TextOptions) {
        
    }
}

typedef TextOptions = {
	var ?style:TextStyle;
    var ?downscroll:Bool;
	var ?outlineColor:FlxColor;
	var ?outlineSize:FlxColor
}

enum abstract TextStyle(FlxColor) {
	var ERROR:TextStyle = FlxColor.RED;
	var RIGHT:TextStyle = FlxColor.GREEN;
	var NORMAL:TextStyle = FlxColor.WHITE;
}
