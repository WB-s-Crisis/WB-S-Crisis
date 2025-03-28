import openfl.geom.ColorTransform;

importScript("data/scripts/game/MachineDodge");

var cinematicBarTween1:FlxTween = null;
var cinematicBarTween2:FlxTween = null;
var cinematicBar1:FunkinSprite = null;
var cinematicBar2:FunkinSprite = null;

var bAbg = new FunkinSprite();

var camCancelled:Bool = false;
var black:FlxSprite;
var qqqeb:Bool = false;

function create()
{
	drainCount = 4;
	drainMax = 4;

    black = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
	black.scrollFactor.set();
	black.camera = camOther;
	add(black);
	camHUD.alpha = 0;
	
	bAbg.makeSolid(6000, 6000, 0xFFFFFFFF);
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
	for (i in 0...2) {
        var cinematicBar:FunkinSprite = new FunkinSprite().makeSolid(1, 1, 0xFF000000);
        cinematicBar.scrollFactor.set(0, 0);
        cinematicBar.zoomFactor = 0;
        cinematicBar.cameras = [camHUD];
        insert(0, cinematicBar);

        cinematicBar.scale.set(FlxG.width, 0);
        cinematicBar.updateHitbox();

        if (i == 1) cinematicBar2 = cinematicBar;
        else cinematicBar1 = cinematicBar;
    }
    
    recycleDodgeCamHandler = function(sb:Dynamic) {};
}

function update(elapsed:Float) {
    if (cinematicBarTween2 != null && cinematicBarTween2.active && cinematicBarTween1 != null && cinematicBarTween1.active)
        for (bar in [cinematicBar1, cinematicBar2]) bar.updateHitbox();
    cinematicBar2.y = FlxG.height - cinematicBar2.height;
    
}

function onStartSong() {
    camZooming = false;
}

function onCameraMove(event) {
	cameraMovementChanged = false;
	if(camCancelled) {
		event.cancel();
	}
}

function stepHit(step:Int) {
	switch(step) {
		case 403 | 436 | 466 | 593 | 914 | 960 | 989 | 1040 | 1060 | 1152 | 1460 | 1508 | 1562 | 1650 | 1714 | 1778 | 1840 | 1919 | 1968:
			execute();
	}
}

function beatHit(curBeat:Int) 
{
 if(qqqeb)
 {
if (curBeat % 2 == 0){
        camHUD.angle -= 8;
        camGame.angle -= 3.5;
        camHUD.y += 5;
        FlxG.camera.zoom += 0.06;
        FlxTween.tween(camHUD, {angle: 0, y: 0}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut});
        FlxTween.tween(camGame, {angle: 0}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut});   
    }
    else if (curBeat % 2 == 1){
        camHUD.angle += 8;
        camGame.angle += 3.5;
        camHUD.y -= 5;
        FlxG.camera.zoom += 0.06;
        FlxTween.tween(camHUD, {angle: 0, y: 0}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut});
        FlxTween.tween(camGame, {angle: 0}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut});   
    }
    }

switch (curBeat) {
		case 0:
		FlxTween.tween(black, {alpha: 0}, (Conductor.stepCrochet / 1000) * 36, {ease: FlxEase.qaudInOut});
		camCancelled = true;
		camFollow.x += 240;
		FlxG.camera.zoom = 0.6;
		//FlxTween.tween(camFollow, {x: camFollow.x + 220, y: camFollow.y + 0}, Conductor.crochet * 3 / 1000, {ease: FlxEase.circInOut});
		FlxTween.tween(FlxG.camera, {zoom: 0.75}, (Conductor.stepCrochet / 1000) * 140);
		case 30:
		FlxTween.tween(camHUD,{alpha: 1},1);
		case 32:
		camCancelled = false;
		case 64:
		camGame.flash(FlxColor.WHITE, 1);
		FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet / 1000) * 32);
		case 100:
		camGame.flash(FlxColor.RED, 1);
	    qqqeb = true;
		case 164:
		qqqeb = false;
		black.alpha = 1;
		FlxTween.tween(black, {alpha: 0}, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.qaudInOut});
		//电影效果
         for (twn in [cinematicBarTween1, cinematicBarTween2])
                if (twn != null) twn.cancel();
         for (bar in [cinematicBar1, cinematicBar2]) {
                var tween:FlxTween = FlxTween.tween(bar.scale, {y: (FlxG.height/2) * 0.25}, ((Conductor.crochet / 4) / 1000) * 16, {ease: Reflect.field(FlxEase.linear)});
                if (bar == cinematicBar1) cinematicBarTween1 = tween;
                else cinematicBarTween2 = tween;
            }
        //end
		bAbg.alpha = 1;
            boyfriend.colorTransform.color = 0xFF000000;
            dad.colorTransform.color = 0xFF000000;
            if (gf != null){
                gf.colorTransform.color = 0xFF000000;
            }
		case 228:
		    qqqeb = true;
		    camGame.flash(FlxColor.WHITE, 1);
		    //电影效果
         for (twn in [cinematicBarTween1, cinematicBarTween2])
                if (twn != null) twn.cancel();
         for (bar in [cinematicBar1, cinematicBar2]) {
                var tween:FlxTween = FlxTween.tween(bar.scale, {y: (FlxG.height/2) * 0}, ((Conductor.crochet / 4) / 1000) * 10, {ease: Reflect.field(FlxEase.linear)});
                if (bar == cinematicBar1) cinematicBarTween1 = tween;
                else cinematicBarTween2 = tween;
            }
        //end
		    bAbg.alpha = 0.0001;
            boyfriend.colorTransform = new ColorTransform();
            dad.colorTransform = new ColorTransform();
            if (gf != null){
                gf.colorTransform = new ColorTransform();
            }
		case 291:
		    qqqeb = false;
		    //电影效果
         for (twn in [cinematicBarTween1, cinematicBarTween2])
                if (twn != null) twn.cancel();
         for (bar in [cinematicBar1, cinematicBar2]) {
                var tween:FlxTween = FlxTween.tween(bar.scale, {y: (FlxG.height/2) * 0.25}, ((Conductor.crochet / 4) / 1000) * 16, {ease: Reflect.field(FlxEase.linear)});
                if (bar == cinematicBar1) cinematicBarTween1 = tween;
                else cinematicBarTween2 = tween;
            }
        //end
        FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet / 1600) * 24);
		case 357:
		//电影效果
         for (twn in [cinematicBarTween1, cinematicBarTween2])
                if (twn != null) twn.cancel();
         for (bar in [cinematicBar1, cinematicBar2]) {
                var tween:FlxTween = FlxTween.tween(bar.scale, {y: (FlxG.height/2) * 0}, ((Conductor.crochet / 4) / 1000) * 12, {ease: Reflect.field(FlxEase.linear)});
                if (bar == cinematicBar1) cinematicBarTween1 = tween;
                else cinematicBarTween2 = tween;
            }
        //end
        case 364:
        qqqeb = true;
        camGame.flash(FlxColor.WHITE, 1);
        case 497:
        qqqeb = false;
        case 515:
        FlxTween.tween(black, {alpha: 1}, (Conductor.stepCrochet / 1000) * 100, {ease: FlxEase.qaudInOut});
		}
}
		