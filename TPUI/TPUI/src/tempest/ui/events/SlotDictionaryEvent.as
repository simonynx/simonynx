package tempest.ui.events
{
	public class SlotDictionaryEvent extends DataEvent
	{
		public static const ADD:String = "add";
		public static const REMOVE:String = "remove";
		public static const SLOT_CHANGE:String = "slot_change";

		public function SlotDictionaryEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}