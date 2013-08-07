package tempest.ui.components.tree2.effect
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class SpreadEffect extends EventDispatcher
	{
		private static var curInstanceId:int = 0;

		private var _target:DisplayObject;

		private var _spreadSpeed:Number = 0.2;
		private var _targetHeight:Number;

		private var _state:int = -1;

		private var _change:ISignal;
		private var _complete:ISignal;

		public static const STATE_SPREAD:int = 0;
		public static const STATE_RETRACT:int = 1;

		public function get change():ISignal
		{
			return _change ||= new Signal(SpreadEffect);
		}

		public function get complete():ISignal
		{
			return _complete ||= new Signal(SpreadEffect);
		}

		public function get target():DisplayObject
		{
			return _target;
		}

		public function SpreadEffect(target:DisplayObject, state:int = 1)
		{
			super(this);
			_target = target;
			_target.addEventListener(Event.RESIZE, onResize);
			_targetHeight = _target.height;
			initState(state);
		}
		
		public function reset(target:DisplayObject, state:int = 1):void
		{
			if(_target == target)
			{
				return;
			}
			if(_target)
			{
				timerEnd();
				_target.removeEventListener(Event.RESIZE, onResize);
				_target.scrollRect = null;
				_target = null;
			}
			_target = target;
			if(_target)
			{
				_target.addEventListener(Event.RESIZE, onResize);
				_targetHeight = _target.height;
				_state = state;
				initScrollRect();
			}
		}
		
		public function get state():int
		{
			return _state;
		}

		private function onResize(event:Event):void
		{
			_targetHeight = event.currentTarget.height;
			initScrollRect();
			this.dispatchEvent(new Event(Event.RESIZE));
		}

		public function dispose():void
		{
			timerEnd();
			_target.removeEventListener(Event.RESIZE, onResize);
			_target.scrollRect = null;
			_target = null;
			change.removeAll();
			complete.removeAll();
		}

		private function initState(state:int):void
		{
			if (_state == state)
			{
				return;
			}
			_state = state;
			initScrollRect();
		}

		private function initScrollRect():void
		{
			if (_state == STATE_RETRACT)
			{
				_target.scrollRect = new Rectangle(0, _targetHeight, _target.width, 0);
			}
			else if (_state == STATE_SPREAD)
			{
				_target.scrollRect = new Rectangle(0, 0, _target.width, _targetHeight);
			}
		}

		public function spread():void
		{
			if (_state == STATE_SPREAD)
			{
				return;
			}

			if(hasEventListener("spreadStart"))
			{
				dispatchEvent(new Event("spreadStart"));
			}
			_state = STATE_SPREAD;
			_target.scrollRect = new Rectangle(0, _targetHeight, _target.width, 0);
			timerStart();
		}

		public function retract():void
		{
			if (_state == STATE_RETRACT)
			{
				return;
			}

			if(hasEventListener("spreadStart"))
			{
				dispatchEvent(new Event("spreadStart"));
			}
			_state = STATE_RETRACT;
			_target.scrollRect = new Rectangle(0, 0, _target.width, _targetHeight);
			timerStart();
		}

		public function play():void
		{
			if (_state == STATE_RETRACT)
			{
				spread();
			}
			else if (_state == STATE_SPREAD)
			{
				retract();
			}
		}

		private function timerStart():void
		{
			_target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function get scorllHeight():Number
		{
			return _target.scrollRect.height;
		}

		private function onEnterFrame(event:Event):void
		{
			if (_state == STATE_SPREAD)
			{
				onSpreadTimer();
			}
			else if (_state == STATE_RETRACT)
			{
				onRetractTimer();
			}
		}

		private function timerEnd():void
		{
			_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onSpreadTimer():void
		{
			var newY:Number = _target.scrollRect.y - _targetHeight * _spreadSpeed;
			if (newY < 0)
			{
				newY = 0;
			}
			var newHeight:Number = _target.scrollRect.height + _targetHeight * _spreadSpeed;
			if (newHeight > _targetHeight)
			{
				newHeight = _targetHeight;
			}
			_target.scrollRect = new Rectangle(0, newY, _target.width, newHeight);
//			change.dispatch(this);
			delayDispatch(change);
//			trace("Spread: _target.scrollRect.width = " + _target.scrollRect.width,
//				"_target.scrollRect.height = " + _target.scrollRect.height,
//				"_target.width = " + _target.width,
//				"_target.height = " + _target.height);
			if (_target.scrollRect.y == 0)
			{
				timerEnd();
//				complete.dispatch(this);
				delayDispatch(complete);
			}
		}

		private function onRetractTimer():void
		{
			var newY:Number = _target.scrollRect.y + _targetHeight * _spreadSpeed;
			if (newY > _targetHeight)
			{
				newY = _targetHeight;
			}
			var newHeight:Number = _target.scrollRect.height - _targetHeight * _spreadSpeed;
			if (newHeight < 0)
			{
				newHeight = 0;
			}
			_target.scrollRect = new Rectangle(0, newY, _target.width, newHeight);
//			change.dispatch(this);
			delayDispatch(change);
//			trace("Retract: _target.scrollRect.width = " + _target.scrollRect.width,
//				"_target.scrollRect.height = " + _target.scrollRect.height,
//				"_target.width = " + _target.width,
//				"_target.height = " + _target.height);
			if (_target.scrollRect.y == _targetHeight)
			{
				timerEnd();
//				complete.dispatch(this);
				delayDispatch(complete);
			}
		}

		private function delayDispatch(signal:ISignal):void
		{
			signal.dispatch(this);
//			_target.addEventListener(Event.ENTER_FRAME, new DelayRunner([this, signal], 1, delayDispatchHandler).onEnterFrame);
		}

		private function delayDispatchHandler(params:Object):void
		{
			var signal:ISignal = params[1] as ISignal;
			signal.dispatch(params[0]);
		}

	}
}
import flash.events.Event;

class DelayRunner
{
	private var _params:Object;
	private var _delay:int;
	private var _totalDelay:int;
	private var _callBack:Function;

	public function DelayRunner(params:Object, totalDelay:int, callBack:Function)
	{
		_params = params;
		_totalDelay = totalDelay;
		_callBack = callBack;
	}

	public function onEnterFrame(event:Event):void
	{
		++_delay;
		if (_delay == _totalDelay)
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			_callBack(_params);
		}
	}
}
