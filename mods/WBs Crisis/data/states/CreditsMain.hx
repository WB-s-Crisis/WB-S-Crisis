import funkin.options.type.TextOption;
import funkin.options.TreeMenu;
import funkin.backend.MusicBeatState;

function create() {
	TreeMenu.lastState = null;
	MusicBeatState.skipTransOut = false;
	MusicBeatState.skipTransIn = false;
	FlxG.mouse.visible = false;
	Main.instance.framerateSprite.visible = true;
	CoolUtil.playMenuSong();

	main.add(new TextOption("WB's Crisis Team", "This Mod's Production Members", gotoRealCredits));
	main.sort((one, two) -> return -1);
}

function gotoRealCredits() {
	new FlxTimer().start(0.75, (tmr) -> {
		if(!FlxG.random.bool(10)) FlxG.switchState(new ModState("WB/CreditsMain"));
		else FlxG.switchState(new ModState("RedemptionState", {lastState: Type.getClass(this)}));
	});
}