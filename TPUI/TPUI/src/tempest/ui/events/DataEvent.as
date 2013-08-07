package tempest.ui.events
{
	import flash.events.Event;

	public class DataEvent extends Event
	{
		protected var _data:*;

		public static const DATA:String = "data";
		public static const SELECT:String = "select";
		public static const DATA_SELECT:String = "dataSelect";

		public function DataEvent(type:String, data:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			_data = data;
		}

		public function get data():*
		{
			return _data;
		}

		public override function clone():Event
		{
			return new DataEvent(type, data, bubbles, cancelable);
		}
	}
}
