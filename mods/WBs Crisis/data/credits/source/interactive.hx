public var recordPanelsOriginPosition:Array<Dynamic> = [];

function update(elapsed:Float) {
	if(canSelected) {
		if(#if !android controls.BACK #else FlxG.android.justReleased.BACK #end) {
			MusicBeatState.skipTransOut = false;
			FlxTween.tween(camCredit, {zoom: 0, alpha: 0}, 0.5, {ease: FlxEase.backIn, onComplete: () -> FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {onComplete: (_) -> FlxG.switchState(new CreditsMain())})});
			
			canSelected = false;
		}
		
		if(introTxts.get("homePage") != null && introTxts.get("homePage").visible && FlxG.mouse.justPressed && StringTools.contains(introTxts.get("homePage").text, "http")) {
			var pos = FlxG.mouse.getScreenPosition(introTxts.get("homePage").cameras[0], FlxPoint.get());
			pos.x -= introTxts.get("homePage").x;
			pos.y -= introTxts.get("homePage").y;
		
			var index = introTxts.get("homePage").textField.getCharIndexAtPoint(pos.x, pos.y);
			if(Reflect.hasField(stuffixData[curLoop - 1], "homePage")) {
				for(n=>u in stuffixData[curLoop - 1].homePage) {
					if(index >= introTxts.get("homePage").text.indexOf(u) && index <= introTxts.get("homePage").text.indexOf(u) + u.length) {
						CoolUtil.openURL(u);
					}
				}
			}
			
			pos.put();
		}
		
		if(controls.LEFT_P) changeSelection(-1);
		else if(controls.RIGHT_P) changeSelection(1);
	}
	
	bg.setPosition(bg.x - elapsed * 50, bg.y - elapsed * 50);
	
	setClipTo();
}

public function changeSelection(change:Int, origin:Bool = false) {
	curLoop += change;
	
	if(curLoop > maxLoop) {
		curLoop = maxLoop;
		return;
	}else if(curLoop < 1) {
		curLoop = 1;
		return;
	}
	
	arrows.members[0].visible = true;
	arrows.members[1].visible = true;
	
	if(curLoop == 1)
		arrows.members[0].visible = false;
	if(curLoop == maxLoop)
		arrows.members[1].visible = false;
	
	var data = stuffixData[curLoop - 1];

	var prevChange = change;
	if(!origin) {
		canSelected = false;
		if(prevChange > 0) {
			panels.members[0].ID = (panels.members[0].ID != 0 ? Math.abs(panels.members[0].ID - prevChange) % 3 : 2);
			panels.members[1].ID = (panels.members[1].ID != 0 ? Math.abs(panels.members[1].ID - prevChange) % 3 : 2);
			panels.members[2].ID = (panels.members[2].ID != 0 ? Math.abs(panels.members[2].ID - prevChange) % 3 : 2);
		}else if(prevChange < 0) {
			panels.members[0].ID = Math.abs(panels.members[0].ID - prevChange) % 3;
			panels.members[1].ID = Math.abs(panels.members[1].ID - prevChange) % 3;
			panels.members[2].ID = Math.abs(panels.members[2].ID - prevChange) % 3;
		}
		
		var defIntroPos = [];
		var defCIPos = {x: creditIcon.x, y: creditIcon.y};
		var defTTPos = {x: topTitle.x, y: topTitle.y};
		
		for(txt in introGroup.members) {
			defIntroPos.push({x: txt.x, y: txt.y});

			FlxTween.tween(txt, {x: -txt.width}, 0.2, {ease: FlxEase.quadInOut});
		}
		FlxTween.tween(creditIcon, {x: FlxG.width + creditIcon.width * 3}, 0.2, {ease: FlxEase.quadInOut});
		FlxTween.tween(topTitle, {y: -topTitle.height}, 0.2, {ease: FlxEase.quadInOut});
		
		new FlxTimer().start(0.2, (tmr) -> {
			topTitle.text = "制作名单（" + displayStuffixList[curLoop - 1] + "）";
	
			setCreditIcon();
	
			introGroup.forEach((txt) -> {
				txt.visible = true;
				txt.y = 150;
	
				switch(txt.ID) {
					case 0:
						if(Reflect.hasField(data, "name")) txt.text = "·名字：" + data.name;
						else {
							txt.visible = false;
							txt.y = 0;
						}
					case 1:
						if(Reflect.hasField(data, "englishName")) txt.text = "·英文名：" + data.englishName;
						else {
							txt.visible = false;
							txt.y = 0;
						}
					case 2:
						if(Reflect.hasField(data, "career")) txt.text = "·职业：" + data.career;
						else {
							txt.visible = false;
							txt.y = 0;
						}
					case 3:
						if(Reflect.hasField(data, "contribute")) {
							if(data.contribute.length > 0) {
								txt.text = "·贡献：【";
								for(con in data.contribute) {
									txt.text += con;
									if(data.contribute.indexOf(con) < data.contribute.length - 1) {
										txt.text += "，";
									}
								}
								txt.text += "】";
							}
						}
						else {
							txt.visible = false;
							txt.y = 0;
						}
					case 4:
						txt.clearFormats();
						if(Reflect.hasField(data, "homePage")) {
							txt.text = "·主页： |";
							for(n=>u in data.homePage) {
								txt.text += "\n    ·" + n + ": " + u;
								txt.addFormat(new FlxTextFormat(0xFF007DAF, false, false, 0xFFFFFFFF, true), txt.text.indexOf(u), txt.text.indexOf(u) + u.length);
							}
						}
						else txt.visible = false;
					case 5:
						if(Reflect.hasField(data, "exchange")) {
							if(data.exchange.length > 0) {
								txt.text = "·想说的话：|";
								for(con in data.exchange) {
									txt.text += "\n   " + con;
								}
							}
						}else {
							txt.visible = false;
							txt.y = 0;
						}
				}
			});
	
			updateTxtPos();
			
			panels.forEach((obj) -> {
				if(prevChange < 0) {
					if(obj.ID == 0) {
						obj.setPosition(recordPanelsOriginPosition[obj.ID].x, recordPanelsOriginPosition[obj.ID].y);
						obj.alpha = recordPanelsOriginPosition[obj.ID.alpha];
						obj.scale.set(recordPanelsOriginPosition[obj.ID].scale.x, recordPanelsOriginPosition[obj.ID].scale.y);
					}else {
						FlxTween.tween(obj, {x: recordPanelsOriginPosition[obj.ID].x, y: recordPanelsOriginPosition[obj.ID].y, alpha: recordPanelsOriginPosition[obj.ID].alpha}, 0.2, {ease: FlxEase.quadIn});
						FlxTween.tween(obj.scale, {x: recordPanelsOriginPosition[obj.ID].scale.x, y: recordPanelsOriginPosition[obj.ID].scale.y}, 0.2, {ease: FlxEase.quadIn});
					}
				}else if(prevChange > 0) {
					if(obj.ID == 2) {
						obj.setPosition(recordPanelsOriginPosition[obj.ID].x, recordPanelsOriginPosition[obj.ID].y);
						obj.alpha = recordPanelsOriginPosition[obj.ID.alpha];
						obj.scale.set(recordPanelsOriginPosition[obj.ID].scale.x, recordPanelsOriginPosition[obj.ID].scale.y);
					}else {
						FlxTween.tween(obj, {x: recordPanelsOriginPosition[obj.ID].x, y: recordPanelsOriginPosition[obj.ID].y, alpha: recordPanelsOriginPosition[obj.ID].alpha}, 0.2, {ease: FlxEase.quadIn});
						FlxTween.tween(obj.scale, {x: recordPanelsOriginPosition[obj.ID].scale.x, y: recordPanelsOriginPosition[obj.ID].scale.y}, 0.2, {ease: FlxEase.quadIn});
					}
				}
				
				var preObj = obj;
				FlxTween.color(obj, 0.2, obj.color, (Reflect.hasField(data, "color") && data.color != null ? data.color : 0xFFFFFFFF), {onComplete: (_) -> {
					if(panels.members.indexOf(preObj) == panels.members.length - 1) {
						for(i=>txt in introGroup.members) {
							txt.clipRect = null;
							FlxTween.tween(txt, {x: defIntroPos[i].x}, 0.2, {ease: FlxEase.quadInOut});
						}
						FlxTween.tween(topTitle, {y: defTTPos.y}, 0.2, {ease: FlxEase.quadInOut});
						FlxTween.tween(creditIcon, {x: defCIPos.x}, 0.2, {ease: FlxEase.quadInOut, onComplete: (_) -> canSelected = true});
					}
				}});
			
			});
		
			FlxTween.color(bg, 0.2, bg.color, (Reflect.hasField(data, "color") && data.color != null ? data.color : 0xFFFFFFFF));
			FlxTween.color(topItem, 0.2, topItem.color, (Reflect.hasField(data, "color") && data.color != null ? data.color : 0xFFFFFFFF));
		});
	}else {
		topTitle.text = "制作名单（" + displayStuffixList[curLoop - 1] + "）";
	
		setCreditIcon();
	
		introGroup.forEach((txt) -> {
			txt.visible = true;
			txt.y = 150;
	
			switch(txt.ID) {
				case 0:
					if(Reflect.hasField(data, "name")) txt.text = "·名字：" + data.name;
					else {
						txt.visible = false;
						txt.y = 0;
					}
				case 1:
					if(Reflect.hasField(data, "englishName")) txt.text = "·英文名：" + data.englishName;
					else {
						txt.visible = false;
						txt.y = 0;
					}
				case 2:
					if(Reflect.hasField(data, "career")) txt.text = "·职业：" + data.career;
					else {
						txt.visible = false;
						txt.y = 0;
					}
				case 3:
					if(Reflect.hasField(data, "contribute")) {
						if(data.contribute.length > 0) {
							txt.text = "·贡献：【";
							for(con in data.contribute) {
								txt.text += con;
								if(data.contribute.indexOf(con) < data.contribute.length - 1) {
									txt.text += "，";
								}
							}
							txt.text += "】";
						}
					}
					else {
						txt.visible = false;
						txt.y = 0;
					}
				case 4:
					txt.clearFormats();
					if(Reflect.hasField(data, "homePage")) {
						txt.text = "·主页： |";
						for(n=>u in data.homePage) {
							txt.text += "\n    ·" + n + ": " + u;
							txt.addFormat(new FlxTextFormat(0xFF007DAF, false, false, 0xFFFFFFFF, true), txt.text.indexOf(u), txt.text.indexOf(u) + u.length);
						}
					}
					else txt.visible = false;
				case 5:
					if(Reflect.hasField(data, "exchange")) {
						if(data.exchange.length > 0) {
							txt.text = "·想说的话：|";
							for(con in data.exchange) {
								txt.text += "\n   " + con;
							}
						}
					}else {
						txt.visible = false;
						txt.y = 0;
					}
			}
		});
	
		updateTxtPos();
	
		panels.forEach((obj) -> {
			recordPanelsOriginPosition.push({x: obj.x, y: obj.y, alpha: obj.alpha, scale: {x: obj.scale.x, y: obj.scale.y}});
			
			obj.color = (Reflect.hasField(data, "color") && data.color != null ? data.color : 0xFFFFFFFF);
		});
		
		bg.color = (Reflect.hasField(data, "color") && data.color != null ? data.color : 0xFFFFFFFF);
		topItem.color = (Reflect.hasField(data, "color") && data.color != null ? data.color : 0xFFFFFFFF);
	}
}

function updateTxtPos() {
	var ky = -1;
	
	for(txt in introGroup) {
		var oldTxt = introGroup.members[introGroup.members.indexOf(txt) - 1];
		if(oldTxt != null) {
			var jiaY:Float = 0;
			var olderTxt = oldTxt;
			
			while(olderTxt != null) {
				if(olderTxt.visible) {
					jiaY += olderTxt.fieldHeight + 12.5;
				}
				
				olderTxt = introGroup.members[introGroup.members.indexOf(olderTxt) - 1];
			}
			
			if(txt == introTxts.get("contribute") || txt == introTxts.get("homePage") || txt == introTxts.get("exchange")) jiaY += 75;
			
			txt.y += jiaY;
		}
	}
}

function setClipTo() {
	if(!loaded) return false;

	introGroup.forEach((txt) -> {
		if(txt.x - 95 < 0) {
			txt.clipRect = new FlxRect(FlxMath.bound(Math.abs(txt.x - 95), 0, txt.width), 0, txt.width, txt.height);
		}else txt.clipRect = null;
	});
	if(creditIcon.x - 950 > 0) {
		creditIcon.clipRect = new FlxRect(0, 0, FlxMath.bound(creditIcon.width - (creditIcon.x - 950), 0, creditIcon.width), creditIcon.height);
	}else creditIcon.clipRect = null;
	
	if(topTitle.y - 10 < 0) {
		topTitle.clipRect = new FlxRect(FlxMath.bound(0, Math.abs(topTitle.y - 10), 0, topTitle.height), topTitle.width, topTitle.height);
	}else topTitle.clipRect = null;
}

function setCreditIcon() {
	var graphic = graphicCache.cachedGraphics[curLoop - 1];
	if(graphic == null) {
		creditIcon.visible = false;
		return;
	}
	creditIcon.visible = true;

	creditIcon.loadGraphic(graphic);
	creditIcon.setGraphicSize(200, 200);
	creditIcon.updateHitbox();
}