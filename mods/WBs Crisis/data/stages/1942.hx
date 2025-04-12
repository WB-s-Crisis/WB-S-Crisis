
public var realDefaultCamZoom:Float = 0.;
public var camMovementZoom:Bool = true;

function create() {
	shadow.alpha = 0.5;
	w.alpha = 0;
}

function postCreate() {
	realDefaultCamZoom = defaultCamZoom;
	
	switch(SONG.meta.name) {
		case "Blood dispute":
			boyfriend.x -= 350;
			strumLines.members[2].characters[0].alpha = 0.45;
			strumLines.members[2].characters[0].x += 150;
		default: {}
	}
	
	if(curCameraTarget == 1 && SONG.meta.name != "Blood dispute") {
		FlxG.camera.zoom = defaultCamZoom * 1.25;
	}
	
	comboGroup.y += 450;
	comboGroup.x -= 150;
	
	//change = curCameraTarget;
}

function onSongStart() {
	camZooming = true;
}

function stepHit() {
	if (PlayState.SONG.meta.displayName == 'bloody scissors') {

		
		switch (curStep) {
			case 608:
				bb(0.5, true);
			case 640:
				bb(0.5, false);
			case 784:
				bb(0.5, true);
			case 799:
				bb(0.5, false);
			case 897:
				w.alpha = 1;
				fwJerry.color = 0xFF000000;
			case 1025:
				w.alpha = 0;
				fwJerry.color = 0xFFFFFFFF;
		}
	}
	
	if (PlayState.SONG.meta.displayName == 'Cruel cartoon erect') {
	    
	}
}
//方便更改realDefaultCamZoom
function dz(s) {
    realDefaultCamZoom = s;
}

public function bb(s, on) {
    if (on == true) {
        FlxTween.tween(bg, {alpha: 0}, s, {ease:FlxEase.sineOut});
        FlxTween.tween(outside, {alpha: 0}, s, {ease:FlxEase.sineOut});
        FlxTween.tween(fwJerry, {alpha: 0}, s, {ease:FlxEase.sineOut});
    }else{
        FlxTween.tween(bg, {alpha: 1}, s, {ease:FlxEase.sineOut});
        FlxTween.tween(outside, {alpha: 1}, s, {ease:FlxEase.sineOut});
        FlxTween.tween(fwJerry, {alpha: 1}, s, {ease:FlxEase.sineOut});
    }
}

function onCameraMove(event) {
	if(cameraMovementChanged && camMovementZoom) {
		switch(curCameraTarget) {
			case 0:
				defaultCamZoom = realDefaultCamZoom;
				//debugPrint("itsTime This!!", 5);
			case 1:
				defaultCamZoom = realDefaultCamZoom * 1.25;
			case 2:
				if(SONG.meta.name == "Blood dispute") {
					defaultCamZoom = realDefaultCamZoom * 1.5;
				}
			default: {
				/*我操死你们的妈，这里啥也木有*/
			}
		}
	}
}