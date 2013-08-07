package fj1.modules.item.view.components
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.interfaces.IStoredObject;
	import fj1.common.helper.ItemOperateHelper;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.MenuOperationType;
	import fj1.common.ui.MenuDataItem;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import tempest.ui.DragManager;
	import tempest.ui.components.TListMenu;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.interfaces.ISlotData;

	public class AwardDepotDataBox extends BaseDataBox
	{
		private var _awordDepotView:AwardDepotPanel;

		public function AwardDepotDataBox(proxy:* = null, dragBackAreaArray:Array = null, constraints:Object = null)
		{
			super(proxy, dragBackAreaArray, constraints);
			this.dragImage.addEventListener(DragEvent.DROP_DOWN, onItemDropDown);
			this.dragImage.place = DragImagePlaces.AWORD_DEPOT;
			this.dragImage.dragAccpetPlaces = [DragImagePlaces.BAG];
		}

		private function onItemDropDown(event:DragEvent):void
		{
			MessageManager.instance.addHintById_client(58, "奖励仓库无法储存物品");
		}

		override protected function onClick(event:MouseEvent):void
		{
			super.onClick(event);
			if (!data)
			{
				return;
			}
			var targetSlot:int = SlotItemManager.instance.getFristEmptySlot(ItemConst.CONTAINER_BACKPACK);
			if (targetSlot < 0)
			{
				MessageManager.instance.addHintById_client(29, "背包已满");
			}
			else
			{
				ItemOperateHelper.moveItem(ItemData(data), targetSlot);
			}
		}

		private function get awordDepotView():AwardDepotPanel
		{
			return _awordDepotView ||= AwardDepotPanel(getParentView(AwardDepotPanel));
		}

//		/**
//		 * 构造菜单(派生类可以扩展)
//		 * @param event
//		 *
//		 */
//		override protected function buildMenu():Array
//		{
//			super.buildMenu();
//			var itemData:ItemData = data as ItemData;
//			if (!itemData)
//				return [];
//			return [MenuOperationType.PICK_UP,
//				MenuOperationType.SEND_TO_CHAT];
//		}
		/**
		 * 弹出菜单点击 (派生类可以扩展)
		 * @param event
		 *
		 */
		override protected function onMenuSelect(event:Event):void
		{
			if (!data)
			{
				return;
			}
			var menu:TListMenu = TListMenu(event.currentTarget);
			switch ((menu.list.selectedItem as MenuDataItem).operateType)
			{
				case MenuOperationType.SEND_TO_CHAT:
					(data as IStoredObject).sendToChat();
					break;
				case MenuOperationType.PICK_UP:
					_dragImage.pickUp();
					break;
			}
		}
//		/**
//		 * 物品放下操作
//		 * @param event
//		 *
//		 */
//		private function onItemDropDown(event:DragEvent):void
//		{
//			var imageFrom:TDragableImage = event.dragFromImage as TDragableImage;
//			var imageTarget:TDragableImage = event.dragImageTarget as TDragableImage;
//			var indexTarget:int = awordDepotView.getRenderIndex(imageTarget);
//			switch (imageFrom.place)
//			{
//				case DragImagePlaces.AWORD_DEPOT: //移动
//					var indexFrom:int = ISlotData(DragManager.dragingData).slot & 0x000000FF;
//					//;
//					if (indexFrom == indexTarget)
//						return;
//					ItemOperateHelper.moveItem(ItemData(DragManager.dragingData), ItemConst.CONTAINER_AWORD_DEPOT << 8 | indexTarget);
//					break;
//			}
//		}
	}
}
