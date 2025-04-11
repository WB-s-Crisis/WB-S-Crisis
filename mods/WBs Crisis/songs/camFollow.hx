public var followPoint:FlxPoint = FlxPoint.get(45, 45);
public var follow:Bool = true;
public var allowFollowAngle:Bool = true;
public var followAngle:Float = 1;
var followLerpAngle:Float = 0;
var camTarget:FlxPoint = camGame.targetOffset;
var focused:Array<Bool> = [];
var lastHit:Float = -114514;

function create() {
	for(i in 0...strumLines.members.length) {
		focused.push(false);
		
		var strumLine = strumLines.members[i];
		strumLine.onHit.add((event) -> {
			if(!follow) return;
		
			if(strumLine.cpu) {
				focused[i] = true;
			}else if(cpuControlled) {
				focused[i] = true;
			}

			if(camTarget != null && focused.contains(true)) {
				switch(event.note.noteData) {
					case 0:
						camTarget.set(-followPoint.x, 0);
						if(allowFollowAngle) followLerpAngle = -followAngle;
					case 1:
						camTarget.set(0, followPoint.y);
						if(allowFollowAngle) followLerpAngle = 0;
					case 2:
						camTarget.set(0, -followPoint.y);
						if(allowFollowAngle) followLerpAngle = 0;
					case 3:
						camTarget.set(followPoint.x, 0);
						if(allowFollowAngle) followLerpAngle = followAngle;
				}
			}
			
			if(strumLine.cpu) {
				lastHit = event.note.strumTime;
				per.push(i);
			}else if(cpuControlled) {
				lastHit = event.note.strumTime;
				per.push(i);
			}
		});
	}
}

function onInputUpdate(event) {
	if(!event.strumLine.cpu && follow && !cpuControlled) {
		if(event.pressed.contains(true)) {
			focused[strumLines.members.indexOf(event.strumLine)] = true;
		}else {
			focused[strumLines.members.indexOf(event.strumLine)] = false;
		}
	}
}

var followChange:Bool = false;
var prevCameraTarget:Int = -1;
function onCameraMove(event) {
	if(curCameraTarget != prevCameraTarget) {
		//每一次切换镜头都会刷新
		prevCameraTarget = curCameraTarget;
		camGame.targetOffset.set(0, 0);
		followLerpAngle = 0;
		
		cameraMovementChanged = true;
	}
}

function update(elapsed:Float) {
	camGame.angle = lerp(camGame.angle, followLerpAngle, 0.08);
}

var per:Array<Int> = [];
function postUpdate(elapsed:Float) {
	if(lastHit + (Conductor.crochet / 2) < Conductor.songPosition && per.length > 0) {
		for(i in per) {
			focused[i] = false;
		}
		
		CoolUtil.clear(per);
	}

	if((!focused.contains(true) && camTarget != null) || !follow) {
		camTarget.set(0, 0);
		followLerpAngle = 0;
	}
}

function destroy() {
	followPoint.put();
}