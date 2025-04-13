import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxTextBorderStyle;
import openfl.display.BitmapData;
import flixel.util.FlxGradient;
import flixel.FlxObject;
import funkin.editors.EditorPicker;
import flixel.effects.FlxFlicker;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.backend.system.framerate.Framerate;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.BitmapData;
import lime.app.Application;

importAddons("shader.OldTV");

var camMain:FlxCamera;

var bg:FunkinSprite;
var logo:FunkinSprite;
var buttons:WCSNMD;
var versionTxt:FlxText;

var tvShader:OldTV;

var canSelected:Bool = false;
var canAccessCheat = false;

/*看你妈呢*/

var menuItems:Array<Dynamic> = [
	{
		name: "storyOption",
		nextState: StoryMenuState,
		extraFunc: function(fw:FunkinSprite, info:Dynamic) {
			CoolUtil.playMenuSFX(1);
			canSelected = false;
			imYourDad(fw, info);
		},
		info: {
			x: 345,
			y: 306,
			scale: 0.78
		},
		downed: false
	},
	{
		name: "freeplayOption",
		nextState: FreeplayState,
		extraFunc: function(fw:FunkinSprite, info:Dynamic) {
			CoolUtil.playMenuSFX(1);
			canSelected = false;
			imYourDad(fw, info);
		},
		info: {
			x: 485,
			y: 328,
			scale: 0.75
		},
		downed: false
	},
	{
		name: "optionsOption",
		nextState: OptionsMenu,
		extraFunc: function(fw:FunkinSprite, info:Dynamic) {
			CoolUtil.playMenuSFX(1);
			canSelected = false;
			imYourDad(fw, info);
		},
		info: {
			x: 655,
			y: 306,
			scale: 0.75
		},
		downed: false
	},
	{
		name: "creditsOption",
		nextState: CreditsMain,
		extraFunc: function(fw:FunkinSprite, info:Dynamic) {
			CoolUtil.playMenuSFX(1);
			canSelected = false;
			imYourDad(fw, info);
		},
		info: {
			x: 835,
			y: 296,
			scale: 0.78
		},
		downed: false
	}
];

function create() {
	FlxG.mouse.visible = true;
	CoolUtil.playMenuSong();
	
	Framerate.instance.alpha = 0.1;
	
	camMain = new FlxCamera();
	camMain.bgColor = 0;
	FlxG.cameras.add(camMain, false);
	FlxG.camera.scroll.y = (Options.downscroll ? 1 : -1) * FlxG.height;
	
	FlxTween.tween(FlxG.camera.scroll, {y: 0}, 0.75, {ease: FlxEase.circInOut, onComplete: (_) -> canSelected = true});
	
	bg = new FunkinSprite();
	addGradientFW(bg);
	bg.scrollFactor.set(0.5, 0.5);
	bg.zoomFactor = 0.5;
	add(bg);
	
	tvShader = new OldTV();
	tvShader.blueOpac = 1.0;
	FlxG.camera.addShader(tvShader.shader);
	add(tvShader);

	logo = new FunkinSprite().loadGraphic(Paths.image("menus/logo"));
	logo.antialiasing = Options.antialiasing;
	logo.scale.set(0.4, 0.4);
	logo.updateHitbox();
	logo.screenCenter();
	add(logo);
	
	buttons = new FlxGroup(menuItems.length);
	createFW(buttons);
	add(buttons);
	
	versionTxt = new FlxText(0, 0, FlxG.width, "wcnmd", 16);
	versionTxt.antialiasing = Options.antialiasing;
	versionTxt.cameras = [camMain];
	versionTxt.setFormat(Paths.font("Super Cartoon.ttf"), #if mobile 24 #else 16 #end, 0xFFFFFFFF, FlxG.random.getObject(["left", "center", "right"]));
	versionTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF4D0000, 0.5, 2);
	versionTxt.alpha = 0;
	if(versionTxt.alignment == "right") versionTxt.text = (Options.downscroll ? "0.1.0v CodenameEngine\n" + Application.current.meta.get("version") + "v WB’s crisis" : Application.current.meta.get("version") + "v WB’s crisis\n0.1.0v CodenameEngine");
	else versionTxt.text = (Options.downscroll ? "CodenameEngine v0.1.0\nWB’s crisis v" + Application.current.meta.get("version") : "WB’s crisis v" + Application.current.meta.get("version") + "\nCodenameEngine v0.1.0");
	versionTxt.y = (Options.downscroll ? 0 : (FlxG.height - versionTxt.height));
	add(versionTxt);
	FlxTween.tween(versionTxt, {alpha: 1}, 0.75);
	
	#if (mobile && !android)
	addVirtualPad("NONE", "B");
	addVirtualPadCamera();
	#end
}

function createFW(group:FlxGroup) {
	for(id=>mini in menuItems) {
		var fw = new FlxSprite();
		fw.ID = id;
		fw.antialiasing = Options.antialiasing;
		fw.frames = Paths.getSparrowAtlas("menus/mainmenu/options/" + mini.name);
		fw.animation.addByPrefix("static", "static", FlxG.random.int(2, 4), true);
		fw.animation.addByPrefix("confirm", "confirm", 1, true);
		fw.animation.play("static");

		fw.setPosition(mini.info.x, mini.info.y);
		fw.scale.set(mini.info.scale, mini.info.scale);
		fw.updateHitbox();
		
		var hitbox = new FlxObject(fw.x, fw.y, fw.frameWidth, fw.frameHeight * 2/3);
		
		FlxMouseEvent.add(hitbox,
			(obj) -> {onMenuItemDown(obj, mini, fw);},
			(obj) -> {onMenuItemUp(obj, mini, fw);},
			(obj) -> {onMenuItemOver(obj, mini, fw);},
			(obj) -> {onMenuItemOut(obj, mini, fw);}
		);
		
		group.add(fw);
	}
}

function update(elapsed:Float) {
	if(canSelected) {
		var moveOffset = 20;
		FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, ((FlxG.mouse.screenX - FlxG.width / 2) / (FlxG.width / 2)) * moveOffset, 0.1);
		FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, ((FlxG.mouse.screenY - FlxG.height / 2) / (FlxG.height / 2)) * moveOffset, 0.1);
		
		if(FlxG.sound.music != null && FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * elapsed;
		
		#if android
		if(FlxG.android.justReleased.BACK) {
			canSelected = false;
			fuckYourMom();
		}
		#else
		if(controls.BACK) {
			canSelected = false;
			fuckYourMom();
		}
		#end
		
		if(canAccessCheat)
			if (FlxG.keys.justPressed.SEVEN) {
				persistentUpdate = false;
				persistentDraw = true;
				openSubState(new EditorPicker());
			}
	}
}

function onMenuItemDown(obj:FlxObject, info:Dynamic, spr:FlxSprite) {
	if(!canSelected) return;

	info.downed = true;
	spr.color = 0xFF4D4D4D;
}

function onMenuItemUp(obj:FlxObject, info:Dynamic, spr:FlxSprite) {
	if(!canSelected) return;

	if(info.downed) {
		spr.color = 0xFFFFFFFF;
		if(info.extraFunc != null) {
			info.extraFunc(spr, info);
		}else {
			FlxG.switchState(Type.createInstance(info.nextState, []));
			canSelected = false;
		}
		
		info.downed = false;
	}
}

function onMenuItemOver(obj:FlxObject, info:Dynamic, spr:FlxSprite) {
	if(!canSelected) return;

	CoolUtil.playMenuSFX(0);
	spr.animation.play("confirm");
}

function onMenuItemOut(obj:FlxObject, info:Dynamic, spr:FlxSprite) {
	if(!canSelected) return;
	
	if(info.downed) info.downed = false;
	spr.color = 0xFFFFFFFF;
	spr.animation.play("static");
}

function imYourDad(obj:FlxSprite, info:Dynamic) {
	FlxG.camera.flash(0xFFFFFFFF, 0.25);
	
	FlxTween.tween(versionTxt, {alpha: 0}, 0.4);
	Framerate.instance.alpha = 1;
	
	if(FlxG.sound.music != null)
		FlxTween.tween(FlxG.sound.music, {volume: 0.1}, 0.2);

	FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.75}, 0.75, {ease: FlxEase.circOut});
	FlxFlicker.flicker(obj, 1);
	
	buttons.forEach(function(fw:FunkinSprite) {
		if(fw != obj) {
			FlxTween.tween(fw, {alpha: 0}, 0.15);
		}
	});
	FlxTween.tween(obj, {x: (FlxG.width - obj.width) / 2, y: (FlxG.height - obj.height) / 2}, 0.5, {ease: FlxEase.quadOut});
	FlxTween.tween(obj.scale, {x: obj.scale.x * 2, y: obj.scale.y * 2}, 0.5, {ease: FlxEase.quadOut});
	new FlxTimer().start(1, (fw) -> {
		
		if(FlxG.sound.music != null)
			FlxTween.tween(FlxG.sound.music, {volume: 0.8}, 0.25, {onComplete: (fw) -> FlxG.switchState(Type.createInstance(info.nextState, []))});
		else {
			FlxG.switchState(Type.createInstance(info.nextState, []));
		}
	});
}

function fuckYourMom() {
	FlxG.camera.scroll.set();
	FlxTween.tween(versionTxt, {alpha: 0}, 0.4);
	Framerate.instance.alpha = 1;
	FlxTween.tween(FlxG.camera.scroll, {x: FlxG.height}, 1, {ease: FlxEase.circIn, onStart: (_) -> {
		FlxTween.tween(FlxG.camera, {alpha: 0}, 1);
		if(FlxG.sound.music != null)
			FlxTween.tween(FlxG.sound.music, {volume: 0.35}, 1);
	}, onComplete: (_) -> FlxG.switchState(new TitleState())});
}

//添加史诗级渐变废物
function addGradientFW(spr:FlxSprite) {
	var bitmapData:BitmapData = Assets.getBitmapData(Paths.image("menus/mainmenu/bg/warehouse"));
	var realBitmapData:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
	realBitmapData.draw(bitmapData);

	for(i in 0...4) realBitmapData.draw(FlxGradient.createGradientBitmapData(bitmapData.width, bitmapData.height, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000], 1, 90 * i));

	spr.loadGraphic(realBitmapData);
}
