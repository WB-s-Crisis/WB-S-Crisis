var bg:FlxSprite;

function create() {

    bg = new FlxSprite(0, 100, Paths.image('stages/Looney/BG'));
    bg.scale.set(2.2, 2.2);
    insert(1, bg);

}