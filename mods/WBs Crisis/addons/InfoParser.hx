/**
 * 用于读取并解析歌曲信息，并储存到expr里面（很水就是了
 */
class InfoParser {
	public var content:String;
	public var expr:Dynamic;

	public function new(content:String) {
		this.content = content;
		
		parseString(content);
	}
	
	public function parseString(c:String):Dynamic {
		var ca:Array<String> = c.split("\n");
		
		if(ca.length > 0) {
			//不太确定i=>v能否在class结构体起作用
			var keyGroup:Array<String> = [];
			var valueGroup:Array<Dynamic> = [];
			
			var duohang:Bool = false;
		
			for(st in ca) {
				var i = -1;
				
				while(i < st.length - 1) {
					i ++;
					
					var char:String = st.charAt(i);
					
					if(char == "`") {
						if(st.charAt(i + 1) == "`" && st.charAt(i + 2) == "`") {
							break;
						}
						
						Application.current.window.alert("未知格式！", "错误");
						
						break;
					}
					
					if(isLetter(char)) {
						var existMao:Bool = false;
						var startColor:Bool = existMao;
					
						var preKey:String = char;
						var preValue:String;
						var preIndex:Int = 0;
					
						while(true) {
							preIndex ++;
							var abab = st.charAt(preIndex + i);
							
							if(isSpace(abab)) {
								continue;
							}
							
							if(isLetter(abab) || isMath(abab))
								if(!existMao)
									preKey += abab;
								else {
									if(!startColor) {
										if(preValue == null)
											preValue = abab;
										else preValue += abab;
									}else {
										if(preValue == null || !StringTools.startsWith(preValue, "0xFF"))
											preValue = "0xFF";
										
										if(preValue.length < 10)
											preValue += abab.toUpperCase();
									}
								}
							else if(abab == "[") {
								if(existMao && st.charAt(preIndex + i + 1) == "[") {
									duohang = true;
									
									var shenyu = st.substr(preIndex + i + 2).split("");
									if(shenyu.length > 0)
										for(sy in shenyu) {
											preValue += sy;
										}
									
									break;
								}
							}
							else if(abab == "#") {
								if(existMao) {
									startColor = true;
								}
							}
							else if(abab == "_") {
								if(existMao) {
									preValue += " ";
								}
							}else if(abab == ":") {
								existMao = true;
							}else if(abab == null || abab == "") {
								if(existMao) {
									if(preKey != null)
										keyGroup.push(preKey);
									
									if(preValue != null)
										valueGroup.push(preValue);
								}
								
								break;
							}
						}
						
						if(duohang) {
							for(content in ca.indexOf(st)...ca.length - 1) {
								if(!StringTools.contains(ca[content], "]]")) {
									preValue += ca[content] + "\n";
								}else {
									var ing:Int = ca[content].indexOf("]]");
									if(ing > 0) {
										preValue += ca[content].substring(0, ing - 1);
									}else {
										if(StringTools.endsWith(preValue, "\n")) {
											preValue = preValue.substring(0, preValue.length - 2);
										}
									}
									
									valueGroup.push(preValue);
									
									break;
								}
							}
							
							duohang = false;
							continue;
						}
						
						if(!duohang) {
							break;
						}
					}
				}
			}
			
			if(keyGroup.length > 0)
				for(key in keyGroup) {
					if(expr == null)
						expr = {};
					
					if(StringTools.startsWith(valueGroup[keyGroup.indexOf(key)], "0xFF")) {
						valueGroup[keyGroup.indexOf(key)] = FlxColor.fromString(valueGroup[keyGroup.indexOf(key)]);
					}
				
					Reflect.setField(expr, key, valueGroup[keyGroup.indexOf(key)]);
				}
		}else {
			expr = {};
			return expr;
		}
	}
	
	public function isNotMandatoryChar(char:String):Bool
		return (!isSpace(char) && !isMath(char) && !isLetter(char) && char != "");
	
	public function isSpace(char:String):Bool
		return char == " ";
	
	public function isMath(char:String):Bool 
		return "0123456789".split("").contains(char);
	
	public function isLetter(char:String, ?big:Bool):Bool {
		var letterList:String = "abcdefghijklmnopqrstuvwxyz";
	
		return (big == null ? (letterList.split("").contains(char) || letterList.toUpperCase().split("").contains(char)) : (big ? letterList.toUpperCase().split("").contains(char) : letterList.split("").contains(char)));
	}
}