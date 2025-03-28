import flixel.effects.FlxFlicker;

importAddons("game.AttackSystem");

//bbbb
public var recycleDodgeCamHandler:Dynamic->Void = null;

public var makeYourDad:Dynamic = null;

var dodgeSystem:AttackSystem;
var characterLockCurAnim:Array<Bool> = [];
var attackSound:FlxSound = FlxG.sound.load(Paths.sound("game/attack"));
var tinnitusSound:FlxSound = FlxG.sound.load(Paths.sound("game/tinnitus"));
var attackNoDodgeSound:FlxSound = FlxG.sound.load(Paths.sound("game/blood"));

public var drainMax:Int = 8;
public var drainCount:Int = drainMax;
var getStuck:Bool = false;

function new() {
	for(i in 0...strumLines.length) {
		characterLockCurAnim.push(false);
	}
}

function onNoteHit(event) {
	if(getStuck) event.preventVocalsUnmute();
}

function onPlayerMiss(event) {
	if(getStuck) {
		event.preventVocalsUnmute();
		event.preventMissSound();
	}
}

function onPlayerHit(event) {
	event.healthGain = 0.023 * (drainCount / drainMax);
}

function onInputUpdate(event) {
	if(!cpuControlled && getStuck) event.cancel();
}

function create() {
	dodgeSystem = new AttackSystem((obj) -> {
		obj.frames = Paths.getSparrowAtlas("game/spacebar");
		obj.animation.addByPrefix("static", "static", 1, true);
		obj.animation.addByPrefix("press", "press", 1, true);
		obj.animation.play("static", true);
		obj.scale.set(0.6, 0.6);
		obj.updateHitbox();
		obj.alpha = 0;
		obj.screenCenter();
	});
	dodgeSystem.cameras = [camHUD];
	dodgeSystem.add("reaction", function(bean:AttackSystem) {
		FlxG.sound.play(Paths.sound("game/warning"));
		bean.warningLabel.alpha = 1;
		FlxFlicker.flicker(bean.warningLabel, 0.2, 0.2/4);
	});
	dodgeSystem.add("reaction_update", function(bean:AttackSystem, elapsed:Float) {
		if(controlDodge.pressed)
			bean.warningLabel.animation.play("press");
		else bean.warningLabel.animation.play("static");
	});
	dodgeSystem.add("success", function(bean:AttackSystem) {
		FlxTween.tween(bean.warningLabel, {alpha: 0}, 0.15);
		
		dadAttack(FlxPoint.get(dad.x, dad.y), "success");
		attackSound.play();
		charDodges(1, "success");
	});
	dodgeSystem.add("failed", function(bean:AttackSystem) {
		FlxTween.tween(bean.warningLabel, {alpha: 0}, 0.15);
		
		dadAttack(FlxPoint.get(dad.x, dad.y), "failed");
		attackNoDodgeSound.play();
		charDodges(1, "failed");
	});
	add(dodgeSystem);
}

var controllZoom = 0.65;
var tnData:Dynamic = {};
function postUpdate(elapsed:Float) {
	strumLines.forEachAlive(function(strumLine:StrumLine) {
		if(characterLockCurAnim[strumLines.members.indexOf(strumLine)] == true) strumLine.characters[0].__lockAnimThisFrame = true;
	});
	
	var controlCamera = characterLockCurAnim.contains(true);
	if(controlCamera) {
		if(Reflect.fields(tnData).length < 1) {
			Reflect.setField(tnData, "camx", camFollow.x);
			Reflect.setField(tnData, "camy", camFollow.y);
			Reflect.setField(tnData, "zoom", camGame.zoom);
		}
		camFollow.setPosition(850, 450);
		camGame.zoom = lerp(FlxG.camera.zoom, controllZoom, 0.1);
	}else {
		if(Reflect.fields(tnData).length >= 1) {
			if(recycleDodgeCamHandler != null && Reflect.isFunction(recycleDodgeCamHandler)) {
				if(recycleDodgeCamHandler(tnData) != true) {
					camFollow.setPosition(tnData.camx, tnData.camy);
					camGame.zoom = tnData.zoom;
				}
			}else {
				camFollow.setPosition(tnData.camx, tnData.camy);
				camGame.zoom = tnData.zoom;
			}
			
			for(field in Reflect.fields(tnData)) {
				Reflect.deleteField(tnData, field);
			}
		}
	}
}

public function execute() {
	dodgeSystem.dispatch(0.5, function(timer:Float, rt:Float) {
		if(cpuControlled) return true;

		if(controlDodge.justPressed) return true;
	});
}

function charDodges(i:Int, type:String) {
	if(i == 0 || characterLockCurAnim[i] == true) return;
	
	var realType = type;
	var char = strumLines.members[i].characters[0];
	var recordv = FlxPoint.get(char.x, char.y);
	characterLockCurAnim[i] = true;

	if(type == "success") {
		char.playAnim("dodge");
		var finishTime = (1 / char.animation.curAnim.frameRate) * (char.animation.curAnim.numFrames);
		new FlxTimer().start(finishTime, (tmr) -> characterLockCurAnim[i] = false);
	}else {
		characterLockCurAnim[i] = false;
	}
}

function dadAttack(record:FlxPoint, type:String) {
	if(characterLockCurAnim[0] == true) return;
	
	dad.playAnim("attack");

	var realType = type;
	var recordv = record;
	var finishTime = (1 / dad.animation.curAnim.frameRate) * (dad.animation.curAnim.numFrames + 1);
	FlxTween.tween(dad, {x: recordv.x + 550}, finishTime / 3, {ease: FlxEase.quadIn, startDelay: finishTime * 1/3, onComplete: (_) -> {
		if(realType == "failed") {
			camHUD.flash(0xFFFF0000, Conductor.crochet * 1.5 / 1000);
			
			executeSendOut();
			FlxTween.tween(dad, {x: recordv.x}, 0.25, {ease: FlxEase.quadOut, startDelay: finishTime * 1/5, onComplete: (_) -> {
				characterLockCurAnim[0] = false;
				recordv.put();
			}});
		}else {
			FlxTween.tween(dad, {x: recordv.x}, 0.25, {ease: FlxEase.quadOut, startDelay: finishTime * 1/5, onComplete: (_) -> {
				characterLockCurAnim[0] = false;
				recordv.put();
			}});
		}
	}});
	characterLockCurAnim[0] = true;
}

function executeSendOut() {
	drainCount -= (drainCount > 0 ? 1 : 0);
	if(FlxG.sound.music != null) {
		FlxG.sound.music.volume = 0;
		chromatic.aberration = -0.5;
		getStuck = true;
		strumLines.members[1].notes.forEach((sb) -> sb.alpha = 0.35);
		
		tinnitusSound.volume = 1;
		tinnitusSound.fadeOut(Conductor.crochet * 2 / 1000 + 0.5);
		tinnitusSound.play(false, Math.abs(tinnitusSound.length - (Conductor.crochet * 2 + 500)));
		
		FlxTween.num(0, 1, Conductor.crochet * 2 / 1000, {startDelay: 0.5, onComplete: (_) -> {
			getStuck = false;
			strumLines.members[1].notes.forEach((sb) -> sb.alpha = 1);
		}}, function(val:Float) {
			if(FlxG.sound.music != null)
				FlxG.sound.music.volume = val;
			vocals.volume = 0;
		});
		//我是没想到，他们竟然是为了这个才改的？？？
		FlxTween.tween(chromatic, {aberration: -0.02}, Conductor.crochet * 2.5 / 1000, {startDelay: 0.5});
	}
}