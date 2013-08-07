package tempest.ui.events
{
	import flash.events.Event;

	public class TAlertEvent extends DataEvent
	{
		public function TAlertEvent(type:String, flag:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, flag, bubbles, cancelable);
		}

		public function get flag():int
		{
			return int(_data);
		}

		public override function clone():Event
		{
			return new TAlertEvent(type, flag, bubbles, cancelable);
		}
	}
}
