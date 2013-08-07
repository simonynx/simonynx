package tempest.ui.events
{
	import flash.events.Event;
	
	import tempest.ui.components.TWindow;
	
	public class TWindowPoolEvent extends DataEvent
	{
		public static const WINDOW_SHOW:String = "window_show";
		public static const WINDOW_CLOSE:String = "window_close";

		public function TWindowPoolEvent(type:String, data:TWindow, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
		
		public function get targetWindow():TWindow
		{
			return TWindow(data);
		}
	}
}