package tempest.ui.events
{
	public class SlotEvent extends DataChangeEvent
	{
		public static const SLOT_CHANGE:String = "slotChange";
		public static const SLOT_REMOVE:String = "slotRemove";
		
		public function SlotEvent(type:String, oldData:*, newData:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, oldData, newData, bubbles, cancelable);
		}
	}
}