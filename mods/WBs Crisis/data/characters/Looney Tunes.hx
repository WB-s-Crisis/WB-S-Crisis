var defaultScale:FlxPoint;

function postCreate() {
	defaultScale = FlxPoint.get(scale.x, scale.y);
}

var requestedSingUp:Bool = false;
function onPlayAnim(event) {
	if(!requestedSingUp && event.animName == "singUP") {
		scale.set(defaultScale.x * 1.25, defaultScale.y * 1.25);
		requestedSingUp = true;
	}
	
	if(event.animName != "singUP" && defaultScale != null) {
		requestedSingUp = false;
		scale.set(defaultScale.x, defaultScale.y);
	}
}