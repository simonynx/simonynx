package tempest.ui.events
{
	import flash.events.Event;

	public class TComboboxEvent extends Event
	{
		public static const MENU_DROP_DOWN:String = "menuDropDown";

		public function TComboboxEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new TComboboxEvent(type, bubbles, cancelable);
		}
	}
}
