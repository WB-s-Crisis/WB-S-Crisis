function onPlaySingAnim(event) {
	if(animation.curAnim.name == "attack") event.cancel();
}

function onTryDance(event) {
	event.singHoldTime = (1 / animation.curAnim.frameRate) * (animation.curAnim.numFrames + 1) * 1000;
}