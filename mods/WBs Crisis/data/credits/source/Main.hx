public var canSelected:Bool = false;
public var displayStuffixList:Array<String> = [];
public var optionStuffixList:Array<String> = [];
public var stuffixData:Array<Dynamic> = [];
public var maxLoop:Int = 1;
public var curLoop:Int = 1;
public var camCredit:FlxCamera;

public var startedLoaded:Bool = false;
public var loaded:Bool = false;

function create() {
	FlxG.mouse.visible = true;
	MusicBeatState.skipTransIn = true;
	Main.instance.framerateSprite.visible = false;
	
	camCredit = new FlxCamera();
	camCredit.bgColor = 0;
	FlxG.cameras.add(camCredit, false);
	
	if(FlxG.sound.music != null)
		FlxG.sound.music.stop();
	
	var stuffixList = Assets.getText(txtPath("stuffix/list")).split("\n");
	for(stuffix in stuffixList) {
		if(StringTools.startsWith(stuffix, "#") || stuffix == "") continue;
		var nb = stuffix.split(";");
		if(nb.length > 1) {
			displayStuffixList.push(StringTools.trim(nb[0]));
			optionStuffixList.push(StringTools.trim(nb[1]));
		}
	}
	maxLoop = displayStuffixList.length;
}

public function txtPath(path:String) {
	return getPath(Path.withoutExtension("data/" + path) + ".txt");
}

public function xmlPath(path:String) {
	return getPath(Path.withoutExtension("data/" + path) + ".xml");
}

public function fontPath(path:String) {
	return getPath("fonts/" + path);
}

public function imagePath(path:String) {
	return getPath(Path.withoutExtension("images/" + path) + ".png");
}

public function soundPath(path:String) {
	return getPath(Path.withoutExtension("sounds/" + path) + ".ogg");
}

public function musicPath(path:String) {
	return getPath(Path.withoutExtension("music/" + path) + ".ogg");
}

public function xmlPath(path:String) {
	return getPath(Path.withoutExtension("data/" + path) + ".xml");
}

public function getPath(path:String) {
	return Paths.getPath("data/credits/assets/" + path);
}