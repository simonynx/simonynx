package tempest.ui.events
{
	import flash.events.Event;

	public class TToolTipEvent extends Event
	{
		public static const POS_FIX_TO_UP:String = "posfixtoup";
		public static const POS_FIX_TO_LEFT:String = "posfixtoleft";

		public function TToolTipEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new TToolTipEvent(type, bubbles, cancelable);
		}

	}
}
