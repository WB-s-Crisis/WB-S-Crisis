import Reflect;

import flixel.math.FlxRect;
import flixel.ui.FlxBar;
import flixel.util.FlxStringUtil;
import flixel.text.FlxTextBorderStyle;

importAddons("BarEvaluate");

public var fullTBHealthBar:Bool = false;
public var TBHealthBar:FlxSprite;

public var timeGroup:FlxSpriteGrouo;

public var timeBar:FlxBar;
public var timeBarBG:BarEvaluate;
public var timeTxt:FlxText;

var good:Dynamic = {
	healthLerp: (health != null ? health : 1)
}
var timeManager:Dynamic = {
	percent: 0.0
};

function create() {
	timeGroup = new FlxSpriteGroup();

	timeBarBG = new BarEvaluate(0, 0, FlxG.width / 3, 25, {
		thickness: 6,
		color: 0xFF000000
	});
	timeGroup.add(timeBarBG);
	
	timeBar = new FlxBar(timeBarBG.thickness, timeBarBG.thickness, null, (timeBarBG.width - timeBarBG.thickness * 2) + 1, timeBarBG.height - timeBarBG.thickness * 2, timeManager, "percent", 0, 100);
	timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
	timeGroup.add(timeBar);
	
	timeTxt = new FlxText(0, timeBarBG.height - 5, timeGroup.width, "0:00 - 0:00", 24);
	timeTxt.setFormat(Paths.font("vcr.ttf"), 24, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF4D0000);
	timeTxt.scale.x *= 0.95;
	timeGroup.add(timeTxt);
	
	timeGroup.screenCenter(FlxAxes.X);
	timeGroup.cameras = [camHUD];
	timeGroup.y = 18;
	timeGroup.alpha = 0;
	add(timeGroup);
}

function postCreate() {

    TBHealthBar=new FunkinSprite().loadGraphic(Paths.image('game/TBHealthBar'));
    TBHealthBar.scale.set(0.6, 0.6);
    TBHealthBar.alpha = 1;
    TBHealthBar.updateHitbox();
    TBHealthBar.x = 151.5;
    TBHealthBar.y = Options.downscroll ? 292 : 368;
    TBHealthBar.cameras = [camHUD];
    insert(members.indexOf(healthBar)+1, TBHealthBar);

    remove(healthBarBG);
    healthBar.scale.x = 1.18;
    healthBar.scale.y = 1.4;
    healthBar.setParent(good, "healthLerp");
    
    strumLines.members[0].onHit.add(function(event) {
    	event.preventStrumGlow();
    	
    	health -= switch(SONG.meta.name.toLowerCase()) {
    		case "friendship broken": health > 0.00500001 ? 0.005 : 0;
    		case "bloody scissors": health > 0.0150000001 ? 0.015 : 0;
    		case "he died unjustly": health > 0.0300088880011 ? 0.03 : 0;
    		default: 0;
    	};
    	
    	event.note.__strum.press(event.note.nextSustain != null ? event.note.strumTime : (event.note.strumTime - Conductor.crochet / 2) + (1 / event.note.__strum.animation._animations.get("confirm").frameRate) * event.note.__strum.animation._animations.get("confirm").numFrames * 1000);
    });

//oiiaoiiiiai --橘子
//kjkjjajakjkjjajakjkjgadldododo --袼雪梦晓花
}

function onStartSong() {
	FlxTween.tween(timeGroup, {alpha: 1}, Conductor.stepCrochet * 2 / 1000, {onStart: function(tween:FlxTween) {
		timeGroup.scale.x = 0.05;
		FlxTween.tween(timeGroup.scale, {x: 1}, Conductor.stepCrochet * 2 / 1000, {ease: FlxEase.quadInOut});
	}});
}

function onSongEnd() {
	timeGroup.visible = false;
}

function update(elapsed:Float) {
	good.healthLerp = FlxMath.lerp(good.healthLerp, health, 0.2);
	
	if(startedCountdown && !startingSong) {
		var time:Float = FlxG.sound.music != null ? FlxG.sound.music.time : 0;
		var length:Float = FlxG.sound.music != null ? FlxG.sound.music.length : 0;
		
		if(FlxG.sound.music != null && !FlxG.sound.music._paused)
		timeManager.percent = lerp(timeManager.percent, (time / length) * 100, 0.1);
		
		timeTxt.text = FlxStringUtil.formatTime(time / 1000) + "-" + FlxStringUtil.formatTime(length / 1000);
	}
}