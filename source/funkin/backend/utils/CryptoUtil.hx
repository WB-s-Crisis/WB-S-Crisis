package funkin.backend.utils;

#if ALLOW_CRYPTO
import com.hurlant.util.*;
#end

class CryptoUtil {
	//暂时只进行base64加密
	public inline static function convertByteToBase64(beep:haxe.io.Bytes):String {
		#if ALLOW_CRYPTO
		return Base64.encodeByteArray(beep);
		#end
		return null;
	}

	//openfl和hurlant都玩的太抽象了，只能这么干了
	public inline static function convertBase64ToByte(c:String):haxe.io.Bytes {
		#if ALLOW_CRYPTO
		return Base64.decodeToByteArray(c);
		#end
		return null;
	}

	public inline static function convertStringToBase64(c:String):String {
		#if ALLOW_CRYPTO
		return Base64.encode(c);
		#end
		return null;
	}

	public inline static function convertBase64ToString(c:String):String {
		#if ALLOW_CRYPTO
		return Base64.decode(c);
		#end
		return null;
	}
}
