package fj1.common.events
{
	import flash.events.Event;

	public class DataObjectEvent extends Event
	{
		public static const CDSTATE_RESET:String = "cdStateReset";

		public function DataObjectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new DataObjectEvent(type, bubbles, cancelable);
		}
	}
}
