package funkin.backend.scripting.lua.implements;

#if LUAState
import funkin.backend.scripting.lua.LuaScript;

class BaseCallback {
  public static function implement(parent:LuaScript) {
    parent.set("debugPrint", Main.game.debugPrint);
    parent.set("alert", lime.app.Application.current.window.alert);
  }
}
#end
