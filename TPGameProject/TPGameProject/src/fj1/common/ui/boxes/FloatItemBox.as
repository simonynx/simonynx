package fj1.common.ui.boxes
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.interfaces.IUseable;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FloatItemBox extends BaseDataBox
	{
		public function FloatItemBox(proxy:* = null, dragBackAreaArray:Array = null, constraints:Object = null)
		{
			super(proxy, dragBackAreaArray, constraints);
//			useDoubleClick = true;
//			addEventListener(MouseEvent.DOUBLE_CLICK, onItemBoxDoubleClick);
		}

		override protected function onClick(event:MouseEvent):void
		{
			super.onClick(event);
			ItemData(data).useObj();
		}

//		override protected function buildMenu():Array
//		{
//			super.buildMenu();
//			var itemData:ItemData = data as ItemData;
//			if (!itemData)
//				return [];
//			if (itemData is EquipmentData)
//			{
//				return [MenuOperationType.EQUIP];
//			}
//			else
//			{
//				if (itemData.num > 1)
//					return itemData.itemTemplate.can_be_use ? [MenuOperationType.USE] : [];
//				else
//					return itemData.itemTemplate.can_be_use ? [MenuOperationType.USE] : [];
//			}
//		}
//
//		override protected function onMenuSelect(event:Event):void
//		{
//			super.onMenuSelect(event);
//			switch ((_menu.list.selectedItem as MenuDataItem).operateType)
//			{
//				case MenuOperationType.USE:
//				case MenuOperationType.EQUIP:
//					(data as IUseable).useObj();
//					break;
//					break;
//			}
//		}
//
//
//		private function onItemBoxDoubleClick(event:MouseEvent):void
//		{
//
//		}

	}
}
