public var bt:Bool = false;
function create() {
  
    barUp = new FlxSprite(0, 650).makeGraphic(1280, 70, 0xFF000000);
    barUp.cameras = [camHUD];
    add(barUp);

    barDw = new FlxSprite(0, 0).makeGraphic(1280, 70, 0xFF000000);
    barDw.cameras = [camHUD];
    add(barDw);

}

function onStartCountdown() {
    camGame.alpha = 0;
    camHUD.alpha = 0;
}

function stepHit() {
    
    if (bt == true) {
        if (curStep % 3 == 1) {
            FlxTween.num(1.05, 1, 0.2, {ease:FlxEase.sineOut}, (val:Float) -> {camHUD.zoom=val;});
            FlxTween.num(0.87, 0.85, 0.2, {ease:FlxEase.sineOut}, (vall:Float) -> {camGame.zoom=vall;});
        }
    }

    switch (curStep) {
        case 0:
            FlxTween.tween(camGame, {alpha: 1}, 5);
            FlxTween.tween(camHUD, {alpha: 1}, 5);
            updw('up');
        case 64:
        	camGame.flash(0xFFFFFFFF, 0.5);
        case 130:
            bt = true;
        case 238 | 248 | 249:
        	camGame.flash(0xFFFFFFFF, 0.25);
        case 256:
            updw('dw');
            dy('out');
        case 385:
            bt = false;
            updw('up');
            dy('in');
        case 391:
            camGame.alpha = 0;
        case 401:
            camGame.alpha = 1;
            bt = true;
        case 512:
            dy('out');
        case 608:
            dy('in');
            bt = false;
        case 640:
            dy('out');
            bt = true;
        case 678:
            bt = false;
        case 784:
            camGame.zoom = 1.3;
        case 897:
            dy('in');
            bt = false;
            ba(true);
        case 1025:
            dy('out');
            ba(false);
        case 1154:
            bt = true;
            updw('up');
            dy('in');
        case 1288:
            camHUD.alpha = 0;
            camGame.alpha = 0;
            bt = false;
    }
}

function updw(fx) {
    if (fx == 'up') {
    FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[0].y=val;});
    FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[1].y=val;});
    FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[2].y=val;});
    FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[3].y=val;});            FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[0].y=val;});
    FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[1].y=val;});
    FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[2].y=val;});
    FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[3].y=val;});
    } else if (fx == 'dw') {
    FlxTween.num(80, 60, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[0].y=val;});
    FlxTween.num(80, 60, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[1].y=val;});
    FlxTween.num(80, 60, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[2].y=val;});
    FlxTween.num(80, 60, 3, {ease:FlxEase.sineOut}, (val:Float) -> {playerStrums.members[3].y=val;});            FlxTween.num(60, 80, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[0].y=val;});
    FlxTween.num(80, 60, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[1].y=val;});
    FlxTween.num(80, 60, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[2].y=val;});
    FlxTween.num(80, 60, 3, {ease:FlxEase.sineOut}, (val:Float) -> {cpuStrums.members[3].y=val;});
    }
}
//电影条
function dy(fx) {
    if (fx == 'in') {
        FlxTween.tween(barUp, {y: 650}, 1, {ease:FlxEase.sineOut});
        FlxTween.tween(barDw, {y: 0}, 1, {ease:FlxEase.sineOut});
    } else if (fx == 'out') {
        FlxTween.tween(barUp, {y: 720}, 1, {ease:FlxEase.sineOut});
        FlxTween.tween(barDw, {y: -70}, 1, {ease:FlxEase.sineOut});
    }
}

function fd(z, can) {
    if (can == true) {
        
        FlxTween.tween(FlxG.camera, {zoom: z}, 0.3);
    } else {
        
        FlxTween.tween(FlxG.camera, {zoom: 1}, 0.3);
    }
}
//人物变黑
function ba(can) {
    if (can == true) {
        dad.color = 0xFF000000;
        boyfriend.color = 0xFF000000;
        gf.color = 0xFF000000;
    } else {
        dad.color = 0xFFFFFFFF;
        boyfriend.color = 0xFFFFFFFF;
        gf.color = 0xFFFFFFFF;
    }
}
