import funkin.options.OptionsMenu;
import funkin.options.OptionsScreen;
import funkin.options.type.OptionType;
import funkin.options.type.TextOption;
import funkin.options.type.ArrayOption;
import Sys;
import Type;

function postCreate() {
	#if mobile
	var index = getOptionsIndex("Mobile Options >");
	main.members[index].selectCallback = () -> {
		if (Std.isOfType(OptionsMenu.mainOptions[index].state, OptionsScreen)) {
			var state = OptionsMenu.mainOptions[index].state;
			
			var extraPosState = new ArrayOption("Extra Position", "Change Extra Buttons Position", ["TOP", "BOTTOM"], ["TOP", "BOTTOM"], "buttonExtra", (str) -> {
				gameSaver.buttonExtraPos = str;
			});
			extraPosState.currentSelection = FlxMath.bound(extraPosState.options.indexOf(gameSaver.buttonExtraPos), 0, extraPosState.options.length - 1);
			extraPosState.onChangeSelection(0);

			state.insert(1, extraPosState);
			state.insert(2, new TextOption("Mobile Controls", "Modify The Game Button Mode", selectButtonMobile));
			
			optionsTree.add(state);
		}else {
			var state = Type.createInstance(OptionsMenu.mainOptions[index].state, []);
			
			var extraPosState = new ArrayOption("Extra Position", "Change Extra Buttons Position", ["TOP", "BOTTOM"], ["TOP", "BOTTOM"], "buttonExtra", (str) -> {
				gameSaver.buttonExtraPos = str;
			});
			extraPosState.currentSelection = FlxMath.bound(extraPosState.options.indexOf(gameSaver.buttonExtraPos), 0, extraPosState.options.length - 1);
			extraPosState.onChangeSelection(0);
			
			state.insert(1, extraPosState);
			state.insert(2, new TextOption("Mobile Controls", "Modify The Game Button Mode", selectButtonMobile));
			
			optionsTree.add(state);
		}
	};
	#end
}

function onStateSwitch(event) {
	gameSaver.save();
}

function getOptionsIndex(name:String) {
	for(i=>sb in OptionsMenu.mainOptions) {
		if(sb.name != name) continue;
		
		return i;
	}
	
	debugPrint("not exist this options");
	return -1;
}

#if mobile
function selectButtonMobile() {
	persistentUpdate = false;
	persistentDraw = true;
	openSubState(new ModSubState("WB/EditButtonStyle"));
}
#end