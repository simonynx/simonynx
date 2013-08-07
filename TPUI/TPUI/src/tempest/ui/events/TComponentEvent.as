package tempest.ui.events
{
	import flash.events.Event;

	public class TComponentEvent extends Event
	{
		public static const STOP_RIPPING:String = "stopRipping";
		public static const START_RIPPING:String = "startRipping";
		public static const DRAW:String = "draw";
		public static const SHOW:String = "show";
		public static const HIDE:String = "hide";
		public static const MOVE:String = "move";
		public static const INVALIDATE_COMPLETE:String = "InvalidateComplete";
		public static const SHOW_TIP:String = "showTip";
		public static const HIDE_TIP:String = "hideTip";

		public function TComponentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new TComponentEvent(type, bubbles, cancelable);
		}

	}
}
