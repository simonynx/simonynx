package fj1.common.ui
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import tempest.common.time.vo.TimerData;
	import tempest.core.IPoolClient;
	import tempest.manager.TimerManager;
	import tempest.ui.UIStyle;

	public class AutoCompleteTextField extends TextField implements IPoolClient
	{
		private var _timer:TimerData;
		private var _completeTime:Number;
		public static const COMPLETE_TIME:Number = 3;

		public function AutoCompleteTextField()
		{
			super();
			_completeTime = COMPLETE_TIME;
			var tfFormat:TextFormat = new TextFormat(null, 12, 0x00FF00);
			this.defaultTextFormat = tfFormat;
			this.filters = [UIStyle.textBoundFilter];
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.mouseEnabled = false;
		}

		private function onRemovedFromStage(event:Event):void
		{
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
		}

		public function set completeTime(value:Number):void
		{
			_completeTime = value;
		}

		private function onAddedToStage(event:Event):void
		{
			_timer = TimerManager.createNormalTimer(_completeTime * 1000, 1, null, null, onComplete);
		}

		private function onComplete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
		}

		public function dispose():void
		{
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
		}

		public function reset(args:Array):void
		{


		}

	}
}
