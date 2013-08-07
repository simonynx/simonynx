package fj1.common.helper
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.cd.CDState;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.net.GameClient;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.BindType;
	import fj1.common.staticdata.CDConst;
	import fj1.common.staticdata.ItemConst;
	import fj1.manager.CDManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.FetchHelper;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	public class ItemOperateHelper
	{
		/**
		 * 物品使用触发
		 * 检查物品使用条件
		 * @param itemData
		 * @return
		 *
		 */
		public static function checkUse(itemData:ItemData, onReqSendSuccess:Function):Boolean
		{
			if (itemData.itemTemplate.alertId)
			{
				var alert:TAlert = TAlertHelper.showDialog(itemData.itemTemplate.alertId, null, false, TAlert.OK | TAlert.CANCEL, onItemEnsureDialogClose);
				alert.data = itemData;
				return false;
			}
			if (!itemData.playerBinded && itemData.itemTemplate.bind_type == BindType.EQUIP)
			{
				TAlert.Show(LanguageManager.translate(50462, "该物品使用后将绑定，是否使用？"), "", false, TAlert.OK | TAlert.CANCEL, function(e:TAlertEvent):void
				{
					if (e.flag == TAlert.OK)
					{
						itemData.useObjNotCheckUseEnsure(onReqSendSuccess);
					}
				});
				return false;
			}
//			if (itemData.itemTemplate.increase_belief > 0 && !GameInstance.mainCharData.godPowerIsOpen)
//			{
//				TAlert.Show(LanguageManager.translate(100041, "还未掌握的神秘能力，主线任务中开启！"), "", false, TAlert.OK);
//				return false;
//			}
			return true;
		}

		private static function onItemEnsureDialogClose(event:TAlertEvent):void
		{
			if (event.flag == TAlert.OK)
			{
				var itemData:ItemData = ItemData(event.currentTarget.data);
				itemData.useObjNotCheckUseEnsure();
			}
		}

		/**
		 * 物品移动
		 * @param itemData
		 * @param slotMoveTo
		 * @return
		 *
		 */
		public static function moveItem(itemData:ItemData, slotMoveTo:int):void
		{
			var targetItem:ItemData = ItemData(SlotItemManager.instance.getItemBySlot(slotMoveTo));
			if (targetItem && targetItem.itemTemplate.max_stack > 1)
			{
				if (!targetItem.validDate && !itemData.validDate && targetItem.templateId == itemData.templateId && targetItem.playerBinded && !itemData.playerBinded)
				{
					TAlertHelper.showDialog(10013, "疊加後將使非綁定物品變為綁定，確認是否要進行疊加？", true, TAlert.OK | TAlert.CANCEL, function(event:TAlertEvent):void
					{
						switch (event.flag)
						{
							case TAlert.OK:
								GameClient.sendItemMove(itemData.guId, itemData.slot, slotMoveTo);
								break;
						}
					});
					return;
				}
			}
			GameClient.sendItemMove(itemData.guId, itemData.slot, slotMoveTo);
		}
	}
}
