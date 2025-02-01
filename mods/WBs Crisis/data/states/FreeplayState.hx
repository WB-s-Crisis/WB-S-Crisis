import Sys;

importAddons("AnimationIcon");

function postCreate() {

	for(meta in songs) {
		if(Reflect.hasField(meta, "customValues") && Reflect.hasField(meta.customValues, "iconAnimated") && meta.customValues.iconAnimated == true) {
			var indexIcon:Int = songs.indexOf(meta);
			var index:Int = members.indexOf(iconArray[indexIcon]);
			remove(iconArray[songs.indexOf(meta)]);
			iconArray.remove(iconArray[indexIcon]);
				
			var icon:AnimationIcon = new AnimationIcon(meta.icon, false);
			icon.x = indexIcon * 100;
				
			icon.scale.set((Reflect.hasField(meta, "customValues") && Reflect.hasField(meta.customValues, "iconScale") ? meta.customValues.iconScale : 1), (Reflect.hasField(meta, "customValues") && Reflect.hasField(meta.customValues, "iconScale") ? meta.customValues.iconScale : 1));
			icon.updateHitbox();
				
			icon.posObject = grpSongs.members[indexIcon];
			icon.freeplayOffset.set((Reflect.hasField(meta, "customValues") && Reflect.hasField(meta.customValues, "iconOffset") ? meta.customValues.iconOffset[0] : 0), (Reflect.hasField(meta, "customValues") && Reflect.hasField(meta.customValues, "iconOffset") ? meta.customValues.iconOffset[1] : 0));
				
			insert(index, icon);
				
			iconArray.insert(indexIcon, icon);
		}
	}
	
	//Application.current.window.alert(iconArray);
}

function postUpdate(elapsed:Float) {

}