package fj1.modules.item.events
{
	import flash.events.Event;
	
	import tempest.ui.events.DataEvent;
	
	public class PlayerTradeEvent extends DataEvent
	{
		public static const LOCK:String = "PlayerTradeEvent.lock";
		
		public function PlayerTradeEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}