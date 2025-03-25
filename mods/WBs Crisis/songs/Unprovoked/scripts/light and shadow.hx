function create() {
	rtxLighting.innerShadowColor.set(0.8, 0.35, 0.35, 0.5);
	rtxLighting.satinColor.set(0.65, 0.3, 0.2, 0.75);
	rtxLighting.innerShadowAngle = (Math.PI / 180) * -45;
	rtxLighting.innerShadowDistance = 35;
	boyfriend.shader = rtxLighting.shader;
	gf.shader = rtxLighting.shader;
	dad.shader = rtxLighting.shader;
}