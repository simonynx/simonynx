package fj1.common.res.map
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.map.vo.MapRes;
	import fj1.common.res.map.vo.TransportRes;
	import fj1.common.res.map.vo.TransportTempl;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.XMLAnalyser;

	public class MapResManager
	{
		private static var log:ILogger = TLog.getLogger(MapResManager);
		private static var maps:Array = [];
		private static var transports:Array;
		private static var transportTemplates:Array;

		/**
		 * 初始化地图列表
		 * @param xml
		 * @return
		 */
		public static function initMapList(data:*):void
		{
			maps = ResManagerHelper.getArray(MapRes, data, "id");
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

		/**
		 * 初始化传送点列表
		 * @param xml
		 * @return
		 */
		public static function initTransportList(data:*):Boolean
		{
			transports = ResManagerHelper.getArray(TransportRes, data, "id");
			return transports != null;
		}

		/**
		 * 获取传送点资源
		 * @param id
		 * @return
		 */
		public static function getTransportRes(id:int):TransportRes
		{
			return transports[id];
		}

		/**
		 * 获取制定地图传送点列表
		 * @param mapId
		 * @return
		 */
		public static function getTransportList(mapId:int):Array
		{
			return transports.filter(function(item:TransportRes, index:int, arr:Array):Boolean
			{
				return (item == null) ? false : (item.mapId == mapId);
			});
		}

		/**
		 * 初始化传送点模板
		 * @param xml
		 * @return
		 */
		public static function initTransportTempl(data:*):Boolean
		{
			transportTemplates = ResManagerHelper.getArray(TransportTempl, data, "id");
			return transportTemplates != null;
		}

		/**
		 * 获取传送点模板
		 * @param id
		 * @return
		 */
		public static function getTransportTempl(id:int):TransportTempl
		{
			var templ:TransportTempl = transportTemplates[id];
			if (!templ)
			{
				log.error("获取传送点模板TransportTempl失败！Id = " + id);
			}
			///////调试信息////////
			CONFIG::debugging
			{
				if (templ)
				{
					templ.name = "[ID:" + templ.id + "]" + templ.name;
				}
			}
			return templ;
		}

		/**
		 * 跨图寻路
		 * @param start 开始地图ID
		 * @param end 结束地图ID
		 * @return 返回传送点数组
		 */
		public static function find(start:int, end:int):Array
		{
			if (start == end || !maps[start] || !maps[end])
				return null;
			var resultList:Array = [];
			var searched:Vector.<int> = new Vector.<int>();
			searched.push(start);
			search(start, end, searched, [], resultList);
			if (resultList.length != 0)
			{
				resultList.sortOn("length");
				return resultList[0];
			}
			else
				return null;
		}

		/**
		 * 寻路核心算法
		 * @param start 开始地图
		 * @param end 结束地图
		 * @param seached 确定不是目标地图缓存表
		 * @param tempResult 临时返回路线列表
		 * @param result 所有可能路线列表
		 */
		private static function search(start:int, end:int, seached:Vector.<int>, tempResult:Array, result:Array):void
		{
			var transList:Array = maps[start].transports;
			for each (var trans:TransportRes in transList)
			{
				var _tempResult:Array = tempResult.concat();
				var id:int = trans.template.targetMapId;
				if (seached.indexOf(id) == -1)
				{
					if (id == end)
					{
						_tempResult.push([trans.mapId, trans.pos_x, trans.pos_y]);
						result.push(_tempResult);
						break;
					}
					else
					{
						var seachedTemp:Vector.<int> = seached.concat();
						for each (var _trans:TransportRes in transList)
						{
							seachedTemp.push(_trans.template.targetMapId);
						}
						var _result:Array = tempResult.concat();
						_result.push([trans.mapId, trans.pos_x, trans.pos_y]);
						search(id, end, seachedTemp, _result, result);
					}
				}
			}
		}
	}
}
