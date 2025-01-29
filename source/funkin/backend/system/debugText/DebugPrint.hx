package funkin.backend.system.debugText;

import openfl.Lib;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxShader;

/**
 * bro，回一句话🙁，空留给你了
 * 
 */
class DebugPrint extends Sprite {
	public var downscroll:Bool;

	public var textFormat:TextFormat;

	private var hangju:Float = 8;

	public function new(textFormat:TextFormat, ?downScroll = false) {
		super();

		downscroll = downscroll;
		this.textFormat = textFormat;
	}
    
	public function debugPrint(text:String, ?textOptions:TextOptions) {
        var print:DebugText = new DebugText(__children.length, textOptions != null && Reflect.hasField(textOptions, "delayTime") ? textOptions.delayTime : null);

        if(textOptions != null && Reflect.hasField(textOptions, "style")) {
			print.textColor = textOptions;
		}else {
			print.textColor = FlxColor.WHITE;
		}
		
		print.text = text;
		print.defaultTextFormat = this.textFormat;
		addChild(print);
    }

	public override function addChild(child:DisplayObject):DisplayObject {
		super.addChild(child);
		
		var outline:OUTLINE = new OUTLINE();
		child.filters = [new ShaderFilter(outline)];
		
		if(child is DebugText) {
			var realChild = cast(child, DebugText);

			realChild.lastTime = Lib.getTimer();
            realChild.y = (this.downscroll ? FlxG.stage.stageHeight - realChild.height : 0);
			if(realChild.ID > 0) {
                realChild.y = __children[realChild.ID - 1].y;
                realChild.y += (this.downscroll ? -realChild.height - hangju : __children[realChild.ID - 1].width + hangju);
            }
		}
		
		return child;
	}

	@:noCompletion
	private override function __enterFrame(deltaTime:Float):Void {
		var elapsed:Float = FlxG.elapsed;
        var timer:Float = Lib.getTimer();
		
        if(__children.length > 0) {
		    for(child in __children) {
                if(child is DebugText) {
					var realChild = cast(child, DebugText);
					
					if(realChild.lastTime + realChild.delayTime * 1000 < timer) {
						realChild.alpha -= elapsed / 0.5;
						
						if(realChild.lastTime + realChild.delayTime * 1000 + 500 < timer) {
                            removeChild(realChild);
                            
                            continue;
                        }
					}
				}
		    }
		}
	}

	@:noCompletion
	private function toString():String {
		return "滚！！！\t out of here!!!";
	}
}

/**
 * 由于openfl的TextField没有OUTLINE只能这么搞了
 */
class OUTLINE extends FlxShader {
	@:glFragmentSource("
#pragma header

uniform vec3 color;
uniform int samples;
uniform float size;

void main()
{
	vec2 iResolution = openfl_TextureSize;
	vec2 fragCoord = openfl_TextureCoordv.xy * iResolution;

	vec2 uv = fragCoord.xy / iResolution.xy;
    
    vec3 targetCol = color; //The color of the outline
    
    vec4 finalCol = vec4(0);
    
    float rads = ((360.0 / float(samples)) * 3.14159265359) / 180.0;	//radians based on SAMPLES
    
    for(int i = 0; i < samples; i++)
    {
        if(finalCol.w < 0.1)
        {
        	float r = float(i + 1) * rads;
    		vec2 offset = vec2(cos(r) * 0.1, -sin(r)) * size; //calculate vector based on current radians and multiply by magnitude
    		finalCol = texture2D(bitmap, uv + offset);	//render the texture to the pixel on an offset UV
            if(finalCol.w > 0.0)
            {
                finalCol.xyz = targetCol;
            }
        }
    }
    
    vec4 tex = texture2D(bitmap, uv);
    if(tex.w > 0.0)
    {
     	finalCol = tex;   //if the centered texture's alpha is greater than 0, set finalcol to tex
    }
    
	gl_FragColor = finalCol;
}
	")
	public function new(?defaultValue:{
		var ?color:FlxColor;
		var ?size:Float;
		var ?fast:Bool;
	}) {
		color.value = [0.07, 0, 0];
		size.value = [0.05];
		samples.value = [8];
		
		if(defaultValue != null) {
			if(Reflect.hasField(defaultValue, "color")) {
				color.value = [defaultValue.color.redFloat, defaultValue.color.greenFloat, defaultValue.color.blueFloat];
			}

			if(Reflect.hasField(defaultValue, "size")) {
				size.value = [size];
			}

			if(Reflect.hasField(defaultValue, "fast")) {
				samples.value = [(fast ? 4 : 8)];
			}
		}
	}
}

typedef TextOptions = {
	var ?style:FlxColor;
	var ?delayTime:Float;
}
