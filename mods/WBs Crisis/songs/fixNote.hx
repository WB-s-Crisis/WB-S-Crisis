function onStrumCreation(event) {
	event.cancel();
	
	event.strum.x -= 28;
	
	event.strum.frames = Paths.getFrames(event.sprite);
	event.strum.animation.addByPrefix('green', 'arrowUP');
	event.strum.animation.addByPrefix('blue', 'arrowDOWN');
	event.strum.animation.addByPrefix('purple', 'arrowLEFT');
	event.strum.animation.addByPrefix('red', 'arrowRIGHT');

	event.strum.antialiasing = true;
	event.strum.scale.set(0.35, 0.35);

	event.strum.animation.addByPrefix('static', 'arrow' + event.animPrefix.toUpperCase());
	event.strum.animation.addByPrefix('pressed', event.animPrefix + ' press', 24, false);
	event.strum.animation.addByPrefix('confirm', event.animPrefix + ' confirm', 24, false);
}

function create() {
	strumLines.forEach(function(strumLine:StrumLine) {
		strumLine.onNoteUpdate.add(function(event) {
			event.__reposNote = false;
			
			var daNote:Note = event.note;
			var strum:Strum = event.strum;
			
			var noteOffsetX:Float = !daNote.isSustainNote ? 100 : 0;
			var noteOffsetY:Float = 30;
			
			if(daNote.exists) {
				daNote.__strumCameras = strum.lastDrawCameras;
				daNote.__strum = strum;
				daNote.scrollFactor.set(strum.scrollFactor.x, strum.scrollFactor.y);
				daNote.__noteAngle = strum.getNotesAngle(daNote);
				daNote.angle = daNote.isSustainNote ? daNote.__noteAngle : strum.angle;
				
				if (daNote.strumRelativePos) {
					daNote.setPosition((strum.width - daNote.width) / 2 + noteOffsetX, (daNote.strumTime - Conductor.songPosition) * (0.45 * CoolUtil.quantize(strum.getScrollSpeed(daNote), 100)) - (Options.downscroll && !daNote.isSustainNote ? 200 : 0));
					if (daNote.isSustainNote) daNote.y += strum.N_WIDTHDIV2 + noteOffsetY;
				} else {
					var offset = FlxPoint.get(0, (Conductor.songPosition - daNote.strumTime) * (0.45 * CoolUtil.quantize(strum.getScrollSpeed(daNote), 100)));
					var realOffset = FlxPoint.get(0, 0);

					if (daNote.isSustainNote) offset.y -= strum.N_WIDTHDIV2 + noteOffsetY;

					if (Std.int(daNote.__noteAngle % 360) != 0) {
						var noteAngleCos = FlxMath.fastCos(daNote.__noteAngle / strum.PIX180);
						var noteAngleSin = FlxMath.fastSin(daNote.__noteAngle / strum.PIX180);

						var aOffset:FlxPoint = FlxPoint.get(
							(daNote.origin.x / daNote.scale.x) - daNote.offset.x,
							(daNote.origin.y / daNote.scale.y) - daNote.offset.y
						);
						realOffset.x = -aOffset.x + (noteAngleCos * (offset.x + aOffset.x)) + (noteAngleSin * (offset.y + aOffset.y));
						realOffset.y = -aOffset.y + (noteAngleSin * (offset.x + aOffset.x)) + (noteAngleCos * (offset.y + aOffset.y));

						aOffset.put();
					} else {
						realOffset.x = offset.x;
						realOffset.y = offset.y;
					}
					realOffset.y *= -1;

					daNote.setPosition(strum.x + realOffset.x + noteOffsetX, strum.y + realOffset.y - (Options.downscroll && !daNote.isSustainNote ? 200 : 0));

					offset.put();
					realOffset.put();
				}
			}
		});
	});
}