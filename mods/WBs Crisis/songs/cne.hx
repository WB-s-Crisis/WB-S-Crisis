//此脚本用于放置某些公立的东西，
import funkin.backend.scripting.addons.AddonsManager;

public static var deadState:Bool;

public var camOther:FlxCamera;

public var cpuControlled:Bool = false;
public var cameraMovementChanged:Bool = false;

function new() {
	PauseSubState.script = "data/scripts/pause";
	camOther = new FlxCamera();
	camOther.bgColor = 0;
	
	FlxG.cameras.add(camOther, false);
	FlxG.mouse.visible = false;
}

/**
 * ⠀⠀⠀⠀⠀⠀⠀ ⠾⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠷⠄
 * ⠀⠀⠀⠀⠀⠀  ⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠇
 * ⠀⠀⠀⠀⠀⠀ ⠿⠛⠉⠉⠉⠻⠿⠿⠟⠉⠉⠉⠛⠿⠇
 * ⠀⠀⠀⠀⠀⠀ ⠿⠀⠀⠶⠀⠸⠿⠿⠇ 🌎   ⠇
 * ⠀⠀⠀⠀⠀⠀⠀⠻⠶⠤⠤⠠⠿⠃⠘⠿⠄⠤⠤⠶⠟
 * ⠀⠀⠀⠀⠀⠀⠀⠾⠿⠙⠶⠿⠿⠤⠤⠿⠿⠶⠏⠻⠷
 * ⠀⠀⠀⠀⠀⠀⠀⠻⠶⠜⠰⠭⠩⠍⠭⠍⠭⠱⠠⠶⠟
 * ⠀⠀⠀⠀⠠⠶⠦⠈⠻⠿⠶⠭⠘⠃⠛⠃⠫⠴⠿⠟⠡⠾⠟⠂
 * ⠀⠀⠀⠀⠊⠉⠛⠳⠦⠈⠉⠛⠛⠛⠛⠛⠛⠉⠁⠠⠿⠋⠀⠱⠄
 * ⠀⠀⠀⠔⠀⠀⠄⠀⠉⠳⠦⠄⠳⠶⠶⠃⠠⠤⠞⠛⠁⠠⠂⠀⠙⠄
 * ⠀⠀⠎⠀⠀⠀⠇⠀⠀⠸⠀⠏⠠⠭⠍⠈⠏⠇⠀⠀⠀⠼⠀⠀⠀⠙⠆
 * ⠀⠼⠀⠀⠀⠀⠷⠔⠒⠚⠍⠣⠸⠿⠿⠸⠋⠇⠠⠴⠚⠹⠀⠀⠀⠀⠻
 * ⠀⠻⠄⠀⠀⠰⠁⠀⠀⠀⠗⠹⠸⠿⠿⠸⠉⠇⠇⠀⠀⠈⠇⠀⠀⠀⠸
 * ⠀⠀⠙⠦⠄⠸⠀⠀⠀⠀⠱⠹⠸⠿⠿⠸⠹⠜⠀⠀⠀⠀⠇⠀⠀⠴⠋
 * ⠀⠀⠀⠈⠃⠼⠶⠄⠀⠀⠸⠾⠶⠒⠒⠚⠾⠤⠤⠤⠤⠾⠃⠶⠊⠁
 * ⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉
 * ⠀⠀⠀⠀⠀⠀⠔⠀⠶⠀⠀⠀⠀⠀⠀⠀⠀⠸⠇⠀⠀⠣
 * ⠀⠀⠀⠀⠀⠀⠇⠸⠇⠀⠀⠀⠀⠎⠆⠀⠀⠸⠧⠀⠀⠸
 * ⠀⠀⠀⠀⠀⠰⠁⠾⠁⠀⠀⠀⠠⠇⠱⠀⠀⠸⠿⠀⠀⠀⠇
 * ⠀⠀⠀⠀⠀⠸⠀⠿⠀⠀⠀⠀⠸⠀⠸⠀⠀⠀⠿⠀⠀⠀⠇
 * ⠀⠀⠀⠀⠀⠈⠉⠉⠒⠒⠒⠒⠊⠀⠈⠒⠒⠒⠛⠓⠊⠉⠁
 * ⠀⠀⠀⠀⠠⠶⠶⠤⠲⠶⠀⠀⠀⠀⠀⠀⠠⠷⠶⠶⠂⠤⠶⠦⠄
 * ⠀⠀⠀⠀⠿⠿⠿⠿⠧⠩⠄⠀⠀⠀⠀⠀⠬⠭⠭⠱⠿⠿⠿⠿⠟﻿
 * ......
 * （你将会横尸遍野）
 */
function onNextSong() {
	if(PlayState.isStoryMode) {
		if(PlayState.storyPlaylist.length < 1) {
			if(gameSaver.passedWeeks.contains(PlayState.storyWeek)) return;
			gameSaver.passedWeeks.push(PlayState.storyWeek);
			for(sb in PlayState.storyWeek.songs) 
				if(!gameSaver.passedSongs.contains(sb.name))
					gameSaver.passedSongs.push(sb.name);
			
			//不这样是存不了的，因为没有赋值，所以调用不了set_passedWeeks
			gameSaver.passedWeeks = gameSaver.passedWeeks;
			gameSaver.passedSongs = gameSaver.passedSongs;
		}
	}else {
		if(gameSaver.passedSongs.contains(SONG.meta.name)) return;
		for(gs in gameSaver.passedWeeks) {
			if(gs.name == SONG.meta.name) {
				return;
			}
		}
		gameSaver.passedSongs.push(SONG.meta.name);
		
		gameSaver.passedSongs = gameSaver.passedSongs;
	}
	
	//测试的
	gameSaver.forTest = !gameSaver.forTest;
	gameSaver.save();
}

function onGameOver(event) {
	if(deadState == null || deadState == false)
		deadState = true;
	
	for(sb in FlxG.cameras.list) {
		if(sb._filters != null && sb._filters.length > 1)
			sb._filters = [];
	}
}

public function changeHealthBarColor(empty:FlxColor, filled:FlxColor) {
	if(healthBar == null) return;
	
	healthBar.createFilledBar(empty, filled);
	
	//百分比更新，不然这辈子都有了
	healthBar.percent = health * 100 / 2;
}

function postUpdate(elapsed) {
	if(cameraMovementChanged)
		cameraMoveMentChanged = false;
}