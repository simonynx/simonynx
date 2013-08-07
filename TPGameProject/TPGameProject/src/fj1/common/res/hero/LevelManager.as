package fj1.common.res.hero
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.hero.vo.LevelRes;
	import flash.utils.ByteArray;
	import tempest.utils.XMLAnalyser;

	public class LevelManager
	{
		public static var configArray:Array = [];

		/**
		 *初始化配置加载数据
		 * @param xml
		 *
		 */
		public static function load(data:*):Boolean
		{
			return ResManagerHelper.mapArryList(configArray, LevelRes, data, false, "level");
		}

		/**
		 *
		 * @param level
		 * @return
		 *
		 */
		public static function get(level:int):LevelRes
		{
			if (level == 0)
				return null;
			return LevelRes(configArray[level]);
		}
	}
}
