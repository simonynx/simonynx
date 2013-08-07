package tempest.ui.effects
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import tempest.ui.events.EffectEvent;

	public class ToBackEffect implements IWindowEffect
	{
		private var eventDispatcher:EventDispatcher;
		private const STATE_TO:int = 1;
		private const STATE_BACK:int = 2;
		protected var _toEffect:BaseEffect;
		protected var _backEffect:BaseEffect;
		private var _state:int;
		private var _breakable:Boolean = false; //标记播放是否可以被中断, true为可以被中断

		public function ToBackEffect(toEffect:BaseEffect, backEffect:BaseEffect)
		{
			eventDispatcher = new EventDispatcher(this);
			_state = STATE_TO;
			_toEffect = toEffect;
			_backEffect = backEffect;
			_toEffect.addEventListener(EffectEvent.START, onToEffectStart);
			_toEffect.addEventListener(EffectEvent.END, onToEffectEnd);
			_backEffect.addEventListener(EffectEvent.START, onBackEffectStart);
			_backEffect.addEventListener(EffectEvent.END, onBackEffectEnd);
		}

		private function onToEffectStart(event:Event):void
		{
			_state = STATE_BACK;
		}

		private function onBackEffectStart(event:Event):void
		{
			_state = STATE_TO;
		}

		private function onToEffectEnd(event:Event):void
		{
//			eventDispatcher.dispatchEvent(event);
		}

		/**
		 * 收起效果播放完后发出End事件
		 * @param event
		 *
		 */
		protected function onBackEffectEnd(event:Event):void
		{
			eventDispatcher.dispatchEvent(new EffectEvent(EffectEvent.END));
			eventDispatcher.dispatchEvent(new WindowEffectEvent(WindowEffectEvent.CLOSE_WINDOW)); //在关闭效果播放完成后关闭窗口
		}

		public function play():void
		{
//			if (!_breakable) //不可中断状态下，返回
//				return;
			if (_state == STATE_TO)
			{
				if (_backEffect.playing)
				{
					if (!_breakable)
						return;
					else
						_backEffect.cancel();
				}
				_toEffect.play();
			}
			else if (_state == STATE_BACK)
			{
				if (_toEffect.playing)
				{
					if (!_breakable)
						return;
					else
						_toEffect.cancel();
				}
				_backEffect.play();
			}
		}

		/**
		 * 只播放弹出效果
		 *
		 */
		public function playOpenEffect():void
		{
			if (_toEffect.playing)
				return;
			if (_backEffect.playing)
			{
				if (!_breakable)
					return;
				else
					_backEffect.cancel();
			}
			_toEffect.play();
		}

		/**
		 * 只播放收起效果
		 *
		 */
		public function playCloseEffect():void
		{
			if (_backEffect.playing)
				return;
			if (_toEffect.playing)
			{
				if (!_breakable)
					return;
				else
					_toEffect.cancel();
			}
			_backEffect.play();
		}

		public function stop():void
		{
			_toEffect.stop();
			_backEffect.stop();
		}

		public function reset():void
		{
		}

		public function cancel():void
		{
		}

		public function dispose():void
		{
			_toEffect.dispose();
			_backEffect.dispose();
		}

		public function get openEffect():IEffect
		{
			return _toEffect;
		}

		public function get closeEffect():IEffect
		{
			return _backEffect;
		}

		public function get playing():Boolean
		{
			return _toEffect.playing || _backEffect.playing;
		}

		/*****************************************IEventDispatcher************************************/
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			return eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
	}
}
