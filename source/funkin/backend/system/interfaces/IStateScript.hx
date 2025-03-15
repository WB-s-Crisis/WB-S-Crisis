package funkin.backend.system.interfaces.IStateScript;

import funkin.backend.scripting.ScriptPack;

interface IStateScript {
	public var scriptVariables:Map<String, Dynamic>;
	public var stateScripts:ScriptPack;
}