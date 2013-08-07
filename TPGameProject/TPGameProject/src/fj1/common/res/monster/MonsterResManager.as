package fj1.common.res.monster
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.monster.vo.MonsterMapTemplate;
	import fj1.common.res.monster.vo.MonsterTempl;
	import fj1.common.res.monster.vo.TalkTextTemplate;
	import flash.utils.ByteArray;
	import tempest.utils.XMLAnalyser;

	public class MonsterResManager
	{
		/**
		 * 怪物模板列表
		 * @default
		 */
		public static var monsterTempls:Array = [];
		public static var monsterTalks:Array = [];
		/**
		 *怪物地图分布表
		 */
		public static var monsterBornList:Array = [];

		/**
		 * 初始化怪物模板
		 * @param xml
		 * @return
		 */
		public static function initMonsterTeml(data:*):Boolean
		{
			monsterTempls = ResManagerHelper.getArray(MonsterTempl, data, "id");
			return monsterTempls != null;
		}

		/**
		 *初始化休闲对话列表
		 * @return
		 *
		 */
		public static function loadTalkTeml(data:*):Boolean
		{
			monsterTalks = ResManagerHelper.getArray(TalkTextTemplate, data, "id");
			return monsterTalks != null;
		}

		/**
		 *加载怪物地图分布配置
		 * @return
		 *
		 */
		public static function loadMonsterBornTeml(data:*):Boolean
		{
			monsterBornList = ResManagerHelper.getArray(MonsterMapTemplate, data, "id");
			return monsterBornList != null;
		}

		/**
		 *根据地图ID获取该地图分布的怪物
		 * @return
		 *
		 */
		public static function getMonstersByMapID(mapID:int):Array
		{
			return monsterBornList.filter(function(item:MonsterMapTemplate, index:int, list:Array):Boolean
			{
				return (item.MapId == mapID);
			});
		}

		/**
		 *获取指定ID对话内容
		 * @param id
		 * @return
		 *
		 */
		public static function getTalkText(id:int):Array
		{
			var talkTextTemplate:TalkTextTemplate = monsterTalks[id]
			if (talkTextTemplate)
			{
				return talkTextTemplate.conext.toString().split("$");
			}
			return [];
		}

		/**
		 * 是否具有指定名称
		 * @param value
		 * @return
		 */
		public static function checkName(value:String):Boolean
		{
			var item:MonsterTempl;
			for each (item in monsterTempls)
			{
				if (item && item.name == value)
					return true;
			}
			return false;
		}

		/**
		 * 获取怪物模板
		 * @param id
		 * @return
		 */
		public static function getMonsterTempl(id:int):MonsterTempl
		{
			return monsterTempls[id];
		}
	}
}
