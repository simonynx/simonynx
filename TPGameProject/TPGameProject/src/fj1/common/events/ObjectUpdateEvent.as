package fj1.common.events
{
	import flash.events.Event;

	public class ObjectUpdateEvent extends Event
	{
		private var _eventList:Array;

		public static const UPDATE:String = "update";

		public function get eventList():Array
		{
			return _eventList;
		}

		public function ObjectUpdateEvent(type:String, eventList:Array, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_eventList = eventList;
		}

		override public function clone():Event
		{
			return new ObjectUpdateEvent(type, _eventList, bubbles, cancelable);
		}
	}
}
