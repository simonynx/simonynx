package fj1.common.ui.tips
{
	import fj1.common.data.dataobject.items.EquipmentData;
	import fj1.common.data.dataobject.items.toolTipShowers.EquipToolTipShower;
	import fj1.common.data.dataobject.items.toolTipShowers.ItemToolTipShower;
	import fj1.common.net.tcpLoader.ItemLoader;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.staticdata.ItemConst;
	import fj1.manager.SlotItemManager;

	import flash.events.Event;
	import flash.text.StyleSheet;

	import tempest.ui.components.tips.TRichTextToolTip;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.events.TToolTipEvent;
	import tempest.ui.interfaces.IToolTipClient;

	public class LoaderCompareTip extends TToolTip
	{
		public var tipLeft:LoaderTip;
		public var tipRight:TRichTextToolTip;

		public function LoaderCompareTip(proxyLeft:* = null, proxyRight:* = null, mouseFollow:Boolean = false, yOffset:Number = 4, xOffset:Number = 0, maxTipWidth:Number = 200, tipStyleSheet:StyleSheet =
			null)
		{
			super(null, mouseFollow, yOffset, xOffset);
			tipLeft = new LoaderTip(proxyLeft, mouseFollow, 0, 0, maxTipWidth, tipStyleSheet);
			tipRight = new TRichTextToolTip(proxyRight, mouseFollow, 0, 0, maxTipWidth, tipStyleSheet);
			this.addEventListener(TToolTipEvent.POS_FIX_TO_LEFT, onPosFixRight);
			tipLeft.complete.add(onLoadComplete);
		}

		override public function set data(value:Object):void
		{
			while (numChildren > 0)
			{
				this.removeChildAt(0);
			}
			super.data = value;
			tipLeft.data = value;
			tipLeft.x = 0;
			addChild(tipLeft);
			if (!(value is TCPLoader))
			{
				showRightTip(value);
			}
			else
			{
				var tcpLoader:TCPLoader = TCPLoader(value);
				if (tcpLoader.completed && !tcpLoader.failed)
				{
					showRightTip(tcpLoader.content as EquipmentData);
				}
			}
			this.measureChildren();
		}

		private function onLoadComplete(loaderTip:LoaderTip):void
		{
			showRightTip(TCPLoader(data).content as EquipmentData);
			this.measureChildren();
		}

		private function showRightTip(value:*):void
		{
			var equipData:EquipmentData;
			if (value is EquipToolTipShower)
			{
				equipData = EquipmentData(EquipToolTipShower(value).itemData);
			}
			else
			{
				equipData = value as EquipmentData;
			}
			if (equipData)
			{
				//查找已穿上的同部位装备
				var equip2:EquipmentData = EquipmentData(SlotItemManager.instance.getItemByIndex(ItemConst.CONTAINER_EQUIP, equipData.equipmentTemplate.subtype));
				if (equip2 && equipData != equip2)
				{
					tipRight.data = equip2.toolTipShower;
					tipRight.x = tipLeft.x + tipLeft.width + 10;
					addChild(tipRight);
				}
			}
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
