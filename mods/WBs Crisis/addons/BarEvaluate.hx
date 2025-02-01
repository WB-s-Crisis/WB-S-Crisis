import flixel.util.FlxSpriteUtil;

class BarEvaluate extends FlxSprite {
	public var thickness:Float;

	public function new(x:Float = 0, y:Float = 0, width:Float = 16, height = 16, ?lineStyle:LineStyle) {
		super(x, y);
		
		makeGraphic(width, height, 0x00000000);
		
		var thicknessPos = (Reflect.hasField(lineStyle, "thickness") ? lineStyle.thickness : 0) / 2;
		
		thickness = (Reflect.hasField(lineStyle, "thickness") ? lineStyle.thickness : 0);
		
		this = FlxSpriteUtil.drawLine(this, 0, thicknessPos, width, thicknessPos, lineStyle);
		this = FlxSpriteUtil.drawLine(this, thicknessPos, 0, thicknessPos, height, lineStyle);
		this = FlxSpriteUtil.drawLine(this, width - thicknessPos, 0, width - thicknessPos, height - thicknessPos, lineStyle);
		this = FlxSpriteUtil.drawLine(this, 0, height - thicknessPos, width - thicknessPos, height - thicknessPos, lineStyle);
	}
}