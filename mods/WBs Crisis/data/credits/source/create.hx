import openfl.display.BitmapData;
import flixel.addons.display.FlxBackdrop;
import openfl.display.Shape;

public var bg:FunkinSprite;
public var topItem:FlxSprite;
public var panels:FlxGroup;
public var arrows:FlxGroup;
public var topTitle:FlxText;
public var introGroup:FlxSpriteGroup;
public var creditIcon:FlxSprite;

public var introTxts:Map<String, FlxText> = new StringMap();

function create() {
	bg = createLgBackdrop(0xFF8AAFDE);
	add(bg);
	
	topItem = new FlxSprite().loadGraphic(imagePath("panel/topItem"));
	topItem.scale.set(1.5, 1.5);
	topItem.updateHitbox();
	
	topItem.cameras = [camCredit];
	topItem.antialiasing = true;
	topItem.screenCenter(FlxAxes.X);
	topItem.visible = false;
	add(topItem);
	
	panels = new FlxGroup(3);
	panels.cameras = [camCredit];
	createPanelsFW(panels);
	add(panels);
	
	topTitle = new FlxText(topItem.x, topItem.y + 25, topItem.width, "制作名单（????）", 16);
	topTitle.antialiasing = true;
	topTitle.setFormat(fontPath("vcr.TTF"), 38, 0xFF000000, "center");
	topTitle.cameras = [camCredit];
	topTitle.visible = false;
	add(topTitle);
	
	arrows = new FlxGroup(2);
	arrows.cameras = [camCredit];
	createArrowFW(arrows);
	add(arrows);
	
	introGroup = new FlxSpriteGroup();
	introGroup.cameras = [camCredit];
	createIntroFW(introGroup);
	introGroup.setPosition(150, 150);
	introGroup.visible = false;
	add(introGroup);
	
	creditIcon = new FlxSprite(800, 125);
	creditIcon.antialiasing = true;
	creditIcon.cameras = [camCredit];
	creditIcon.visible = false;
	add(creditIcon);
}

function createPanelsFW(group:FlxGroup) {
	for(i in 0...group.maxSize) {
		var panel = new FlxSprite().loadGraphic(imagePath("panel/panelItem"));
		panel.scale.set(1.5, 1.4);
		if(i == 0 || i == 2) {
			panel.scale.set(panel.scale.x * 0.75, panel.scale.y * 0.75);
			panel.alpha = 0;
		}

		panel.antialiasing = true;
		panel.ID = i;
		panel.screenCenter(FlxAxes.X);
		panel.x += (i - 1) * FlxG.width;
		panel.y = (FlxG.height - panel.height) / 1.35;
		panel.visible = false;
		group.add(panel);
	}
}

function createArrowFW(group:FlxGroup) {
	for(i in 0...group.maxSize) {
		var arrow = new FlxSprite().loadGraphic(imagePath("panel/arrow"));
		arrow.setPosition((i % 2 == 1 ? topItem.x + topItem.width + 10 : topItem.x - arrow.width - 10), topItem.y + 12);
		
		arrow.antialiasing = true;
		arrow.ID = i;
		arrow.flipX = (i % 2 == 1 ? true : false);
		arrow.visible = false;
		group.add(arrow);
	}
}

function createIntroFW(group:FlxSpriteGroup) {
	var nameTxt = createIntroText("·名字：未知", panels.members[1].width * panels.members[1].scale.x / 2, 34);
	introTxts.set("name", nameTxt);
	group.add(nameTxt);
	var enameTxt = createIntroText("·英文名：未知", panels.members[1].width * panels.members[1].scale.x / 2, 34);
	introTxts.set("englishName", enameTxt);
	group.add(enameTxt);
	var jobTxt = createIntroText("·职业：未知", panels.members[1].width * panels.members[1].scale.x / 2, 34);
	group.add(jobTxt);
	introTxts.set("job", jobTxt);
	var conTxt = createIntroText("·贡献：【无】", panels.members[1].width * panels.members[1].scale.x * 3/4, 24);
	group.add(conTxt);
	introTxts.set("contribute", conTxt);
	var hpTxt = createIntroText("·个人主页：【无】", panels.members[1].width * panels.members[1].scale.x * 4/5, 24);
	group.add(hpTxt);
	introTxts.set("homePage", hpTxt);
	var exTxt = createIntroText("·想说的话：【无】", panels.members[1].width * panels.members[1].scale.x * 4/5, 24);
	group.add(exTxt);
	introTxts.set("exchange", exTxt);
	
	for(i=>k in group.members) {
		k.ID = i;
		
		k.y = (group.members[i - 1] != null ? group.members[i - 1].y + group.members[i - 1].fieldHeight + 10 : 0);
		if(i == 3) {
			k.y += 15;
		}
	}
}

function createIntroText(text:String, width:Float, size:Int) {
	var newText = new FlxText(0, 0, width, text);
	newText.setFormat(fontPath("vcr.TTF"), size, 0xFF000000, "left");
	newText.autoSize = true;
	return newText;
}

public function createLgBackdrop(color:Int = 0xFFFFFFFF) {
	var bitmapData = new BitmapData(128, 128, true, 0x00000000);
	var drawShape = new Shape();
		
	var choose = [{x: 0, y: 0, color: color}, {x: Std.int(bitmapData.width / 2), y: 0, color: 0xFFFFFFFF}, {x: 0, y: Std.int(bitmapData.height / 2), color: 0xFFFFFFFF}, {x: Std.int(bitmapData.width / 2), y: Std.int(bitmapData.height / 2), color: color}];
	for(ch in choose) {
		drawShape.graphics.beginFill(ch.color);
		drawShape.graphics.drawRect(ch.x, ch.y, Std.int(bitmapData.width / 2), Std.int(bitmapData.height / 2));
		drawShape.graphics.endFill();
	}
	bitmapData.draw(drawShape);
	
	var backdrop = new FlxBackdrop(bitmapData);
	return backdrop;
}