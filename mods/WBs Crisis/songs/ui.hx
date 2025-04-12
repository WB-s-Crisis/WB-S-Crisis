import Reflect;

import flixel.math.FlxRect;
import flixel.ui.FlxBar;
import flixel.util.FlxStringUtil;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;

importAddons("game.BarEvaluate");

public var fullTBHealthBar:Bool = false;
public var TBHealthBar:FlxSprite;

public var timeGroup:FlxSpriteGrouo;

public var timeBar:FlxBar;
public var timeBarBG:BarEvaluate;
public var timeTxt:FlxText;

var missFormat:FlxTextFormat = new FlxTextFormat(0xFFFF0000);
 
 var changeMisses:Bool = false;

var good:Dynamic = {
	healthLerp: (health != null ? health : 1)
}
var timeManager:Dynamic = {
	percent: 0.0
};


function create() {
if(PlayState.SONG != null) {
		id = switch(PlayState.SONG.meta.name.toLowerCase()) {
			case "friendship broken" | "bloody scissors" | "cruel cartoon" | "cruel cartoon erect" | "blood dispute": "TBHealthBar";
			case "unprovoked" | "nothing": "TBHealthBar2";
			case "murder": "TBHealthBar3";
			default: "TBHealthBar";
		};
	}

	if(event.newState is PlayState) {
		event.cancel();
		
		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();
	}
	
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

    TBHealthBar=new FunkinSprite().loadGraphic(Paths.image("game/" + id));
    TBHealthBar.scale.set(0.6, 0.6);
    TBHealthBar.alpha = 1;
    TBHealthBar.updateHitbox();
    TBHealthBar.x = 151.5;
    TBHealthBar.y = Options.downscroll ? 292 : 368;
    TBHealthBar.cameras = [camHUD];
    insert(members.indexOf(healthBar)+1, TBHealthBar);

    remove(healthBarBG);
    healthBar.scale.x = 1.18;
    healthBar.scale.y = 1.6;
    healthBar.setParent(good, "healthLerp");
    
    strumLines.members[0].onHit.add(function(event) {
    	event.preventStrumGlow();
    	
    	event.note.__strum.press(event.note.nextSustain != null ? event.note.strumTime : (event.note.strumTime - Conductor.crochet / 2) + (1 / event.note.__strum.animation._animations.get("confirm").frameRate) * event.note.__strum.animation._animations.get("confirm").numFrames * 1000);
    });
    
    accuracyTxt.y += 15;
    missesTxt.y += 15;
    scoreTxt.y += 15;

missesTxt.addFormat(missFormat, (comboBreaks ? "Combo Breaks:" : "Misses:").length, missesTxt.text.length);
     
     onSetVariable.add(function(key:String, val:Dynamic, isPost:Bool) {
     	if(key == "misses" && !isPost)
     		changeMisses = (val != misses);
     
     	if(key == "misses" && isPost && changeMisses) {
     		changeMisses = false;
 
 			updateRatingStuff();
 			missesTxt._formatRanges[0].range.set((comboBreaks ? "Combo Breaks:" : "Misses:").length, missesTxt.text.length);
 		}
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

function onPlayerHit(event) {
 	event.showRating = false;
 	if(!event.note.isSustainNote)
 		displayRating(event.rating, event);
}

var barTweens:Map<String, FlxTween> = [];
var strumsTweens:Map<String, FlxTween> = [];
var hudTweens:Map<String, FlxTween> = [];

function onEvent(_) {
    if (_.event.name == "Cinematics (Bar)") {
        if (barTweens.exists("CinematicBarTop")) {
            barTweens.get("CinematicBarTop").cancel();
            barTweens.get("CinematicBarTop").destroy();
            barTweens.remove("CinematicBarTop");
        }
        if (barTweens.exists("CinematicBarBottom")) {
            barTweens.get("CinematicBarBottom").cancel();
            barTweens.get("CinematicBarBottom").destroy();
            barTweens.remove("CinematicBarBottom");
        }

        var tweenEase:FlxEase = switch(_.event.params[1]) {
            case "Linear": FlxEase.linear;
            default: Reflect.field(FlxEase, _.event.params[1].toLowerCase() + _.event.params[2]);
        };
        var amount = Math.min(Math.max(_.event.params[0], 0), 100) / 100;
        var yVal = -FlxG.height + ((FlxG.height / 2) * amount);
        barTweens.set("CinematicBarTop", FlxTween.tween(barTop, {y: yVal}, _.event.params[3], {ease: tweenEase, onComplete: function() {
            barTweens.remove("CinematicBarTop");
        }}));

        var yVal = FlxG.height - ((FlxG.height / 2) * amount);
        barTweens.set("CinematicBarBottom", FlxTween.tween(barBottom, {y: yVal}, _.event.params[3], {ease: tweenEase, onComplete: function() {
            barTweens.remove("CinematicBarBottom");
        }}));
    }

    if (_.event.name == "Cinematics (HUD)") {
        var tweenEase:FlxEase = switch(_.event.params[1]) {
            case "Linear": FlxEase.linear;
            default: Reflect.field(FlxEase, _.event.params[1].toLowerCase() + _.event.params[2]);
        };
        var opacity:Float = _.event.params[0] ? 1 : 0;
 var hudElements = [iconP1, iconP2, TBHealthBar, healthBar, scoreTxt, missesTxt, accuracyTxt];
        var hudElementsString = ["iconP1", "iconP2", "TBHealthBar", "healthBar", "scoreTxt", "missesTxt", "accuracyTxt"];
        for (i => obj in hudElements) {
            var key:String = hudElementsString[i];
            if (hudTweens.exists(key)) {
                hudTweens.get(key).cancel();
                hudTweens.get(key).destroy();
                hudTweens.remove(key);
            }
            hudTweens.set(key, FlxTween.tween(obj, {alpha: opacity}, _.event.params[3], {ease: tweenEase, onComplete: function() {
                hudTweens.remove(key);
            }}));
        }
    }
}

function onSongEnd() {
	timeGroup.visible = false;
}

function onRegisterSmoothTransition(event) {
	event.cancel();
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
