var realDefaultCamZoom:Float = 0.;

function create() {
	shadow.alpha = 0.5;
}

function postCreate() {
	realDefaultCamZoom = defaultCamZoom;
}

function onSongStart() {
	camZooming = true;
}

function onCameraMove(event) {
	switch(curCameraTarget) {
		case 0:
			defaultCamZoom = realDefaultCamZoom;
		case 1:
			defaultCamZoom = realDefaultCamZoom * 1.25;
		default: {
			/*我操死你们的妈，这里啥也木有*/
		}
	}
}