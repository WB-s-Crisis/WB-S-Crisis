/**
 * 供测试
 */

import funkin.backend.system.interfaces.IBeatReceiver;

class TestSprite extends FlxSprite implements IBeatReceiver {
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
	}
	
	public function stepHit(step:Int) {
		debugPrint(step);
	}
}

class Template {
	public function toString() {
		return "Template";
	}
}