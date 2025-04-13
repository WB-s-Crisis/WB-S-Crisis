import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.text.FlxTextBorderStyle;
import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import funkin.backend.utils.BitmapUtil;
import funkin.backend.scripting.MultiThreadedScript;

importAddons("game.BarEvaluate");

var barGroup:FlxSpriteGroup;
var loadBar:FlxBar;
var barBG:FlxSprite;
var loadTxt:FlxText;

var thread:MultiThreadedScript = null;

var loadedList:Dynamic = {
	percent: 0,
	maxLoaded: 100
};
var loadedAmout:Int = 0;

function postCreate() {
	startedLoaded = true;
	
	thread = new MultiThreadedScript(Paths.script("data/scripts/CreditsThreaded"), __script__);
	thread.script.set("callEnded", thread.callEnded);

	loadBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width - 200 - 16, 75 - 16, loadedList, "percent", 0, loadedList.maxLoaded);
	loadBar.createFilledBar(0xFFD4D4D4, 0xFF00FF00);
	loadBar.screenCenter();
	loadBar.cameras = [camCredit];
	loadBar.visible = false;
	loadBar.scale.set(0.01, 0.01);
	add(loadBar);

	barBG = new BarEvaluate(0, 0, FlxG.width - 200, 75, {thickness: 16, color: 0xFF000000});
	barBG.cameras = [camCredit];
	barBG.screenCenter();
	barBG.visible = false;
	barBG.scale.set(0.01, 0.01);
	add(barBG);
	
	loadTxt = new FlxText(barBG.x, 285, barBG.width, "loading...[0%]", 24);
	loadTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
	loadTxt.cameras = [camCredit];
	loadTxt.alpha = 0;
	add(loadTxt);
	
	FlxG.camera.flash(0xFF000000, 0.75, () -> {
		for(bar in [loadBar, barBG]) {
			bar.visible = true;
			FlxTween.tween(bar.scale, {x: 1, y: 1}, 0.5, {ease: FlxEase.circInOut});
		}
		FlxTween.tween(loadTxt, {alpha: 1}, 0.25, {startDelay: 0.25, onComplete: (_) -> {
			thread.call("onLoad", [maxLoop]);
		}});
	});
}

var useone:Bool = true;
function update(elapsed:Float) {
	loadedList.percent = lerp(loadedList.percent, (loadedAmout / maxLoop) * 100, 0.2);
	
	if(loadedList.percent <= 80) {
		var preText = "loading...[" + Math.floor(loadedList.percent) + "%(stuffix: " + optionStuffixList[loadedAmout] + ")]";
		StringTools.replace(preText, "null", "no man");
		loadTxt.text = preText;
	}else loadTxt.text = "loaded Successfully";
	
	if(loadedList.percent > 99.99 && useone) {
		useone = false;
		
		finish();
	}
}

function destroy() {
	thread.destroy();
}

function finish() {
	loaded = true;
	new FlxTimer().start(0.25, (_) -> finishLoop());
}

function finishLoop() {
	for(bar in [loadBar, barBG]) {
		FlxTween.tween(bar.scale, {x: 0.01, y: 0.01}, 0.5, {ease: FlxEase.circInOut, onComplete: (_) -> {
			bar.visible = false;
		}});
		FlxTween.tween(loadTxt, {alpha: 0}, 0.25, {startDelay: 0.25, onComplete: (_) -> {
			loadTxt.visible = false;
			new FlxTimer().start(0.25, restoreMenu);
		}});
	}
}

function restoreMenu(_:FlxTimer) {
	for(obj in [topItem, topTitle, introGroup, creditIcon]) {
		obj.visible = true;
	}
	for(group in [arrows, panels]) {
		group.forEach((obj) -> {
			obj.visible = true;
			
			if(group == arrows) {
				var spr = obj;
				
				FlxMouseEvent.add(new FlxObject(obj.x, obj.y, obj.width, obj.height),
					(obj) -> {
						if(canSelected && spr.visible && spr.active && spr.exists) {
							changeSelection((spr.ID % 2 == 1 ? 1 : -1));
						}
					},
					null,
					(obj) -> {
						if(canSelected && spr.visible && spr.active && spr.exists) {
							
						}
					},
					(obj) -> {
						if(canSelected && spr.visible && spr.active && spr.exists) {
							
						}
					}
				);
			}
		});
	}
	
	
	camCredit.alpha = 0;
	camCredit.zoom = 0.05;
	FlxTween.tween(camCredit, {alpha: 1, zoom: 1}, 0.5, {ease: FlxEase.circInOut, onComplete: (_) -> {
		canSelected = true;
	}});
	
	changeSelection(0, true);
}