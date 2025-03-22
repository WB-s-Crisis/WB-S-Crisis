import funkin.game.ComboRating;

var oldCpuControlled:Bool = false;

function create() {
	oldCpuControlled = cpuControlled;

	strumLines.members[1].onNoteUpdate.add(function(event:NoteUpdateEvent) {
		if(cpuControlled) event.cancel();
		else return;
		
		if(event.__updateHitWindow) {
			event.note.canBeHit = (event.note.strumTime > Conductor.songPosition - (hitWindow * event.note.latePressWindow)
				&& event.note.strumTime < Conductor.songPosition + (PlayState.instance.hitWindow * event.note.earlyPressWindow));

			if(event.note.strumTime < Conductor.songPosition - PlayState.instance.hitWindow && !event.note.wasGoodHit)
				event.note.tooLate = true;
		}

		if(!event.note.avoid && !event.note.wasGoodHit && event.note.strumTime < Conductor.songPosition) goodNoteHit(strumLines.members[1], event.note);

		if (event.note.wasGoodHit && event.note.isSustainNote && event.note.strumTime + (event.note.sustainLength) < Conductor.songPosition) {
			deleteNote(event.note);
			return;
		}

		if (event.note.tooLate) {
			deleteNote(event.note);
			return;
		}


		if (event.strum == null) return;

		if (event.__reposNote) event.strum.updateNotePosition(event.note);
		if (event.note.isSustainNote)
			event.note.updateSustain(event.strum);
	});
	
	strumLines.members[1].onHit.add(function(event:NoteHitEvent) {
		var curStrumTime:Float = event.note.strumTime;
		event.countScore = !cpuControlled;
		event.countAsCombo = !cpuControlled;
		
	
		if(cpuControlled) {
			var strumConfirmAnimation:FlxAnimation = event.note.__strum.animation._animations["confirm"];
			event.preventStrumGlow();
			event.note.__strum.press(event.note.nextSustain != null ? event.note.strumTime : (event.note.strumTime - Conductor.crochet / 2) + (1 / event.note.__strum.animation._animations.get("confirm").frameRate) * event.note.__strum.animation._animations.get("confirm").numFrames * 1000);
			
			event.accuracy = null;
		}
	});
}

function postUpdate(elapsed:Float) {
	if(oldCpuControlled != cpuControlled) {
		oldCpuControlled = cpuControlled;
		
		if(oldCpuControlled) {
			curRating = null;
		}else {
			var rating = null;
			var acc = get_accuracy();

			for(e in comboRatings)
				if (e.percent <= acc && (rating == null || rating.percent < e.percent))
					rating = e;
			
			curRating = rating;
		}
	}
	
	if(oldCpuControlled) {
		scoreTxt.text = 'Score:0';

		if (curRating == null)
			curRating = new ComboRating(0, "[N/A]", 0xFF888888);

		accFormat.format.color = curRating.color;
		accuracyTxt.text = 'Accuracy:-% - ' + curRating.rating;

		accuracyTxt._formatRanges[0].range.start = accuracyTxt.text.length - curRating.rating.length;
		accuracyTxt._formatRanges[0].range.end = accuracyTxt.text.length;
	}

	if(cpuControlled)
		strumLines.members[1].forEachAlive(updateStrums);
}

function updateStrums(strum:Strum) {
	if(strum.lastHit + Conductor.crochet / 2 < Conductor.songPosition && strum.getAnim() == "confirm") {
		strum.playAnim("static");
	}
}

function onInputUpdate(event) {
	if(cpuControlled) event.cancel();
}