package tempest.ui.events
{
	import flash.events.Event;

	public class DataChangeEvent extends Event
	{
		protected var _oldData:*;
		protected var _newData:*;

		public static const DATA_CHANGE:String = "dataChange";
		public static const DRAG_DATA_CHANGE:String = "dragDataChange";

		public function DataChangeEvent(type:String, oldData:*, newData:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			_oldData = oldData;
			_newData = newData;
		}

		public function get oldData():*
		{
			return _oldData;
		}

		public function get newData():*
		{
			return _newData;
		}

		override public function clone():Event
		{
			return new DataChangeEvent(type, _oldData, _newData, bubbles, cancelable);
		}
	}
}
