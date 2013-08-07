package fj1.common.data.dataobject.items
{
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.net.GameClient;
	import fj1.common.res.guide.vo.GuideConfig;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.BagItemManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.view.components.level2.ExpendDialog;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;
	import tempest.utils.HtmlUtil;

	public class ExpendItemData extends ItemData
	{
		public function ExpendItemData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean = true)
		{
			super(ownerId, guId, info, num, cdEnabled);
		}

		override public function copy():ICopyable
		{
			var item:ExpendItemData = new ExpendItemData(_ownerId, guId, itemTemplate, num, cdEnabled);
			copyPropertys(item);
			return item;
		}

		protected override function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			if (!super.checkUseCondition(onReqSendSuccess))
			{
				return false;
			}
			var size:int;
			var tabIndex:int;
			var dialog:ExpendDialog;
			switch (_itemTemplate.subtype)
			{
				case ItemConst.SUB_TYPE_DRUG_EXPEND_BAG:
					size = BagItemManager.instance.getBagSize();
					tabIndex = size / ItemConst.BAG_PAGE_SIZE + 1;
					if (tabIndex > ItemConst.BAG_ITEM_NUM / ItemConst.BAG_PAGE_SIZE)
					{
						MessageManager.instance.addHintById_client(21, "您的背包容量已达上限");
						return false;
					}
					dialog = TWindowManager.instance.showPopup2(null, ExpendDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, ItemConst.SUB_TYPE_DRUG_EXPEND_BAG, this) as ExpendDialog;
					break;
				case ItemConst.SUB_TYPE_DRUG_EXPEND_DEPOT:
					size = SlotItemManager.instance.getSlotList(ItemConst.CONTAINER_DEPOT).length;
					tabIndex = size / ItemConst.DEPOT_PAGE_SIZE + 1;
					if (tabIndex > ItemConst.DEPOT_ITEM_NUM / ItemConst.DEPOT_PAGE_SIZE)
					{
						MessageManager.instance.addHintById_client(22, "您的仓库容量已达上限");
						return false;
					}
					dialog = TWindowManager.instance.showPopup2(null, ExpendDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, ItemConst.SUB_TYPE_DRUG_EXPEND_DEPOT, this) as ExpendDialog;
					break;
				case ItemConst.SUB_TYPE_DRUG_EXPEND_PET:
					dialog = TWindowManager.instance.showPopup2(null, ExpendDialog.NAME, true, true, TWindowManager.MODEL_USE_OLD, null, ItemConst.SUB_TYPE_DRUG_EXPEND_PET, this) as ExpendDialog;
					break;
			}
			return false;
		}
	}
}
