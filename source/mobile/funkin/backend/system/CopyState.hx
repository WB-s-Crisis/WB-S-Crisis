/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package mobile.funkin.backend.system;

#if mobile
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;
import flixel.addons.util.FlxAsyncLoop;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import openfl.utils.ByteArray;
import haxe.io.Path;
import mobile.funkin.backend.utils.MobileUtil;
import funkin.backend.assets.Paths;
import funkin.backend.utils.NativeAPI;
import funkin.backend.system.Main;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar.FlxBarFillDirection;

#if ALLOW_MULTITHREADING
import lime.system.ThreadPool;
#end

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

/**
 * ......
 * 老样子，我进行了一点小小的修改，用于方便对某些事物进行道光（是这么回事的哦）
 * @editor: VapireMox
 * ...
 * @author: Karim Akra
 */
class CopyState extends funkin.backend.MusicBeatState
{
	private static final textFilesExtensions:Array<String> = ['ini', 'txt', 'xml', 'hxs', 'hx', 'lua', 'json', 'frag', 'vert'];
	public static final IGNORE_FOLDER_FILE_NAME:String = "CopyState-Ignore.txt";
	private static var directoriesToIgnore:Array<String> = [];
	public static var locatedFiles:Array<String> = [];
	public static var maxLoopTimes:Int = 0;

	public var loadingImage:FlxSprite;
	public var loadingBar:FlxBar;
	public var loadedText:FlxText;
	public var copyLoop:FlxAsyncLoop;
	public var threadPool:#if ALLOW_MULTITHREADING ThreadPool #else Dynamic #end;

	var failedFilesStack:Array<String> = [];
	var failedFiles:Array<String> = [];
	var shouldCopy:Bool = false;
	var canUpdate:Bool = true;
	var loopTimes:Int = 0;
	
	var currentLoadFile:String;

	override function create()
	{
		locatedFiles = [];
		maxLoopTimes = 0;
		checkExistingFiles();
		if (maxLoopTimes <= 0)
		{
			FlxG.resetGame();
			return;
		}

		lime.app.Application.current.window.alert("你似乎丢失了启动游戏时必要的文件\n请按下\"OK\"以来复制必要的文件\n(Seems like you have some missing files that are necessary to run the game)\n(Press OK to begin the copy process)\n\n\n（或者说是你个貂毛压根啥文件没丢失，就是第一次下载了而已>:[）", "注意(Notice)");

		shouldCopy = true;

		add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d));

		loadingImage = new FlxSprite(0, 0, Paths.image('menus/funkay'));
		loadingImage.setGraphicSize(0, FlxG.height);
		loadingImage.updateHitbox();
		loadingImage.screenCenter();
		add(loadingImage);

		//666，主播你怎么玩上了啊
		loadingBar = new FlxBar(0, FlxG.height - 26, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 26);
		loadingBar.setRange(0, maxLoopTimes);
		add(loadingBar);

		loadedText = new FlxText(loadingBar.x, loadingBar.y, FlxG.width, '', 16);
		loadedText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT);
		loadedText.setBorderStyle(OUTLINE_FAST, 0xFF4D0000, 1.14514);
		loadedText.y -= loadedText.fieldHeight;
		add(loadedText);

		var ticks:Int = 15;
		if (maxLoopTimes <= 15)
			ticks = 1;

		#if !ALLOW_MULTITHREADING
		copyLoop = new FlxAsyncLoop(maxLoopTimes, copyAsset, ticks);
		add(copyLoop);
		copyLoop.start();
		#else
		threadPool = new ThreadPool(0, CNMBD.cppCNM());
		threadPool.doWork.add((_) -> {
			while(shouldCopy && loopTimes < maxLoopTimes) {
				for(i in loopTimes...Std.int(Math.min(loopTimes + ticks, maxLoopTimes))) {
					copyAsset();
				}
			}
		});

		new FlxTimer().start(0.5, (_)->{
			threadPool.queue({});
		});
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (shouldCopy #if !ALLOW_MULTITHREADING && copyLoop != null #end)
		{
			loadingBar.percent = FlxMath.bound(loopTimes / maxLoopTimes * 100, 0, 100);
			if (#if ALLOW_MULTITHREADING loopTimes == maxLoopTimes #else copyLoop.finished #end && canUpdate)
			{
				canUpdate = false;
			
				if (failedFiles.length > 0)
				{
					NativeAPI.showMessageBox('Failed To Copy ${failedFiles.length} File.', failedFiles.join('\n'), MSG_ERROR);
					if (!FileSystem.exists('logs'))
						FileSystem.createDirectory('logs');
					File.saveContent('logs/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '-CopyState' + '.txt', failedFilesStack.join('\n'));
					Sys.exit(0);
				}
				FlxG.sound.play(Paths.sound('menu/confirm')).onComplete = () ->
				{
					FlxG.resetGame();
				};
			}

			if (loopTimes == maxLoopTimes)
				loadedText.text = "Completed!";
			else {
				loadedText.text = 'Copying In Progress: $loopTimes/$maxLoopTimes' + (currentLoadFile != null ? '(loading: $currentLoadFile)' : '');
			}
			loadedText.y = loadingBar.y - loadedText.fieldHeight;
		}
		super.update(elapsed);
	}

	public function copyAsset()
	{
		var file = locatedFiles[loopTimes];
		currentLoadFile = file;
		loopTimes++;
		if (!FileSystem.exists(file))
		{
			var directory = Path.directory(file);
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			try
			{
				if (OpenFLAssets.exists(getFile(file)))
				{
					if (textFilesExtensions.contains(Path.extension(file)))
						createContentFromInternal(file);
					else
						File.saveBytes(file, getFileBytes(getFile(file)));
				}
				else
				{
					failedFiles.push(getFile(file) + " (File Dosen't Exist)");
					failedFilesStack.push('Asset ${getFile(file)} does not exist.');
				}
			}
			catch (e:haxe.Exception)
			{
				failedFiles.push('${getFile(file)} (${e.message})');
				failedFilesStack.push('${getFile(file)} (${e.stack})');
			}
		}
	}

	public function createContentFromInternal(file:String)
	{
		var fileName = Path.withoutDirectory(file);
		var directory = Path.directory(file);
		try
		{
			var fileData:String = OpenFLAssets.getText(getFile(file));
			if (fileData == null)
				fileData = '';
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			File.saveContent(Path.join([directory, fileName]), fileData);
		}
		catch (e:haxe.Exception)
		{
			failedFiles.push('${getFile(file)} (${e.message})');
			failedFilesStack.push('${getFile(file)} (${e.stack})');
		}
	}

	public function getFileBytes(file:String):ByteArray
	{
		switch (Path.extension(file).toLowerCase())
		{
			case 'otf' | 'ttf':
				return ByteArray.fromFile(file);
			default:
				return OpenFLAssets.getBytes(file);
		}
	}

	public static function getFile(file:String):String
	{
		if (OpenFLAssets.exists(file))
			return file;

		@:privateAccess
		for (library in LimeAssets.libraries.keys())
		{
			if (OpenFLAssets.exists('$library:$file') && library != 'default')
				return '$library:$file';
		}

		return file;
	}

	public static function checkExistingFiles():Bool
	{
		locatedFiles = Paths.assetsTree.list(null);

		// removes unwanted assets
		var assets = locatedFiles.filter(folder -> folder.startsWith('assets/'));
		var mods = locatedFiles.filter(folder -> folder.startsWith('mods/'));
		locatedFiles = assets.concat(mods);
		locatedFiles = locatedFiles.filter(file -> !FileSystem.exists(file));

		var filesToRemove:Array<String> = [];

		for (file in locatedFiles)
		{
			if (filesToRemove.contains(file))
				continue;

			if (file.endsWith(IGNORE_FOLDER_FILE_NAME) && !directoriesToIgnore.contains(Path.directory(file)))
				directoriesToIgnore.push(Path.directory(file));

			if (directoriesToIgnore.length > 0)
			{
				for (directory in directoriesToIgnore)
				{
					if (file.startsWith(directory))
						filesToRemove.push(file);
				}
			}
		}

		locatedFiles = locatedFiles.filter(file -> !filesToRemove.contains(file));

		maxLoopTimes = locatedFiles.length;

		return (maxLoopTimes <= 0);
	}
}

#if cpp
@:cppFileCode('#include <thread>')
#end
class CNMBD {
	#if cpp
	@:functionCode('return std::thread::hardware_concurrency();')
	#end
	public static function cppCNM():Int {
		return 1;
	}
}
#end
