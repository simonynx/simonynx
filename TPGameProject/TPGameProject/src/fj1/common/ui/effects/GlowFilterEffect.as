package fj1.common.ui.effects
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;

	import tempest.ui.UIStyle;
	import tempest.ui.effects.BaseEffect;
	import tempest.ui.events.EffectEvent;

	public class GlowFilterEffect extends BaseEffect
	{
		private var _color:uint;

		private var filter:GlowFilter;
		private var _timeSpan:Number;

		private var _minBlurX:Number = 0;
		private var _minBlurY:Number = 0;
		private var _maxBlurX:Number = 10;
		private var _maxBlurY:Number = 10;

		private var STATE_TO:int = 0;
		private var STATE_BACK:int = 1;

		public function GlowFilterEffect(target:DisplayObject, timeSpan:Number = 0.4, color:int = 0xFFFF00)
		{
			super(target);
			_color = color;
			_timeSpan = timeSpan;
			this.addEventListener(EffectEvent.START, onStart);
			this.addEventListener(EffectEvent.END, onEnd);
			filter = new GlowFilter(_color, 1, _minBlurX, _minBlurY, 3);
		}

		public function set minBlurX(value:Number):void
		{
			_minBlurX = value;
		}

		public function set minBlurY(value:Number):void
		{
			_minBlurY = value;
		}

		public function set maxBlurX(value:Number):void
		{
			_maxBlurX = value;
		}

		public function set maxBlurY(value:Number):void
		{
			_maxBlurY = value;
		}

		private function onStart(event:EffectEvent):void
		{
			filter.blurX = _minBlurX;
			filter.blurY = _minBlurY;
			beginTween(STATE_TO);
		}

		private function beginTween(state:int):void
		{
			var onComplete:Function = function(gTween:GTween):void
			{
				state = (state == STATE_TO) ? STATE_BACK : STATE_TO;
				beginTween(state);
			};
			var onChange:Function = function(gTween:GTween):void
			{
				target.filters = [filter];
			};
			if (state == STATE_TO)
			{
				GTweener.to(filter, _timeSpan, {blurX: _maxBlurX, blurY: _maxBlurY}, {onChange: onChange, onComplete: onComplete});
			}
			else
			{
				GTweener.to(filter, _timeSpan, {blurX: _minBlurX, blurY: _minBlurY}, {onChange: onChange, onComplete: onComplete});
			}
		}

		private function onEnd(event:EffectEvent):void
		{
			GTweener.removeTweens(filter);
			target.filters = null;
		}
	}
}
