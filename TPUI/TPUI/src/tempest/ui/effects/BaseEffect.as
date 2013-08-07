package tempest.ui.effects
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import tempest.ui.events.EffectEvent;

	[Event(name = "end", type = "tempest.ui.events.EffectEvent")]
	[Event(name = "start", type = "tempest.ui.events.EffectEvent")]
	public class BaseEffect extends EventDispatcher implements IEffect
	{

		protected var _target:DisplayObject;
		private var _playing:Boolean;

		/**
		 *
		 * @param delay 持续时间
		 * @param target 作用目标
		 *
		 */
		public function BaseEffect(target:DisplayObject)
		{
			super(this);
			_target = target;
		}

		public function play():void
		{
			if (!_playing)
			{
				_playing = true;
				dispatchEvent(new EffectEvent(EffectEvent.START));
			}
		}

		public function stop():void
		{
			if (_playing)
			{
				_playing = false;
				dispatchEvent(new EffectEvent(EffectEvent.END));
			}
		}

		public function dispose():void
		{
			stop();
		}

		public function reset():void
		{

		}

		public function cancel():void
		{
			if (_playing)
			{
				_playing = false;
			}
			dispatchEvent(new EffectEvent(EffectEvent.CANCALED));
		}

		public function get playing():Boolean
		{
			return _playing;
		}

		public function get target():DisplayObject
		{
			return _target;
		}
	}
}
