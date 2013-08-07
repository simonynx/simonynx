package fj1.modules.item.events
{
	import flash.events.Event;

	import tempest.ui.events.DataEvent;

	public class ItemEvent extends DataEvent
	{
		public static const ADD:String = "add";
		public static const REMOVE:String = "remove";
		public static const UPDATE:String = "update";
		public static const RESIZE_BAG:String = "resizeBag";
		public static const MOVE:String = "move";

		private var _pos:int;

		public function ItemEvent(type:String, data:*, pos:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
			_pos = pos;
		}

		public function get pos():int
		{
			return _pos;
		}
	}
}
