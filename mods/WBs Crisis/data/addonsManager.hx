import haxe.io.Path;

import funkin.backend.assets.ModsFolder;
import funkin.backend.scripting.Script;
import funkin.backend.scripting.ScriptPack;
import openfl.Assets;

import sys.FileSystem;
import sys.io.File;

var addonsScriptManager:ScriptPack;

function new() {
	addonsScriptManager = new ScriptPack("addonsScript");
	
	if(FileSystem.exists(getPath("addons")) && FileSystem.isDirectory(getPath("addons"))) {
		var filesName:Array<String> = FileSystem.readDirectory(getPath("addons"));
		
		if(filesName.length > 0) {
			var i:Int = -1;
			
			while(i < filesName.length - 1) {
				i++;
				
				var obj:String = filesName[i];
				var script:HScript = Script.create(Paths.script("addons/" + obj));
				addonsScriptManager.add(script);
				script.load();
			}
		}
	}
}

function onScriptCreated(script:HScript, origin:String) {
	
	var kawa = script;
	script.set("importAddons", function(sb:String) {
		importScriptAddons(sb, kawa);
	});
}

function importScriptAddons(str:String, script:HScript) {
	var split:Array<String> = str.split(".");
	var scName:Array<String> = [];
	
	for(sc in addonsScriptManager.scripts) {
		scName.push(Path.withoutExtension(sc.fileName));
		
		if(split[0] == Path.withoutExtension(sc.fileName)) {
			var customClasses:Map<String, Dynamic> = sc.interp.customClasses;
			
			if(split.length < 2) {
				if(customClasses.exists(split[0])) {
					script.set(split[0], customClasses.get(split[0]));
				}else {
					Application.current.window.alert("not exists this Addons \"" + split[0] + '"', "Error");
				}
			}else if(split.length < 3) {
				if(split[1] == "*") {
					for(cs=>go in customClasses) {
						script.set(cs, go);
					}
				}else {
					if(customClasses.exists(split[1])) {
						script.set(split[1], customClasses.get(split[1]));
					}else {
						Application.current.window.alert("not exists this Addons \"" + split[0] + "/" + split[1] + '"', "Error");
					}
				}
			}else {
				Application.current.window.alert("not Support create new Addons Directory Package", "Error");
			}
		}
	}
	
	if(!scName.contains(split[0])) {
		Application.current.window.alert("not exists this Addons File \"" + split[0] + '"', "Error");
	}
}

function getPath(path:String) {
	return ModsFolder.currentModFolder != null ? "mods/" + ModsFolder.currentModFolder + "/" + path : Paths.getPath(path);
}
