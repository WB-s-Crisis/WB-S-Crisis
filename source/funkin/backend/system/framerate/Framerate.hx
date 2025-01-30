package funkin.backend.system.framerate;

import funkin.backend.system.debugText.DebugPrint.OUTLINE;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.filters.ShaderFilter;

import lime.system.System as LimeSystem

class Framerate extends Sprite {
  public static var fontName:String = Assets.getFont(Paths.font("Super Cartoon.ttf")).fontName;
  public static final os:String = 'OS Build: ${LimeSystem.platformName}[${LimeSystem.deviceVendor}(${LimeSystem.deviceModel})]-${LimeSystem.platformVersion}.';

  public var fpsText:TextField = null;
  public var osText:TextField = null;
  
  public var currentFPS:Int;
  private var cacheCount:Int;
  private var currentTime:Float;
  private var times:Array<Float>;

  public function new(?outline:Bool = true) {
    super();

    initVars();

    fpsText = new TextField();
    fpsText.defaultTextFormat = new TextFormat(fontName, 16, FlxColor.WHITE);
    fpsText.autoSize = TextFieldAutoSize.LEFT;

    fpsText.test = "FPS: 0";
    addChild(fpsText);

    osText = new TextField();
    osText.defaultTextFormat = new TextFormat(fontName, 16, FlxColor.WHITE);
    osText.autoSize = TextFieldAutoSize.LEFT;
    osText.scrollY = fpsText.height + 2;

    osText.text = os;
    addChild(osText);

    if(outline) {
      this.filters = [new ShaderFilter(new OUTLINE())];
    }
  }

  override function __enterFrame(deltaTime:Float) {
    currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentCount != cacheCount && fpsText.visible)
			fpsText.text = "FPS: " + currentFPS;

		cacheCount = currentCount;
  }

  private function initVars():Void {
    currentFPS = 0;
    cacheCount = 0;
    currentTime = 0.;
    times = [];
  }
}
