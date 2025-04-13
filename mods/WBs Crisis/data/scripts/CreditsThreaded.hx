import sys.thread.Mutex;
import openfl.display.BitmapData;

var mutex = new Mutex();

function onLoad(length:Int) {
	var i = 0;
	while(i < length) {
		var sb = parseCreditsFromDirectory(optionStuffixList[i]);
		
		//huh？加载失败？直接给我回炉重造！！！
		if(sb == null) continue;
		
		stuffixData.push(sb);

		var dir = optionStuffixList[i];

		if(Assets.exists(imagePath("stuffix/" + dir + "/icon"))) {

			mutex.tryAcquire();
			
			var assetsBD = Assets.getBitmapData(imagePath("stuffix/" + dir + "/icon"));
			var bd = null;

			if(assetsBD != null) {
				bd = new BitmapData(assetsBD.width, assetsBD.height, true, 0x00000000);
				bd.draw(assetsBD);
			}else bd = new BitmapData(150, 150, true, 0xFF000000);
		
			if(!Reflect.hasField(stuffixData[i], "color") || stuffixData[i].color == null) {
				var newColor = BitmapUtil.getMostPresentSaturatedColor(bd);
				Reflect.setField(stuffixData[i], "color", newColor);
			}
		
			if(Reflect.hasField(stuffixData[i], "maskIcon") && stuffixData[i].maskIcon) {
				var maskBd = new BitmapData(bd.width, bd.height, true, 0x00000000);
				var shape = new Shape();
				shape.graphics.beginFill(0xFF00FF00);
				shape.graphics.drawCircle(maskBd.width / 2, maskBd.height / 2, ((maskBd.width + maskBd.height) / 2) / 2);
				shape.graphics.endFill();
				maskBd.draw(shape);
			
				bd.copyChannel(maskBd, new Rectangle(0, 0, bd.width, bd.height), new Point(), 8, 8);
			}
		
			graphicCache.cacheGraphic(FlxG.bitmap.add(bd));
			
			mutex.release();
		}
	
		i++;
		loadedAmout++;
	}
}

function destroy() {
	mutex = null;
}