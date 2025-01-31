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
    Lua.init_callbacks(state);

    switch(Path.extension(path)) {
        case "lua":
          if(Assets.exists(path)) {
            LuaL.dostring(state, Assets.getText(path));
            lime.app.Application.current.window.alert("loaded ok");
          }else close();
        default: close();
    }

    lime.app.Application.current.window.alert('lua version: ${Lua.version()}');

    Lua_helper.add_callback(state, "alert", function(text:String) {
      lime.app.Application.current.window.alert(text);
    });
  }

  public function close():Void {
    if(state == null) return;
    
    Lua.close(state);
  }
}
#end
