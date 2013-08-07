package shell
{
	import fj1.common.GameInstance;

	import flash.utils.Dictionary;

	public class AppUIMananger
	{
		private static var _uiDic:Dictionary = new Dictionary();

		public static function addUI(name:String, ui:*):*
		{
			_uiDic[name] = ui;
			return ui;
		}

		public static function removeUI(name:String):void
		{
			delete _uiDic[name];
		}

		public static function getUI(name:String):*
		{
			return _uiDic[name];
		}

		public static function show(name:String):void
		{
			var ui:* = _uiDic[name];
			GameInstance.app.addChild(ui);
		}

		public static function close(name:String):void
		{
			var ui:* = _uiDic[name];
			GameInstance.app.removeChild(ui);
		}

		public static function clean():void
		{
			_uiDic = new Dictionary();
		}
	}
}
