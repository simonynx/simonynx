package fj1.common.res.monster
{
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.monster.vo.CollectTemplate;
	import flash.utils.Dictionary;

	public class CollectTemplateManager
	{
		private static var _instrance:CollectTemplateManager = null;
		private var _collectTemplateList:Dictionary = new Dictionary(); //技能列表
		private static var _key:Boolean = false; //单例锁

		public static function get instrance():CollectTemplateManager
		{
			if (_instrance == null)
			{
				_key = true;
				_instrance = new CollectTemplateManager();
			}
			return _instrance;
		}

		public function CollectTemplateManager()
		{
			if (!_key)
			{
				throw new Error("单例模式,请用 instance() 取实例。");
			}
			_key = false;
		}

		public function loadXml(data:*):Boolean
		{
			_collectTemplateList = ResManagerHelper.getDictionary(CollectTemplate, data);
			return _collectTemplateList != null;
		}

		/**
		 *获取采集模版
		 * @param id
		 * @return
		 *
		 */
		public function getCollectTempl(id:int):CollectTemplate
		{
			return _collectTemplateList[id];
		}

		/**
		 * 根据采集工具id查找采集模板
		 * @param toolId
		 * @return
		 *
		 */
		public function getCollectTemplByToolId(toolId:int):CollectTemplate
		{
			var dic:Dictionary = CollectTemplateManager.instrance.list;
			for each (var item:CollectTemplate in dic)
			{
				if (item.tool_id == toolId)
				{
					return item;
				}
			}
			return null;
		}

		public function get list():Dictionary
		{
			return _collectTemplateList;
		}
	}
}
