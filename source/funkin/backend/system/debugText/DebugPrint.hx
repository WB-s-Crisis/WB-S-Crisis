package funkin.backend.system.debugText;

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
	/**
     * 描边着色器
     */
	public var outlineShader:OUTLINE;
	public var downscroll:Bool;

	public var textFormat:TextFormat;

	public function new(textFormat:TextFormat, ?downScroll = false, ?defaultValue:{
		var ?color:FlxColor;
		var ?size:Float;
		var ?fast:Bool;
	}) {
		super();

		downscroll = downscroll;
		this.textFormat = textFormat;

		outlineShader = new OUTLINE(defaultValue);
		filters = [new ShaderFilter(outlineShader)];
	}
    
	public function debugPrint(text:String, textOptions:TextOptions) {
        var print:TextField = new TextField();
		print.text = text;
		print.defaultTextFormat = this.textFormat;

		if(this.downscroll) {
			
		}else {
			
		}

		addChild(print);
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
		color.value = [0, 0, 0];
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
	var ?style:TextStyle;
	var ?delayTime:Float;
}

enum abstract TextStyle(FlxColor) {
	var ERROR:TextStyle = FlxColor.RED;
	var RIGHT:TextStyle = FlxColor.GREEN;
	var NORMAL:TextStyle = FlxColor.WHITE;
}
