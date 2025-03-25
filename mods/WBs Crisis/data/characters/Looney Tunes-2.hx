var defaultScale:FlxPoint;

function postCreate() {
	defaultScale = FlxPoint.get(scale.x, scale.y);
}

var requestedSingUp:Bool = false;
function onPlayAnim(event) {
	if(defaultScale == null) return;

	if(!requestedSingUp && event.animName == "idle") {
		scale.set(defaultScale.x * 0.885, defaultScale.y * 0.885);
		requestedSingUp = true;
	}
	
	if(event.animName != "idle" && defaultScale != null) {
		requestedSingUp = false;
		scale.set(defaultScale.x, defaultScale.y);
	}
}