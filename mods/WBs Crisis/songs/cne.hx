public static var deathState:Bool;

public var camOther:FlxCamera;

function new() {
	camOther = new FlxCamera();
	camOther.bgColor = 0;
	
	FlxG.cameras.add(camOther, false);
}