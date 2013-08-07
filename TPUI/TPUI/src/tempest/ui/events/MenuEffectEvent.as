package tempest.ui.events
{
	import flash.events.Event;
	
	public class MenuEffectEvent extends Event
	{
		public function MenuEffectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const DEPLOY:String = "deploy";
		public static const RETRACTION:String = "retraction";
	}
}