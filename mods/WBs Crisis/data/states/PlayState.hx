import flixel.input.FlxInputState;
import flixel.input.keyboard.FlxKey;
import flixel.input.actions.FlxActionDigital;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Shape;
import funkin.backend.system.Control;
#if TOUCH_CONTROLS
import mobile.flixel.FlxVirtualPad;
import mobile.flixel.FlxButton;
#end

var controlDodge:Dynamic = {
	justPressed: false,
	pressed: false,
	justReleased: false
};
var DODGE_P:FlxActionDigital;
var DODGE:FlxActionDigital;
var DODGE_R:FlxActionDigital;
#if TOUCH_CONTROLS
var newHitbox:FlxSpriteGroup;
#end

function postCreate() {
	DODGE_P = new FlxActionDigital();
	DODGE_P.addKey(FlxKey.SPACE, FlxInputState.JUST_PRESSED);
	DODGE = new FlxActionDigital();
	DODGE.addKey(FlxKey.SPACE, FlxInputState.PRESSED);
	DODGE_R = new FlxActionDigital();
	DODGE_R.addKey(FlxKey.SPACE, FlxInputState.JUST_RELEASED);
	scripts.publicVariables.set("controlDodge", controlDodge);

	#if TOUCH_CONTROLS
	switch(gameSaver.mobileControlStyle) {
		case "LEFT_FULL" | "RIGHT_FULL":
			removeHitbox();
			virtualPad = new FlxVirtualPad(gameSaver.mobileControlStyle, "NONE");
			if(scripts.publicVariables.exists("makeYourDad")) {
				virtualPad.buttonA = virtualPad.createButton((gameSaver.mobileControlStyle == "LEFT_FULL" ? FlxG.width - 150 : 0), (gameSaver.buttonExtraPos == "TOP" ? 0 : FlxG.height - 150), 'a', 0xFFFF0000);
				virtualPad.add(virtualPad.buttonA);
				DODGE_P.addInput(virtualPad.buttonA, FlxInputState.JUST_PRESSED);
				DODGE.addInput(virtualPad.buttonA, FlxInputState.PRESSED);
				DODGE_R.addInput(virtualPad.buttonA, FlxInputState.JUST_RELEASED);
			}
			virtualPad.cameras = [camHitbox];
			add(virtualPad);
			
			trackedInputsHitbox = controls.trackedInputsNOTES;
			controls.trackedInputsNOTES = [];
			setControlPad(virtualPad);
		case "CUSTOM":
			removeHitbox();
			virtualPad = new FlxVirtualPad("RIGHT_FULL", "NONE");
			virtualPad.cameras = [camHitbox];
			add(virtualPad);
			
			for(key=>beep in gameSaver.mobileCustomButtonsPos) {
				switch(key) {
					case 0:
						virtualPad.buttonUp.setPosition(beep[0], beep[1]);
					case 1:
						virtualPad.buttonLeft.setPosition(beep[0], beep[1]);
					case 2:
						virtualPad.buttonRight.setPosition(beep[0], beep[1]);
					case 3:
						virtualPad.buttonDown.setPosition(beep[0], beep[1]);
					case 4:
						if(scripts.publicVariables.exists("makeYourDad")) {
							virtualPad.buttonA = virtualPad.createButton(beep[0], beep[1], 'a', 0xFFFF0000);
							virtualPad.add(virtualPad.buttonA);
							DODGE_P.addInput(virtualPad.buttonA, FlxInputState.JUST_PRESSED);
							DODGE.addInput(virtualPad.buttonA, FlxInputState.PRESSED);
							DODGE_R.addInput(virtualPad.buttonA, FlxInputState.JUST_RELEASED);
						}
				}
			}
			
			trackedInputsHitbox = controls.trackedInputsNOTES;
			controls.trackedInputsNOTES = [];
			setControlPad(virtualPad);
		case "KEYBOARD":
			removeHitbox();
		default:
			removeHitbox();

			trackedInputsHitbox = controls.trackedInputsNOTES;
			controls.trackedInputsNOTES = [];
			
			newHitbox = new FlxSpriteGroup();
			makeNewHitbox(newHitbox, scripts.publicVariables.exists("makeYourDad"));
			
			newHitbox.alpha = Options.controlsAlpha;
			newHitbox.scrollFactor.set();
			newHitbox.cameras = [camHitbox];
			add(newHitbox);
	}
	#end
}

function preUpdate(elapsed:Float) {
	controlDodge.justPressed = DODGE_P.check();
	controlDodge.pressed = DODGE.check();
	controlDodge.justReleased = DODGE_R.check();
}

#if TOUCH_CONTROLS
function setControlPad(pad:FlxVirtualPad) {
	var cnm:FlxVirtualPad = pad;
	controls.forEachBound(Control.NOTE_UP, (action, state) -> {controls.addButtonNOTES(action, cnm.buttonUp, state);});
	controls.forEachBound(Control.NOTE_LEFT, (action, state) -> {controls.addButtonNOTES(action, cnm.buttonLeft, state);});
	controls.forEachBound(Control.NOTE_RIGHT, (action, state) -> {controls.addButtonNOTES(action, cnm.buttonRight, state);});
	controls.forEachBound(Control.NOTE_DOWN, (action, state) -> {controls.addButtonNOTES(action, cnm.buttonDown, state);});
}

function makeNewHitbox(hitbox:FlxSpriteGroup, need:Bool) {
	var downscroll:Bool = (gameSaver.buttonExtraPos != "TOP");
	var list:Array<Array<Dynamic>> = null;
	
	if(need) {
		list = [
			[0, (downscroll ? 0 : FlxG.height / 4), Std.int(FlxG.width / 4), Std.int(FlxG.height * 3/4), 0xFFC24B99, Control.NOTE_LEFT, !downscroll],
			[FlxG.width * 1/4, (downscroll ? 0 : FlxG.height / 4), Std.int(FlxG.width / 4), Std.int(FlxG.height * 3/4), 0xFF00FFFF, Control.NOTE_DOWN, !downscroll],
			[FlxG.width / 2, (downscroll ? 0 : FlxG.height / 4), Std.int(FlxG.width / 4), Std.int(FlxG.height * 3/4), 0xFF12FA05, Control.NOTE_UP, !downscroll],
			[FlxG.width * 3/4, (downscroll ? 0 : FlxG.height / 4), Std.int(FlxG.width / 4), Std.int(FlxG.height * 3/4), 0xFFF9393F, Control.NOTE_RIGHT, !downscroll],
			[0, (downscroll ? FlxG.height * 3/4 : 0), FlxG.width, Std.int(FlxG.height / 4), 0xFFFFFF00, null, downscroll]
		];
	}else {
		list = [
			[0, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFC24B99, Control.NOTE_LEFT, true],
			[Std.int(FlxG.width * 1/4), 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF00FFFF, Control.NOTE_DOWN, true],
			[Std.int(FlxG.width / 2), 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF12FA05, Control.NOTE_UP, true],
			[Std.int(FlxG.width * 3/4), 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFF9393F, Control.NOTE_RIGHT, true]
		];
	}
	
	for(i in 0...list.length) {
		var curContent = list[i];
		var button = createHint(curContent[0], curContent[1], curContent[2], curContent[3], curContent[4], (curContent[6] == null ? false : curContent[6]));
		hitbox.add(button);
		
		if(curContent[5] != null)
			controls.forEachBound(curContent[5], (action, state) -> {controls.addButtonNOTES(action, button, state);});
		else {
			DODGE_P.addInput(button, FlxInputState.JUST_PRESSED);
			DODGE.addInput(button, FlxInputState.PRESSED);
			DODGE_R.addInput(button, FlxInputState.JUST_RELEASED);
		}
	}
}

function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFFFF, downscroll:Bool = false):FlxButton {
	var hintTween:FlxTween = null;
	var hintLaneTween:FlxTween = null;
	var hint = new FlxButton(X, Y);
	hint.loadGraphic(createHintGraphic(Width, Height));
	hint.color = Color;
	hint.solid = false;
	hint.immovable = true;
	hint.multiTouch = true;
	hint.moves = false;
	hint.scrollFactor.set();
	hint.alpha = 0.00001;
	hint.antialiasing = Options.antialiasing;
	hint.label = new FlxSprite();
	hint.labelStatusDiff = (Options.hitboxType != "hidden") ? Options.controlsAlpha : 0.00001;
	hint.label.loadGraphic(createHintGraphic(Width, Math.floor(Height * 0.035), true));
	hint.label.color = Color;
	hint.label.offset.y -= (downscroll ? hint.height - hint.label.height : 0);
	if (Options.hitboxType != 'hidden')
	{
		hint.onDown.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			if (hintLaneTween != null)
				hintLaneTween.cancel();

			hintTween = FlxTween.tween(hint, {alpha: Options.controlsAlpha}, Options.controlsAlpha / 100, {
				ease: FlxEase.circInOut,
				onComplete: (twn:FlxTween) -> hintTween = null
			});

			hintLaneTween = FlxTween.tween(hint.label, {alpha: 0.00001}, Options.controlsAlpha / 10, {
				ease: FlxEase.circInOut,
				onComplete: (twn:FlxTween) -> hintLaneTween = null
			});
		}

		hint.onOut.callback = hint.onUp.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			if (hintLaneTween != null)
				hintLaneTween.cancel();

			hintTween = FlxTween.tween(hint, {alpha: 0.00001}, Options.controlsAlpha / 10, {
				ease: FlxEase.circInOut,
				onComplete: (twn:FlxTween) -> hintTween = null
			});

			hintLaneTween = FlxTween.tween(hint.label, {alpha: Options.controlsAlpha}, Options.controlsAlpha / 100, {
				ease: FlxEase.circInOut,
				onComplete: (twn:FlxTween) -> hintLaneTween = null
			});
		}
	}

	return hint;
}

function createHintGraphic(Width:Int, Height:Int, ?isLane:Bool = false):BitmapData {
	var guh = Options.controlsAlpha;
	if (guh >= 0.9)
		guh = Options.controlsAlpha - 0.07;
	var shape:Shape = new Shape();
	shape.graphics.beginFill(0xFFFFFFFF);
	if (Options.hitboxType == "noGradient")
	{
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(Width, Height, 0, 0, 0);

		if (isLane)
			shape.graphics.beginFill(0xFFFFFFFF);
		else
			shape.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFFFF, 0xFFFFFFFF], [0, 1], [60, 255], matrix, PAD, RGB, 0);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.endFill();
	}
	else if (Options.hitboxType == 'gradient')
	{
		shape.graphics.lineStyle(3, 0xFFFFFFFF, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.lineStyle(0, 0, 0);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		if (isLane)
			shape.graphics.beginFill(0xFFFFFFFF);
		else
			shape.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFFFF, FlxColor.TRANSPARENT], [1, 0], [0, 255], null, null, null, 0.5);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		}
	else //if (Options.hitboxType == "noGradientOld")
	{
		shape.graphics.lineStyle(10, 0xFFFFFFFF, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.endFill();
	}
	var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
	bitmap.draw(shape);
	return bitmap;
}
#end