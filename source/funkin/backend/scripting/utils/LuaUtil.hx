package funkin.backend.scripting.utils;

#if ALLOW_LUASTATE
import funkin.backend.scripting.LuaScript;

class LuaUtil {
	public inline static final Function_Stop:Int = 0;
	public inline static final Function_Continue:Int = 1;
	
	public static function reflectFunction(lua:LuaScript) {
		lua.set("getProperty", function(tag:String) {
			if(lua.scriptObject != null) {
				return getVariableFromStr(lua.scriptObject, tag, lua, "getProperty");
			}else {
				error('ScriptObject Was Null, So You Can\'t Use This Callback', "getProperty", lua);
			}
			
			return null;
		});
		
		lua.set("setProperty", function(tag:String, val:Dynamic) {
			if(lua.scriptObject != null) {
				return setVariableFromStr(lua.scriptObject, tag, val, lua, "setProperty");
			}else {
				error('ScriptObject Was Null, So You Can\'t Use This Callback', "setProperty", lua);
			}
			
			return false;
		});
	}
	
	public static function getVariableFromStr(scriptObject:Dynamic, variable:String, lua:LuaScript, title:String):Dynamic {
		if(scriptObject == null) {
		}

		var fuckyou = variable.split(".");
	
		if(fuckyou.length > 1) {
			var oldVar:Dynamic = scriptObject;
			for(shit=>fuck in fuckyou) {
				if(StringTools.contains(fuck, "[") && StringTools.contains(fuck, "]")) {
					var realShit = fuck.substr(0, fuck.indexOf("["));
					var preField = Reflect.getProperty(oldVar, realShit);
					if(!Std.isOfType(preField, Array)) {
						error('Expected "$realShit"!! Currently Only Supports Array In This Callback', title, lua);
						return null;
					}

					var preInt = fuck.substring(fuck.indexOf("[") + 1, fuck.indexOf("]"));
					oldVar = preField[Std.parseInt(preInt)];
					continue;
				}
		
				oldVar = Reflect.getProperty(oldVar, fuck);
			}
			return oldVar;
		}else if(fuckyou.length == 1) {
			var originFuck = fuckyou[0];
			if(StringTools.contains(originFuck, "[") && StringTools.contains(originFuck, "]")) {
				var preField = Reflect.getProperty(scriptObject, originFuck.substr(0, originFuck.indexOf("[")));
				if(!Std.isOfType(preField, Array)) return null;

				var preInt = originFuck.substring(originFuck.indexOf("[") + 1, originFuck.indexOf("]"));

				return preField[Std.parseInt(preInt)];
			}
		
			return Reflect.getProperty(scriptObject, originFuck);
		}
	
		return null;
	}

	public static function setVariableFromStr(scriptObject:Dynamic, variable:String, value:Dynamic, lua:LuaScript, title:String):Bool {
		if(scriptObject == null) {
			error('ScriptObject Was Null, So You Can\'t Use This Callback', title, lua);
			return false;
		}

		var fuckyou = variable.split(".");
	
		if(fuckyou.length > 1) {
			var preVar:Dynamic = null;
			var oldVar:Dynamic = scriptObject;
			for(shit=>fuck in fuckyou) {
				if(shit < fuckyou.length - 1) {
					if(StringTools.contains(fuck, "[") && StringTools.contains(fuck, "]")) {
						var realShit = fuck.substr(0, fuck.indexOf("["));
						var preField = Reflect.getProperty(oldVar, realShit);
						if(!Std.isOfType(preField, Array)) {
						error('Expected "$realShit"!! Currently Only Supports Array In This Callback', title, lua);
							return false;
						}

						var preInt = fuck.substring(fuck.indexOf("[") + 1, fuck.indexOf("]"));
					
						oldVar = preField[Std.parseInt(preInt)];
						continue;
					}
			
					oldVar = Reflect.getProperty(oldVar, fuck);
				}else {
					if(oldVar != null) {
						try {
							if((StringTools.contains(fuck, "[") && StringTools.contains(fuck, "]"))) {
								error('The final value cannot be Array', title, lua);
								return false;
							}else {
								Reflect.setProperty(oldVar, fuck, value);
								return true;
							}
						} catch(e) {
							error('Expected "$fuck" In This Callback', title, lua);
							return false;
						}
					}else error('Expected "$fuck" In This Callback', title, lua);
				}
			}
		}else if(fuckyou.length == 1) {
			var originFuck = fuckyou[0];
			if(StringTools.contains(originFuck, "[") && StringTools.contains(originFuck, "]")) {
				error('The final value cannot be Array', title, lua);
				return false;
			}
			
			try {
				Reflect.setProperty(scriptObject, originFuck, value);
				return true;
			} catch(e) {
				error('Expected "$originFuck" In This Callback', title, lua);
				return false;
			}
		}
	
		return false;
	}
	
	private static function error(text:String, title:String, lua:LuaScript) {
		lua.error('Null Pointer($title): $text');
	}
}
#end