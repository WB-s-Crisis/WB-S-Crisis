/*import funkin.backend.shaders.CustomShader;*/
import hscript.IHScriptCustomBehaviour;

importAddons("shader.OldTV");
importAddons("shader.GLITCH");
importAddons("shader.Chromatic");
importAddons("shader.RTXLighting");

public var tvShader:OldTV;
public var glitch:GLITCH;
public var chromatic:Chromatic;
public var rtxLighting:RTXLighting = new RTXLighting();

function create() {
	tvShader = new OldTV();
	tvShader.blueOpac = 1.3;
	tvShader.redOpac = 0.15;
	camGame.addShader(tvShader.shader);
	add(tvShader);
	
	glitch = new GLITCH();
	camGame.addShader(glitch.shader);
	add(glitch);
	
	chromatic = new Chromatic();
	chromatic.aberration = -0.02;
	camGame.addShader(chromatic.shader);
	camHUD.addShader(chromatic.shader);
}