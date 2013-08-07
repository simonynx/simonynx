package tempest.engine.core
{
	import tempest.engine.SceneCharacter;

	public interface ISceneCharacterPlugin
	{
		function get name():String;
		function setup(target:SceneCharacter):void;
		function shutdown():void;
		function update():void;
	}
}
