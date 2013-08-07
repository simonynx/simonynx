package fj1.common.res.guide
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.guide.vo.GodPowerTeachConfig;
	import flash.utils.ByteArray;
	import tempest.utils.XMLAnalyser;

	public class GodPowerTeachResManager
	{
		private static var _teachDataList:Array = [];

		public function GodPowerTeachResManager()
		{
		}

		public static function load(data:*):Boolean
		{
			return ResManagerHelper.mapArryList(_teachDataList, GodPowerTeachConfig, data, false);
		}

		public static function get teachDataList():Array
		{
			return _teachDataList;
		}

		public static function getTeachInfoById(id:int):GodPowerTeachConfig
		{
			if (_teachDataList[id])
				return _teachDataList[id];
			return null;
		}
	}
}
