package tempest.ui.events
{
	import flash.events.Event;
	
	import tempest.ui.components.TListItemRender;

	public class ListEvent extends DataEvent
	{
		public function ListEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new ListEvent(type, data, bubbles,cancelable);
		}
		
		public function get itemRender():TListItemRender
		{
			return data as TListItemRender;
		}
		
		public static const ITEM_RENDER_CREATE:String = "itemRenderCreate";
		public static const REMOVE:String = "remove";
		public static const ADD:String = "add";
	}
}