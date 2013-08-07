package fj1.manager
{
	import fj1.common.GameInstance;
	import fj1.common.core.ICDClient;
	import fj1.common.data.dataobject.cd.CDGroup;
	import fj1.common.data.dataobject.cd.CDState;
	import fj1.common.events.CDEvent;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.staticdata.CDConst;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	//	import tempest.manager.ItemManager;
	/**
	 * CD管理器，管理 CDState 对象
	 * 每个CDState和模板表中的物品一一对应，按照公共CD组Id管理
	 * @author linxun
	 *
	 */
	public class CDManager
	{
		private static var _instance:CDManager;
		private var _cdGroupDic:Dictionary; //cd组集合
		private var _commonCDGroupDic:Dictionary; //公共CD组集合
		private var _nonGroupCDDic:Dictionary; //不用组管理的CD

		public static function getInstance():CDManager
		{
			if (!_instance)
			{
				new CDManager();
			}
			return _instance;
		}

		public function CDManager()
		{
			if (_instance)
				throw new Error("该类只能有一个实例");
			_instance = this;
			_cdGroupDic = new Dictionary();
			_commonCDGroupDic = new Dictionary();
//			_commonCDGroupDic[CDConst.GROUP_ITEM] = new CDGroup(ObjectType.TYPEID_ITEM, 500, CDConst.GROUP_ITEM, CDConst.PRIORITY_COMMON);//物品无公共CD
			_commonCDGroupDic[CDConst.GROUP_SPELL] = new CDGroup(CDConst.GROUP_SPELL, CDConst.SPELL_CD, CDConst.GROUP_SPELL, CDConst.PRIORITY_COMMON);
			_nonGroupCDDic = new Dictionary();
		}

		public function initCD(templateCollection:Dictionary):void
		{
			for each (var cdTemplate:ICDClient in templateCollection)
			{
				if (cdTemplate)
					initAdd(cdTemplate);
			}
		}

		/**
		 * 获取公共CD组
		 * @param groupType
		 *
		 */
		public function getCommonCDGroup(groupType:int):CDGroup
		{
			return CDGroup(_commonCDGroupDic[groupType]);
		}

		/**
		 * 读取CD组配置
		 * @param xml
		 *
		 */
		public function initGroup(data:*):Boolean
		{
			var itemList:XMLList = ResManagerHelper.getXmlList(data);
			if (itemList)
			{
				for each (var item:XML in itemList)
				{
					_cdGroupDic[parseInt(item.@cdType)] = new CDGroup(parseInt(item.@cdType), parseInt(item.@cdTime), parseInt(item.@type));
				}
				return true;
			}
			return false;
		}

		/**
		 * 初始化，对每一个模板对象添加冷却状态
		 * @param freezeItem
		 *
		 */
		public function initAdd(cdItem:ICDClient):void
		{
			initAdd2(cdItem.templateId, cdItem.groupId, cdItem.groupType);
		}

		/**
		 * 初始化，对每一个模板对象添加冷却状态
		 * @param templateId
		 * @param group
		 *
		 */
		public function initAdd2(templateId:int, groupId:int, type:int):void
		{
			var group:CDGroup = _cdGroupDic[groupId];
			var cdState:CDState = new CDState(templateId, group, type);
			cdState.addEventListener(CDEvent.CDSTART_EVENT, onCDStart);
			if (group)
				group.setCDState(cdState);
			//添加到公共CD组
			var comGroup:CDGroup = CDGroup(_commonCDGroupDic[type]);
			if (comGroup)
				comGroup.setCDState(cdState);
			if (!group && !comGroup)
				_nonGroupCDDic[templateId] = cdState;
		}

		/**
		 * 开始CD时，开始公共CD
		 * @param event
		 *
		 */
		private function onCDStart(event:CDEvent):void
		{
			var cdState:CDState = event.currentTarget as CDState;
			var comGroup:CDGroup = CDGroup(_commonCDGroupDic[cdState.cdGroupType]);
			if (comGroup)
			{
				comGroup.startCommonCD(cdState.templateId); //公共CD冷却
			}
			var group:CDGroup = getCDGroup(cdState.groupId);
			if (group)
			{
				group.startCommonCD(cdState.templateId); //当前组冷却使用组内部冷却时间
			}
		}

		/**
		 * 获得CD组
		 * @param groupId
		 * @return
		 *
		 */
		public function getCDGroup(groupId:int):CDGroup
		{
			return _cdGroupDic[groupId] as CDGroup;
		}

		/**
		 * 获得CDState
		 * @param groupId 冷却组
		 * @param templateId 模板Id
		 * @param cdGroupType 冷却组类型 CDConst
		 * @return
		 *
		 */
		public function getCDState(groupId:int, templateId:int, cdGroupType:int):CDState
		{
			var group:CDGroup = _cdGroupDic[groupId] as CDGroup;
			if (group)
				return group.getCDState(templateId);
			var comGroup:CDGroup = _commonCDGroupDic[cdGroupType] as CDGroup;
			if (comGroup)
				return comGroup.getCDState(templateId);
			return _nonGroupCDDic[templateId];
		}

		/**
		 *
		 * @param itemTemplate
		 * @param cdGroupType 冷却组类型 CDConst
		 * @return
		 *
		 */
		public function getCDStateByTemplate(itemTemplate:ItemTemplate, cdGroupType:int):CDState
		{
			return getCDState(itemTemplate.cd_type, itemTemplate.templateId, cdGroupType);
		}

		/**
		 *
		 * @param commonCDGroupId
		 *
		 */
		public function cleanAllCD(cdGroupType:int):void
		{
			var comGroup:CDGroup = _commonCDGroupDic[cdGroupType] as CDGroup;
			if (!comGroup)
				throw new Error("错误的冷却类别：" + cdGroupType);
			comGroup.stopCD(CDConst.PRIORITY_SINGLE);
		}
	}
}
