public function parseCreditsFromDirectory(name:String) {
	if(!Assets.exists(xmlPath("stuffix/" + name + "/info"))) return null;
	
	return parseCreditsFromXML(Assets.getText(xmlPath("stuffix/" + name + "/info")));
}

public function parseCreditsFromXML(text:String) {
	var data:Dynamic = {};
	
	var xml = Xml.parse(text);
	var fx = xml.firstElement();
	
	if(fx.exists("name")) Reflect.setField(data, "name", fx.get("name"));
	if(fx.exists("englishName")) Reflect.setField(data, "englishName", fx.get("englishName"));
	if(fx.exists("color")) Reflect.setField(data, "color", FlxColor.fromString(fx.get("color")));
	if(fx.exists("career")) Reflect.setField(data, "career", fx.get("career"));
	if(fx.exists("maskIcon")) Reflect.setField(data, "maskIcon", fx.get("maskIcon") == "true");
	
	for(cx in fx.elements()) {
		switch(cx.nodeName) {
			case "homePage":
				Reflect.setField(data, "homePage", new StringMap());
				for(cox in cx.elements()) {
					if(cox.exists("name") && cox.exists("url")) data.homePage.set(cox.get("name"), cox.get("url"));
				}
			case "contribute":
				if(!Reflect.hasField(data, "contribute")) Reflect.setField(data, "contribute", []);
				
				data.contribute.push(cx.children[0]);
			case "exchange":
				if(!Reflect.hasField(data, "exchange")) Reflect.setField(data, "exchange", []);
				
				data.exchange.push(cx.children[0]);
			default: {}
		}
	}

	return data;
}