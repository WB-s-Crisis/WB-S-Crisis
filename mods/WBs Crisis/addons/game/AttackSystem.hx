import Reflect;
import flixel.util.FlxDestroyUtil;

class AttackSystem extends FlxBasic {
	/**
	 * 反应时间
	 */
	public var reactionTime:Float;
	/**
	 * 类似FlxTween.tween的startDelay，预计几秒开启机制
	 */
	public var delayTime:Float;
	/**
	 * 用于对于反应时间时所做所为来判断下一次行动会是如何的
	 */
	public var scoutCallback:Float->Float->Bool = null;
	
	public var loading:Bool;
	public var access:Bool;
	public var prevStarted:Bool;
	public var requestedScout:Bool;
	public var finished:Bool;
	
	public var readyTimer:Float;
	
	public var callbacks:Map<String, Array<AttackSystem->Void>>;
	
	/**
	 * 用于在反应时间进行显示警告，预制贴图可以在new构造函数的输入函数中启用
	 */
	public var warningLabel:FunkinSprite;
	
	/**
	 * 构造函数，懒得说
	 * @param CreateCallback 用于对warningLabel的初始化修改
	 */
	public function new(?CreateCallback:FunkinSprite->Void) {
		super();
		
		//一辈子都信不得啊，唉
		initVars();
	
		warningLabel = new FunkinSprite();
		if(CreateCallback != null && Reflect.isFunction(CreateCallback))
			CreateCallback(warningLabel);
		else {
			warningLabel.visible = false;
		}
	}
	
	/**
	 * 躲避事件主要执行者，如果有另一样躲避事件执行，它会选择回避，并返回false
	 * @param ReactionTime 给予初始的反应时间（单位为s）
	 * @param ScoutCallback 用于侦测来决定下一次行动的调用，如果为不为函数，执行会作废并返回false
	 * @param DelayTine 延长启动执行的时间，类似FlxTween的startDelay，dddd（单位为s）
	 * @return 返回布尔值，如果为false，说明执行失败，否则执行成功
	 */
	public function dispatch(ReationTime:Float, ScoutCallback:Void->Bool, ?DelayTime:Float):Bool {
		if(!active || !exists) return false;
		if(loading || access || readyTimer > 0.0) return false;
	
		if(ScoutCallback != null && Reflect.isFunction(ScoutCallback)) {
			scoutCallback = ScoutCallback;
		}else {
			return false;
		}
	
		loading = true;
		prevStarted = true;
		requestedScout = true;
		reactionTime = ReationTime;
		
		if(DelayTime != null)
			delayTime = DelayTime;
		
		return true;
	}
	
	/**
	 * 添加相关的调用
	 * @param type 指定需要的目标调用，例如"failed", "success"啥的，若输入其他的，将会一例进入"垃圾桶里"，并将在这次执行事件完成后废掉
	 * @param callback 需添加的调用函数，若不是函数，执行作废
	 */
	public function add(type:String, callback:Void->Void) {
		switch(type.toLowerCase()) {
			case "reaction" | "reaction_update" | "success" | "failed" | "finished":
				if(Reflect.isFunction(callback))
					callbacks.get(type.toLowerCase() + "Callback").push(callback);
			default:
				if(Reflect.isFunction(callback))
					callbacks.get("dumbCallback").push(callback);
		}
	}
	
	/**
	 * 移除对应目标的调用（没啥卵用）
	 * @param type 懒得说
	 * @param callback 移除选定的调用函数，如果存在的话
	 */
	public function remove(type:String, callback:Void->Void) {
		if(callbacks.exists(type.toLowerCase() + "Callback")) {
			if(callbacks.get(type.toLowerCase() + "Callback").contains(callback)) {
				callbacks.get(type.toLowerCase() + "Callback").remove(callback);
			}
		}
	}
	
	/**
	 * 移除对应目标的所有调用
	 * @param type 懒得说
	 */
	public function removeAll(type:String) {
		if(callbacks.exists(type.toLowerCase() + "Callback")) {
			while(callbacks.get(type.toLowerCase() + "Callback").length > 0) {
				callbacks.get(type.toLowerCase() + "Callback").pop();
			}
		}
	}
	
	public override function update(elapsed:Float) {
		super.update(elapsed);
		
		if(!exists || !active) return;
		
		updateLabel(elapsed);
		
		if(loading) {
			if(readyTimer > delayTime * 1000 && readyTimer < reactionTime * 1000) {
				if(prevStarted) {
					startReaction();
				}
				
				if(callbacks.get("reaction_updateCallback").length > 0)
					for(k=>func in callbacks.get("reaction_updateCallback")) {
						func(this, elapsed);
					}
				
				sustainReaction(elapsed, readyTimer);
			}else if(readyTimer >= reactionTime * 1000) {
				executeBranch();
				finished = true;
			}
		
			readyTimer += elapsed * 1000;
			
			if(finished) {
				finish();
				finished = false;
			}
		}
	}
	
	public function startReaction() {
		if(callbacks.get("reactionCallback").length > 0) {
			for(k=>func in callbacks.get("reactionCallback")) {
				func(this);
			}
		}
		
		prevStarted = false;
	}
	
	public function sustainReaction(elapsed:Float, timer:Float) {
		if(!requestedScout) return;
	
		if(scoutCallback(timer, reactionTime) == true) {
			access = true;
			requestedScout = false;
		}
	}
	
	public function executeBranch() {
		if(access) {
			if(callbacks.get("successCallback").length > 0)
				for(k=>func in callbacks.get("successCallback")) {
					func(this);
				}
		}else {
			if(callbacks.get("failedCallback").length > 0)
				for(k=>func in callbacks.get("failedCallback")) {
					func(this);
				}
		}
	}
	
	public function finish() {
		removeAll("dumb");
		
		loading = false;
		access = false;
		scoutCallback = null;
		readyTimer = 0.0;
		
		if(callbacks.get("finishedCallback").length > 0)
			for(k=>func in callbacks.get("finishedCallback"))
				func(this);
	}
	
	public override function draw() {
		super.draw();
		
		var prevDefaultCameras:Array<FlxCamera> = FlxCamera._defaultCameras;
		if(_cameras != null)
			FlxCamera._defaultCameras = _cameras;
		
		drawLabel();
		
		FlxCamera._defaultCameras = prevDefaultCameras;
	}
	
	public override function destroy() {
		super.destroy();
		
		FlxDestroyUtil.destroy(warningLabel);
		for(key in callbacks.keys())
			removeAll(key);
		
		if(scoutCallback != null)
			scoutCallback = null;
	}
	
	public function drawLabel() {
		if(warningLabel.visible && warningLabel.exists && warningLabel.active)
			warningLabel.draw();
	}
	
	public function updateLabel(elapsed:Float) {
		if(warningLabel.active && warningLabel.exists) warningLabel.update(elapsed);
	}
	
	public function initVars() {
		readyTimer = 0.0;
		reactionTime = 0.0;
		delayTime = 0.0;
		
		loading = false;
		access = false;
		prevStarted = false;
		requestedScout = false;
		finished = false;
		
		callbacks = [
			"reactionCallback" => [],
			"reaction_updateCallback" => [],
			"successCallback" => [],
			"failedCallback" => [],
			"finishedCallback" => [],
			"dumbCallback" => []
		];
	}
}