package fj1.common.events
{
	import flash.events.Event;

	public class CDEvent extends Event
	{
		public static const CDSTART_EVENT:String = "cdstart_event";
		public static const CDEND_EVENT:String = "cdend_event";

		public function CDEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new CDEvent(type, bubbles, cancelable);
		}
	}
}
