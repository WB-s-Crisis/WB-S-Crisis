package funkin.backend.system.debugText;

import openfl.text.TextField

/**
 * e......只是图个方便罢了
 */
class DebugText extends TextField {
    public var ID:Int = 0;
    
    public function new(id:Int) {
        super();
        ID = id;
    }
}
