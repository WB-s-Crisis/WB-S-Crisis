/**
 * 主播主播😥
 * 你的杨戬确实很强😋
 * 但还是太吃操作了🤢
 * 有没有更加简单又强势的英雄推荐一下呢😗
 * ......
 * 有的兄弟，有的😋
 * 这么强的英雄当然不止一个啦🐵
 * 一共有9位...👺
 * 都是当前版本T0.5的强势英雄，兄弟👾
 * 掌握一到两个的牢铁们上个荣耀白金小标都是没问题的😋
 * 如果能掌握一半以上的牢铁们，英雄的话
 * 打个巅峰巅峰前百前十都是相当轻松的😋
 */

var tomStuffix:Array<String> = ["tom", "tom1-3"];
var bugRabbitStuffix:Array<String> = ["Looney Tunes"];

var brBaseDrain:Float;
var brCacheTime:Float = Conductor.crochet / 950;
var brCacheAmout:Float = 0.00075;
var brSustainAmout:Float = 0;
var brSustainTime:Null<Float>;
var brPressing = false;
var brFinishing = false;
function create() {
	if(bugRabbitStuffix.contains(strumLines.members[0].characters[0].curCharacter)) {
		brBaseDrain = switch(SONG.meta.name.toLowerCase()) {
			case "unprovoked": 0.005;
			case "hunt and kill": 0.01;
			case "last life": 0.001;
			default: 0.001;
		};
		
		brCacheAmout = switch(SONG.meta.name.toLowerCase()) {
			case "unprovoked": 0.0005;
			case "last life": 0.002;
			default: 0.00075;
		};
	}

	strumLines.members[0].onHit.add(function(event) {
		if(tomStuffix.contains(strumLines.members[0].characters[0].curCharacter)) {
			var drain:{var max:Float; var min:Float;} = switch(SONG.meta.name.toLowerCase()) {
    			case "friendship broken": {max: 0.03, min: 0.007};
    			case "bloody scissors": {max: 0.045, min: 0.005};
    			case "he died unjustly" | "cruel cartoon": {max: 0.07, min: 0.01};
    			case "cruel cartoon erect": {max: 0.15, min: 0};
    			case "blood dispute": {max: 0.1, min: 0};
    			default: {max: 0, min: 0};
			};
	
			health -= (((drain.max - drain.min) / maxHealth) * health);
		}
		
		if(bugRabbitStuffix.contains(strumLines.members[0].characters[0].curCharacter)) {
			var curDrain:Float = brBaseDrain + brSustainAmout;
			health -= (health > curDrain + 0.000001 ? brBaseDrain + brSustainAmout : 0);
		
			if(!event.note.isSustainNote) {
				brSustainTime = brCacheTime;
				brPressing = true;
			}
			
			if(brPressing)
				brSustainAmout += brCacheAmout;
		}
	});
}

function update(elapsed:Float) {
	if(brBaseDrain != null && brPressing && brSustainTime != null) {
		if(brSustainTime <= 0) {
			brFinishing = true;
		}
	
		brSustainTime -= elapsed;
		if(brFinishing) {
			brPressing = false;
			brSustainTime = null;
			brFinishing = false;
			brSustainAmout = 0;
		}
	}
}

// 2 => 0.0
// 0 => 0.005

// 2*k + b = 0.05;
// b = 0.005
// 2k + 0.005 = 0.05
// 2k = 0.045
// k = 0.995 / 2