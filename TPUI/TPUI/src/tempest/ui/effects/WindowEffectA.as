package tempest.ui.effects
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import tempest.ui.events.EffectEvent;

	public class WindowEffectA implements IWindowEffect
	{
		//播放时间
		public static const OPEN_DELAY:Number = 6; //0.2;
		public static const CLOSE_DELAY:Number = 6; //0.2;

		private static const STATE_CLOSE:int = 1;
		private static const STATE_OPEN:int = 2;
		private var _state:int;

		private var _effectOpen:WindowOpenEffectA;
		private var _effectClose:WindowCloseEffectA;

		private var _target:DisplayObject;
		private var _targetSnapshot:Object;

		private var _eventDispatcher:EventDispatcher;

		/**
		 *
		 * @param delay 播放时间
		 * @param target 播放目标
		 * @param fromControl 动作起始点对象
		 *
		 */
		public function WindowEffectA(target:DisplayObject, fromControl:DisplayObject = null, offset:Point = null)
		{
			_eventDispatcher = new EventDispatcher(this);
			_state = STATE_CLOSE;
			_target = target;
			_effectOpen = new WindowOpenEffectA(OPEN_DELAY, target, fromControl, offset);
			_effectClose = new WindowCloseEffectA(CLOSE_DELAY, target, fromControl, offset);
			_effectOpen.addEventListener(EffectEvent.END, onToEffectEnd);
			_effectClose.addEventListener(EffectEvent.END, onBackEffectEnd);
		}

		private function onToEffectEnd(event:EffectEvent):void
		{
			_state = STATE_OPEN;
		}

		private function onBackEffectEnd(event:EffectEvent):void
		{
			_state = STATE_CLOSE;
			_eventDispatcher.dispatchEvent(new EffectEvent(EffectEvent.END));
		}

		public function setFromPos(x:Number, y:Number):void
		{
			_effectOpen.setFromPos(x, y);
			_effectClose.setToPos(x, y);
		}

		public function set fromControl(value:DisplayObject):void
		{
			_effectOpen.controlFrom = value;
			_effectClose.controlTo = value;
		}

		private var _openDelayTween:GTween;

		public function playOpenEffect():void
		{
			if (_openDelayTween) //正在打开动画前的延时中
			{
				return;
			}
			if (_effectOpen.playing)
			{
				return;
			}
			if (_effectClose.playing)
			{
				_effectClose.cancel();
				_effectOpen.play();
			}
			else
			{
				_target.alpha = 0; //隐藏窗口
				_openDelayTween = GTweener.to(_target, 2, null, {useFrames: true});
				_openDelayTween.onComplete = function(gTween:GTween):void //延时几帧截取Snapshot
				{
					_openDelayTween = null;
					_target.alpha = 1;
					_targetSnapshot = getSnapshot(_target);
					_effectOpen.targetSnapshot = _targetSnapshot;
					_effectClose.targetSnapshot = _targetSnapshot;
					_effectOpen.play();
				}
			}
		}

		public function playCloseEffect():void
		{
			if (_openDelayTween) //正在打开动画前的延时中
			{
				_openDelayTween.paused = true;
				_openDelayTween = null;
//				_eventDispatcher.dispatchEvent(new EffectEvent(EffectEvent.END));
				_eventDispatcher.dispatchEvent(new WindowEffectEvent(WindowEffectEvent.CLOSE_WINDOW)); //在关闭效果刚开始播放时关闭窗口, 而不是在关闭效果播放完成后
				return;
			}
			if (_effectClose.playing)
			{
				return;
			}
			if (_effectOpen.playing)
			{
				_effectOpen.cancel();
				_effectClose.play();
			}
			else
			{
				_targetSnapshot = getSnapshot(_target);
				_effectOpen.targetSnapshot = _targetSnapshot;
				_effectClose.targetSnapshot = _targetSnapshot;
				_effectClose.play();
			}
			_eventDispatcher.dispatchEvent(new WindowEffectEvent(WindowEffectEvent.CLOSE_WINDOW)); //在关闭效果刚开始播放时关闭窗口, 而不是在关闭效果播放完成后
		}

		public function play():void
		{
			if (_state == STATE_CLOSE)
			{
				if (_effectClose.playing)
				{
					playOpenEffect();
				}
				else if (_effectOpen.playing)
				{
					playCloseEffect();
				}
				else
				{
					playOpenEffect();
				}
			}
			else
			{
				if (_effectClose.playing)
				{
					playOpenEffect();
				}
				else if (_effectOpen.playing)
				{
					playCloseEffect();
				}
				else
				{
					playCloseEffect();
				}
			}
		}

		public function get openEffect():IEffect
		{
			return _effectOpen;
		}

		public function get closeEffect():IEffect
		{
			return _effectClose;
		}

		public function get playing():Boolean
		{
			return _openDelayTween || _effectOpen.playing || _effectClose.playing;
		}

		public function dispose():void
		{
			_effectOpen.dispose();
			_effectClose.dispose();
		}

		private function getSnapshot(target:DisplayObject):Object
		{
			var bounds:Rectangle = target.getBounds(target);
			var width:int = Math.ceil(bounds.width);
			var height:int = Math.ceil(bounds.height);
			return {width: width, height: height, x: target.x + bounds.x, y: target.y + bounds.y, bitmap: catchBitmap(target, bounds)};
		}

		private function catchBitmap(target:DisplayObject, bounds:Rectangle):Bitmap
		{
			var matrix:Matrix = new Matrix();
			matrix.tx -= bounds.x;
			matrix.ty -= bounds.y;
			var width:int = Math.ceil(bounds.width);
			var height:int = Math.ceil(bounds.height);
			var bitmap:Bitmap = new Bitmap(new BitmapData(width, height, true, 0x00FFFFFF));
			bitmap.bitmapData.draw(target, matrix);
			bitmap.x = target.x + bounds.x;
			bitmap.y = target.y + bounds.y;
			return bitmap;
		}

		public function reset():void
		{

		}

		public function cancel():void
		{

		}

		public function stop():void
		{

		}


		/*****************************************IEventDispatcher************************************/
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			return _eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
	}
}
