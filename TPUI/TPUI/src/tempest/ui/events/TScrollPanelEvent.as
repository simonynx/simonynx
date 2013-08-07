package tempest.ui.events
{
	import flash.events.Event;

	public class TScrollPanelEvent extends Event
	{
		public static const SCORLLBAR_SHOW:String = "scorllbar_show";
		public static const SCORLLBAR_HIDE:String = "scorllbar_hide";

		public function TScrollPanelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new TScrollPanelEvent(type, bubbles, cancelable);
		}

	}
}
