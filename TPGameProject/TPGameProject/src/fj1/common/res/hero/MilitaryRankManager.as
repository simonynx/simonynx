package fj1.common.res.hero
{
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.hero.vo.MilitaryRankRes;

	public class MilitaryRankManager
	{
		public static var military:Array = [];

		public static function initXml(data:*):Boolean
		{
			return ResManagerHelper.mapArryList(military, MilitaryRankRes, data);
		}

		/**
		 *获取军衔图标种类
		 * @param value
		 * @return
		 *
		 */
		public static function getMilitaryStyle(value:int):int
		{
			return (value - 1) / 10;
		}

		/**
		 *获取军衔个数
		 * @param value
		 * @return
		 *
		 */
		public static function getMilitaryNum(value:int):int
		{
			return ((value - 1) % 10) / 2 + 1;
		}

		/**
		 *获取军衔信息
		 * @param value
		 * @return
		 *
		 */
		public static function getMiliInfo(value:int):MilitaryRankRes
		{
			if (military.length > 0)
			{
				for each (var mili:MilitaryRankRes in military)
				{
					if (mili.id == value)
					{
						return mili;
					}
				}
			}
			return null;
		}
	}
}
