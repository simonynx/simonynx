package tempest.ui.events
{
	import flash.events.Event;

	public class TTreeEvent extends Event
	{
		public static const SPREAD_NODE:String = "spreadNode";
		public static const RETRACT_NODE:String = "retractNode";

		public function TTreeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			return new TTreeEvent(type, bubbles, cancelable);
		}
	}
}
