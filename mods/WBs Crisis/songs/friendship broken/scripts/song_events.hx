function create() {
camHUD.alpha = 0;
camGame.alpha = 0;
}

function stepHit(step:Int){

    switch (step) {
    case 0:
          FlxTween.tween(camGame, {alpha: 1}, 12, {ease: FlxEase.expoInOut});
          FlxTween.tween(camHUD, {alpha: 1}, 12, {ease: FlxEase.expoInOut});
    case 913:
          FlxTween.tween(camGame, {alpha: 0}, 20, {ease: FlxEase.expoInOut});
          FlxTween.tween(camHUD, {alpha: 0}, 20, {ease: FlxEase.expoInOut});
}
}