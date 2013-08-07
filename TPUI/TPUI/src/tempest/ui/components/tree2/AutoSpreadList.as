package tempest.ui.components.tree2
{
	import flash.events.Event;

	import tempest.ui.components.IList;
	import tempest.ui.components.TList;
	import tempest.ui.events.ListEvent;

	public class AutoSpreadList extends TList
	{
		public function AutoSpreadList(constraints:Object = null, itemRenderClass:* = null, listItemSkinClass:* = null, items:Array = null)
		{
			super(constraints, null, null, itemRenderClass, listItemSkinClass, items, false);
			addEventListener(ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			event.itemRender.addEventListener(Event.RESIZE, onRenderResize);
		}

		private function onRenderResize(event:Event):void
		{
			_resetItemData = false; //重新布局时，不需要重新设置数据源
			this.invalidateNow();
			_resetItemData = true;
		}
	}
}
