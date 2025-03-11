/**
 * 此玩意儿仅用于测试addons（不会真有人拿来用吧）
 */

/**
 * dddd
 */
class Point {
	public var x:Float;
	public var y:Float;
	
	public function new(?x:Float = 0, ?y:Float = 0) {
		this.x = x;
		this.y = y;
	}
}

class Point3D {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	public function new(?x:Float = 0, ?y:Float = 0, ?z:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
}