package funkin.options.categories;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import funkin.backend.MusicBeatState;
import funkin.options.Options;
import lime.system.System as LimeSystem;
#if android
import mobile.funkin.backend.utils.MobileUtil;
#end
#if sys
import sys.io.File;
#end

class MobileOptions extends OptionsScreen {
	var canEnter:Bool = true;

	public override function new() {
		dpadMode = 'LEFT_FULL';
		actionMode = 'A_B';
		super("Mobile", 'Change Mobile Related Things such as Controls alpha, screen timeout....', null, 'LEFT_FULL', 'A_B');
		#if TOUCH_CONTROLS
		add(new NumOption(
			"Controls Alpha",
			"Change how transparent the touch controls should be",
			0.0, // minimum
			1.0, // maximum
			0.1, // change
			"controlsAlpha", // save name or smth
			changeControlsAlpha)); // callback
		add(new ArrayOption(
			"Hitbox Design",
			"Choose how your hitbox should look like!",
			['noGradient', 'noGradientOld', 'gradient', 'hidden'],
			["No Gradient", "No Gradient (Old)", "Gradient", "Hidden"],
			'hitboxType'));
		#end
		#if mobile
		add(new Checkbox(
			"Allow Screen Timeout",
			"If checked, The phone will enter sleep mode if the player is inactive.",
			"screenTimeOut"));
		#end
	}

	override function update(elapsed) {
		#if mobile
		final lastScreenTimeOut:Bool = Options.screenTimeOut;
		if (lastScreenTimeOut != Options.screenTimeOut) LimeSystem.allowScreenTimeout = Options.screenTimeOut;
		#end
		super.update(elapsed);
	}

	function changeControlsAlpha(alpha) {
		#if TOUCH_CONTROLS
		MusicBeatState.getState().virtualPad.alpha = alpha;
		if (funkin.backend.system.Controls.instance.touchC) {
			FlxG.sound.volumeUpKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.muteKeys = [];
		} else {
			FlxG.sound.volumeUpKeys = [FlxKey.PLUS, FlxKey.NUMPADPLUS];
			FlxG.sound.volumeDownKeys = [FlxKey.MINUS, FlxKey.NUMPADMINUS];
			FlxG.sound.muteKeys = [FlxKey.ZERO, FlxKey.NUMPADZERO];
		}
		#end
	}
}
