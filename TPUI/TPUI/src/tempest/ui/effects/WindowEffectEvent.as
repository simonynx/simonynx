package tempest.ui.effects
{
	import flash.events.Event;

	public class WindowEffectEvent extends Event
	{
		public static const CLOSE_WINDOW:String = "closeWindow";

		public function WindowEffectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new WindowEffectEvent(type, bubbles, cancelable);
		}
	}
}
