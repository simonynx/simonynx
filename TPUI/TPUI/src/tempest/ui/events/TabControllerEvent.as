package tempest.ui.events
{
	import flash.events.Event;

	public class TabControllerEvent extends Event
	{
		public static const TAB_INIT:String = "tabInit";
		public static const TAB_DISPOSE:String = "tabDispose";
		public static const CHANGE:String = "change";
		public static const CHANGE_FAILED:String = "change_failed"

		private var _tabIndex:int;

		public function TabControllerEvent(type:String, tabIndex:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_tabIndex = tabIndex;
		}

		public function get tabIndex():int
		{
			return _tabIndex;
		}

		override public function clone():Event
		{
			return new TabControllerEvent(type, _tabIndex, bubbles, cancelable);
		}
	}
}
