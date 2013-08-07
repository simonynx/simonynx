package tempest.ui.components
{
	import tempest.ui.events.DataChangeEvent;
	import tempest.ui.events.ListEvent;

	[Event(name="pickUp", type="tempest.ui.events.DragEvent")]
	[Event(name="dropDown", type="tempest.ui.events.DragEvent")]
	[Event(name="dropOut", type="tempest.ui.events.DragEvent")]
	[Event(name="dragDataChange", type="tempest.ui.events.DataChangeEvent")]
	public class TItemDragableList extends TList
	{
		protected var _checkDropDown:Boolean;
		
		public function TItemDragableList(constraints:Object=null, _proxy:*=null, scrollBarProxy:*=null, listItemClass:Class=null, listItemSkinClass:*=null, items:Array=null, useScorllBar:Boolean=true)
		{
			super(constraints, _proxy, scrollBarProxy, listItemClass, listItemSkinClass, items, useScorllBar);
			
			this.addEventListener(ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
		}
		
		private function onItemRenderCreate(event:ListEvent):void
		{
			var itemRender:TListItemRender = event.data as TListItemRender;
			if(!_checkDropDown && itemRender && !itemRender.hasEventListener(DataChangeEvent.DRAG_DATA_CHANGE))
			{
				itemRender.addEventListener(DataChangeEvent.DRAG_DATA_CHANGE, onDragDataChange);
			}
		}
		
		/**
		 * 利用dragdataChange事件，同步 _items
		 * @param event
		 * 
		 */		
		protected function onDragDataChange(event:DataChangeEvent):void
		{
			if(!_checkDropDown)
			{
				if(_items)
				{
					var itemRender:TListItemRender = event.currentTarget as TListItemRender;
					_items[itemRender.index] = itemRender.data;
				}
			}
		}
	}
}