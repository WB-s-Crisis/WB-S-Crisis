import Reflect;

importAddons("game.AnimationIcon");

var allowAnimationIcon:Array<{var name:String; var scale:Float; var x:Float; var y:Float;}> = [
	{
		name: "hnbf",
		scale: 0.15,
		x: 40,
		y: (Options.downscroll ? -0 : -15),
		dgCallback: function(obj:AnimationIcon) {
			obj.x = TBHealthBar.x + TBHealthBar.width - 165;
		}
	},
	{
		name: "tom",
		scale: 0.35,
		x: 460,
		y: (Options.downscroll ? -30 : -70)
	},
	{
		name: "tom-final",
		scale: 0.25,
		x: 570,
		y: (Options.downscroll ? -6 : -30)
	},
	{
		name: "pico",
		scale: 0.115,
		x: 45,
		y: (Options.downscroll ? 110 : -35),
		dgCallback: function(obj:AnimationIcon) {
		obj.x = TBHealthBar.x + TBHealthBar.width - 100;
		}
	},
	{
		name: "bugRabbit",
		scale: 0.14,
		x: 940,
		y: (Options.downscroll ? 10 : -20)
	},
	{
		name: "tom95",
		scale: 0.375,
		x: 820,
		y: (Options.downscroll ? -135 : -120)
	}
];

public var animationIconP1:AnimationIcon = null;
public var animationIconP2:AnimationIcon = null;
public var animationIconP3:AnimationIcon = null;

function postCreate() {
	var iconName:Array<String> = [];
	
	for(ai in allowAnimationIcon) {
		iconName.push(ai.name);
	}
	
	if(boyfriend != null && dad != null)
		for(char in [boyfriend, dad]) {
			if(iconName.contains(char.getIcon())) {
				switch(char) {
					case boyfriend:
						var cne:Dynamic = allowAnimationIcon[iconName.indexOf(char.getIcon())];
						var index:Int = members.indexOf(iconP1);
						
						remove(iconP1);
						
						animationIconP1 = new AnimationIcon(char.getIcon(), true);
						animationIconP1.data = cne;
						
						animationIconP1.scale.set(cne.scale, cne.scale);
						animationIconP1.updateHitbox();
						
						animationIconP1.cameras = [camHUD];
						animationIconP1.y = iconP1.y + cne.y;
						insert(index, animationIconP1);
					case dad:
						var cne:Dynamic = allowAnimationIcon[iconName.indexOf(char.getIcon())];
						var index:Int = members.indexOf(iconP2);
						
						remove(iconP2);
						
						animationIconP2 = new AnimationIcon(char.getIcon(), false);
						animationIconP2.data = cne;
						animationIconP2.cameras = [camHUD];
						
						animationIconP2.scale.set(cne.scale, cne.scale);
						animationIconP2.updateHitbox();
						
						animationIconP2.y = iconP2.y + cne.y;
						insert(index, animationIconP2);
				}
			}
		}
	
	switch(SONG.meta.name) {
		case "Blood dispute":
			var char = strumLines.members[2].characters[0];
			var index = iconName.indexOf(char.getIcon());
			
			if(index > -1) {
				animationIconP3 = new AnimationIcon(char.getIcon(), true);
				
				var cne = allowAnimationIcon[index];
				animationIconP3.data = cne;
				animationIconP3.cameras = [camHUD];
				animationIconP3.scale.set(cne.scale, cne.scale);
				animationIconP3.updateHitbox();
				animationIconP3.y = iconP1.y + cne.y;
				
				animationIconP3.followHealth = false;
			
				if(animationIconP1 != null)
					insert(members.indexOf(animationIconP1) + 1, animationIconP3);
				else add(animationIconP1);
			}
		default: {}
	}
}

var barTweens:Map<String, FlxTween> = [];
var strumsTweens:Map<String, FlxTween> = [];
var hudTweens:Map<String, FlxTween> = [];

function onEvent(_) {

    if (_.event.name == "Cinematics (HUD)") {
        var tweenEase:FlxEase = switch(_.event.params[1]) {
            case "Linear": FlxEase.linear;
            default: Reflect.field(FlxEase, _.event.params[1].toLowerCase() + _.event.params[2]);
        };
        var opacity:Float = _.event.params[0] ? 1 : 0;
 var hudElements = [animationIconP1, animationIconP2];
        var hudElementsString = ["animationIconP1", "animationIconP2"];
        if(animationIconP3 != null) {
        	hudElements.push(animationIconP3);
        	hudElementsString.push("animationIconP3");
        }
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

function update(elapsed:Float) {
	if(animationIconP1 != null && members.indexOf(animationIconP1) > -1) {
		animationIconP1.health = healthBar.percent / 100;
	
		var iconOffset:Float = animationIconP1.data.x + 52;
		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0) * healthBar.scale.x;
	
		if(animationIconP1.followHealth)
			animationIconP1.x = center - iconOffset;
		else {
			if(Reflect.hasField(animationIconP1.data, "dgCallback") && animationIconP1.data.dgCallback != null && Reflect.isFunction(animationIconP1.data.dgCallback)) animationIconP1.data.dgCallback(animationIconP1);
		}
	}
	
	if(animationIconP2 != null && members.indexOf(animationIconP2) > -1) {
		animationIconP2.health = 1 - (healthBar.percent / 100);
	
		var iconOffset:Float = animationIconP2.data.x - 52;
		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0) * healthBar.scale.x;
	
		if(animationIconP2.followHealth)
			animationIconP2.x = center - (animationIconP2.frameWidth - iconOffset);
		else {
			if(Reflect.hasField(animationIconP2.data, "dgCallback") && animationIconP2.data.dgCallback != null && Reflect.isFunction(animationIconP2.data.dgCallback)) animationIconP2.data.dgCallback(animationIconP2);
		}
	}
	
	if(animationIconP3 != null && members.indexOf(animationIconP3) > -1) {
		animationIconP3.health = healthBar.percent / 100;
	
		var iconOffset:Float = animationIconP3.data.x + 52;
		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0) * healthBar.scale.x;
	
		if(animationIconP3.followHealth)
			animationIconP3.x = center - iconOffset;
		else {
			if(Reflect.hasField(animationIconP3.data, "dgCallback") && animationIconP3.data.dgCallback != null && Reflect.isFunction(animationIconP3.data.dgCallback)) animationIconP3.data.dgCallback(animationIconP3);
		}
	}
}

var change:Int = 0;
function onNoteHit(event) {
	switch(SONG.meta.name) {
		case "Blood dispute":
			if(event.noteType == "4 Sing") {
				if(change == 0) {
					change = 1;
					animationIconP1.followHealth = false;
					animationIconP3.followHealth = true;
					
					changeHealthBarColor(dad.iconColor, strumLines.members[2].characters[0].iconColor);
					
					if(strumLines.members[2].characters[0].alpha != 1)
						FlxTween.tween(strumLines.members[2].characters[0], {alpha: 1}, 0.35);
				}
			}else {
				if(change == 1) {
					change = 0;
					animationIconP1.followHealth = true;
					animationIconP3.followHealth = false;
					
					changeHealthBarColor(dad.iconColor, boyfriend.iconColor);
					
					if(strumLines.members[2].characters[0].alpha != 0.45)
						FlxTween.tween(strumLines.members[2].characters[0], {alpha: 0.45}, 0.35);
				}
			}
		default: {}
	}
}