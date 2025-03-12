bt = false; //缩放
lr = false; //左右摆动
beatZoom = 2;
lrbeat = 4;
la = 1;
ra = 3;

function create() {
  
    barUp = new FlxSprite(0, 360).makeGraphic(1280, 360, 0xFF000000);
    barUp.cameras = [camHUD];
    add(barUp);

    barDw = new FlxSprite(0, 0).makeGraphic(1280, 360, 0xFF000000);
    barDw.cameras = [camHUD];
    add(barDw);

}

function beatHit() {
    
    if (bt == true) {
        if (curBeat % beatZoom == 0){
            FlxTween.num(1.05, 1, 0.2, {ease:FlxEase.sineOut}, (val:Float) -> {camHUD.zoom=val;});
            FlxTween.num(1, 0.93, 0.2, {ease:FlxEase.sineOut}, (vall:Float) -> {camGame.zoom=vall;});
        }
    }
    
    if (lr == true) {
        if (curBeat % lrbeat == la) {
            FlxTween.num(5, 0, 0.4, {ease:FlxEase.sineOut}, (val:Float) -> {camHUD.angle=val;});
            FlxTween.num(5, 0, 0.4, {ease:FlxEase.sineOut}, (vall:Float) -> {camGame.angle=vall;});
        }
        if (curBeat % lrbeat == ra) {
            FlxTween.num(-5, 0, 0.4, {ease:FlxEase.sineOut}, (val:Float) -> {camHUD.angle=val;});
            FlxTween.num(-5, 0, 0.4, {ease:FlxEase.sineOut}, (vall:Float) -> {camGame.angle=vall;});
        }
    }
}

function onStartCountdown() {
    camGame.alpha = 0;
    camHUD.alpha = 0;
}

function stepHit() {
    switch (curStep) {
        case 120:
            bt = true;
            FlxTween.tween(camGame, {alpha: 1}, 5);
            FlxTween.tween(camHUD, {alpha: 1}, 0.05);
            
            FlxTween.tween(barUp, {y: 720}, 5, {ease:FlxEase.sineOut});
            FlxTween.tween(barDw, {y: -360}, 5, {ease:FlxEase.sineOut});
        case 238:
            bt = false;
        case 359:
            lr = true;
        case 417:
            lrbeat = 2;
            la = 1;
            ra = 0;
        case 463:
            lr = false;
        case 849:
            FlxTween.num(3,0.5,0.05,{ease:FlxEase.sineOut},(val:Float) -> {scrollSpeed=val;});
        case 851:
            FlxTween.num(0.5,2.2,2,{ease:FlxEase.sineOut},(val:Float) -> {scrollSpeed=val;});
        case 1927:
            lr = true;
    }
}

//by 雪溪喵~