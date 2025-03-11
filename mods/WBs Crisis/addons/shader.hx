import Array;

import openfl.Assets;
import openfl.display.ShaderParameterType;

class RTXLighting {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var overlayColor:ShaderVector;
	public var satinColor:ShaderVector;
	public var innerShadowColor:ShaderVector;
	public var innerShadowAngle:Float;
	public var innerShadowDistance:Float;
	
	public function new() {
		shader = new FunkinShader(this.shaderCode);
		
		overlayColor = new ShaderVector(shader, "overlayColor", {
			r: 0,
			g: 0,
			b: 0,
			a: 0
		});
		satinColor = new ShaderVector(shader, "satinColor", {
			r: 0,
			g: 0,
			b: 0,
			a: 0
		});
		innerShadowColor = new ShaderVector(shader, "innerShadowColor", {
			r: 0,
			g: 0,
			b: 0,
			a: 0
		});
		
		innerShadowAngle = 0;
		innerShadowDistance = 0;
		
		shader.innerShadowAngle = innerShadowAngle;
		shader.innerShadowDistance = innerShadowDistance;
	}
	
	public function set_innerShadowAngle(val:Float) {
		innerShadowAngle = val;
		shader.innerShadowAngle = val;
	
		return val;
	}
	
	public function set_innerShadowDistance(val:Float) {
		innerShadowDistance = val;
		shader.innerShadowDistance = val;
	
		return val;
	}
	
	public function get_shaderCode():String {
		return "
#pragma header

//https://github.com/jamieowen/glsl-blend !!!!

float blendOverlay(float base, float blend) {
	return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}

vec3 blendOverlay(vec3 base, vec3 blend) {
	return vec3(blendOverlay(base.r,blend.r),blendOverlay(base.g,blend.g),blendOverlay(base.b,blend.b));
}

vec3 blendOverlay(vec3 base, vec3 blend, float opacity) {
	return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
}

float blendColorDodge(float base, float blend) {
	return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
}

vec3 blendColorDodge(vec3 base, vec3 blend) {
	return vec3(blendColorDodge(base.r,blend.r),blendColorDodge(base.g,blend.g),blendColorDodge(base.b,blend.b));
}

vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
	return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
}

float blendLighten(float base, float blend) {
	return max(blend,base);
}
vec3 blendLighten(vec3 base, vec3 blend) {
	return vec3(blendLighten(base.r,blend.r),blendLighten(base.g,blend.g),blendLighten(base.b,blend.b));
}
vec3 blendLighten(vec3 base, vec3 blend, float opacity) {
	return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
}

vec3 blendMultiply(vec3 base, vec3 blend) {
	return base*blend;
}
vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
	return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
}

float inv(float val)
{
    return (0.0 - val) + 1.0;
}


//Shader by TheZoroForce240

uniform vec4 overlayColor;
uniform vec4 satinColor; //not proper satin but yea still works
uniform vec4 innerShadowColor;
uniform float innerShadowAngle;
uniform float innerShadowDistance;

float SAMPLEDIST = 5.0;
		
void main()
{	
    vec2 uv = openfl_TextureCoordv.xy;
    vec4 spritecolor = flixel_texture2D(bitmap, uv);    
    vec2 resFactor = 1.0 / openfl_TextureSize.xy;

    
    spritecolor.rgb = blendMultiply(spritecolor.rgb, satinColor.rgb, satinColor.a); //apply satin (but no blur)

    //inner shadow
    float offsetX = cos(innerShadowAngle);
    float offsetY = sin(innerShadowAngle);
    vec2 distMult = (innerShadowDistance*resFactor) / SAMPLEDIST;
   	for (float i = 0.0; i < SAMPLEDIST; i++) //sample nearby pixels to see if theyre transparent, multiply blend by inverse alpha to brighten the edge pixels
    {
        //make sure to use texture2D instead of flixel_texture2D so alpha doesnt effect it
        vec4 col = texture2D(bitmap, uv + vec2(offsetX * (distMult.x * i), offsetY * (distMult.y * i)));
        spritecolor.rgb = blendColorDodge(spritecolor.rgb, innerShadowColor.rgb, innerShadowColor.a * inv(col.a)); //mult by the inverse alpha so it blends from the outside
    }

    spritecolor.rgb = blendLighten(spritecolor.rgb, overlayColor.rgb, overlayColor.a); //apply overlay

    
    gl_FragColor = spritecolor * spritecolor.a;
}
		";
	}
}

class Chromatic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var aberration:Float;
	
	public function new() {
		shader = new FunkinShader(this.shaderCode);
		
		aberration = 0.0;
		shader.aberration = aberration;
	}
	
	public function set_aberration(val:Float) {
		aberration = val;
		shader.aberration = val;
	}
	
	public function get_shaderCode():String {
		return "
#pragma header
/*
https://www.shadertoy.com/view/wtt3z2
*/
    
uniform float aberration;
    
    vec3 tex2D(sampler2D _tex,vec2 _p)
    {
        vec3 col=texture2D(_tex,_p).xyz;
        if(0.5<abs(_p.x-0.5)){
            col=vec3(0.1);
        }
        return col;
    }
    
    void main() {
        #pragma body
        vec2 uv = openfl_TextureCoordv; //openfl_TextureCoordv.xy*2.0 / openfl_TextureSize.xy-vec2(1.0);
        
        vec2 trueAberration = aberration * pow((uv - 0.5), vec2(3.0, 3.0));
        // vec4 texColor = tex2D(bitmap, uv_prj.st);
        gl_FragColor = vec4(
            texture2D(bitmap, uv + trueAberration).r, 
            texture2D(bitmap, uv).g, 
            texture2D(bitmap, uv - trueAberration).b, 
            texture2D(bitmap,uv).a
        );
    }
		";
	}
}

class GLITCH extends FlxBasic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var iTime:Float;
	public var speed:Float;
	public var amt:Float;
	public var framerate:Float;
	
	public function new() {
		super();
	
		shader = new FunkinShader(this.shaderCode);
		
		iTime = 0;
		shader.iTime = iTime;
		
		speed = 0;
		shader.speed = speed;
		
		amt = 0;
		shader.amt = amt;
		
		framerate = FlxG.drawFramerate;
		shader.framerate = framerate;
	}
	
	public override function update(elapsed:Float) {
		super.update();
		
		this.iTime += elapsed;
	}
	
	public function set_iTime(val:Float) {
		iTime = val;
		shader.iTime = val;
	
		return val;
	}
	
	public function set_speed(val:Float) {
		speed = val;
		shader.speed = val;
	
		return val;
	}
	
	public function set_amt(val:Float) {
		amt = val;
		shader.amt = val;
	
		return val;
	}
	
	public function set_framerate(val:Float) {
		framerate = val;
		shader.framerate = val;
	
		return val;
	}
	
	public function get_shaderCode() {
		return "
#pragma header

uniform float iTime;
uniform float speed;
uniform float amt;
uniform float framerate;

//2D (returns 0 - 1)
float random2d(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float randomRange (in vec2 seed, in float min, in float max) {
		return min + random2d(seed) * (max - min);
}

// return 1 if v inside 1d range
float insideRange(float v, float bottom, float top) {
   return step(bottom, v) - step(top, v);
}

//inputs
//float AMT = 0.2; //0 - 1 glitch amount
//float SPEED = 0.6; //0 - 1 speed
   
void main()
{
    vec2 iResolution = openfl_TextureSize.xy;
    vec2 fragCoord = openfl_TextureCoordv * iResolution.xy;
    
    float time = floor(iTime * speed * framerate);    
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    //copy orig
    vec3 outCol = texture2D(bitmap, uv).rgb;
    
    //randomly offset slices horizontally
    float maxOffset = amt/2.0;
    for (float i = 0.0; i < 10.0 * amt; i += 1.0) {
        float sliceY = random2d(vec2(time , 2345.0 + float(i)));
        float sliceH = random2d(vec2(time , 9035.0 + float(i))) * 0.25;
        float hOffset = randomRange(vec2(time , 9625.0 + float(i)), -maxOffset, maxOffset);
        vec2 uvOff = uv;
        uvOff.x += hOffset;
        if (insideRange(uv.y, sliceY, fract(sliceY+sliceH)) == 1.0 ){
        	outCol = texture2D(bitmap, uvOff).rgb;
        }
    }
    
    //do slight offset on one entire channel
    float maxColOffset = amt/6.0;
    float rnd = random2d(vec2(time , 9545.0));
    vec2 colOffset = vec2(randomRange(vec2(time , 9545.0),-maxColOffset,maxColOffset), 
                       randomRange(vec2(time , 7205.0),-maxColOffset,maxColOffset));
    if (rnd < 0.33){
        outCol.r = texture2D(bitmap, uv + colOffset).r;
        
    }else if (rnd < 0.66){
        outCol.g = texture2D(bitmap, uv + colOffset).g;
        
    } else{
        outCol.b = texture2D(bitmap, uv + colOffset).b;  
    }
       
	gl_FragColor = vec4(outCol,1.0);
}
		";
	}
}

class OUTLINE extends FlxBasic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var color:Int;
	public var colorVec:ShaderVector;
	public var samples:Int;
	public var size:Float;
	
	public function new(cc:Int) {
		shader = new FunkinShader(this.shaderCode);
		
		color = cc;
		colorVec = new ShaderVector(shader, "color", {
			x: ((color >> 16) & 0xFF) / 255,
			y: ((color >> 8) & 0xFF) / 255,
			z: (color & 0xFF) / 255
		});
		
		size = 0.001;
		shader.size = size;
		
		samples = 4;
		shader.samples = samples;
		
		super();
	}
	
	public function set_color(val:Int) {
		color = val;
		
		colorVec.set(((color >> 16) & 0xFF) / 255, ((color >> 8) & 0xFF) / 255, (color & 0xFF) / 255);
		return color;
	}
	
	public function set_size(val:Float) {
		size = val;
		shader.size = size;
		
		return size;
	}
	
	public function set_samples(val:Int) {
		samples = val;
		shader.samples = samples;
		
		return samples;
	}
	
	public function get_shaderCode():String {
		return "
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
		";
	}
}

/**
 * 不知道
 */
class Trans extends FlxBasic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var apply:Float;
	
	public function new() {
		shader = new FunkinShader(this.shaderCode);
		
		apply = 0.;
		shader.apply = apply;
		
		super();
	}
	
	public function set_apply(val:Float):Float {
		apply = val;
		
		shader.apply = apply;
		return apply;
	}
	
	public function get_shaderCode():String {
		return "
// TRANSITION CODE BY NE_EO

#pragma header

uniform float apply;

void main()
{
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 fragCoord = uv * openfl_TextureSize.xy;
	vec4 col = texture2D(bitmap, uv);

	vec2 uvf = fragCoord/openfl_TextureSize.xx;

	float dd = distance(uvf, vec2(0.5, openfl_TextureSize.y/openfl_TextureSize.x*0.5))*1.6666;

	if(dd > 1.0-apply)
		col.rgba = vec4(0.0, 0.0, 0.0, 1.0);

	gl_FragColor = col;
}
		";
	}
}

/**
 * 老电视花瓶
 */
class OldTV extends FlxBasic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var iTime:Float;
	public var alphaNoise:Float;
	public var blueOpac:Float;
	public var redOpac:Float;
	public var noiseTex:BitmapData;
	public var glitchModifier:Float;
	
	/**
	 * 实例化，dddd
	 * @param texPath 给一个噪点的路径图片
	 */
	public function new(?texPath:String) {
		super();
	
		shader = new FunkinShader(this.shaderCode);
		
		iTime = 0.;
		alphaNoise = 1;
		blueOpac = 0;
		redOpac = 0.;
		glitchModifier = 0;
		
		if(texPath != null)
			if(Assets.exists(texPath))
				noiseTex = Assets.getBitmapData(texPath);
		
		shader.iTime = iTime;
		shader.alphaNoise = alphaNoise;
		shader.blueOpac = blueOpac;
		shader.redOpac = redOpac;
		shader.glitchModifier = glitchModifier;
		
		if(noiseTex != null)
			shader.noiseTex = noiseTex;
	}
	
	public override function update(elapsed:Float) {
		super.update(elapsed);
	
		this.iTime += elapsed;
	}
	
	public function set_iTime(val:Float):Float {
		iTime = val;
		
		shader.iTime = iTime;
		return iTime;
	}
	
	public function set_alphaNoise(val:Float):Float {
		alphaNoise = val;
		
		shader.alphaNoise = alphaNoise;
		return alphaNoise;
	}
	
	public function set_blueOpac(val:Float):Float {
		blueOpac = val;
		
		shader.blueOpac = blueOpac;
		return blueOpac;
	}
	
	public function set_redOpac(val:Float):Float {
		redOpac = val;
		
		shader.redOpac = redOpac;
		return redOpac;
	}
	
	public function set_glitchModifier(val:Float):Float {
		glitchModifier = val;
		
		shader.glitchModifier = glitchModifier;
		return glitchModifier;
	}
	
	public function get_shaderCode():String {
		return "
	 #pragma header

    uniform float iTime;
    uniform float alphaNoise;
    uniform float blueOpac;
    uniform float redOpac;
    uniform sampler2D noiseTex;
    uniform float glitchModifier;
    uniform vec3 iResolution;

    float onOff(float a, float b, float c)
    {
    	return step(c, sin(iTime + a*cos(iTime*b)));
    }

    float ramp(float y, float start, float end)
    {
    	float inside = step(start,y) - step(end,y);
    	float fact = (y-start)/(end-start)*inside;
    	return (1.-fact) * inside;

    }

    vec4 getVideo(vec2 uv)
      {
      	vec2 look = uv;
        	float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,15.)));
        	look.x = look.x + (sin(look.y*10. + iTime)/540.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window)*(glitchModifier*2.);
        	float vShift = 0.4*onOff(2.,3.,.9)*(sin(iTime)*sin(iTime*20.) +
        										 (1.0 + 0.1*sin(iTime*200.)*cos(iTime)));
        	look.y = mod(look.y + vShift*glitchModifier, 1.);
      	vec4 video = flixel_texture2D(bitmap,look);

      	return video;
      }

    vec2 screenDistort(vec2 uv)
    {
        uv = (uv - 0.5) * 2.0;
      	uv *= 1.1;
      	uv.x *= 1.0 + pow((abs(uv.y) / 4.5), 2.0);
      	uv.y *= 1.0 + pow((abs(uv.x) / 3.5), 2.0);
      	uv  = (uv / 2.0) + 0.5;
      	uv =  uv *0.92 + 0.04;
      	return uv;
    	return uv;
    }
    float random(vec2 uv)
    {
     	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));
    }
    float filmGrainNoise(in float time, in vec2 uv)
    {
    return fract(sin(dot(uv, vec2(12.9898, 78.233) * time)) * 43758.5453);
    }
    float noise(vec2 uv)
    {
     	vec2 i = floor(uv);
        vec2 f = fract(uv);

        float a = random(i);
        float b = random(i + vec2(1.,0.));
    	float c = random(i + vec2(0., 1.));
        float d = random(i + vec2(1.));

        vec2 u = smoothstep(0., 1., f);

        return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;

    }


    vec2 scandistort(vec2 uv) {
    	float scan1 = clamp(cos(uv.y * 3.0 + iTime), 4.0, 1.0);
    	float scan2 = clamp(cos(uv.y * 6.0 + iTime + 4.0) * 10.0,0.0, 1.0) ;
    	float amount = scan1 * scan2 * uv.x;

    	uv.x -= 0.015 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.2);

    	return uv;

    }
    void main()
    {
    	vec2 uv = openfl_TextureCoordv;
      vec2 curUV = screenDistort(uv);
    	uv = scandistort(curUV);
    	vec4 video = getVideo(uv);
      float vigAmt = 1.0;
      float x = 0.0;
      float grainFactor = filmGrainNoise(iTime, uv);


      video.r = getVideo(vec2(x+uv.x+0.001,uv.y+1.0)).x + abs(sin(0.12 * redOpac)); // used for sirokous fire part
      video.g = getVideo(vec2(x+uv.x-0.001,uv.y+1.0)).y + abs(sin(0.06 * blueOpac));
      video.b = getVideo(vec2(x+uv.x-0.001,uv.y+1.0)).z + abs(sin(0.06 * blueOpac));
    	vigAmt = 2.+.1*sin(iTime + 5.*cos(iTime*5.));

    	float vignette = (1.1-vigAmt*(uv.y-.5)*(uv.y-.5))*(0.1-vigAmt*(uv.x-.5)*(uv.x-.5));

      gl_FragColor = mix(video,vec4(noise(uv * 75.)),.05);

      if(curUV.x<0. || curUV.x>1. || curUV.y<0. || curUV.y>1.){
        gl_FragColor = vec4(0.0,0.0,0.0,0.0);
      }

    }
		";
	}
}

/**
 * 对于这个悲催的hscript世界有十分甚至九分有用（狂喜
 * huh？
 * 仅支持vec类型的，比如vec2, vec3, vec4诸如此类
 */
class ShaderVector {
	/**
	 * 父类shader，懂得都懂
	 */
	public var parent:FunkinShader;
	/**
	 * 用于检测vec类型，当值为1时，就是未有出parent里的data匿名结构中的variable类型或者其为null
	 */
	public var count:Int;

	/**
	 * 🐶造史诗级🐶shit...只和德川君做太狡猾了
	 * @param parentShader 父类shadder，方便用于掌控其uniform的值
	 * @param variable parentShader中的data里变量名称，用于懒得讲
	 * @param defaultVariables 给你输入的variable定义初始赋值，是匿名结构
	 */
	public function new(parentShader:FunkinShader, variable:String, ?defaultVariables:{
		var x:Float;
		var y:Float;
		var z:Float;
		var a:Float;
	}) {
		parent = parentShader;
		
		if(parent.data != null && Reflect.hasField(parent.data, variable)) {
			var field = Reflect.field(parent.data, variable);
			
			if(field.value == null && field.type > 4 && field.type < 8) {
				field.value = new Array();
				
				var i:Int = 0;
				
				while(i < field.type - 3) {
					i++;
					
					field.value.push(0.0);
				}
			}
			
			switch(field.type) {
				case ShaderParameterType.FLOAT2:
					this.__interp.variables.set("x", (defaultVariables != null && Reflect.hasField(defaultVariables, "x") ? defaultVariables.x : field.value[0]));
					this.__interp.variables.set("y", (defaultVariables != null && Reflect.hasField(defaultVariables, "y") ? defaultVariables.y : field.value[1]));
					
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "x")) {
						field.value[0] = defaultVariables.x;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "y")) {
						field.value[1] = defaultVariables.y;
					}
					
					count = 2;
				case ShaderParameterType.FLOAT3:
					this.__interp.variables.set("x", (defaultVariables != null && Reflect.hasField(defaultVariables, "x") ? defaultVariables.x : field.value[0]));
					this.__interp.variables.set("y", (defaultVariables != null && Reflect.hasField(defaultVariables, "y") ? defaultVariables.y : field.value[1]));
					this.__interp.variables.set("z", (defaultVariables != null && Reflect.hasField(defaultVariables, "z") ? defaultVariables.z : field.value[2]));
					
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "x")) {
						field.value[0] = defaultVariables.x;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "y")) {
						field.value[1] = defaultVariables.y;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "z")) {
						field.value[2] = defaultVariables.z;
					}
					
					count = 3;
				case ShaderParameterType.FLOAT4:
					this.__interp.variables.set("r", (defaultVariables != null && Reflect.hasField(defaultVariables, "r") ? defaultVariables.r : field.value[0]));
					this.__interp.variables.set("g", (defaultVariables != null && Reflect.hasField(defaultVariables, "g") ? defaultVariables.g : field.value[1]));
					this.__interp.variables.set("b", (defaultVariables != null && Reflect.hasField(defaultVariables, "b") ? defaultVariables.b : field.value[2]));
					this.__interp.variables.set("a", (defaultVariables != null && Reflect.hasField(defaultVariables, "a") ? defaultVariables.a : field.value[3]));
					
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "r")) {
						field.value[0] = defaultVariables.r;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "g")) {
						field.value[1] = defaultVariables.g;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "b")) {
						field.value[2] = defaultVariables.b;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "a")) {
						field.value[3] = defaultVariables.a;
					}
					
					count = 4;
				default:
					#if mobile
						Application.current.window.alert("not support this Type, sorry! qnmd");
					#end
					
					count = 1;
			}
			
			if(count > 1) {
				switch(count) {
					case 2:
						this.__interp.variables.set("set_x", function(val:Float) {
							x = val;
							
							if(field.value[0] != x) {
								field.value.remove(field.value[0]);
								field.value.insert(0, x);
							}
							
		
							return x;
						});
						this.__interp.variables.set("set_y", function(val:Float) {
							y = val;
							
							if(field.value[1] != y) {
								field.value.remove(field.value[1]);
								field.value.insert(1, y);
							}
						
							return y;
						});
					case 3:
						this.__interp.variables.set("set_x", function(val:Float) {
							x = val;
							
							if(field.value[0] != x) {
								field.value.remove(field.value[0]);
								field.value.insert(0, x);
							}
							
		
							return x;
						});
						this.__interp.variables.set("set_y", function(val:Float) {
							y = val;
							
							if(field.value[1] != y) {
								field.value.remove(field.value[1]);
								field.value.insert(1, y);
							}
						
							return y;
						});
						this.__interp.variables.set("set_z", function(val:Float) {
							z = val;
							
							if(field.value[2] != z) {
								field.value.remove(field.value[2]);
								field.value.insert(2, z);
							}
							
		
							return z;
						});
					case 4:
						this.__interp.variables.set("set_r", function(val:Float) {
							r = val;
							
							if(field.value[0] != r) {
								field.value.remove(field.value[0]);
								field.value.insert(0, r);
							}
							
		
							return r;
						});
						this.__interp.variables.set("set_g", function(val:Float) {
							g = val;
							
							if(field.value[1] != g) {
								field.value.remove(field.value[1]);
								field.value.insert(1, g);
							}
						
							return g;
						});
						this.__interp.variables.set("set_b", function(val:Float) {
							b = val;
							
							if(field.value[2] != b) {
								field.value.remove(field.value[2]);
								field.value.insert(2, b);
							}
							
		
							return b;
						});
						this.__interp.variables.set("set_a", function(val:Float) {
							a = val;
							
							if(field.value[3] != a) {
								field.value.remove(field.value[3]);
								field.value.insert(3, a);
							}
			
							return a;
						});
					default:
						Application.current.window.alert("
* 我不知道， 您是如何进行到这一步的
* 但我想说的是
* ......
* 你个肮脏的黑客...
* 不要再让我见到你...
						");
				}
			}
		}
	}
	
	/**
	 * 用过flixel里的FlxPoint吗？用过就行了
	 * @param vx no parsing
	 * @param vy no parsing
	 * @param vz no parsing
	 * @param va no parsing
	 */
	public function set(?vx:Float, ?vy:Float, ?vz:Float, ?va:Float):ShaderVector {
		if(count == 1) return this;
		
		if(count < 4) {
			this.x = vx;
			this.y = vy;

			if(count > 2) {
				this.z = vz;
			}
		}else {
			this.r = vx;
			this.g = vy;
			this.b = vz;
			this.a = va;
		}
	
		return this;
	}
}

__script__.set("ShaderVector", ShaderVector);