import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.text.FlxTextBorderStyle;
import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import funkin.backend.utils.BitmapUtil;

importAddons("game.BarEvaluate");

var barGroup:FlxSpriteGroup;
var loadBar:FlxBar;
var barBG:FlxSprite;
var loadTxt:FlxText;

var loadedList:Dynamic = {
	percent: 0,
	maxLoaded: 100
};
var loadedAmout:Int = 0;

function postCreate() {
	startedLoaded = true;

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
	
	var al = new FlxAsyncLoop(maxLoop, iterationCallback, 1);
	add(al);
	
	FlxG.camera.flash(0xFF000000, 0.75, () -> {
		for(bar in [loadBar, barBG]) {
			bar.visible = true;
			FlxTween.tween(bar.scale, {x: 1, y: 1}, 0.5, {ease: FlxEase.circInOut});
		}
		FlxTween.tween(loadTxt, {alpha: 1}, 0.25, {startDelay: 0.25, onComplete: (_) -> {
			al.start();
		}});
	});
}

function iterationCallback() {
	stuffixData.push(parseCreditsFromDirectory(optionStuffixList[loadedAmout]));
	loadcacheGraphic();

	loadedAmout++;
	loadedList.percent = (loadedAmout / maxLoop) * 100;
	loadTxt.text = "loading...[" + Math.floor(loadedList.percent) + "%(stuffix: " + optionStuffixList[loadedAmout - 1] + ")]";
	
	if(loadedAmout == maxLoop) {
		loaded = true;
		new FlxTimer().start(0.25, (_) -> finishLoop());
	}
}

function finishLoop() {
	loadTxt.text = "loaded successfully!!";

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

function loadcacheGraphic() {
	var dir = optionStuffixList[loadedAmout];

	if(Assets.exists(imagePath("stuffix/" + dir + "/icon"))) {
		var bd = Assets.getBitmapData(imagePath("stuffix/" + dir + "/icon"));
		
		if(!Reflect.hasField(stuffixData[loadedAmout], "color") || stuffixData[loadedAmout].color == null) {
			var newColor = BitmapUtil.getMostPresentSaturatedColor(bd);
			Reflect.setField(stuffixData[loadedAmout], "color", newColor);
		}
		
		if(Reflect.hasField(stuffixData[loadedAmout], "maskIcon") && stuffixData[loadedAmout].maskIcon) {
			var maskBd = new BitmapData(bd.width, bd.height, true, 0x00000000);
			var shape = new Shape();
			shape.graphics.beginFill(0xFF00FF00);
			shape.graphics.drawCircle(maskBd.width / 2, maskBd.height / 2, ((maskBd.width + maskBd.height) / 2) / 2);
			shape.graphics.endFill();
			maskBd.draw(shape);
			
			bd.copyChannel(maskBd, new Rectangle(0, 0, bd.width, bd.height), new Point(), 8, 8);
		}
		
		graphicCache.cacheGraphic(FlxG.bitmap.add(bd));
	}
}