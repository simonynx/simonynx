package fj1.common.events.item
{
	import tempest.ui.events.DataEvent;

	public class SlotItemManagerEvent extends DataEvent
	{
		public static const RESIZE_LIST:String = "resize_list";

		public function SlotItemManagerEvent(type:String, data:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}
