package fj1.modules.item.controller
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.BagItemManager;
	import tempest.common.mvc.base.Command;
	import tempest.ui.collections.TArrayCollection;

	public class ItemLoginCompleteCheckCommand extends Command
	{
		public override function execute():void
		{
			//检查背包中是否有更好的装备并提示
			var bagItemList:TArrayCollection = BagItemManager.instance.getBagItemList();
			var item:ItemData;
			for each (item in bagItemList)
			{
				if (item)
				{
					BagItemManager.testHint(item);
				}
			}
		}
	}
}
