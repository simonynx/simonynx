package fj1.modules.mainUI.hintAreas
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Timer;
	import tempest.ui.components.TComponent;

	/**
	 *
	 * @author zhoubo
	 *
	 */
	public class SystemAlert extends TComponent
	{
		private var timer:Timer;
		private var intence:SystemAlert;
		private var tf:TextField;

		public function SystemAlert(constraints:Object, width:Number, height:Number)
		{
			var shape:Sprite = new Sprite();
			shape.graphics.drawRect(0, 0, width, height);
			super(constraints, shape);
		}

		public function show(msg:String = "", color:uint = 0xff0000, movetime:int = 2):void
		{
//			timer = new Timer(1000, movetime);
//			if (timer.running == true && tf)
//			{
//				timer.stop();
//				this.removeChild(tf);
//			}
			tf = new TextField();
			tf.text = msg;
			tf.backgroundColor = color;
			this.addObject(tf)
		}

		private function addObject(value:DisplayObject):void
		{
			this.addChild(value);
//			if (tf.text != "")
//			{
//				timer.start();
//			}
//			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

//		private function onTimer(event:TimerEvent):void
//		{
//			if (timer.running == false)
//			{
//				timer.stop();
//				timer.removeEventListener(TimerEvent.TIMER, onTimer);
//				this.removeChild(tf);
//				return;
//			}
//			else
//			{
//				tf.y += tf.height;
//			}
//			this.addChild(tf);
//		}
		override public function invalidateSize(changed:Boolean = false):void
		{
		}
	}
}
