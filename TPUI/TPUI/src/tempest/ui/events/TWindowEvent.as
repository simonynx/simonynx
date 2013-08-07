package tempest.ui.events
{
	import flash.events.Event;

	public class TWindowEvent extends DataEvent
	{
		public static const WINDOW_CLOSE:String = "windowClose";
		public static const REGISTER:String = "register";
		public static const WINDOW_SHOW:String = "windowShow";
		public static const MOVE_TO_TOP:String = "moveToTop";
		public static const WINDOW_CLOSE_START:String = "windowCloseStart";

		public function TWindowEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

	}
}
