package funkin.backend.scripting.addons;

import funkin.backend.scripting.ScriptPack;
import funkin.backend.scripting.Script;
import funkin.backend.scripting.HScript;
import flixel.util.FlxDestroyUtil;
import funkin.backend.assets.ModsFolder;
import lime.app.Application;
import haxe.io.Path;

/**
 * 这依托你爱看吗？
 */
class AddonsManager {
	private static var addonsScripts:ScriptPack;
	
	public static function init() {
		addonsScripts = new ScriptPack("addons");
		#if MOD_SUPPORT
		ModsFolder.onModSwitch.add(onModSwitch);
		#end
	}
	
	public static function importScriptAddons(addonsPath:String, sb:HScript) {
		if(addonsScripts == null) return;
		
		var split:Array<String> = addonsPath.split(".");
	
		if(split.length <= 0) {
			Application.current.window.alert("你怎么做到的？");
			return;
		}
	
		if(Paths.getFolderDirectories("").contains("addons")) {
			if(split.length < 2) {
				var sd:Array<String> = Paths.getFolderDirectories("addons");
				var sc:Array<String> = Paths.getFolderContent("addons");
				var scWithoutExtension = [];
			
				for(nb in sc) {
					var gengNb = Path.withoutExtension(nb);
					scWithoutExtension.push(gengNb);
				}
			
				if(scWithoutExtension.contains(split[0])) {
					var script = Script.create(Paths.script("addons/" + split[0]));
					script.load();
				
					if(script.interp.customClasses.exists(split[0])) {
						addonsScripts.add(script);
						sb.set(split[0], script.interp.customClasses.get(split[0]));
					}else {
						Application.current.window.alert("不能只导入文件，需要准确的类，或者你可以添加\".*\"来导入此文件的所有类");
					}
				
					return;
				}
			
				if(sd.contains(split[0])) {
					Application.current.window.alert("不能只导入目录，你需要指定一份确切的脚本文件");
				}
			}else {
				var isLockingFile:Bool = false;
				var curPath = "addons";
				for(i=>sp in split) {
					var sd:Array<String> = Paths.getFolderDirectories(curPath);
					var sc:Array<String> = Paths.getFolderContent(curPath);
					var scWithoutExtension = [];
			
					for(nb in sc) {
						var gengNb = Path.withoutExtension(nb);
						scWithoutExtension.push(gengNb);
					}
				
					if(isLockingFile) {
						var rawPath = curPath;
					
						var script = Script.create(Paths.script(rawPath));
						script.load();
					
						if(split.length - 1 - i > 1) {
							Application.current.window.alert("仅支持导入类，不能再导入类里的东西");
						}else {
							addonsScripts.add(script);
						
							if(script.interp.customClasses.exists(sp)) {
								sb.set(sp, script.interp.customClasses.get(sp));
							}else if(sp == "*") {
								for(k=>c in script.interp.customClasses) {
									sb.set(k, c);
								}
							}else {
								Application.current.window.alert("该脚本里不存在此类\"" + sp + "\"，建议去死");
							}
						}
					
						break;
					}
				
					if(scWithoutExtension.contains(sp)) {
						isLockingFile = true;
						curPath += (StringTools.endsWith(curPath, "/") ? "" : "/") + sp;
					
						if(i == split.length - 1) {
							var rawPath = curPath;
							var script = Script.create(Paths.script(rawPath));
							script.load();
						
							if(script.interp.customClasses.exists(sp)) {
								addonsScripts.add(script);
								sb.set(sp, script.customClasses.get(sp));
							}else {
								Application.current.window.alert("不能只导入文件，需要准确的类，或者你可以添加\".*\"来导入此文件的所有类");
							}
						
							break;
						}
					
						continue;
					}
				
					if(sd.contains(sp) && !isLockingFile) {
						curPath += (StringTools.endsWith(curPath, "/") ? "" : "/") + sp;
					
						if(i == split.length - 1) {
							Application.current.window.alert("不能只导入目录，你需要指定一份确切的脚本文件");
						
							break;
						}
					
						continue;
					}
				
					Application.current.window.alert("不存在" + "\"" + sp + "\"此文件亦或是目录，请确认有没有或者你有没有输对");
				//break;
				}
			}
		}else {
			Application.current.window.alert("没有addons目录哦");
		}
	}
	
	private static function onModSwitch(idk:String) {
		if(addonsScripts.scripts.length > 0) {
			var i:Int = -1;
			while(i < addonsScripts.scripts.length - 1) {
				i++;
				addonsScript.pop();
			}
		}
	}
}
