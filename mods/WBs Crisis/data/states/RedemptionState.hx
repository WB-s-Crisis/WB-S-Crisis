import funkin.backend.MusicBeatState;
import flixel.FlxObject;
import haxe.io.Path;

var despair:FlxSprite = new FlxSprite();
var spirit:FlxSprite = new FlxSprite();
var rope:FlxSprite = new FlxSprite(0, -450);
var foreverTxt:FlxText = new FlxText(0, 50, FlxG.width, "", 16);
var cnTxt:FlxTxt = new FlxText(0, 50, FlxG.width, "", 16);
var camFollow:FlxObject = new FlxObject();

var defaultCamZoom:Float = 1.0;
var startedSong:Bool = false;
var dang:Bool = false;

var pain:Array<Dynamic> = [
	{content: "救いをもたらす\n将救赎携带而来", time: "16:21"},
	{content: "天上に伸びる蜘蛛の糸\n延伸至天上的蜘蛛之丝", time: "19:05"},
	{content: "掴んだあの人は\n将其抓住的那人", time: "22:52"},
	{content: "地獄へ落ちてった\n向地狱坠落而去了", time: "26:09"},
	{content: "心を蝕んでく\n逐渐侵蚀内心", time: "29:26"},
	{content: "即効性の猛毒が\n立即生效的猛毒", time: "32:42"},
	{content: "もうすぐ蔓延して\n马上就要蔓延开来", time: "35:56"},
	{content: "吸い込んでしまうから\n因为已经吸入体内了啊", time: "39:10"},
	{content: "苦しみが続かないように\n为了使那份痛苦不再延续", time: "42:28"},
	{content: "首を括ったら\n将脖颈勒紧后", time: "49:00"},
	{content: "息を止める\n停止了呼吸", time: "51:56"},
	{content: "拝啓、孤独のションペット\n敬启，孤独中的污物塑料瓶", time: "55:32"},
	{content: "雑菌まみれ生ゴミと埋もれてく\n与长满杂菌的生活垃圾一同埋没", time: "58:28"},
	{content: "茶色く濁った液体が\n混成茶色的液体侵湿", time: "01:02:00"},
	{content: "心写す汚い姿を\n引人注意的污浊", time: "01:04:50"},
	{content: "心労でセルフネグレクト\n在精神疲劳中自我放弃", time: "01:08:34"},
	{content: "無観客の小さな処刑台で\n身处无观众的小处刑台上", time: "01:11:28"},
	{content: "地に足がつかないような\n在脚不着地而忘乎所以的", time: "01:15:04"},
	{content: "気持ちで\n心情之中", time: "01:19:00"},
	{content: "見送って\n目送临终", time: "01:20:00"},
	{content: "踏み出せなかった\n没有能够迈步向前", time: "01:34:42"}
	{content: "未練を手繰りいつまでも\n无论到何时都追忆着依恋", time: "01:37:48"},
	{content: "解けない首輪が\n无法解开的紧绳", time: "01:41:16"},
	{content: "足枷になっていた\n化成双脚的枷锁", time: "01:44:08"},
	{content: "神様がいないって\n神并不存在什么的", time: "01:47:46"},
	{content: "此処が証明してるけど\n虽然在此处就是证明", time: "01:50:38"},
	{content: "どうせいつか死ぬなら\n如果反正有一天会死", time: "01:54:18"},
	{content: "天国がいいでしょう\n那着手去天堂也不错吧", time: "01:57:10"},
	{content: "奈落から連れ出してくれる\n即使带领我走出奈落地狱的", time: "02:00:52"},
	{content: "天使がいなくても救われたくて\n天使并不存在也仍想要得到救赎", time: "02:07:24"},
	{content: "最低な君の方へと\n朝着最坏的你那边", time: "02:13:56"},
	{content: "進む足はまだ震えているけど\n前进的双脚虽说还处于震颤中", time: "02:16:52"},
	{content: "心臓の音が怖くって\n说着害怕心脏的声音", time: "02:20:24"},
	{content: "吐いて、泣いて\n吞吐着，哭泣着", time: "02:23:14"},
	{content: "命綱離して\n放开救生索", time: "02:25:00"},
	{content: "大抵地獄の光景が\n因为地狱中的光景", time: "02:26:58"},
	{content: "巣食う明日なんて見たくないから\n大概就是不想着看到栖居着的明天吧", time: "02:29:58"},
	{content: "もう何も感じなくても\n即使毫无察觉也好", time: "02:33:28"},
	{content: "いいから連れてって\n所以请带我离开这里吧", time: "02:37:20"},
	{content: "鮮やかな光の向こうに\n朝这灿烂光芒的彼端", time: "02:53:06"},
	{content: "一歩踏み出して\n向前方迈出一步", time: "02:59:38"},
	{content: "足場を蹴った\n踢开了立足处", time: "03:02:30"},
	{content: "最低な日々の情景が\n最坏的每一天的情景", time: "03:06:08"},
	{content: "もがき足掻く\n挣扎着，折腾着", time: "03:09:02"},
	{content: "走馬灯も消えてく\n走马灯也逐渐消逝", time: "03:10:38"},
	{content: "もう戻れないけど\n尽管已经无法回头了", time: "03:12:44"},
	{content: "これでいいの\n但那样就好了", time: "03:15:36"},
	{content: "それが答えでしょう\n那就是我的回答了吧", time: "03:17:10"},
	{content: "きっと自らの手を\n一定将自己的双手", time: "03:19:22"},
	{content: "汚し、殺し\n玷污，杀死", time: "03:22:06"},
	{content: "全て諦めたなら\n放弃掉一切的话", time: "03:23:36"},
	{content: "もう何も掴めないから\n因为什么都抓不住了", time: "03:25:44"},
	{content: "宙へとただ浮いてる\n只是朝向半空悬浮着", time: "03:29:38"},
	{content: "拝啓、私の怨念へ\n敬启，致我的怨念", time: "03:32:16"},
	{content: "恨み嫉み苦しく辛い日々は\n憎恨，妒忌，痛苦艰辛的时日中", time: "03:35:12"},
	{content: "救われやしないけど\n虽然说没有得到救赎", time: "03:38:44"},
	{content: "ここで終わり\n但已到此为止", time: "03:41:34"},
	{content: "迎えに行くから\n我会去迎接你的", time: "03:43:14"},
	{content: "もう明日が来なくても\n即使明天已经不会到来了", time: "03:45:20"},
	{content: "ここでいつもずっと待っているから\n我也会在这里一直等待下去，直到永远", time: "03:48:14"},
	{content: "地に足がつかないように\n为能脚不着地地而忘乎所以", time: "03:51:48"},
	{content: "見守ってあげるから\n会向你一直献上关注", time: "03:55:44"},
	{content: "ね～\n呐～", time: "04:01:46"}
];

//var baiqi:FlxSound = FlxG.sound.load();

function new() {
	Conductor.reset();
	Main.instance.framerateSprite.visible = false;
}

function create() {
	FlxG.camera.alpha = 0;
	FlxG.camera.follow(camFollow, null, 1);
	camFollow.setPosition(FlxG.width / 2, FlxG.height / 2);

	MusicBeatState.skipTransIn = true;
	
	pain.sort((left, right) -> {
		return covert(left.time) < covert(right.time);
	});
	
	var fs = new FunkinShader(getShaderCode());
	fs.rzoom = 1.0025;
	fs.gzoom = 0.995;
	FlxG.camera.addShader(fs);
	
	rope.loadGraphic(image("Redemptive-Rope"));
	rope.alpha = 0.5;
	rope.y = -rope.height;
	rope.origin.y = -rope.height / 2.5;
	rope.screenCenter(FlxAxes.X);
	add(rope);

	despair.loadGraphic(image("Depression-Girl"), true, 540, 540);
	despair.antialiasing = Options.antialiasing;
	despair.animation.add("static", [0, 1], 4, true);
	despair.animation.play("static");
	
	despair.setPosition(0, FlxG.height - despair.frameHeight);
	add(despair);
	
	spirit.loadGraphic(image("Suicide-spirite"), true, 540, 540);
	spirit.antialiasing = Options.antialiasing;
	spirit.animation.add("static", [0, 1], 4, true);
	spirit.animation.play("static");
	
	spirit.setPosition(FlxG.width - spirit.frameWidth - 12.5, FlxG.height - spirit.frameHeight - 12.5);
	add(spirit);
	FlxTween.circularMotion(spirit, spirit.x, spirit.y, 25, 0, true, 7.5, true, {type: 2});
	
	foreverTxt.setFormat(font("jp.ttf"), 64, 0xFFFFFFFF, "center");
	add(foreverTxt);
	
	cnTxt.setFormat(Paths.getPath("data/credits/assets/fonts/vcr.TTF"), 64, 0xFFFFFFFF, "center");
	cnTxt.y += foreverTxt.fieldHeight + 35;
	add(cnTxt);
	
	startSong();
}

var holdTime:Float = 0;
function update(elapsed:Float) {
	FlxG.camera.zoom = lerp(FlxG.camera.zoom, defaultCamZoom, 0.05);
	
	for(together in pain) {
		var ts = covert(together.time, 60);
		
		if(Conductor.songPosition >= ts) {
			var separate = together.content.split("\n");
			foreverTxt.text = separate[0];
			cnTxt.text = separate[1];
			pain.remove(together);
		}
		
		break;
	}
	
	if(dang) {
		rope.angle = Math.sin(holdTime) * 2;
		
		holdTime += elapsed;
	}
}

function beatHit(beat:Int) {
	var canZoom:Bool = beat > 3 && !(beat > 39 && beat < 70) && !(beat > 101 && beat < 120) && !(beat >= 228 && beat <= 236) && !(beat >= 292 && beat < 308) && !(beat >= 418 && beat < 450) && !(beat >= 638);
	if(startedSong && canZoom) {
		FlxG.camera.zoom += 0.025;
	}
	
	switch(beat) {
		case 4:
			FlxG.camera.alpha = 1;
			foreverTxt.text = "Music: Pepoyo";
			FlxTween.tween(rope, {y: rope.y + (rope.height - 100) / 3}, Conductor.stepCrochet * 3 / 1000, {ease: FlxEase.backOut});
		case 5:
			foreverTxt.text = "Music: Pepoyo
歌：初音ミク";
			FlxTween.tween(rope, {y: rope.y + (rope.height - 100) / 3}, Conductor.stepCrochet * 3 / 1000, {ease: FlxEase.backOut});
		case 6:
			FlxTween.tween(rope, {y: rope.y + (rope.height - 100) / 3}, Conductor.stepCrochet * 3 / 1000, {ease: FlxEase.backOut});
			foreverTxt.text = "Music: Pepoyo
歌：初音ミク
移植：本廢物（打不了簡體字）";
		case 7:
			FlxG.camera.alpha = 0;
		case 8:
			dang = true;
			FlxG.camera.alpha = 1;
			foreverTxt.text = "若侵則刪";
		case 130 | 197 | 320 | 386:
			foreverTxt.text = "";
			cnTxt.text = "";
			FlxG.camera.alpha = 0;
		case 135 | 228 | 324 | 418:
			FlxG.camera.alpha = 1;
		case 592:
			FlxTween.tween(foreverTxt, {alpha: 0}, Conductor.crochet * 2 / 1000);
			FlxTween.tween(cnTxt, {alpha: 0}, Conductor.crochet * 2 / 1000);
		case 638:
			FlxTween.tween(FlxG.camera, {alpha: 0}, Conductor.crochet * 4 / 1000);
		default: {}
	}
}

function startSong() {
	//baiqi.onComplete = endSong;
	CoolUtil.playMusic(music("Baiqi"), false, 1, true, 145);
	FlxG.sound.music.onComplete = endSong;
	//FlxG.sound.music.play();
	
	startedSong = true;
}

function endSong() {
	MusicBeatState.skipTransIn = false;
	if(Reflect.hasField(data, "lastState") && data.lastState != null) FlxG.switchState(Type.createInstance(data.lastState, []));
	else FlxG.switchState(new MainMenuState());
	Main.instance.framerateSprite.visible = false;
}

function postUpdate(elapsed:Float) {
	for(forever in [despair, spirit])
	if(forever.animation.curAnim.curFrame == 1) {
		forever.offset.x = -3;
	}else {
		forever.offset.x = 0;
	}
}

function covert(str:String, fr:Int = 60) {
	var data = [];
	for(sb in str.split(":")) {
		data.push(Std.parseFloat(StringTools.trim(sb)));
	}
	
	var result:Float = 0;
	for(i=>c in data) {
		var li = data.length - i - 2;
		if(i < data.length - 2) {
			result += (c % 60) * Math.pow(60, li);
		}else if(i == data.length - 1) {
			result += (c % fr) / fr;
		}else {
			result += c;
		}
	}
	
	return result * 1000;
}

function image(path:String) {
	return Paths.getPath("data/credits/redemption/images/" + Path.withoutExtension(path) + ".png");
}

function music(path:String) {
	return Paths.getPath("data/credits/redemption/music/" + Path.withoutExtension(path) + ".ogg");
}

function font(path:String) {
	return Paths.getPath("data/credits/redemption/fonts/" + path);
}

function getShaderCode() {
	return "
#pragma header

uniform vec2 redOff;
uniform vec2 greenOff;
uniform vec2 blueOff;
uniform float rzoom;
uniform float gzoom;

void main()
{
	vec2 uv = getCamPos(openfl_TextureCoordv);
	vec4 col;
	col.r = textureCam(bitmap, (uv * rzoom + redOff)).r;
	col.g = textureCam(bitmap, uv * gzoom + greenOff).g;
	col.b = textureCam(bitmap, uv + blueOff).b;
	col.a = texture2D(bitmap, openfl_TextureCoordv).a;

	gl_FragColor = col;
}";
}

/*
垂下蛛丝纤细不堪 神说引导罪人坠入深渊
*/