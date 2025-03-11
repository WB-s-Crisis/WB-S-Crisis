import haxe.crypto.Base64;
import lime.media.AudioBuffer;
import openfl.display.BitmapData;
import haxe.io.Bytes;
import haxe.io.Path;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import openfl.display.PNGEncoderOptions;
import sys.io.File;
import sys.FileSystem;

/**
 * 由你爷爷的二舅的隔壁老王的爸爸的叔叔的不认识的路人的婶婶的孙子的我不知道从哪儿滚来的人抽风写出来的屎代码
 * ..................................................................................................
 * 🌑🌑🌑🌑🌑🌖🌔🌑🌑🌑🌑🌑
 * 🌑🌑🌑🌑🌒🌖🌔🌘🌑🌑🌑🌑
 * 🌑🌑🌑🌑🌓🌖🌔🌗🌑🌑🌑🌑
 * 🌑🌑🌑🌑🌓🌖🌔🌗🌑🌑🌑🌑
 * 🌑🌑🌑🌑🌔🌖🌔🌖🌑🌑🌑🌑
 * 🌑🌑🌑🌒🌕🌖🌔🌕🌘🌑🌑🌑
 * 🌑🌑🌑🌔🌕🌖🌔🌕🌖🌑🌑🌑
 * 🌑🌎🌕🌕🌕🌖🌔🌕🌕🌕🌎🌑
 * 🌎🌎🌕🌕🌕🌖🌔🌕🌕🌕🌎🌎
 * 🌎🌎🌎🌕🌕🌑🌑🌕🌕🌎🌎🌎
 * 🌎🌎🌎🌎🌑🌑🌑🌑🌎🌎🌎🌎
 * ..................................................................................................
 * 求佛祖保佑我别再给我报错啦！！！！！！😭😭😭😭😭
 * ..................................................................................................
 * 测试时：
 * ```haxe
 * var testSound:FlxSound;
 * 
 * function create() {
 * 	testSound = FlxG.sound.load(cryptoTools.base64.getSound(Paths.sound("easterEgg/jumpScared2")));
 * }
 *
 * function onSongStart() {
 * 	testSound.play();
 * 	//此时一段没好的音效传来......
 * }
 * ```
 */

public static var cryptoTools = null;

function new() {
	cryptoTools = {
		base64: {
			getBitmapData: getBase64BitmapData,
			getSound: getBase64Sound,
			exportAudioBuffer: exportBase64AudioBuffer,
			exportBitmapData: exportBase64BitmapData
		}
	};
}

/**
 * 通过路径获取位图数据，记住路劲最后的文件得是真实文件名字解密后的名字（base64）
 * @param path 你的图片路径
 * @return 在不出错的情况下，将会返回openfl.display.BitmapData的类实例化（FlxG.bitmap.add()效果最佳），否则为null
 */
function getBase64BitmapData(path:String) {
	var getCryptoName = Base64.encode(Bytes.ofString(Path.withoutDirectory(path)));
	var realPath = Path.directory(path) + (StringTools.endsWith(Path.directory(path), "/") ? "" : "/") + getCryptoName;
	if(!Assets.exists(realPath)) {
		debugPrint("not exist path:" + path + "(realPath:" + realPath + ")", {delayTime: 3.5, style: 0xFFFF0000});
		return null;
	}
	
	var jerryBitmapData = BitmapData.fromBase64(Assets.getText(realPath), "image/" + Path.extension(path));
	if(jerryBitmapData == null) {
		debugPrint("BITMAPDATA ERROR: try to get text from path:" + path + "(realPath:" + realPath + ") | failed!", {delayTime: 3.5, style: 0xFFFF0000});
		return null;
	}else {
		return jerryBitmapData;
	}
}

/**
 * 通过路径获取音频数据，记住路径最后的文件得是真实文件名字解密后的名字（base64）
 * @param path 你的音频路径
 * @return 如果不出错的话，返回openfl.media.Sound的类实例化（可以通过使用FlxG.sound.load()来直接使用），否则结果为null
 */
function getBase64Sound(path:String) {
	var getCryptoName = Base64.encode(Bytes.ofString(Path.withoutDirectory(path)));
	var realPath = Path.directory(path) + (StringTools.endsWith(Path.directory(path), "/") ? "" : "/") + getCryptoName;
	if(!Assets.exists(realPath)) {
		debugPrint("not exist path:" + path + "(realPath:" + realPath + ")", {delayTime: 3.5, style: 0xFFFF0000});
		return null;
	}
	
	var jerryAB = AudioBuffer.fromBase64(Assets.getText(realPath));
	if(jerryAB == null) {
		debugPrint("AUDIOBUFFER ERROR: try to get text from path:" + path + "(realPath:" + realPath + ") | failed!", {delayTime: 3.5, style: 0xFFFF0000});
		return null;
	}
	var jerrySound = Sound.fromAudioBuffer(jerryAB);
	return jerrySound;
}

/**
 * 通过路径加密音频并导出成加密的文件，导出的文件名字是原本选定文件的名字加密（base64）
 * @param path 需要加密音频的文件
 * @param target 目标目录，如果为null值或不输入，默认目标位置是游戏文件根目录
 */
function exportBase64AudioBuffer(path:String, ?target:String) {
	if(!Assets.exists(path)) {
		debugPrint("not exist path:" + path, {delayTime: 3.5, style: 0xFFFF0000});
		return;
	}
	
	var jerry = Assets.getBytes(path);
	if(jerry == null) {
		debugPrint("loading rawPath:" + path + " | failed", {delayTime: 3.5, style: 0xFFFF0000});
		return;
	}
	var crypto = Base64.encode(jerry);
	if(target != null && !FileSystem.exists(target)) FileSystem.createDirectory(target);
	File.saveContent((target != null ? (StringTools.endsWith(target, "/") ? target : target + "/") : "") + Base64.encode(Bytes.ofString(Path.withoutDirectory(path))), crypto);
}

/**
 * 通过路径加密图片并导出成加密的文件，导出的文件名字是原本选定文件的名字加密（base64）
 * @param path 需要加密图片的文件
 * @param target 目标目录，如果为null值或不输入，默认目标位置是游戏文件根目录
 */
function exportBase64BitmapData(path:String, ?target:String) {
	if(!Assets.exists(path)) {
		debugPrint("not exist path:" + path, {delayTime: 3.5, style: 0xFFFF0000});
		return;
	}

	var jerry = Assets.getBitmapData(path, false);
	if(jerry == null) {
		debugPrint("rawPath:" + path + " | was not image", {delayTime: 3.5, style: 0xFFFF0000});
		return;
	}
	var bytes = jerry.encode(new Rectangle(0, 0, jerry.width, jerry.height), new PNGEncoderOptions());
	var crypto = Base64.encode(bytes);
	if(target != null && !FileSystem.exists(target)) FileSystem.createDirectory(target);
	File.saveContent((target != null ? (StringTools.endsWith(target, "/") ? target : target + "/") : "") + Base64.encode(Bytes.ofString(Path.withoutDirectory(path))), crypto);
}