import Reflect;

import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import hxIni.IniManager;

import openfl.Assets;

public var songInfo:Map<String, String>;
var fontName:String = "Super Cartoon.ttf";

var point:Dynamic = {
	start: {
		x: -55, 
		y: 100
	},
	over: {
		x: -625,
		y: 100
	}
};

var panelGroup:FlxSpriteGroup;

function create() {
	var infoPath:String = Paths.getPath("songs/" + SONG.meta.name + "/info.ini");

	if(Assets.exists(infoPath)) {
		songInfo = IniManager.loadFromString(Assets.getText(infoPath));
	}
}

var cog:Bool = false;
function onSongStart() {
	if(songInfo != null) {
		FlxTween.tween(panelGroup, {x: point.start.x}, Conductor.stepCrochet * 4 / 1000, {ease: FlxEase.quadOut, onStart: function(tween:FlxTween) {
			if(panelGroup.members.length > 1) {
				var i:Int = -1;
				
				panelGroup.forEachOfType(FlxText, function(obj:FlxText) {
					i++;
				
					obj.scale.x = 0.1;
					obj.offset.x = 500;
				
					FlxTween.tween(obj.scale, {x: 1}, Conductor.stepCrochet * 5 / 1000, {ease: FlxEase.quadOut, startDelay: i * Conductor.stepCrochet / 1.5 / 1000});
				
					FlxTween.tween(obj.offset, {x: 0}, Conductor.stepCrochet * 6 / 1000, {ease: FlxEase.quadOut, startDelay: i * Conductor.stepCrochet / 1.5 / 1000, onComplete: function(tween:FlxTween) {
						cog = true;
					}});
				});
			}
		}, onComplete: function(tween:FlxTween) {
			if(panelGroup.members.length <= 1) {
				cog = true;
			}
		}});
	}
}

var onlyTime:Float = Conductor.crochet * 4;
var preTime:Float = 0.;
function update(elapsed:Float) {
	if(cog) {
		preTime += elapsed;
		
		panelGroup.y = point.start.y + Math.sin(preTime * Math.PI / 2) * 8;
		
		if(preTime >= onlyTime / 1000) {
			cog = false;
			
			FlxTween.tween(panelGroup, {x: point.over.x}, Conductor.stepCrochet * 4 / 1000, {ease: FlxEase.quadIn, onStart: function(tween:FlxTween) {
				if(panelGroup.members.length > 1) {
					var i:Int = -1;
					
					panelGroup.forEachOfType(FlxText, function(obj:FlxText) {
						i++;
					
						FlxTween.tween(obj.scale, {x: 0.01}, Conductor.stepCrochet * 5 / 1000, {ease: FlxEase.quadIn, startDelay: i * Conductor.stepCrochet / 2 / 1000});
				
						FlxTween.tween(obj.offset, {x: 500}, Conductor.stepCrochet * 6 / 1000, {ease: FlxEase.quadIn, startDelay: i * Conductor.stepCrochet / 2 / 1000, onComplete: function(tween:FlxTween) {
					remove(panelGroup, true);
					panelGroup.destroy();
				}});
					});
				}
			}, onComplete: function(tween:FlxTween) {
				if(panelGroup.members.length <= 1) {
					remove(panelGroup, true);
					panelGroup.destroy();
				}
			}});
		}
	}
}

function postCreate() {
	if(songInfo != null) {
		panelGroup = new FlxSpriteGroup(point.over.x, point.over.y);
		panelGroup.cameras = [camOther];
		
		addMembers(panelGroup, songInfo);
		
		add(panelGroup);
		
		//Application.current.window.alert(panelGroup.members);
	}
}

function addMembers(preGroup:FlxSpriteGroup, expr:Dynamic) {
if(PlayState.SONG != null) {
		id = switch(PlayState.SONG.meta.name.toLowerCase()) {
			case "friendship broken" | "bloody scissors" | "cruel cartoon" | "cruel cartoon erect" | "blood dispute": "infoPanel";
			case "unprovoked" | "nothing": "infoPanel2";
			case "murder": "infoPanel3";
			default: "infoPanel";
		};
	}

	if(event.newState is PlayState) {
		event.cancel();
		
		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();
	}

	var jiange:Float = 10;

	var panel:FlxSprite = new FlxSprite().loadGraphic(Paths.image("game/infoPanel/" + id));
	panel.scale.set(0.35, 0.35);
	panel.updateHitbox();
	preGroup.add(panel);
	
	if(expr.exists("Game")) {
		var snTxt:FlxText = new FlxText(70, 105, panel.width, "Now Playing: " + expr.get("Game").get("SongName"), 32);
		snTxt.setFormat(Paths.font(fontName), 32, 0xFFFFFFFF, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		snTxt.borderSize = 4;
		
		preGroup.add(snTxt);
	}
	
	var authorTxt:FlxText = new FlxText(70, 145, panel.width, "Made By: " + expr.get("Global").get("SongAuthor"), 32);
	authorTxt.setFormat(Paths.font(fontName), 32, 0xFFFFFFFF, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, 0xFF000000);
	authorTxt.borderSize = 4;
		
	preGroup.add(authorTxt);
	
	return preGroup;
}