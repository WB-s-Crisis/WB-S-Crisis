function create() {
    black = new FlxSprite(0, 0).makeGraphic(1280, 720, 0xFF000000);
    black.alpha = 1;
    black.cameras = [camHUD];
    add(black);
}

function stepHit(step:Int){

    switch (step) {
    case 0:
          FlxTween.tween(black, {alpha: 0}, 12);
    case 250:
          FlxTween.tween(black, {alpha: 1}, 2);
    case 341:
          black.alpha = 0;
    case 594:
          black.alpha = 1;
    case 597:
          black.alpha = 0;
    case 939:
          FlxTween.tween(black, {alpha: 1}, 1);
    case 960:
          black.alpha = 0;
    case 1134:
          FlxTween.tween(black, {alpha: 1}, 2);
}
}