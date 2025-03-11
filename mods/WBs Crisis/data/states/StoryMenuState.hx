function postCreate() {
	weekSprites.members[0].scale.set(1.4, 1.4);
	difficultySprites.get("tom").scale.set(difficultySprites.get("tom").scale.x * 1.75, difficultySprites.get("tom").scale.y * 1.75);
	//difficultySprites.get("tom").updateHitbox();
}

function onWeekSelect(event) {
	if(event.week.name == "1942") {
		event.cancel();
	
		canSelect = false;
		CoolUtil.playMenuSFX(1);

		var cutData = {
			nextState: new PlayState(),
			week: event.week,
			difficulty: event.difficulty,
			videoPath: Paths.video("cutscenes/1942-1")
		};
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.switchState(new ModState("WB/VideoHandler", cutData));
		});
		weekSprites.members[event.weekID].startFlashing();
	}
}