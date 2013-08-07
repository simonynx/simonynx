package fj1.common.ui.animation
{

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.time.PreciseTimer;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;

	/**
	 * 动画帧率控制器
	 * @author linxun
	 *
	 */
	public class AnimationFrameController implements IAnimationFrameController
	{
		private var _timer:EnterFrameTimer;
//		private var _timer:TimerData;
		private var _frameRate:Number;
		private var _tick:int;
//		private var _enterframeSignal:ISignal;
		private var _autoPause:Boolean;
		private var _playing:Boolean;
		private var _listenerArr:Array;

		/**
		 * 动画帧率控制器
		 * @param frameRate 帧率
		 * @param autoPause 是否在当注册的回调函数个数为0时暂停播放
		 * @param startNow 是否立刻开始计数
		 *
		 */
		public function AnimationFrameController(frameRate:Number, autoPause:Boolean = true, startNow:Boolean = true)
		{
			_listenerArr = [];
//			_enterframeSignal = new Signal();
			_frameRate = frameRate;
			_autoPause = autoPause;
			if (startNow)
			{
				play();
			}
		}

		/**
		 * 添加帧率监听函数
		 * @param handler
		 *
		 */
		public function addFrameListener(handler:Function):void
		{
			_listenerArr.push(handler);
			if (_playing && _autoPause && _listenerArr.length == 1)
			{
				resume();
			}
		}

		/**
		 * 移除帧率监听函数
		 * @param handler
		 *
		 */
		public function removeFrameListener(handler:Function):void
		{
			_listenerArr.splice(_listenerArr.indexOf(handler), 1);
			if (_playing && _autoPause && _listenerArr.length == 0)
			{
				pause();
			}
		}

		/**
		 * 暂停跳帧（保持playing状态）
		 *
		 */
		public function pause():void
		{
			if (!_playing)
			{
				return;
			}
			if (_timer)
			{
				_timer.stop();
			}
		}

		/**
		 * 恢复跳帧暂停状态
		 *
		 */
		public function resume():void
		{
			if (!_playing)
			{
				return;
			}
			if (_timer)
			{
				_timer.start();
			}
		}

		/**
		 * 开始跳帧
		 *
		 */
		public function play():void
		{
			if (_playing)
			{
				return;
			}
			if (_timer)
			{
				return;
			}
//			_timer = TimerManager.createPreciseTimer(1000 / _frameRate, 0, onTimerUpdate, null, null, null, false);
			_timer = new EnterFrameTimer();
			_timer.add(onTimerUpdate);
			if (!_autoPause || (_autoPause && _listenerArr.length))
			{
				_timer.start();
			}
			_playing = true;
		}

		/**
		 * 停止跳帧
		 *
		 */
		public function stop():void
		{
			if (!_playing)
			{
				return;
			}
			if (_timer)
			{
//				_timer.dispose();
				_timer.stop();
//				_timer = null;
			}
			_playing = false;
		}

		public function get tick():int
		{
			return _tick;
		}

		public function set tick(value:int):void
		{
			_tick = value;
			var h:Function;
			for each (h in _listenerArr)
			{
				h(_tick);
			}
		}

		private function onTimerUpdate():void
		{
			++tick;
		}
	}
}
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;

class EnterFrameTimer
{
	private var _playing:Boolean;
	private var _target:EventDispatcher;
	private var _handlers:Vector.<Function>;

	public function EnterFrameTimer(target:EventDispatcher = null)
	{
		_handlers = new Vector.<Function>();
		_target = target;
		if (!_target)
		{
			_target = new Sprite();
		}
	}

	public function add(handler:Function):void
	{
		_handlers.push(handler);
	}

	public function remove(handler:Function):void
	{
		var index:int = _handlers.indexOf(handler);
		if (index != -1)
		{
			_handlers.splice(index, 1);
		}
	}

	public function start():void
	{
		if (_playing)
		{
			return;
		}
		_target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	public function stop():void
	{
		if (!_playing)
		{
			return;
		}
		_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(event:Event):void
	{
		var h:Function;
		for each (h in _handlers)
		{
			h();
		}
	}
}
