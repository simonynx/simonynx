package fj1.common.ui.tips
{
	import fj1.common.data.dataobject.items.EquipmentData;
	import fj1.common.data.dataobject.items.toolTipShowers.ItemToolTipShower;
	import fj1.common.staticdata.ItemConst;
	import fj1.manager.SlotItemManager;
	import flash.events.Event;
	import flash.text.StyleSheet;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.tips.TRichTextToolTip;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.events.TToolTipEvent;

	public class TCompareToolTip extends TToolTip
	{
		private var tipLeft:TRichTextToolTip;
		private var tipRight:TRichTextToolTip;

		public function TCompareToolTip(proxyLeft:* = null, proxyRight:* = null, mouseFollow:Boolean = false, yOffset:Number = 4, xOffset:Number = 0, maxTipWidth:Number = 200,
			tipStyleSheet:StyleSheet = null)
		{
			super(null, mouseFollow, yOffset, xOffset);
			tipLeft = new TRichTextToolTip(proxyLeft, mouseFollow, 0, 0, maxTipWidth, tipStyleSheet);
			tipRight = new TRichTextToolTip(proxyRight, mouseFollow, 0, 0, maxTipWidth, tipStyleSheet);
			this.addEventListener(TToolTipEvent.POS_FIX_TO_LEFT, onPosFixRight);
		}

		override public function set data(value:Object):void
		{
			while (numChildren > 0)
			{
				this.removeChildAt(0);
			}
//			if (_delayCount != 0)
//			{
//				_delayCount = 0;
//			}
			super.data = value;
			tipLeft.data = value;
			tipLeft.x = 0;
			addChild(tipLeft);
			var tipShower:ItemToolTipShower = data as ItemToolTipShower;
			if (tipShower)
			{
				var equip:EquipmentData = tipShower.itemData as EquipmentData;
				if (equip)
				{
					//查找已穿上的同部位装备
					var equip2:EquipmentData = EquipmentData(SlotItemManager.instance.getItemByIndex(ItemConst.CONTAINER_EQUIP, equip.equipmentTemplate.subtype));
					if (equip2 && equip != equip2)
					{
						tipRight.data = equip2.toolTipShower;
						tipRight.x = tipLeft.x + tipLeft.width + 10;
						addChild(tipRight);
					}
				}
			}
			this.measureChildren();
//			this.addEventListener(Event.ENTER_FRAME, onDelayMeasureChildren);
		}

//		private var _delayCount:int = 0;

		private function onDelayMeasureChildren(event:Event):void
		{
//			if (_delayCount < 1)
//			{
//				++_delayCount;
//				return;
//			}
//			_delayCount = 0;
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.measureChildren();
		}

		private function onPosFixRight(event:Event):void
		{
			if (tipLeft.parent && tipRight.parent)
			{
				//互换位置
				tipRight.x = 0;
				tipLeft.x = tipRight.x + tipRight.width + 10;
			}
		}
	}
}
