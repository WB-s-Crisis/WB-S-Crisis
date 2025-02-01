import Array;

import openfl.Assets;
import openfl.display.ShaderParameterType;

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
 * 这里不得不列举@橘子整的转场必备shader
 */
class Trans extends FlxBasic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var apply:Float;
	
	public function new() {
		shader = new FunkinShader(this.shaderCode);
		
		apply = 0.;
		shader.apply = apply;
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
	public function new(texPath:String) {
		shader = new FunkinShader(this.shaderCode);
		
		iTime = 0.;
		alphaNoise = 1;
		blueOpac = 0;
		redOpac = 0.;
		glitchModifier = 0;
		
		if(Assets.exists(texPath))
			noiseTex = Assets.getBitmapData(texPath);
		
		shader.iTime = iTime;
		shader.alphaNoise = alphaNoise;
		shader.blueOpac = blueOpac;
		shader.redOpac = redOpac;
		shader.glitchModifier = glitchModifier;
		
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
					this.__interp.variables.set("r", (defaultVariables != null && Reflect.hasField(defaultVariables, "r") ? defaultVariables.x : field.value[0]));
					this.__interp.variables.set("g", (defaultVariables != null && Reflect.hasField(defaultVariables, "g") ? defaultVariables.y : field.value[1]));
					this.__interp.variables.set("b", (defaultVariables != null && Reflect.hasField(defaultVariables, "b") ? defaultVariables.z : field.value[2]));
					this.__interp.variables.set("a", (defaultVariables != null && Reflect.hasField(defaultVariables, "a") ? defaultVariables.a : field.value[3]));
					
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "x")) {
						field.value[0] = defaultVariables.x;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "y")) {
						field.value[1] = defaultVariables.y;
					}
					if(defaultVariables != null && Reflect.hasField(defaultVariables, "z")) {
						field.value[2] = defaultVariables.z;
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