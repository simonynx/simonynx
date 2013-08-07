package tempest.ui.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import tempest.ui.UIStyle;

	public class TextList extends TList
	{
		public function TextList(constraints:Object = null, _proxy:* = null, scrollBarProxy:* = null, itemRenderClass:* = null, listItemSkinClass:* = null, items:Array = null, useScorllBar:Boolean = true)
		{
			if (!itemRenderClass)
			{
				itemRenderClass = UIStyle.textListItemRender;
			}
			if (!listItemSkinClass)
			{
				listItemSkinClass = UIStyle.listItemSkin;
			}
			super(constraints, _proxy, scrollBarProxy, itemRenderClass, listItemSkinClass, items, useScorllBar);
		}
	}
}