package common
{
	import modules.main.business.battle.view.components.BattleScene;
	import modules.main.business.scene.constants.SceneCharacterType;
	
	import tempest.engine.SceneCharacter;
	import tempest.engine.TScene;
	import tempest.ui.TPApplication;

	public class GameInstance
	{
		public static var app:TestProject;

		private static var _scene:TScene;
		private static var _decoder:Decoder;
		private static var _battleScene:BattleScene;

		public static function get battleScene():BattleScene
		{
			return _battleScene ||= new BattleScene();
		}
		
		public static function get scene():TScene
		{
			return _scene ||= new TScene();
		}

		public static function get decoder():Decoder
		{
			return _decoder ||= new Decoder();
		}

		public static var mainChar:SceneCharacter;
	}
}
