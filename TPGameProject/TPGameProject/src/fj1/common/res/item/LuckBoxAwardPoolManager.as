package fj1.common.res.item
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.hero.vo.LevelRes;
	import fj1.common.res.item.vo.LuckBoxAwardData;
	import flash.utils.ByteArray;
	import tempest.utils.XMLAnalyser;

	public class LuckBoxAwardPoolManager
	{
		private static var _poolArray:Array;

		public static function load(data:*):Boolean
		{
			var list:Array = [];
			list = ResManagerHelper.getList(list, LuckBoxAwardData, data);
			if (list)
			{
				_poolArray = [];
				for (var i:int = 0; i < list.length; i++)
				{
					var luckBoxData:LuckBoxAwardData = LuckBoxAwardData(list[i]);
					var pool:LuckBoxAwardPool = LuckBoxAwardPool(_poolArray[luckBoxData.packs_template_id]);
					if (!pool)
					{
						pool = new LuckBoxAwardPool();
						_poolArray[luckBoxData.packs_template_id] = pool;
					}
					pool.initAddAward(luckBoxData);
				}
//			var xmlList:XMLList = xml.*;
//			var arr:Array = XMLAnalyser.getParseList(xml, LuckBoxAwardData);
//			for each (var luckBoxData:LuckBoxAwardData in arr)
//			{
//				var pool:LuckBoxAwardPool = LuckBoxAwardPool(_poolArray[luckBoxData.packs_template_id]);
//				if (!pool)
//				{
//					pool = new LuckBoxAwardPool();
//					_poolArray[luckBoxData.packs_template_id] = pool;
//				}
//				pool.initAddAward(luckBoxData);
//			}
				return true;
			}
			return false;
		}

		public static function getPool(packs_template_id:int):LuckBoxAwardPool
		{
			return LuckBoxAwardPool(_poolArray[packs_template_id]);
		}

		public static function get poolArray():Array
		{
			return _poolArray;
		}
	}
}
