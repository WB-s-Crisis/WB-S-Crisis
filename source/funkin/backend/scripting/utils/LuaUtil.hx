package funkin.backend.scripting.utils;

#if ALLOW_LUASTATE
import Type.ValueType;
import funkin.backend.scripting.LuaScript;

class LuaUtil {
	public inline static final Function_Stop:Int = 0;
	public inline static final Function_Continue:Int = 1;
	
	public static function reflectFunction(lua:LuaScript) {
		/**
		 * 获取此lua脚本的`scriptObject`中的变量值
		 * @param tag 选定变量
		 * @return 返回其变量值
		 */
		lua.set("getProperty", function(tag:String) {
			if(lua.scriptObject != null) {
				return getVariableFromStr(lua.scriptObject, tag, lua, "getProperty");
			}else {
				error('ScriptObject Was Null, So You Can\'t Use This Callback', "getProperty", lua);
			}
			
			return null;
		});
		
		/**
		 * 设置此脚本的`scriptObject`中选定变量的值
		 * @param tag 选定变量
		 * @param val 设置其变量的值
		 * @return 如果此回调运行正常，将会返回true，否则为false
		 */
		lua.set("setProperty", function(tag:String, val:Dynamic) {
			if(lua.scriptObject != null) {
				return setVariableFromStr(lua.scriptObject, tag, val, lua, "setProperty");
			}else {
				error('ScriptObject Was Null, So You Can\'t Use This Callback', "setProperty", lua);
			}
			
			return false;
		});
		
		/**
		 * 设置选定的类`Class`的静态变量的值
		 * @param cl 所选定的类
		 * @param tag 所选定其类中的静态变量
		 * @return 如果此回调运行正常，将会返回true，否则为false
		 */
		lua.set("setPropertyFromClass", function(cl:String, tag:String, val:Dynamic) {
			var cls:Class<Dynamic> = Type.resolveClass(cl);
			if(cls == null) {
				error('Not Found Class: $cl', "setPropertyFromClass", lua);
				return false;
			}
			
			return setVariableFromStr(cls, tag, val, lua, "setPropertyFromClass");
		});
		
		/**
		 * 获取选定的类`Class`的静态变量的值
		 * @param cl 所选定的类
		 * @param tag 所选定其类中的静态变量
		 * @return 将返回其类的静态变量的值
		 */
		lua.set("getPropertyFromClass", function(cl:String, tag:String) {
			var cls:Class<Dynamic> = Type.resolveClass(cl);
			if(cls == null) {
				error('Not Found Class: $cl', "getPropertyFromClass", lua);
				return null;
			}
			
			return getVariableFromStr(cls, tag, lua, "getPropertyFromClass");
		});
		
		/**
		 * 获取lua脚本中`scriptObject`中选定为`FlxGroup`或者`Array`类型的变量的变量值
		 * @param group 所选定的`FlxGroup`类型或者`Array`的变量
		 * @param index ......懒得说
		 * @param variable 其变量值
		 * @return 返回其所选的变量的值
		 */
		lua.set("getPropertyFromGroup", function(group:String, index:Int, variable:String) {
			if(lua.scriptObject == null) {
				error('ScriptObject Was Null, So You Can\'t Use This Callback', "getPropertyFromGroup", lua);
				return null;
			}
			
			var grp:Dynamic = getVariableFromStr(lua.scriptObject, group, lua, "getPropertyFromGroup");
			if(grp == null) {
				error('The Variable "$group" Was Null', "getPropertyFromGroup", lua);
				return null;
			}
			return (switch(Type.typeof(grp)) {
				case TClass(cls):
					if(cls == Array) {
						getVariableFromStr(grp[index], variable, lua, "getPropertyFromGroup");
					} else {
						if(Type.getInstanceFields(cls).contains("members") && (Reflect.getProperty(grp, "members") is Array)) {
							getVariableFromStr(grp.members[index], variable, lua, "getPropertyFromGroup");
						}else {
							error('The Variable "$group" Not Belonging To FlxGroup Or Array', "getPropertyFromGroup", lua);
							null;
						}
					}
				default:
					error('The Variable "$group" Not Belonging To FlxGroup Or Array', "getPropertyFromGroup", lua);
					null;
			});
		});
		
		/**
		 * 设置lua脚本中`scriptObject`中选定为`FlxGroup`或者`Array`类型的变量的变量值
		 * @param group 所选定的`FlxGroup`类型或者`Array`的变量
		 * @param index ......懒得说
		 * @param variable 其变量值
		 * @return 如果回调正常，将返回true，否则为false
		 */
		lua.set("setPropertyFromGroup", function(group:String, index:Int, variable:String, value:Dynamic) {
			if(lua.scriptObject == null) {
				error('ScriptObject Was Null, So You Can\'t Use This Callback', "setPropertyFromGroup", lua);
				return false;
			}
			
			var grp:Dynamic = getVariableFromStr(lua.scriptObject, group, lua, "setPropertyFromGroup");
			if(grp == null) {
				error('The Variable "$group" Was Null', "setPropertyFromGroup", lua);
				return false;
			}
			
			switch(Type.typeof(grp)) {
				case TClass(cls):
					if(cls == Array) {
						return setVariableFromStr(grp[index], variable, value, lua, "setPropertyFromGroup");
					} else {
						if(Type.getInstanceFields(cls).contains("members") && (Reflect.getProperty(grp, "members") is Array)) {
							return setVariableFromStr(grp.members[index], variable, value, lua, "setPropertyFromGroup");
						}else {
							error('The Variable "$group" Not Belonging To FlxGroup Or Array', "setPropertyFromGroup", lua);
							return false;
						}
					}
				default:
					error('The Variable "$group" Not Belonging To FlxGroup Or Array', "setPropertyFromGroup", lua);
					return false;
			}
		});
		
		/**
		 * 回调
		 * @param func 选定的函数
		 * @paran args 选定的参数组
		 * @return 如果其函数拥有返回值，将会返回其值（否则为null）
		 */
		lua.set("callMethod", function(func:String, ?args:Array<Dynamic>) {
			if(lua.scriptObject == null) {
				error('ScriptObject Was Null, So You Can\'t Use This Callback', "callMethod", lua);
				return null;
			}
			
			var fs:Dynamic = getVariableFromStr(lua.scriptObject, func, lua, "callMethod");
			if(fs == null) {
				error('The Variable "$func" Was Null', "callMethod", lua);
				return null;
			}
			if(Reflect.isFunction(fs)) {
				try {
					return Reflect.callMethod(null, fs, (args == null ? [] : args));
				} catch(e:Dynamic) {
					error('Expected variable "$func" In This Callback', "callMethod", lua);
				}
			}else {
				error('The Variable "$func" Was Not Function!', "callMethod", lua);
			}
			
			return null;
		});
		
		/**
		 * 选定类`Class`中的静态函数
		 * @param cl 选定的类
		 * @param func 选定其类中的静态函数
		 * @args 参数
		 * @return 你知道的，我懒得说
		 */
		lua.set("callMethodFromClass", function(cl:String, func:String, ?args:Array<Dynamic>) {
			var cls:Class<Dynamic> = Type.resolveClass(cl);
			if(cls == null) {
				error('Not Found Class "$cl"', "callMethodFromClass", lua);
				return null;
			}
			
			var fs:Dynamic = getVariableFromStr(cls, func, lua, "callMethodFromClass");
			if(fs == null) {
				error('The Variable "$func" Was Null', "callMethodFromClass", lua);
				return null;
			}
			if(Reflect.isFunction(fs)) {
				try {
					return Reflect.callMethod(null, fs, (args == null ? [] : args));
				} catch(e:Dynamic) {
					error('Expected variable "$func" In This Callback', "callMethodFromClass", lua);
				}
			}else {
				error('The Variable "$func" Was Not Function!', "callMethodFromClass", lua);
			}
			
			return null;
		})
	}
	
	public static function hscriptFunction(lua:LuaScript, allowHScript:Bool = true) {
		lua.set("addHaxeLibrary", function(className:String, ?packageName:String) {
			return false;
		});
		
		lua.set("runHaxeCode", function(code:String) {
			return null;
		});
	}
	
	public static function getVariableFromStr(scriptObject:Dynamic, variable:String, lua:LuaScript, title:String):Dynamic {
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
						error('Expected Variable "$realShit"!! Currently Only Supports Array In This Callback', title, lua);
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
							error('Expected Variable "$fuck" In This Callback', title, lua);
							return false;
						}
					}else error('Expected Variable "$fuck" In This Callback', title, lua);
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
				error('Expected Variable "$originFuck" In This Callback', title, lua);
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