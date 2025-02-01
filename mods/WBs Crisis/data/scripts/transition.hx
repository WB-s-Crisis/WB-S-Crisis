import Sys;

//脑子好痛，搞的代码都皓垃圾

var loadBG:FlxSprite;
var fanLoad:FlxSprite;

var flashTime:Float = 1.25;

var timer:Float = 0.;
var minLoadingTime:Float = 0.65;

var loadDelay:Bool = false;

function create(event) {
	if(event.newState is PlayState) {
		event.cancel();
		
		FlxG.sound.music.stop();
		
		transitionCamera.fade(0xFF000000, flashTime, true, function() {
			loadDelay = true;
		});
		
		new FlxTimer().start(flashTime / 9, function(time:FlxTimer) {
			for(obj in [loadBG, fanLoad]) {
				obj.alpha = 1;
			}
		});
	
		loadBG = new FlxSprite().loadGraphic(Paths.image("loadingMenu/1942menu"));
		loadBG.setGraphicSize(FlxG.width, FlxG.height);
		loadBG.updateHitbox();
		loadBG.cameras = [transitionCamera];
		loadBG.scrollFactor.set();
		loadBG.alpha = 0;
		add(loadBG);
		
		fanLoad = new FlxSprite().loadGraphic(Paths.image("loadingMenu/loading"));
		fanLoad.scale.set(0.45, 0.45);
		fanLoad.updateHitbox();
		
		fanLoad.setPosition(-250, 325);
		
		fanLoad.cameras = [transitionCamera];
		fanLoad.alpha = 0;
		add(fanLoad);
	}else if(event.newState == null && Std.isOfType(FlxG.state, PlayState)) {
		event.cancel();
		
		loadBG = new FlxSprite().loadGraphic(Paths.image("loadingMenu/1942menu"));
		loadBG.setGraphicSize(FlxG.width, FlxG.height);
		loadBG.updateHitbox();
		loadBG.cameras = [transitionCamera];
		loadBG.scrollFactor.set();
		loadBG.alpha = 1;
		add(loadBG);
		
		fanLoad = new FlxSprite().loadGraphic(Paths.image("loadingMenu/loadingFinish"));
		fanLoad.scale.set(0.75, 0.75);
		fanLoad.updateHitbox();
		
		fanLoad.setPosition(-230, 210);
		
		fanLoad.cameras = [transitionCamera];
		fanLoad.alpha = 1;
		add(fanLoad);
		
		new FlxTimer().start(0.5, function(time:FlxTimer) {
			for(obj in [loadBG, fanLoad]) {
				FlxTween.tween(obj, {alpha: 0}, 1, {ease: FlxEase.sineOut, onComplete: function(_:FlxTween) {
					if(obj == fanLoad) {
						finish();
					}
				}});
			}
		});
	}
}

function update(elapsed:Float) {
	if(Std.isOfType(newState, PlayState) && loadDelay) {
		timer += elapsed;
		
		if(timer > minLoadingTime)
			finish();
	}
}
