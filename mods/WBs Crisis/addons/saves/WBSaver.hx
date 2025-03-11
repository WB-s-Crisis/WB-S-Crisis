import Reflect;
import flixel.util.FlxSave;

/**
 * ▒▒▒█████████████▒▒▒
 * ▒▒███████████████▒▒
 * ▒████████████████▒▒
 * ▒███████▒████▒████▒
 * ▒████▒██▒▒██▒▒▒███▒
 * ████▒▒▒▒▒▒▒▒▒▒▒███▒
 * ██▒█▒▒▒▒▒▒▒▒▒▒▒████
 * ██▒▒▒▒██▒▒▒▒██▒████
 * ███▒▒▒▒▒▒▒▒▒▒▒▒▒███
 * ████▒▒▒▒▒██▒▒▒▒▒███
 * ██████▒▒▒▒▒▒▒▒▒████
 * ███████▒▒▒▒▒▒▒█████
 * ▒█▒█████▒▒██████▒█▒
 * ▒▒▒█▒▒▒█▒▒█▒▒▒▒▒▒▒▒
 * ▒▒▒▒▒███████▒▒▒▒▒▒▒
 * ▒▒▒██▓█████▓███▒▒▒▒
 * ▒▒█▓█▓▓▓▓▓▓▓▓███▒▒▒
 * ▒█▓██▒▒▒▒▒▒▒▒▒█▓█▒▒
 * ▒█▓█▓▓▓▓▓▓▓▓▓▓█▓█▒▒
 * ▒███▒▒▒▒▒▒▒▒▒▒███▒▒
 * ▒█▒█▓▓▓▓▓▓▓▓▓▓█▒█▒▒
 * ▒███▓▓▓▓▓▓▓▓▓▓███▒▒
 * ▒▒▒█▓▓▓▓███▓▓▓█▒▒▒▒
 * ▒▒▒█▓▓▓▓█▒█▓▓▓█▒▒▒▒
 * ▒▒▒██████▒█████▒▒▒▒
 * ▒▒▒▒▒████▒████▒▒▒▒▒
 * ▒▒▒▒█████▒█████▒▒▒▒
 * ......
 * (这使你充满了决心)
 */
class WBSaver extends FlxBasic {
	public var saves:FlxSave;
	public var data:Dynamic;
	public var defaultData:Dynamic;
	
	public var saved:Bool = false;
	public var loaded:Bool = false;
	
	public var fileName:String = "WB's Crisis Mod Saver";

	public function new(options:Dynamic) {
		saves = new FlxSave();
		data = options;
		defaultData = options;
		
		saves.bind(this.fileName);
		var oFieldsName = Reflect.fields(options);
		if(oFieldsName.length > 0) {
			for(fn in oFieldsName) {
				var getValue = Reflect.field(options, fn);
				if(Reflect.hasField(saves.data, fn))
					getValue = Reflect.field(saves.data, fn);

				this.__interp.variables.set(fn, getValue);
				if(data != null)
					Reflect.setField(data, fn, getValue);
				if(saves != null)
					Reflect.setField(saves.data, fn, getValue);
				this.__interp.variables.set("set_" + fn, function(val:Dynamic) {
					this.__interp.variables.set(fn, val);
				
					if(data != null)
						Reflect.setField(data, fn, val);
					if(saves != null)
						Reflect.setField(saves.data, fn, val);
					
					return val;
				});
			}
		}
		//Application.current.window.alert(saves.data);
	}
	
	public function pushNewFields(options:Dynamic) {
		var oFieldsName = Reflect.fields(options);
		
		if(!active || !exists) return;
		
		if(oFieldsName.length > 0) {
			for(fn in oFieldsName) {
				if(this.__interp.variables.exists(fn) || Reflect.hasField(data, fn) || Reflect.hasField(saves.data, fn)) {
					Application.current.window.alert("
关于你新建的\"" + fn + "\"变量已存在，因为某些原因，不能进行对原本的替代，请删掉
					", "警告!!!");
					continue;
				}
			
				var getValue = Reflect.field(options, fn);
				this.__interp.variables.set(fn, getValue);
				if(data != null)
					Reflect.setField(data, fn, getValue);
				if(saves != null)
					Reflect.setField(saves.data, fn, getValue);
				this.__interp.variables.set("set_" + fn, function(val:Dynamic) {
					this.__interp.variables.set(fn, val);
				
					if(data != null)
						Reflect.setField(data, fn, val);
					if(saves != null)
						Reflect.setField(saves.data, fn, val);
					
					return val;
				});
			}
		}
	}
	
	public function load() {
		if(saves == null) return;
		
		saves.bind(this.fileName);
		loaded = true;
	}
	
	public function save() {
		if(saves == null) return false;
		
		saved = true;
		return saves.flush();
	}
	
	public function clear() {
		if(saves == null) return;
		
		saves.data = {};
		data = defaultData;
		saves.close();
		saves.flush();
	}
	
	public override function destroy():String {
		data = null;
		clear();
		save = null;
	}
	
	public override function toString():String {
		if(save != null) {
			return "( " + "fields: " + save.data + " | " + "saved: " + saved + " | " + "loaded: " + loaded + " )";
		}
	}
}