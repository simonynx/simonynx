package fj1.common.res.randomName
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.randomName.vo.RandomNameInfo;
	import flash.utils.ByteArray;
	import tempest.utils.XMLAnalyser;

	public class RandomNameManager
	{
		public static var randomNameArr:Array; //所有卷轴的数据

		/**
		 * 获取卷轴数据
		 * @param xml
		 * @return
		 *
		 */
		public static function initRandomNameXML(data:*):Boolean
		{
			randomNameArr = ResManagerHelper.getArray(RandomNameInfo, data);
			if (randomNameArr)
			{
				return true;
			}
			return false;
		}

		public static function getNameArr(title:String):Array
		{
			var arr:Array = [];
			var _randomNameInfo:RandomNameInfo;
			for each (_randomNameInfo in randomNameArr)
			{
				if (title == _randomNameInfo.title)
				{
					arr = _randomNameInfo.content.split(",");
					return arr;
				}
			}
			return arr;
		}
	}
}
