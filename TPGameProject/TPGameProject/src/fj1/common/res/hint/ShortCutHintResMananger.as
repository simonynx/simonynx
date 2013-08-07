package fj1.common.res.hint
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.hint.vo.ShortCutHintConfig2;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import tempest.utils.XMLAnalyser;

	public class ShortCutHintResMananger
	{
		private static var _configDic:Dictionary;

		public static function load(data:*):Boolean
		{
			var list:Array = [];
			list = ResManagerHelper.getList(list, ShortCutHintConfig2, data);
			if (list)
			{
				_configDic = new Dictionary();
				for each (var config:ShortCutHintConfig2 in list)
				{
					config.content = config.content.replace("\\n", "\n");
					configDic[config.id] = config;
				}
				return true;
			}
			return false;
		}

		public static function get(id:int):ShortCutHintConfig2
		{
			return configDic[id];
		}

		public static function get configDic():Dictionary
		{
			return _configDic;
		}
	}
}
