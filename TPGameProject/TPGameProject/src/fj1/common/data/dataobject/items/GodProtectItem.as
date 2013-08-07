package fj1.common.data.dataobject.items
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.cd.CDState;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.CDConst;
	import fj1.common.staticdata.ItemSpecailConst;
	import fj1.manager.BagItemManager;
	import fj1.manager.CDManager;
	import fj1.manager.MessageManager;
	import fj1.modules.item.view.components.level2.ItemUseDialog;

	public class GodProtectItem extends ItemData
	{
		public function GodProtectItem(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean)
		{
			super(ownerId, guId, info, num, cdEnabled);
		}

		/**
		 * 检查CD
		 * @return
		 *
		 */
		override protected function checkCD():Boolean
		{
			var ret:Boolean = super.checkCD();
			if (!ret)
			{
				//CD中检查是否存在神佑能量石，并提示
				var cdItem:ItemData = BagItemManager.instance.getFirstItemByTemplateId(ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT_CD);
				if (!cdItem)
				{
					cdItem = ItemDataFactory.createByID(0, 0, ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT_CD, null, 0);
				}
				var dialog:ItemUseDialog = ItemUseDialog.show(LanguageManager.translate(18024, "重置神佑技能冷却时间"), LanguageManager.translate(18025, "使用后你的神佑技能冷却时间将被重置"), cdItem, false, onEnsure);
				if (cdItem.guId == 0)
				{
					dialog.btn_submit.text = LanguageManager.translate(100019, "购买");
				}
				var cdState:CDState = CDManager.getInstance().getCDStateByTemplate(ItemTemplateManager.instance.get(ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT), CDConst.GROUP_ITEM);
				if (!cdState.inCD())
				{
					MessageManager.instance.addHintById_client(51, "当前神佑技能可使用，不需要使用神佑能量石");
					return false;
				}
			}
			return ret;
		}

		/**
		 *检查物品是否存在
		 * @param onReqSendSuccess
		 * @return
		 *
		 */
		override protected function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			var gpItem:ItemData = BagItemManager.instance.getFirstItemByTemplateId(ItemSpecailConst.ITEM_TEMPLATE_GOD_PROTECT);
			if (!gpItem)
			{
				MessageManager.instance.addHintById_client(52, "背包中没有神佑护符，无法使用神佑能量石");
				return false;
			}
			return true;
		}

		private function onEnsure(itemData:ItemData):void
		{
			if (itemData.guId != 0)
			{
				itemData.useObj();
			}
			else
			{
				GameInstance.signal.mall.queryItem.dispatch(itemData.templateId);
			}
		}

		override public function copy():ICopyable
		{
			var item:GodProtectItem = new GodProtectItem(_ownerId, guId, itemTemplate, num, cdEnabled);
			copyPropertys(item);
			return item;
		}
	}
}
