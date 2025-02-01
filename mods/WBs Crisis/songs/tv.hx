importAddons("shader.OldTV");

var tvShader:OldTV;

function create() {
	tvShader = new OldTV(Paths.image("noise"));
	tvShader.blueOpac = 1;
	add(tvShader);
	
	camGame.addShader(tvShader.shader);
}