package  fj1.common.ui
{
	import com.gskinner.motion.GTween;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import tempest.core.IPoolClient;
	import tempest.ui.UIStyle;

	public class AutoHideTextField extends TextField implements IPoolClient
	{
		public static const DISAPPREAR_TIME:int = 1;
		public static const DELAY_TIME:int = 2;
		public static const END_ALPHA:Number = 0.2;
		private var _gTween:GTween;

		private var _disappearTime:Number;
		private var _delayTime:Number;
		private var _endAlpha:Number;

		public function AutoHideTextField()
		{
			super();
			var tfFormat:TextFormat = new TextFormat(null, 12, 0x00FF00);
			this.defaultTextFormat = tfFormat;
			this.filters = [UIStyle.textBoundFilter];
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			_disappearTime = DISAPPREAR_TIME;
			_delayTime = DELAY_TIME;
			_endAlpha = END_ALPHA;
		}

		public function set disappearTime(value:Number):void
		{
			_disappearTime = value;
		}

		public function set delayTime(value:Number):void
		{
			_delayTime = value;
		}

		public function set endAlpha(value:Number):void
		{
			_endAlpha = value;
		}

		private function onRemovedFromStage(event:Event):void
		{
			stopTween();
		}

		private function onAddedToStage(event:Event):void
		{
			_gTween = new GTween(this, _disappearTime, {alpha: _endAlpha});
			_gTween.delay = _delayTime;
			_gTween.onComplete = onComplete;
		}

		private function onComplete(gTween:GTween):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			stopTween();
		}

		public function stopTween():void
		{
			_gTween.onComplete = null;
			_gTween.end();
		}

		public function dispose():void
		{
			_gTween.onComplete = null;
			_gTween.end();
		}

		public function reset(args:Array):void
		{

		}

	}
}
