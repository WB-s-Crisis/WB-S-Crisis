import flixel.input.mouse.FlxMouseEvent;
import funkin.backend.scripting.ScriptPack;
import funkin.backend.scripting.Script;
import funkin.backend.MusicBeatState;
import flixel.addons.util.FlxAsyncLoop;
import flixel.text.FlxTextFormat;
import flixel.FlxObject;
import flixel.math.FlxRect;
import funkin.menus.credits.CreditsMain;
import haxe.ds.StringMap;
import flixel.util.FlxSpriteUtil;
import haxe.io.Path;
import Xml;
import Reflect;
import Type;

var sourceScripts:ScriptPack = new ScriptPack("CreditsMod");
var sourcePath:String = "data/credits/";

function new() {
	var getFiles = Paths.getFolderContent(sourcePath + "source", true);
	if(getFiles.length > 0) {
		for(file in getFiles) {
			loadScript(file);
		}
		
		if(sourceScripts.scripts.length > 0) {
			setDefaultVariables(sourceScripts);
			sourceScripts.setParent(this);
			sourceScripts.load();
		}
	}
}

function create() {
	sourceScripts.call("create", []);
}

function postCreate() {
	sourceScripts.call("postCreate", []);
}

function preUpdate(elapsed:Float) {
	sourceScripts.call("preUpdate", [elapsed]);
}

function update(elapsed:Float) {
	sourceScripts.call("update", [elapsed]);
}

function postUpdate(elapsed:Float) {
	sourceScripts.call("postUpdate", [elapsed]);
}

function stepHit(curStep:Int) {
	sourceScripts.call("stepHit", [curStep]);
}

function beatHit(curBeat:Int) {
	sourceScripts.call("beatHit", [curBeat]);
}

function measureHit(curMeasure:Int) {
	sourceScripts.call("measureHit", [curMeasure]);
}

function onOpenSubState(event:StateEvent) {
	sourceScripts.call("onOpenSubState", [event]);
}

function onResize(event:ResizeEvent) {
	sourceScripts.call("onResize", [event]);
}

function draw(event:DrawEvent) {
	sourceScripts.call("draw", [event]);
}

function postDraw(event:DrawEvent) {
	sourceScripts.call("postDraw", [event]);
}

function onStateSwitch(event:StateEvent) {
	sourceScripts.call("onStateSwitch", [event]);
}

function onFocus() {
	sourceScripts.call("onFocus", [event]);
}

function onFocusLost() {
	sourceScripts.call("onFocusLost", [event]);
}

function destroy() {
	sourceScripts.call("destroy", []);
	
	sourceScripts.destroy();
}

function setDefaultVariables(_scripts:ScriptPack) {
	var VM:Map<String, Dynamic> = [
		"CreditsMain" => CreditsMain,
		"FlxMouseEvent" => FlxMouseEvent,
		"FlxObject" => FlxObject,
		"FlxAsyncLoop" => FlxAsyncLoop,
		"FlxSpriteUtil" => FlxSpriteUtil,
		"FlxTextFormat" => FlxTextFormat,
		"MusicBeatState" => MusicBeatState,
		"Path" => Path,
		"Reflect" => Reflect,
		"FlxRect" => FlxRect,
		"Type" => Type,
		"Xml" => Xml,
		"StringMap" => StringMap
	];
	
	for(str=>val in VM)
		_scripts.set(str, val);
}

function loadScript(path:String) {
	if(Assets.exists(path) && Script.scriptExtensions.contains(Path.extension(path))) {
		var script = Script.create(path);
		if(script.fileName == "Main.hx")
			sourceScripts.insert(0, script);
		else
			sourceScripts.add(script);
	}
}