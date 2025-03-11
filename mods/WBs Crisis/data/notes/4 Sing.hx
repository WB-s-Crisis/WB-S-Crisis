function onNoteHit(e)
    if (e.noteType == "4 Sing")
        e.characters = strumLines.members[2].characters;
        
function onPlayerMiss(e)
    if (e.noteType == "4 Sing")
        e.characters = strumLines.members[2].characters;
        //2 是gf 3-8控制着不同的 3是你新添加的 4也是一样把这个放在敌人得控制别人可以帮你控制放至玩家玩家可控制