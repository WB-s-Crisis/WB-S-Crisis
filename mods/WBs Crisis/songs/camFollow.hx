public var followPoint:FlxPoint;
public var follow:Bool = true;

function new() {
	followPoint = FlxPoint.get(20, 20);
}

function onNoteHit(event) {
	if(follow) {
		switch(event.note.noteData) {
			case 0:
				camGame.targetOffset.x = -1 * followPoint.x;
				camGame.targetOffset.y = 0;
			case 1:
				camGame.targetOffset.x = 0;
				camGame.targetOffset.y = 1 * followPoint.y;
			case 2:
				camGame.targetOffset.x = 0;
				camGame.targetOffset.y = -1 * followPoint.y;
			case 3:
				camGame.targetOffset.x = 1 * followPoint.x;
				camGame.targetOffset.y = 0;
		}
	}
}