package fj1.modules.mainUI.hintAreas
{
	import assets.ResLib;
	import com.gskinner.motion.GTween;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import tempest.common.rsl.TRslManager;

	public class MainUITaskHintArea extends BaseFlyObjectArea
	{
		public static const DISAPPREAR_TIME:int = 1;
		public static const DELAY_TIME:int = 2;
		public static const END_ALPHA:Number = 0.2;
		private static const MOVE_DELAY:Number = 50;
		private static const MOVE_TIME:Number = 0.5;
		private var _gTween:GTween;
		private var hintText:TextField;
		private var _disappearTime:Number;
		private var _delayTime:Number;
		private var _endAlpha:Number;
		private var _taskHintMC:MovieClip;

		public function MainUITaskHintArea(parent:DisplayObjectContainer, constraints:Object, width:Number, height:Number, maxLen:int)
		{
			super(parent, constraints, width, height, maxLen);
			_taskHintMC = TRslManager.getInstance(ResLib.UI_EFFECT_TASKHINT) as MovieClip;
			_disappearTime = DISAPPREAR_TIME;
			_delayTime = DELAY_TIME;
			_endAlpha = END_ALPHA;
			moveTime = MOVE_TIME;
			moveDelay = MOVE_DELAY;
		}

		public function addText(value:String):void
		{
			var taskHintMC:MovieClip = TRslManager.getInstance(ResLib.UI_EFFECT_TASKHINT);
			hintText = taskHintMC.getChildByName("lbl_time") as TextField;
			var gTween:GTween;
			taskHintMC.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void
			{
				gTween = new GTween(event.target, _disappearTime, {alpha: _endAlpha}, {onComplete: function(gt:GTween):void
				{
					gTween.onComplete = null;
					gTween.end();
					event.target.dispatchEvent(new Event(Event.COMPLETE));
				}});
				gTween.delay = _delayTime;
			});
			taskHintMC.addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):void
			{
				gTween.onComplete = null;
				gTween.end();
			});
			hintText.text = value;
			this.addObject(taskHintMC);
		}

//		private function onRemoveFromStage(event:Event):void
//		{
//			stopTween();
//		}
//		private function onAddedToStage(event:Event):void
//		{
//			_gTween = new GTween(event.target, _disappearTime, {alpha: _endAlpha}, {onComplete: function(gt:GTween):void
//			{
//				stopTween();
//				event.target.dispatchEvent(new Event(Event.COMPLETE));
//			}});
//			_gTween.delay = _delayTime;
//		}
//		public function stopTween():void
//		{
//			_gTween.onComplete = null;
//			_gTween.end();
//		}
		public override function dispose():void
		{
			super.dispose();
//			_gTween.onComplete = null;
//			_gTween.end();
		}

		public function reset(args:Array):void
		{
		}
	}
}
