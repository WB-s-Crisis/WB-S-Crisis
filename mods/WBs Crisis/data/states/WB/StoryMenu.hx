import funkin.backend.MusicBeatState;
import flixel.group.FlxSpriteGroup;
//import Xml;
//不需要以上这个

import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

var description:FunkinText;
var banners:FlxSpriteGroup;
var backgrounds:FlxSpriteGroup;
var weeok:FlxSpriteGroup;
var arrows:FlxSpriteGroup;
var noSongsMessage:FlxText;

var curWeek:String = 'rabbit';
var curSelection:Int = 0;
var weekOrder:Array<String> = [];

var weekData:Dynamic = {
	name: '1942',
	description: '?',
	difficuly: 'WB',
	songs: []
};

var canSelect:Bool = true;
var hasSongs:Bool = false;

function create() {
	window.title = "WB's Crisis(Story Menu)";

	CoolUtil.playMenuSong();

	for (i in Paths.getFolderContent('data/weeks')) {
		if (!StringTools.endsWith(i, '.xml')) continue;
		try {
			var xml:Xml = Xml.parse(Assets.getText('data/weeks/' + i)).firstElement();
			if (xml == null) {
				throw 'hey you fucked up yo shit bruh! (' + i + ')';
				continue;
			}

			weekOrder[Std.parseInt(xml.get('index'))] = i;
		} catch(e:Exception) {
			trace(e);
			continue;
		}
	}

	for (i in weekOrder)
		if (i == null)
			weekOrder.remove(i);

	curWeek = weekOrder[0];

	parseWeek();

	banners = new FlxSpriteGroup();
	backgrounds = new FlxSpriteGroup();
	weeok = new FlxSpriteGroup();
	arrows = new FlxSpriteGroup();

	for (week in weekOrder) {
		var bgPath = 'menus/storymenu/bg/' + StringTools.replace(week, '.xml', '');
		var bg = new FunkinSprite().loadGraphic(
			Assets.exists(Paths.image(bgPath)) ? 
			Paths.image(bgPath) : 
			Paths.image('1942')
		);
		bg.width = FlxG.width;
		bg.height = FlxG.height;
		bg.scrollFactor.set(0, 0);
		bg.alpha = weekOrder.indexOf(week) == curSelection ? 1 : 0.001;
		backgrounds.add(bg);
	}
	
	for (week in weekOrder) {
		var weekkPath = 'menus/storymenu/week/' + StringTools.replace(week, '.xml', '');
		var weekk = new FunkinSprite().loadGraphic(
			Assets.exists(Paths.image(weekkPath)) ? 
			Paths.image(weekkPath) : 
			Paths.image('1942')
		);
		weekk.width = FlxG.width;
		weekk.height = FlxG.height;
		weekk.scale.set(0.25, 0.25);
		weekk.scrollFactor.set(0, 0);
		weekk.x -= 390;
		weekk.alpha = weekOrder.indexOf(week) == curSelection ? 1 : 0.001;
		weeok.add(weekk);
	}
	
	add(backgrounds);
	add(weeok);

	for (week in weekOrder) {
		var banner = new FunkinSprite().loadGraphic(
			Assets.exists(Paths.image('menus/storymenu/' + StringTools.replace(week, '.xml', ''))) ?
			Paths.image('menus/storymenu/' + StringTools.replace(week, '.xml', '')) :
			Paths.image('1942')
		);
		banner.updateHitbox();
		banner.scale.set(0.7, 0.7);
		banner.screenCenter();
		banner.x -= -170;
		banner.antialiasing = true;
		banner.alpha = weekOrder.indexOf(week) == curSelection ? 1 : 0.001;
		banners.add(banner);
	}

	description = new FunkinText(0, 0, banners.members[0].width, weekData.description, 32, 0xFFC0C0C0, true);
	description.font = Paths.font('vcr.ttf');
	description.setPosition(banners.members[0].x, 250);
	description.x = 5;
	description.applyMarkup(
		description.text,
		[new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF9100C5, true, false, 0x00000000), "#")]
	);
	add(description);

	noSongsMessage = new FlxText(0, 0, 0, "No songs available in this week!", 32);
	noSongsMessage.color = 0xFFFF0000;
	noSongsMessage.screenCenter();
	noSongsMessage.x -= noSongsMessage.width / 70;
	noSongsMessage.y = FlxG.height - 100;
	noSongsMessage.alpha = 0;
	add(noSongsMessage);

	for (i in [0, 1]) {
		var arrow:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('menus/storymenu/Arrow'));
		arrow.x = i == 0 ? 
			-430 :
			FlxG.width - arrow.width - 520;
		arrow.flipX = i == 1;
		arrow.y = -250;
		arrow.scale.set(0.1, 0.1);
		arrow.alpha = 0.5;
		arrow.antialiasing = true;
		arrows.add(arrow);
	}

	add(banners);
	add(arrows);

	#if mobile
	addVirtualPad('LEFT_RIGHT', 'A_B');
	addVirtualPadCamera(false);
	#end

}

function parseWeek() {
	weekData.name = '';
	weekData.description = '';
	weekData.difficulty = '';
	weekData.songs = [];

	var xml:Xml = Xml.parse(Assets.getText('data/weeks/' + curWeek)).firstElement();
	weekData.name = xml.get('name');
	weekData.description = StringTools.replace(xml.get('description'), '_BREAK_', '\n');
	weekData.difficulty = xml.get('difficulty');

	for (node in xml.elements())
		weekData.songs.push(node.get('name'));

	hasSongs = weekData.songs.length > 0;
}

function changeItem(value:Int, arrow:Int) {
	CoolUtil.playMenuSFX(0, 0.7);
	arrows.members[arrow].alpha = 1;

	banners.members[curSelection].alpha = 0.001;
	backgrounds.members[curSelection].alpha = 0.001;
	weeok.members[curSelection].alpha = 0.001;

	curSelection = value;

	banners.members[curSelection].alpha = 1;
	backgrounds.members[curSelection].alpha = 1;
	weeok.members[curSelection].alpha = 1;

	curWeek = weekOrder[curSelection];
	parseWeek();
	description.text = weekData.description;
	description.applyMarkup(
		description.text,
		[new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF9100C5, true, false, 0x00000000), "#")]
	);

	if (!hasSongs) {
		showNoSongsMessage();
	} else {
		noSongsMessage.alpha = 0;
	}
}

function showNoSongsMessage() {
	noSongsMessage.alpha = 1;

	new FlxTimer().start(3, function() {
		FlxTween.tween(noSongsMessage, { alpha: 0 }, 0.5);
	});
}


function update(elapsed) {
	if (controls.BACK) {
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.25, function() {FlxG.switchState(new MainMenuState());});
	}

	if (controls.LEFT_P && curSelection != 0)
		changeItem(curSelection - 1, 0);
	else if (controls.LEFT_R)
		arrows.members[0].alpha = 0.5;
	else if (controls.LEFT_P && curSelection == 0) {
		CoolUtil.playMenuSFX(2, 0.7);
		arrows.members[0].alpha = 1;
	}

	if (controls.RIGHT_P && curSelection != weekOrder.length-1)
		changeItem(curSelection + 1, 1);
	else if (controls.RIGHT_R)
		arrows.members[1].alpha = 0.5;
	else if (controls.RIGHT_P && curSelection == weekOrder.length-1) {
		CoolUtil.playMenuSFX(2, 0.7);
		arrows.members[1].alpha = 1;
	}

	if (controls.ACCEPT && canSelect) {
		if (hasSongs) {
			CoolUtil.playMenuSFX(1, 0.7);

			var convertedData = {
				name: weekData.name,
				id: '',
				sprite: '',
				chars: [],
				songs: [],
				difficulties: [weekData.difficulty]
			};
			
			var cutData = {
			nextState: new PlayState(),
			week: convertedData,
			difficulty: weekData.difficulty,
			videoPath: Paths.video("cutscenes/cutscene1")
		};
			
			for (song in weekData.songs)
				convertedData.songs.push({
					name: song,
					hide: false
				});

			FlxTween.tween(FlxG.camera, {zoom: 2.2}, 1.5, {ease: FlxEase.expoInOut});
			FlxTween.tween(camera.scroll, {x: 160, y: 0}, 1.5, {ease: FlxEase.expoInOut});

			PlayState.loadWeek(convertedData, weekData.difficulty);
			new FlxTimer().start(1, function() {
			if(weekData.difficulty == 'TOM')
			{
			FlxG.switchState(new ModState("WB/VideoHandler", cutData));
			}
			else
			{
			FlxG.switchState(new PlayState());
			}
			});
			canSelect = false;
		} else {
			CoolUtil.playMenuSFX(2, 0.7);
			showNoSongsMessage();
		}
	} else if (controls.ACCEPT && !canSelect) {
		FlxG.camera.stopFX();
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		var cutData = {
			nextState: new PlayState(),
			week: convertedData,
			difficulty: weekData.difficulty,
			videoPath: Paths.video("cutscenes/cutscene1")
		};
		if(weekData.difficulty == 'TOM')
			{
			FlxG.switchState(new ModState("WB/VideoHandler", cutData));
			}
			else
			{
			FlxG.switchState(new PlayState());
			}
	}
}
