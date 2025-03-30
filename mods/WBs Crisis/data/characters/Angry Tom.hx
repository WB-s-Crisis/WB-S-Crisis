var defScale:FlxPoint;

//已废弃
function postCreate() {
	defScale = FlxPoint.get(scale.x, scale.y);
}

var requestScale:Bool = true;
function onPlayAnim(event) {
	switch(event.animName) {
		case "singUP" | "singRIGHT":
			if(!requestScale) {
				scale.set(defScale.x * 0.85, defScale.y * 0.85);
				requestScale = true;
			}
		default:
			if(requestScale && defScale != null) {
				scale.set(defScale.x, defScale.y);
				requestScale = false;
			}
	}
}

function onPlaySingAnim(event) {
	if(animation.curAnim.name == "attack" || animation.curAnim.name == "defence") event.cancel();
}

function onTryDance(event) {
	event.singHoldTime = (1 / animation.curAnim.frameRate) * (animation.curAnim.numFrames + 1) * 1000;
}