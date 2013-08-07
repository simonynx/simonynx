package tempest.ui.components
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TComponentEvent;
	import tempest.ui.layouts.LinearLayout;

	public class TExpendableList extends TList
	{
		public function TExpendableList(constraints:Object=null, _proxy:*=null, scrollBarProxy:*=null, listItemClass:*=null, listItemSkinClass:*=null, items:Array=null, useScorllBar:Boolean=true)
		{
			super(constraints, _proxy, scrollBarProxy, listItemClass, listItemSkinClass, items, useScorllBar);
			
			this.addEventListener(TComponentEvent.INVALIDATE_COMPLETE, onInvalidateComplete);
		}
		
		private function onItemRenderResize(event:Event):void
		{
			//Render改变大小时重新布局
			removeAllRenderListener();
			_resetItemData = false;//重新布局时，不需要重新设置数据源
			this.invalidateNow();
			_resetItemData = true;
		}
		
		private function onInvalidateComplete(event:Event):void
		{
			for (var i:int = 0; i < _itemHolder.numChildren; ++i)
			{
				var itemRender:TListItemRender = _itemHolder.getChildAt(i) as TListItemRender;
				itemRender.addEventListener(Event.RESIZE, onItemRenderResize);
			}
		}
		
		private function removeAllRenderListener():void
		{
			for (var i:int = 0; i < _itemHolder.numChildren; ++i)
			{
				var itemRender:TListItemRender = _itemHolder.getChildAt(i) as TListItemRender;
				itemRender.removeEventListener(Event.RESIZE, onItemRenderResize);
			}
		}
	}
}