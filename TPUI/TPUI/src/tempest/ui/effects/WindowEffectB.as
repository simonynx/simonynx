package tempest.ui.effects
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import tempest.ui.components.TWindow;
	import tempest.ui.events.EffectEvent;

	public class WindowEffectB extends EventDispatcher implements IWindowEffect
	{
		private var _target:TWindow;
		private var _effectOpen:OpenEffect;
		private var _effectClose:CloseEffect;


		public function WindowEffectB(target:TWindow)
		{
			super(this);
			_target = target;
			_effectOpen = new OpenEffect(_target);
			_effectClose = new CloseEffect(_target);

			_effectClose.addEventListener(EffectEvent.END, onCloseEffectEnd);
		}

		private function onCloseEffectEnd(event:EffectEvent):void
		{
			this.dispatchEvent(new EffectEvent(EffectEvent.END));
			this.dispatchEvent(new WindowEffectEvent(WindowEffectEvent.CLOSE_WINDOW));
		}

		public function playOpenEffect():void
		{
			if (_effectOpen.playing)
			{
				return;
			}
			if (_effectClose.playing)
			{
				_effectClose.cancel();
			}
			_effectOpen.play();
		}

		public function playCloseEffect():void
		{
			if (_effectClose.playing)
			{
				return;
			}
			if (_effectOpen.playing)
			{
				_effectOpen.cancel();
			}
			_effectClose.play();
		}

		public function get openEffect():IEffect
		{
			return _effectOpen;
		}

		public function get closeEffect():IEffect
		{
			return _effectClose;
		}

		public function play():void
		{
		}

		public function stop():void
		{
		}

		public function dispose():void
		{
			_effectOpen.dispose();
			_effectClose.dispose();
		}

		public function reset():void
		{
		}

		public function cancel():void
		{
		}

		public function get playing():Boolean
		{
			return _effectOpen.playing || _effectClose.playing;
		}
	}
}
import com.gskinner.motion.GTween;
import com.gskinner.motion.GTweener;

import flash.events.Event;
import flash.events.EventDispatcher;

import tempest.ui.components.TWindow;
import tempest.ui.effects.BaseEffect;
import tempest.ui.effects.IEffect;
import tempest.ui.events.EffectEvent;

class OpenEffect extends BaseEffect implements IEffect
{
	private var _gtween:GTween;

	public function OpenEffect(target:TWindow)
	{
		super(target);
		this.addEventListener(EffectEvent.START, onStart);
		this.addEventListener(EffectEvent.END, onEnd);
	}

	private function onStart(event:Event):void
	{
		_target.alpha = 0;
		_gtween = GTweener.to(_target, 0.3, {alpha: 1}, {onComplete: function(gt:GTween):void
		{
			_gtween = null;
			stop();
		}});
	}

	private function onEnd(event:Event):void
	{
		if (_gtween)
		{
			GTweener.remove(_gtween);
		}
	}
}

class CloseEffect extends BaseEffect implements IEffect
{
	private var _gtween:GTween;

	public function CloseEffect(target:TWindow)
	{
		super(target);
		this.addEventListener(EffectEvent.START, onStart);
		this.addEventListener(EffectEvent.END, onEnd);
	}

	private function onStart(event:Event):void
	{
		_gtween = GTweener.to(_target, 0.3, {alpha: 0}, {onComplete: function(gt:GTween):void
		{
			_gtween = null;
			_target.alpha = 1;
			stop();
		}});
	}

	private function onEnd(event:Event):void
	{
		if (_gtween)
		{
			GTweener.remove(_gtween);
		}
		_target.alpha = 1;
	}
}

