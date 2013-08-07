package tempest.ui.events
{
	import flash.events.Event;

	public class FetchEvent extends Event
	{
		public static const FETCH:String = "fetch";
		public static const CANCEL:String = "cancel";

		private var _fetchType:int;
		private var _params:Object;

		public function FetchEvent(type:String, fetchType:int, params:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_fetchType = fetchType;
			_params = params;
			super(type, bubbles, cancelable);
		}

		public function get params():Object
		{
			return _params;
		}

		public function get fetchType():int
		{
			return _fetchType;
		}

		override public function clone():Event
		{
			return new FetchEvent(type, _fetchType, _params, bubbles, cancelable);
		}
	}
}
