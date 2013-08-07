package fj1.common.data.dataobject.items
{
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.AlertId;
	import fj1.common.staticdata.ItemSpecailConst;
	import fj1.common.ui.TAlertMananger;
	import fj1.manager.VipDataManager;
	import fj1.modules.vip.model.vo.SurportData;
	import fj1.modules.vip.staticdata.VIPConst;

	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	public class VIPCardItem extends ItemData
	{
		public function VIPCardItem(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean)
		{
			super(ownerId, guId, info, num, cdEnabled);
		}

		protected override function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			if (!super.checkUseCondition(onReqSendSuccess))
			{
				return false;
			}

			var itemVipLevel:int = getVIPLevelByTemplate(this.templateId);
			var surportData:SurportData = VipDataManager.instance.currentSurportData;
			if (!surportData)
			{
				return true;
			}
			if (levelCmp(surportData.level, itemVipLevel) == 0)
			{
				return true;
			}
			else if (levelCmp(surportData.level, itemVipLevel) < 0)
			{
				//提示已存在VIP，是否覆盖
				TAlertMananger.showAlert(AlertId.VIP_CARD_USE,
					LanguageManager.translate(81090, "您若使用{0}將取消現有的{1}剩余天数，確定要繼續嗎？", itemTemplate.name, getVIPTemplateByLevel(surportData.level).name),
					false, TAlert.OK | TAlert.CANCEL, function(event:TAlertEvent):void
					{
						if (event.flag == TAlert.OK)
						{
							useObjNotCheckUseEnsure(onReqSendSuccess);
						}
					});
				return false;
			}
			else
			{
				TAlertMananger.showAlert(AlertId.VIP_CARD_USE,
					LanguageManager.translate(81091, "您目前正在使用更為強大的{0}，請至時間截止后再進行更換", getVIPTemplateByLevel(surportData.level).name),
					false, TAlert.OK);
				return false;
			}
		}

		/**
		 * 比较两个VIP卡的等级
		 * @param levelLeft
		 * @param levelRight
		 * @return
		 *
		 */
		private function levelCmp(levelLeft:int, levelRight:int):int
		{
			if (levelLeft == levelRight)
			{
				return 0;
			}
			if (levelLeft == VIPConst.VIP_LEVEL_SPECIAL)
			{
				return -1;
			}
			else if (levelRight == VIPConst.VIP_LEVEL_SPECIAL)
			{
				return 1;
			}
			else
			{
				return levelLeft > levelRight ? 1 : -1;
			}
		}

		/**
		 * 根据VIP等级获得对应物品模板
		 * @param level
		 * @return
		 *
		 */
		private function getVIPTemplateByLevel(level:int):ItemTemplate
		{
			var template:int;
			switch (level)
			{
				case VIPConst.VIP_LEVEL_SPECIAL:
					template = ItemSpecailConst.ITEM_TEMPLATE_VIP_SPEACIAL;
					break;
				case VIPConst.VIP_LEVEL_1:
					template = ItemSpecailConst.ITEM_TEMPLATE_VIP_1;
					break;
				case VIPConst.VIP_LEVEL_2:
					template = ItemSpecailConst.ITEM_TEMPLATE_VIP_2;
					break;
				case VIPConst.VIP_LEVEL_3:
					template = ItemSpecailConst.ITEM_TEMPLATE_VIP_3;
					break;
			}
			return ItemTemplateManager.instance.get(template);
		}

		/**
		 * 根据物品模板获得对应VIP等级
		 * @param template
		 * @return
		 *
		 */
		private function getVIPLevelByTemplate(template:int):int
		{
			switch (template)
			{
				case ItemSpecailConst.ITEM_TEMPLATE_VIP_SPEACIAL:
					return VIPConst.VIP_LEVEL_SPECIAL;
				case ItemSpecailConst.ITEM_TEMPLATE_VIP_1:
					return VIPConst.VIP_LEVEL_1;
				case ItemSpecailConst.ITEM_TEMPLATE_VIP_2:
					return VIPConst.VIP_LEVEL_2;
				case ItemSpecailConst.ITEM_TEMPLATE_VIP_3:
					return VIPConst.VIP_LEVEL_3;
				default:
					return -1;
			}
		}

		override public function copy():ICopyable
		{
			var item:VIPCardItem = new VIPCardItem(_ownerId, guId, itemTemplate, num, cdEnabled);
			copyPropertys(item);
			return item;
		}
	}
}
