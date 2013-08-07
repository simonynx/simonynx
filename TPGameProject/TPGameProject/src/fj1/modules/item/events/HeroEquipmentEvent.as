package fj1.modules.item.events
{
	import tempest.ui.events.DataEvent;

	public class HeroEquipmentEvent extends DataEvent
	{
		public static const ADD:String = "add";
		public static const REMOVE:String = "remove";

		private var _pos:int;

		public function HeroEquipmentEvent(type:String, data:*, pos:int, bubbles:Boolean = false, cancelable:Boolean = false)
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
