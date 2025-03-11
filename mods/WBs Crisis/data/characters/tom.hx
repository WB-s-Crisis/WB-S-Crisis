var defScale:FlxPoint;

function postCreate() {
	defScale = FlxPoint.get(scale.x, scale.y);
}

var requestScale:Bool = true;
function onPlayAnim(event) {
	switch(event.animName) {
		case "singLEFT" | "singRIGHT" | "singDOWN" | "singUP":
			if(!requestScale) {
				scale.set(defScale.x * 1.25, defScale.y * 1.25);
				requestScale = true;
			}
		default:
			if(requestScale && defScale != null) {
				scale.set(defScale.x, defScale.y);
				requestScale = false;
			}
	}
}