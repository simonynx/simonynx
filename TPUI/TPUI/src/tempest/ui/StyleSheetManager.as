package tempest.ui
{
	import flash.text.StyleSheet;
	import flash.utils.Dictionary;

	public class StyleSheetManager
	{
		private static var _instance:StyleSheetManager = null;
		
		private var styleSheets:Dictionary = new Dictionary();
		
		public function StyleSheetManager()
		{
			if (_instance != null)
				throw(new Error("该类不能重复实例化"));
			_instance = this;
		}
		
		public static function get instance():StyleSheetManager
		{
			if (_instance == null)
				new StyleSheetManager();
			return _instance;
		}
		
		public function registerStyleSheet(type:String, styleSheet:StyleSheet):void
		{
			styleSheets[type] = styleSheet;
		}
		
		public function getStyleSheet(type:String):StyleSheet
		{
			if(!type)
				return null;
			
			if(!styleSheets.hasOwnProperty(type))
				throw new Error("找不到StyleSheet类型： " + type);
			
			return styleSheets[type];
		}
	}
}