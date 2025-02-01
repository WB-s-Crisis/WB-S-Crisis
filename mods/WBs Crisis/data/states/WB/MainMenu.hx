import funkin.backend.MusicBeatState;
import funkin.editors.EditorPicker;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.menus.ModSwitchMenu;
import flixel.group.FlxSpriteGroup;
import flixel.effects.FlxFlicker;
import funkin.backend.scripting.Script;
import flixel.util.FlxColor;
import flixel.addons.display.CustomShader;

var optionShit:Array<String> = [
	'story_mode',
	'freeplay',
	'options',
	'credits',
];

var menuItems:FlxSpriteGroup;

var curSelected:Int = 0;
var selectedSomethin:Bool = false;
var transitioning:Bool = false;

function create() {

    window.title = "WB,s Crisis";

    menuItems = new FlxSpriteGroup();

    bg = new FlxSprite(0, 0);
    bg.frames = Paths.getFrames('menus/menuBG');
    bg.updateHitbox();
    bg.scale.set(1, 1);
    add(bg);

    logo = new FlxSprite(-80, -650);
    logo.frames = Paths.getFrames('menus/logo');
    logo.updateHitbox();
    logo.scale.set(0.3, 0.3);
    add(logo);

    var storyModeItem:FlxSprite = new FlxSprite(100, 175);
    storyModeItem.frames = Paths.getSparrowAtlas('menus/mainmenu/mainmenu');
    storyModeItem.animation.addByPrefix('idle', 'story mode basic', 24);
    storyModeItem.animation.addByPrefix('selected', 'story mode white', 24);
    storyModeItem.animation.play('idle');
    storyModeItem.ID = 0;
    storyModeItem.scale.set(1.6, 1.6);
    storyModeItem.scrollFactor.set();
    storyModeItem.antialiasing = true;
    menuItems.add(storyModeItem);

    var freeplayItem:FlxSprite = new FlxSprite(100, 275);
    freeplayItem.frames = Paths.getSparrowAtlas('menus/mainmenu/mainmenu');
    freeplayItem.animation.addByPrefix('idle', 'freeplay basic', 24);
    freeplayItem.animation.addByPrefix('selected', 'freeplay white', 24);
    freeplayItem.animation.play('idle');
    freeplayItem.ID = 1;
    freeplayItem.scale.set(1.6, 1.6);
    freeplayItem.scrollFactor.set();
    freeplayItem.antialiasing = true;
    menuItems.add(freeplayItem);

    var optionsItem:FlxSprite = new FlxSprite(100, 375);
    optionsItem.frames = Paths.getSparrowAtlas('menus/mainmenu/mainmenu');
    optionsItem.animation.addByPrefix('idle', 'options basic', 24);
    optionsItem.animation.addByPrefix('selected', 'options white', 24);
    optionsItem.animation.play('idle');
    optionsItem.ID = 2;
    optionsItem.scale.set(1.6, 1.6);
    optionsItem.scrollFactor.set();
    optionsItem.antialiasing = true;
    menuItems.add(optionsItem);

    var creditsItem:FlxSprite = new FlxSprite(100, 475);
    creditsItem.frames = Paths.getSparrowAtlas('menus/mainmenu/mainmenu');
    creditsItem.animation.addByPrefix('idle', 'donate basic', 24);
    creditsItem.animation.addByPrefix('selected', 'donate white', 24);
    creditsItem.animation.play('idle');
    creditsItem.ID = 3;
    creditsItem.scale.set(1.6, 1.6);
    creditsItem.scrollFactor.set();
    creditsItem.antialiasing = true;
    menuItems.add(creditsItem);

    var versionSh_t:FunkinText = new FunkinText(550, FlxG.height - 0, 0, 'Codename Engine v' + Application.current.meta.get('version') + '\n');
    versionSh_t.scrollFactor.set();
    versionSh_t.y -= versionSh_t.height;
    add(versionSh_t);

    var versionSh_t:FunkinText = new FunkinText(590, FlxG.height - 20, 0, 'WB,s Crisis V1');
    versionSh_t.scrollFactor.set();
    versionSh_t.y -= versionSh_t.height;
    add(versionSh_t);

    add(menuItems);

    changeItem(0);

    #if mobile
    addVirtualPad('UP_DOWN', 'A_B');
    addVirtualPadCamera(false);
    #end
}

var holdTime:Float = 0;
var oiiaoiiiiai:Dynamic = {
	lastTime: -1145141919810,
	jiange: 0.07
};
function update(elapsed:Float) {
    if (controls.BACK) {
        CoolUtil.playMenuSFX(2, 0.7);
        FlxG.switchState(new TitleState());
    }
    if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new MainMenuState());
    if (FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = false;
        persistentDraw = true;
        openSubState(new EditorPicker());
    }

    if (controls.SWITCHMOD) {
        openSubState(new ModSwitchMenu());
        persistentUpdate = false;
        persistentDraw = true;
    }

    if (!selectedSomethin) {
        if (controls.LEFT_P || controls.UP_P) {
            CoolUtil.playMenuSFX(0, 0.7);
            changeItem(-1);
            
            holdTime = 0;
            oiiaoiiiiai.lastTime = -1145141919810;
        }
        
        if(controls.LEFT || controls.UP) {
        	holdTime += elapsed;
        	
        	if(holdTime > 0.6) {
        		if(oiiaoiiiiai.lastTime + oiiaoiiiiai.jiange < holdTime) {
        			CoolUtil.playMenuSFX(0, 0.7);
            		changeItem(-1);
            		
            		oiiaoiiiiai.lastTime = holdTime;
            	}
        	}
        }

        if (controls.RIGHT_P || controls.DOWN_P) {
            CoolUtil.playMenuSFX(0, 0.7);
            changeItem(1);
            
            holdTime = 0;
            oiiaoiiiiai.lastTime = -1145141919810;
        }
        
        if(controls.RIGHT || controls.DOWN) {
        	holdTime += elapsed;
        	
        	if(holdTime > 0.6) {
        		if(oiiaoiiiiai.lastTime + oiiaoiiiiai.jiange < holdTime) {
        			CoolUtil.playMenuSFX(0, 0.7);
            		changeItem(1);
            		
            		oiiaoiiiiai.lastTime = holdTime;
            	}
        	}
        }

		if (controls.ACCEPT) {
			selectedSomethin = transitioning = true;
			CoolUtil.playMenuSFX(1, 0.7);

			menuItems.forEach(function(spr:FunkinSprite) {
				if (curSelected != spr.ID) {
					FlxTween.tween(spr, {alpha: 0}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween) {
							spr.kill();
						}
					});
				} else {
					FlxTween.tween(FlxG.camera, {zoom: 4}, 1, {ease: FlxEase.expoInOut});

					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker) {
						switchState();
					});
				}
			});
		}
	} else if (controls.ACCEPT && transitioning) {
		FlxG.camera.stopFX();
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		switchState();
	}
}
function changeItem(huh:Int = 0) {
	curSelected += huh;

	if (curSelected >= menuItems.length)
		curSelected = 0;
	if (curSelected < 0)
		curSelected = menuItems.length - 1;
		
	updateItems();
}

function updateItems() {
	menuItems.forEach(function(spr:FunkinSprite) {
		spr.animation.play('idle');
		spr.offset.y = 500;
		spr.updateHitbox();

        if (spr.ID == curSelected) {
            spr.animation.play('selected');
		}
	});
}

function switchState() {
	window.title = "WB,s Crisis";
	var daChoice:String = optionShit[curSelected];

	switch (daChoice) {
		case 'story_mode':
			FlxG.switchState(new StoryMenuState());
		case 'freeplay':
			FlxG.switchState(new FreeplayState());
		case 'options':
			FlxG.switchState(new OptionsMenu());
		case 'credits':
			FlxG.switchState(new CreditsMain());
	}
}
