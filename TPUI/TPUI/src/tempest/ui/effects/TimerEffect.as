package tempest.ui.effects
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimerEffect extends BaseEffect
	{
		private var timer:Timer;
		
		public function TimerEffect(delay:Number, target:DisplayObject)
		{
			super(target);
			
			timer = new Timer(delay);
		}
		
		override public function play():void
		{
			super.play();
			if(!timer.running)
			{
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
			}
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			
		}
		
		override public function stop():void
		{
			super.stop();
			if(timer.running)
			{
				timer.removeEventListener(TimerEvent.TIMER, onTimer);	
				timer.reset();
			}
		}
		
		public function set delay(value:Number):void
		{
			timer.delay = value;
		}
	}
}