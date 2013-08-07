package fj1.modules.chat.view.components
{
	import assets.UIHudLib;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	import tempest.common.rsl.RslManager;
	import tempest.ui.UIConst;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TList;
	import tempest.ui.components.TMenuContainer;
	import tempest.ui.effects.MenuEffect;
	import tempest.ui.events.ListEvent;

	public class SmileyListPanel extends TMenuContainer
	{
		public var list:TList;
		private var _selectedSignal:ISignal;

		public function SmileyListPanel(target:DisplayObject = null)
		{
			super(null, UIStyle.tipBkSkin, target, false, [target], false, MenuEffect.DERECT_UP, target);
			var shape:Shape = new Shape();
			shape.graphics.drawRect(0, 0, 330, 10);
			list = new TList(null, shape, null, SmileyItemRender, RslManager.getDefinition(UIHudLib.SMILEY_ITEM_RENDER), null, false);
			list.horizontalAlign = UIConst.LEFT;
			list.addEventListener(Event.SELECT, onSelect);
//			list.columnCount = 10;
			list.type = UIConst.TILE;
			list.fixedHeight = -1;
			this.addChild(list);
		}

		public function set items(value:Array):void
		{
			if (list.items != value)
			{
				list.items = value;
				list.invalidateNow();
				this.measureChildren();
			}
		}

		public function get selectedSignal():ISignal
		{
			return _selectedSignal ||= new Signal();
		}

		private function onSelect(event:Event):void
		{
			selectedSignal.dispatch(list.selectedItem);
			list.removeEventListener(Event.SELECT, onSelect);
			list.selectedIndex = -1;
			list.addEventListener(Event.SELECT, onSelect);
			this.play();
		}
	}
}
