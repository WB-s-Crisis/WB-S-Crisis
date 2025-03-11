import openfl.geom.ColorTransform;

var bAbg = new FunkinSprite();
function postCreate(){
	for (event in events) {
		if (event.name == 'AppleFilter') {
            bAbg.makeSolid(6000, 6000, event.params[2]);// had to make it like this if not it will be blacking your screen
            bAbg.zoomFactor = 0;
            bAbg.scrollFactor.set();
            bAbg.x = "-490";
            bAbg.y = "-490";
            bAbg.alpha = 0.0001;
            if (gf != null){
                insert(members.indexOf(gf), bAbg);
            } else {
                insert(members.indexOf(dad), bAbg);
            }
        }
    }
}
function onEvent(e) {
    if (e.event.name == "AppleFilter"){
        if (e.event.params[0] == true || e.event.params[0] == null){
            //FlxTween.tween(bAbg, {alpha: 1}, e.event.params[1], {ease: FlxEase.quadInOut});
            bAbg.alpha = 1;
            bAbg.colorTransform.color = e.event.params[2];
            boyfriend.colorTransform.color = e.event.params[1];
            dad.colorTransform.color = e.event.params[1];
            if (gf != null){
                gf.colorTransform.color = e.event.params[1];
            }
        } else if (e.event.params[0] == false){
            bAbg.alpha = 0.0001;
            boyfriend.colorTransform = new ColorTransform();
            dad.colorTransform = new ColorTransform();
            if (gf != null){
                gf.colorTransform = new ColorTransform();
            }
        }
    }
}