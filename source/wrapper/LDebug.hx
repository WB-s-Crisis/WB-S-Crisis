package wrapper;

import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;

@:include('linc_lua.h')
extern class LDebug {

    @:native('linc::helpers::setErrorHandler')
    static function setErrorHandler(l:State) : Int;

    static inline function luaTrace(l:State) : Void {}
    
}

