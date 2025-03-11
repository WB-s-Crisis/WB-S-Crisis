importAddons("shader.*");

var glitch:GLITCH = new GLITCH();
var chromatic:Chromatic = new Chromatic();
var logo:FlxSprite = null;

function create() {
	logo = titleScreenSprites.members[1];
	FlxG.camera.addShader(glitch.shader);
	FlxG.camera.addShader(chromatic.shader);
	
	add(glitch);
}

function beatHit(beat:Int) {
	logo.scale.x += 0.025;
	logo.scale.y += 0.025;
}

function measureHit(measure:Int) {
	FlxG.camera.zoom += 0.05;
	chromatic.aberration -= 0.25;
	glitch.amt += 0.1;
	glitch.speed = FlxG.random.float(0.1, 1);
}

function postUpdate(elapsed:Float) {
	logo.scale.x = lerp(logo.scale.x, 0.25, 0.08);
	logo.scale.y = lerp(logo.scale.y, 0.25, 0.08);
	chromatic.aberration = lerp(chromatic.aberration, 0, 0.1);
	
	glitch.amt = lerp(glitch.amt, 0, 0.08);
	
	FlxG.camera.zoom = lerp(FlxG.camera.zoom, 1, 0.05);
}