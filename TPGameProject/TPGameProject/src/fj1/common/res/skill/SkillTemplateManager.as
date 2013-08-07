package fj1.common.res.skill
{
	import flash.utils.Dictionary;
	
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.skill.vo.SkillInfo;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class SkillTemplateManager
	{
		private static const log:ILogger=TLog.getLogger(SkillTemplateManager);
		private static var _instance:SkillTemplateManager=null;
		private static var _key:Boolean=false; //单例锁
		/**
		 * 技能信息模板列表
		 */
		private var _skillInfoList:Dictionary=null;
		/**
		 * 元神配置
		 */
		private var _yuanShentInfoList:Dictionary=null;
		/**
		 * 技能法宝配置
		 */
		private var _skillPartInfoList:Dictionary=null;
		/**
		 *角色出生技能
		 */
		public var bornSpells:Dictionary=null;

		public static function get instance():SkillTemplateManager
		{
			if (_instance == null)
			{
				_key=true;
				_instance=new SkillTemplateManager();
			}
			return _instance;
		}

		public function SkillTemplateManager()
		{
			_skillInfoList=new Dictionary();
			_yuanShentInfoList=new Dictionary();
			_skillPartInfoList=new Dictionary();
			bornSpells=new Dictionary();

			if (!_key)
			{
				throw new Error("单例模式,请用 instance() 取实例。");
			}
			_key=false;
		}

		/**
		 *初始化配置加载数据
		 * @param xml
		 *
		 */
		public function load(data:*):Boolean
		{
			_skillInfoList = ResManagerHelper.getDictionary(SkillInfo, data);
			return _skillInfoList != null;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function loadBornSpells(data:*):Boolean
		{
			var xmlList:XMLList=ResManagerHelper.getXmlList(data)
			if (xmlList)
			{
				var xml:XML=null
				for each (xml in xmlList)
				{
					var profession:int=xml.@profession;
					var spellid:int=xml.@spellid;
					if (bornSpells[profession] == null)
					{
						bornSpells[profession]=[];
					}
					bornSpells[profession].push(spellid);
				}
				return true;
			}
			return false;
		}

		/**
		 *获取技能模板信息
		 * @param id
		 * @return
		 *
		 */
		public function getSkillInfo(id:int):SkillInfo
		{
			if (_skillInfoList[id] == null)
			{
				log.warn("不存在的技能模版id:" + id);
			}
			return _skillInfoList[id];
		}


		/**
		 *获取技能信息模板列表
		 * @return
		 *
		 */
		public function get skillInfoList():Dictionary
		{
			return _skillInfoList;
		}

		/**
		 * 根据消耗物品获取技能模板信息
		 * @param itemId
		 * @return
		 *
		 */
		public function getSkillInfoByConsumeItemId(itemId:int):SkillInfo
		{
			for each (var skillInfo:SkillInfo in _skillInfoList)
			{
				if (skillInfo.consume_goods == itemId)
				{
					return skillInfo;
				}
			}
			log.warn("技能书找不到对应的技能id:" + itemId);
			return null;
		}
	}
}
