function create() {
    rtxLighting.innerShadowColor.set(0.3, 0.6, 0.6, 0.5);
    rtxLighting.satinColor.set(0.5, 0.3, 0.2, 0.6);
    rtxLighting.innerShadowAngle = (Math.PI / 180) * -45;
    rtxLighting.innerShadowDistance = 35;

    camHUD.addShader(rtxLighting.shader);

    boyfriend.shader = rtxLighting.shader;
    gf.shader = rtxLighting.shader;
    dad.shader = rtxLighting.shader;
}

function stepHit(step:Int):Void {
    switch (step) {
        case 683:
            FlxTween.tween(rtxLighting.innerShadowColor, {
                r: 0.8, g: 0.35, b: 0.35, a: 0.5
            }, 65);
            
            FlxTween.tween(rtxLighting.satinColor, {
                r: 0.65, g: 0.3, b: 0.2, a: 0.6
            }, 65);

            FlxTween.tween(rtxLighting, {
                innerShadowAngle: (Math.PI / 180) * -45,
                innerShadowDistance: 35
            }, 65);
    }
}
