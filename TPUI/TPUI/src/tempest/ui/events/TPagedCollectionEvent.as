package tempest.ui.events
{
	import flash.events.Event;

	public class TPagedCollectionEvent extends Event
	{
		public static const HOST_CHANGE:String = "hostChange";

		private var _oldValue:*;
		private var _newValue:*

		public function TPagedCollectionEvent(type:String, oldValue:*, newValue:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_oldValue = oldValue;
			_newValue = newValue;
		}

		public override function clone():Event
		{
			return new TPagedCollectionEvent(type, _oldValue, newValue, bubbles, cancelable);
		}

		public function get oldValue():*
		{
			return _oldValue;
		}

		public function get newValue():*
		{
			return _newValue;
		}
	}
}
