var bg:FlxSprite;
var bg1:FlxSprite;
var bg2:FlxSprite;

function create() {

    bg = new FlxSprite(0, 110, Paths.image('stages/1945/bg'));
    bg.scrollFactor.set(0.9, 0.9);
    bg.scale.set(2.2, 2.2);
    insert(1, bg);

    bg1 = new FlxSprite(0, 100, Paths.image('stages/1945/bg2'));
    bg1.scale.set(2.2, 2.2);
    insert(2, bg1);

    bg2 = new FlxSprite(-30, 100, Paths.image('stages/1945/bg3'));
    bg2.scrollFactor.set(1.1, 1.1);
    bg2.scale.set(2.2, 2.2);
    add(bg2);
}