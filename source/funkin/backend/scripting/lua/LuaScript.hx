package funkin.backend.scripting.lua;

#if LUAState
import Type.ValueType;
import haxe.io.Path;
import wrapper.LuaWrapper;
import funkin.backend.scripting.lua.implements.*;

class LuaScript extends FlxBasic {
  public static var extension:Array<String> = ["lua", "qqqeb", "oranges"];
  
  public var path:String;
  public var fileName:String;

  private var rawPath:String;
  private var code:String;
  private var isLoaded:Bool = false;
  private var isClosed:Bool = false;

  private var wrapper:LuaWrapper = null;

  public function new(path:String) {
    rawPath = path;
    this.path = Paths.getFilenameFromLibFile(rawPath);
    fileName = Path.withoutDirectory(path);
    super();

    onCreate(path);
  }

  function onCreate(path:String) {
    if(Assets.exists(path)) {
      switch(Path.extension(path)) {
          case "lua" | "qqqeb" | "oranges" | "vapiremox":
            code = Assets.getText(path);
          default:
            Logs.trace('this file \'${path}\' not support lua extension');
            close();
      }
    }else close();

    wrapper = new LuaWrapper();
    wrapper.loadLibs();

    BaseCallback.implement(this);
  }

  public function load() {
    if(wrapper == null) return;
    
    if(!isLoaded) execute();
  }

  public function execute() {
    if(wrapper == null) return;

    if(code != null) {
      call("new");
      wrapper.execute(code);

    }else close();
  }

  public function call(funcName:String, ?args:Array<Dynamic>, ?ret:Bool = false):Dynamic {
    if(wrapper == null) return null;
    
    if(args == null || args == []) {
      if(ret) return wrapper.callFunction(funcName, ret);
      wrapper.callFunction(funcName, ret);
    }else {
      if(ret) return wrapper.callFunction_ArrayArgs(funcName, args, ret);
      wrapper.callFunction_ArrayArgs(funcName, args, ret);
    }

    return null;
  }

  /**
   * 仅限global
   */
  public function get(key:String):Dynamic {
    if(wrapper == null) return null;

    var split:Array<String> = key.split(".");

    if(split.length < 2) {
      try {
        return wrapper.get_var(split[0]);
      }catch(e) {
        Logs.trace('not exists this variable \'${split[0]}\', or this variable was not global');
      }
    }else {
      if(split.length > 3) {
        Logs.trace('not support this written');
        return null;
      }

      try {
        return wrapper.get_var_from_table(split[0], split[1]);
      }catch(e) {
        Logs.trace('not exists this variable \'$key\', or this variable was not global');
      }
    }

    return null;
  }

  /**
   * 仅限global
   */
  public function set(key:String, value:Dynamic) {
    if(wrapper == null) return;

    switch(Type.typeof(value)) {
        case TFunction:
          wrapper.setFunction(key, value);
        default:
          var split = key.split(".");

          if(split.length < 2) wrapper.set_var(split[0], value);
          else wrapper.set_var_to_table(split[0], split[1], value);
    }
  }

  public function close(?isDestroyed:Bool = false) {
    if(wrapper == null) return;

    wrapper.close();
    isClosed = true;
    if(isDestroyed) destroy();
  }

  override function destroy() {
    super.destroy();
  }

  @:noCompletion override function toString():String {
    return '';
  }
}
#end
