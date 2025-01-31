package funkin.backend.scripting.lua;
#if LUAState
import haxe.io.Path;

import llua.*;
import llua.Lua;

class LuaScript extends FlxBasic {
  public var state:State = null;
  
  public var fileName:String;
  public var path:String;
  
  public function new(path:String) {
    this.path = path;
    fileName = Path.withoutDirectory(path);

    onCreate(path);

    super();
  }

  public function onCreate(path:String) {
    state = LuaL.newstate();
    LuaL.openlibs(state);

    switch(Path.extension(path)) {
        case "lua":
          if(Assets.exists(path)) {
            Lua.dostring(state, Assets.getText(path));
          }else close();
        default: close();
    }

    Lua_helper.add_callback(state, debugPrint, function(text:String, ?delayTime:Float = 1) {
      Main.game.debugPrint(text, delayTime);
    });
    Lua.getGlobal(state, "test");
    Lua.pcall(lua, 3, 0, 1);

    close();
  }

  public function close():Void {
    if(state == null) return;
    
    Lua.close(state);
  }
}
#end
