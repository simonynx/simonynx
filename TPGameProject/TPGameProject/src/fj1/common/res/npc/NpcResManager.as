package fj1.common.res.npc
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.npc.vo.NpcRes;
	import fj1.common.res.npc.vo.NpcTempl;

	import flash.utils.ByteArray;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.XMLAnalyser;

	/**
	 * NPC资源管理
	 * @author wushangkun
	 */
	public class NpcResManager
	{
		private static const log:ILogger = TLog.getLogger(NpcResManager);
		private static var _npcTempls:Array = [];
		private static var _npcs:Array = [];

		/**
		 * npc列表
		 * @default
		 */
		public static function get npcs():Array
		{
			return _npcs;
		}

		/**
		 * npc模板列表
		 * @default
		 */
		public static function get npcTempls():Array
		{
			return _npcTempls;
		}

		/**
		 * 初始化NPC模板资源
		 * @param xml
		 */
		public static function initNpcList(data:*):void
		{
			_npcs = ResManagerHelper.getArray(NpcRes, data);
		}

		/**
		 * 根据地图ID获取NPC列表
		 * @param mapId
		 * @return
		 */
		public static function getNpcList(mapId:int, serverId:int):Array
		{
			return _npcs.filter(function(item:NpcRes, index:int, arr:Array):Boolean
			{
				return (item == null) ? false : ((item.serverId == 0 || item.serverId == serverId) && (item.mapId == mapId));
			});
		}

		public static function getNpcResById(id:int):NpcRes
		{
			return _npcs[id];
		}

		/**
		 * 初始化NPC模板
		 * @param xml
		 * @return
		 */
		public static function initNpcTempl(data:*):void
		{
			_npcTempls = ResManagerHelper.getArray(NpcTempl, data, "id");
		}

		/**
		 * 获取NPC模板
		 * @param id
		 * @return
		 */
		public static function getNpcTempl(id:int):NpcTempl
		{
			var templ:NpcTempl = _npcTempls[id];
			if (!templ)
			{
				log.error("npc模板查询失败 id = " + id);
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
		 * 是否具有指定名称
		 * @param value
		 * @return
		 */
		public static function checkName(value:String):Boolean
		{
			var item:NpcTempl;
			for each (item in _npcTempls)
			{
				if (item && item.name == value)
					return true;
			}
			return false;
		}
	}
}
