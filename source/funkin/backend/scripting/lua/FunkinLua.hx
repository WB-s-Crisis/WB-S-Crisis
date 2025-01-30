package funkin.backend.scripting.lua;

#if LUAState
import haxe.io.Path;

import llua.*;
import llua.Lua;

class LuaScript {
  public var state:State = null;

  public var rawPath:String;
  public var path:String;
  public var fileName:String;
  public var extension:String:

  private var stringCode:String;

  public function new(path:String) {
    path = path.trim();
    
    rawPath = path;
    path = Paths.getFilenameFromLibFile(path);
    this.path = path;
    fileName = Path.withoutDirectory(path);
    extension = Path.extension(path);
    
    state = LuaL.newState();
    LuaL.openLibs(state);

    onCreate(rawPath);
  }

  public function get(name:String):Dynamic {}

  public function set(name:String, value:Dynamic):Dynamic {
    if(state == null) return null;
    
    if(!Reflect.isFunction(value)) {
      Convert.toLua(state, value);
      Lua.setGlobal(state, name);
    }else {
      Lua_helper.add_callback(state, "name", value);
    }

    return value;
  }

  public function close() {
    if(state == null) return;

    Lua.close(state);
  }

  private function onCreate(path:String) {
    if(Assets.exists(path)) {
      stringCode = Assets.getText(path);
      Lua.doString(state, stringCode);
    }
  }
}
#end
