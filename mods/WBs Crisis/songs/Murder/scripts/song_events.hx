public var zoop:Bool = false;

function stepHit(step:Int){
if (zoop == true) {
        if (curStep % 3 == 1) {
            FlxTween.num(1.05, 1, 0.1, {ease:FlxEase.sineOut}, (val:Float) -> {camHUD.zoom=val;});
            FlxTween.num(0.8, 0.75, 0.1, {ease:FlxEase.sineOut}, (vall:Float) -> {camGame.zoom=vall;});
        }
    }

    switch (step) {
    case 639:
          zoop = true;
    case 1151:
          zoop = false;
    case 1664:
          zoop = true;
    case 1920:
          zoop = false;
}
}