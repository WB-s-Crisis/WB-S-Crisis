import Array;
import Sys;
import flixel.ui.FlxButton;
import mobile.flixel.FlxVirtualPad;
import mobile.objects.Hitbox;
import funkin.backend.MusicBeatState;
import flixel.text.FlxTextBorderStyle;
import flixel.input.mouse.FlxMouseEvent;
import flixel.util.FlxDestroyUtil;
import funkin.backend.system.framerate.Framerate;

/**
 * made by YourDad, okay?
 */

var camEdit:FlxCamera = new FlxCamera();

var bg:FunkinSprite;
var fwPad:FlxVirtualPad;
var fwHitbox:Hitbox;
var styleTxt:FlxText;
var arrows:FlxGroup;
var saveButton:FlxButton;
var exitButton:FlxButton;

var styleOptions:Array<String> = ["RIGHT_FULL", "LEFT_FULL", "CUSTOM", "HITBOX", "KEYBOARD"];
var styleCustomPos = [
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0],
	[0, 0]
];
var curStyle:Int = -1;
var canActions:Bool = false;

var trackedCustomPressed:Array<Bool> = [false, false, false, false, false];
var trackedCustomContent:Array<Dynamic> = [];

function new() {
	camEdit.bgColor = 0;
	FlxG.cameras.add(camEdit, false);
}

function create() {
	//如果有try那好办了，只惜是没有的:(
	//但好像hscript也不需要吧
	if(FlxG.state is MusicBeatState)
		FlxG.state.removeVirtualPad();
	
	Framerate.instance.alpha = 0.1;

	bg = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF00FF00);
	bg.cameras = [camEdit];
	bg.scrollFactor.set();
	bg.alpha = 0.45;
	add(bg);

	fwHitbox = new Hitbox();
	fwHitbox.cameras = [camEdit];
	fwHitbox.visible = false;
	add(fwHitbox);

	fwPad = new FlxVirtualPad("RIGHT_FULL", "NONE");
	fwPad.buttonA = fwPad.createButton(0, 0, "a", 0xFFFF0000);
	fwPad.add(fwPad.buttonA);
	
	fwPad.forEachAlive((button) -> {
		button.ID = fwPad.members.indexOf(button);
		var sb = button;
		button.onDown.callback = function() {
			if(!trackedCustomPressed.contains(true) && styleOptions[curStyle] == "CUSTOM") {
				trackedCustomPressed[button.ID] = true;
				trackedCustomContent.push({
					x: sb.x,
					y: sb.y
				});
			}
		};
		button.onUp.callback = function() {
			if(trackedCustomPressed.contains(true) && styleOptions[curStyle] == "CUSTOM") {
				trackedCustomPressed[button.ID] = false;
				trackedCustomContent.pop();
				
				var ok = styleCustomPos[sb.ID];
				ok[0] = sb.x;
				ok[1] = sb.y;
			}
		};
	});
	fwPad.cameras = [camEdit];
	fwPad.visible = false;
	add(fwPad);

	saveButton = new FlxButton(FlxG.width, 20, "save", saveOptions);
	saveButton.label.color = 0xFF000000;
	saveButton.label.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF, 0.25, 2);
	saveButton.color = 0xFF00FF00;
	saveButton.scale.set(3, 3);
	saveButton.label.scale.set(3, 3);
	saveButton.label.updateHitbox();
	saveButton.updateHitbox();
	saveButton.cameras = [camEdit];
	saveButton.scrollFactor.set();
	saveButton.x -= saveButton.width + 25;
	add(saveButton);
	
	exitButton = new FlxButton(saveButton.x, 20, "exit", exitOptions);
	exitButton.label.color = 0xFF000000;
	exitButton.label.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF, 0.25, 2);
	exitButton.color = 0xFFFF0000;
	exitButton.scale.set(3, 3);
	exitButton.updateHitbox();
	exitButton.label.scale.set(3, 3);
	exitButton.label.updateHitbox();
	exitButton.cameras = [camEdit];
	exitButton.scrollFactor.set();
	exitButton.x -= exitButton.width + 15;
	add(exitButton);
	
	styleTxt = new FlxText(100, 35, FlxG.width, "", 1);
	styleTxt.cameras = [camEdit];
	add(styleTxt);
	
	arrows = new FlxGroup(2);
	arrows.cameras = [camEdit];
	createArrows(arrows);
	add(arrows);
	
	var sureExtended:Bool = false;
	for(dddd in gameSaver.mobileCustomButtonsPos) {
		if(dddd[0] != 0 || dddd[1] != 0) {
			sureExtended = true;
			break;
		}
	}
	if(sureExtended) {
		styleCustomPos = new Array();
		for(fw in gameSaver.mobileCustomButtonsPos) {
			styleCustomPos.push(fw);
		}
	}else {
		styleCustomPos[0] = [fwPad.buttonUp.x, fwPad.buttonUp.y];
		styleCustomPos[1] = [fwPad.buttonLeft.x, fwPad.buttonLeft.y];
		styleCustomPos[2] = [fwPad.buttonRight.x, fwPad.buttonRight.y];
		styleCustomPos[3] = [fwPad.buttonDown.x, fwPad.buttonDown.y];
		styleCustomPos[4] = [FlxG.width - 150, (gameSaver.buttonExtraPos.toLowerCase() == "top" ? 0 : FlxG.height - 150)];
	}
	
	for(sb in [bg, fwHitbox, fwPad, saveButton, exitButton, styleTxt, arrows.members[0], arrows.members[1]]) {
		sb.alpha = 0;
		switch(sb) {
			case bg:
				FlxTween.tween(sb, {alpha: 0.35}, 0.3, {ease: FlxEase.quadIn, onComplete: function(_) {
					canActions = true;
					if(styleOptions.contains(gameSaver.mobileControlStyle)) {
						var index = styleOptions.indexOf(gameSaver.mobileControlStyle) + 1;
						changeStyle(index, true);
					}else {
						changeStyle(styleOptions.indexOf("HITBOX") + 1, true);
					}
				}});
			case fwPad | fwHitbox:
				FlxTween.tween(sb, {alpha: Options.controlsAlpha}, 0.25, {ease: FlxEase.quadIn});
			default:
				FlxTween.tween(sb, {alpha: 1}, 0.25, {ease: FlxEase.quadIn});
		}
		
	}
}

function update(elapsed:Float) {
	if(canActions) {
		for(touch in FlxG.touches.list) {
			var touchPos = touch.getScreenPosition(camEdit);
			
			arrows.forEachAlive(function(obj:FlxSprite) {
				if(pointOverlap(touchPos, obj)) {
					if(touch.justPressed) {
						obj.animation.play("confirm");
					}
					if(touch.justReleased) {
						obj.animation.play("static");
						changeStyle((obj.ID == 0 ? -1 : 1));
					}
				}
			});
			
			if(styleOptions[curStyle] == "CUSTOM") {
				for(button in fwPad.members) {
					if(trackedCustomPressed[button.ID]) {
						button.setPosition(touchPos.x - (touch.justPressedPosition.x - trackedCustomContent[trackedCustomContent.length - 1].x), touchPos.y - (touch.justPressedPosition.y - trackedCustomContent[trackedCustomContent.length - 1].y));
						
						break;
					}
				}
			}
		}
	}
}

function destroy() {
	FlxDestroyUtil.destroy(bg);
	FlxDestroyUtil.destroy(saveButton);
	FlxDestroyUtil.destroy(exitButton);
	FlxDestroyUtil.destroy(styleTxt);
	FlxDestroyUtil.destroy(arrows);
	FlxDestroyUtil.destroy(fwHitbox);
	FlxDestroyUtil.destroy(fwPad);
	FlxG.cameras.remove(camEdit);
	styleCustomPos = [];
}

function changeStyle(change:Int, needOrigin:Bool = false) {
	if(!canActions && !needOrigin) return;

	curStyle += change;
	if(curStyle > styleOptions.length - 1) {
		curStyle = 0;
	}else if(curStyle < 0) {
		curStyle = styleOptions.length - 1;
	}
	
	var textSize = 52;
	var content = styleOptions[curStyle];
	styleTxt.text = content;
	if(needOrigin) {
		styleTxt.setFormat(Paths.font("pixel.otf"), textSize, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF3D0000);
		
		for(arrow in arrows.members) {
			arrow.y = styleTxt.y;
		}
	}
	styleTxt.fieldWidth = content.length * textSize + 50;
	
	var textOffset = 10;
	arrows.forEachAlive(function(obj:FlxSprite) {
		switch(obj.ID) {
			case 0:
				FlxTween.tween(obj, {x: styleTxt.x - obj.frameWidth - textOffset}, 0.1, {ease: FlxEase.quadInOut});
			case 1:
				FlxTween.tween(obj, {x: styleTxt.x + styleTxt.fieldWidth + textOffset}, 0.1, {ease: FlxEase.quadInOut});
		}
	});
	
	switch(content) {
		case "LEFT_FULL":
			fwHitbox.visible = false;
			fwPad.visible = true;
			
			fwPad.buttonUp.setPosition(105, FlxG.height - 356);
			fwPad.buttonLeft.setPosition(0, FlxG.height - 246);
			fwPad.buttonRight.setPosition(207, FlxG.height - 246);
			fwPad.buttonDown.setPosition(105, FlxG.height - 131);
			fwPad.buttonA.setPosition(FlxG.width - 150, (gameSaver.buttonExtraPos.toLowerCase() == "top" ? 0 : FlxG.height - 150));
		case "RIGHT_FULL":
			fwHitbox.visible = false;
			fwPad.visible = true;
			
			fwPad.buttonUp.setPosition(FlxG.width - 258, FlxG.height - 404);
			fwPad.buttonLeft.setPosition(FlxG.width - 384, FlxG.height - 305);
			fwPad.buttonRight.setPosition(FlxG.width - 132, FlxG.height - 305);
			fwPad.buttonDown.setPosition(FlxG.width - 258, FlxG.height - 197);
			fwPad.buttonA.setPosition(0, (gameSaver.buttonExtraPos.toLowerCase() == "top" ? 0 : FlxG.height - 150));
		case "HITBOX":
			fwHitbox.visible = true;
			fwPad.visible = false;
		case "CUSTOM":
			fwHitbox.visible = false;
			fwPad.visible = true;
			
			for(key=>beep in styleCustomPos) {
				switch(key) {
					case 0:
						fwPad.buttonUp.setPosition(beep[0], beep[1]);
					case 1:
						fwPad.buttonLeft.setPosition(beep[0], beep[1]);
					case 2:
						fwPad.buttonRight.setPosition(beep[0], beep[1]);
					case 3:
						fwPad.buttonDown.setPosition(beep[0], beep[1]);
					case 4:
						fwPad.buttonA.setPosition(beep[0], beep[1]);
				}
			}
		default:
			fwHitbox.visible = false;
			fwPad.visible = false;
	}
}

function exitOptions() {
	if(canActions) {
		close();
		canActions = false;
		Framerate.instance.alpha = 1;
		
		if(FlxG.state is MusicBeatState) {
			FlxG.state.addVirtualPad("LEFT_FULL", "A_B");
		}
	}
}

function saveOptions() {
	if(canActions) {
		#if mobile
		gameSaver.mobileControlStyle = styleOptions[curStyle];
		
		if(gameSaver.mobileControlStyle == "CUSTOM") {
			gameSaver.mobileCustomButtonsPos = new Array();
			for(fw in styleCustomPos) {
				gameSaver.mobileCustomButtonsPos.push(fw);
			}
			gameSaver.mobileCustomButtonsPos = gameSaver.mobileCustomButtonsPos;
		}
		
		gameSaver.save();
		#end
	}
}

function pointOverlap(point:FlxPoint, obj:FlxObject) {
	return (
		point.x >= obj.x && point.x <= obj.x + obj.width &&
		point.y >= obj.y && point.y <= obj.y + obj.height
	);
}

function createArrows(group:FlxSpriteGroup) {
	for(i in 0...2) {
		var babyArrow = new FlxSprite();
		babyArrow.ID = i;
		babyArrow.frames = Paths.loadFrames(Paths.image("mobile/menu/arrows"));
		babyArrow.animation.addByPrefix("static", "arrow left", 1);
		babyArrow.animation.addByPrefix("confirm", "arrow push left", 1);
		babyArrow.animation.play("static", false);
		group.add(babyArrow);
		
		if(i != 0) {
			babyArrow.flipX = true;
		}
	}
}