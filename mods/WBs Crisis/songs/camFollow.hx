public var followPoint:FlxPoint;
public var follow:Bool = true;
public var allowFollowAngle:Bool = true;
public var followAngle:Float = 0.75;
var followLerpAngle:Float = 0;

function new() {
	followPoint = FlxPoint.get(35, 35);
}

function update(elapsed:Float) {
	if(allowFollowAngle)
		camGame.angle = lerp(camGame.angle, followLerpAngle, 0.08);
}

var followChange:Bool = false;
var prevCameraTarget:Int = -1;
function onNoteHit(event) {
	if(follow) {
		switch(event.note.noteData) {
			case 0:
				camGame.targetOffset.x = -1 * followPoint.x;
				camGame.targetOffset.y = 0;
				followLerpAngle = -followAngle;
			case 1:
				camGame.targetOffset.x = 0;
				camGame.targetOffset.y = 1 * followPoint.y;
				followLerpAngle = 0;
			case 2:
				camGame.targetOffset.x = 0;
				camGame.targetOffset.y = -1 * followPoint.y;
				followLerpAngle = 0;
			case 3:
				camGame.targetOffset.x = 1 * followPoint.x;
				camGame.targetOffset.y = 0;
				followLerpAngle = followAngle;
		}
	}
}

function onCameraMove(event) {
	if(curCameraTarget != prevCameraTarget) {
		//每一次切换镜头都会刷新
		prevCameraTarget = curCameraTarget;
		camGame.targetOffset.set(0, 0);
		followLerpAngle = 0;
		
		cameraMovementChanged = true;
	}
}