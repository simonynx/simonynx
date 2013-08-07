package tempest.ui.events
{
	import flash.events.Event;

	public class EffectEvent extends Event
	{
		public static const END:String = "end";
		public static const START:String = "start";
		public static const CANCALED:String = "canceled";

		public function EffectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new EffectEvent(type, bubbles, cancelable);
		}
	}
}
