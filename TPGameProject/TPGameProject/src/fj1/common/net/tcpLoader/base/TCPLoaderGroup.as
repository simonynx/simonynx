package fj1.common.net.tcpLoader.base
{
	import flash.utils.Dictionary;

	public class TCPLoaderGroup
	{
		private static var _nextIdDic:Dictionary = new Dictionary();

		public static const DEFAULT:int = 0;
		public static const RANK_PLAYER:int = 1;
		public static const RANK_STAT:int = 2;
		public static const NAME_CHECK:int = 3;
		public static const QUERY_ITEM_FROM_DB:int = 4;
		public static const QUERY_PLAYERID_BYNAME:int = 5;
		public static const ONLINE_STATE_BYID:int = 6;
		public static const MALL_ITEM:int = 7;

		public static function getNextId(gruopId:int):int
		{
			var curId:int = int(_nextIdDic[gruopId]);
			_nextIdDic[gruopId] = curId + 1;

			return curId;
		}
	}
}
