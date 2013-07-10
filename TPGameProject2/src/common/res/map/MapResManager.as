package common.res.map
{

	import common.GameInstance;
	import common.res.map.vo.MapRes;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.XMLAnalyser;

	public class MapResManager
	{
		private static var log:ILogger = TLog.getLogger(MapResManager);
		private static var maps:Array = [];

		/**
		 * 初始化地图列表
		 * @param xml
		 * @return
		 */
		public static function initMapList(data:*):void
		{
			var xml:XML = GameInstance.decoder.decodeToXML(data);
			maps = XMLAnalyser.getParseList(xml, MapRes);
		}

		/**
		 * 获取地图资源
		 * @param id
		 * @return
		 */
		public static function getMapRes(id:int):MapRes
		{
			var res:MapRes = maps[id];
			if (!res)
			{
				log.error("MapResManager.getMapRes() 获取地图配置失败，无效的地图id：" + id);
			}
			return res;
		}

	}
}
