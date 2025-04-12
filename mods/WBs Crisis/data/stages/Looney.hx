var bg:FlxSprite;
var bg1:FlxSprite;
var bg2:FlxSprite;
var bg22:FlxSprite;
var bg3:FlxSprite;
var bg33:FlxSprite;
var bg4:FlxSprite;
var bg44:FlxSprite;

function create() {

    bg = new FlxSprite(0, 100, Paths.image('stages/Looney/bg1'));
    bg.scrollFactor.set(0.5, 0.5);
    bg.scale.set(2.2, 2.2);
    insert(1, bg);

    bg1 = new FlxSprite(0, 100, Paths.image('stages/Looney/bg1-2'));
    bg1.scrollFactor.set(0.5, 0.5);
    bg1.scale.set(2.2, 2.2);
    bg1.alpha = 0;
    insert(2, bg1);

    bg2 = new FlxSprite(0, 100, Paths.image('stages/Looney/bg2'));
    bg2.scrollFactor.set(0.65, 0.65);
    bg2.scale.set(2.2, 2.2);
    insert(3, bg2);

    bg22 = new FlxSprite(0, 100, Paths.image('stages/Looney/bg2-2'));
    bg22.scrollFactor.set(0.65, 0.65);
    bg22.scale.set(2.2, 2.2);
    bg22.alpha = 0;
    insert(4, bg22);

    bg3 = new FlxSprite(0, 100, Paths.image('stages/Looney/bg3'));
    bg3.scrollFactor.set(0.85, 0.85);
    bg3.scale.set(2.2, 2.2);
    insert(5, bg3);

    bg33 = new FlxSprite(0, 100, Paths.image('stages/Looney/bg3-2'));
    bg33.scrollFactor.set(0.85, 0.85);
    bg33.scale.set(2.2, 2.2);
    bg33.alpha = 0;
    insert(6, bg33);

    bg4 = new FlxSprite(0, 100, Paths.image('stages/Looney/bg4'));
    bg4.scale.set(2.2, 2.2);
    insert(7, bg4);

    bg44 = new FlxSprite(0, 100, Paths.image('stages/Looney/bg4-2'));
    bg44.scale.set(2.2, 2.2);
    bg44.alpha = 0;
    insert(8, bg44);
}

function stepHit() {
	if (PlayState.SONG.meta.displayName == 'Unprovoked') {

		switch (curStep) {
			case 683:
               FlxTween.tween(bg1, {alpha: 1}, 65);
               FlxTween.tween(bg22, {alpha: 1}, 65);
               FlxTween.tween(bg33, {alpha: 1}, 65);
               FlxTween.tween(bg44, {alpha: 1}, 65);
		}
	}
	}