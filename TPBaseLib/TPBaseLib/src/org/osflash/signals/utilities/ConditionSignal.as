package org.osflash.signals.utilities
{
	import flash.utils.Dictionary;
	import org.osflash.signals.*;

	/**
	 * 条件监听
	 * @author wushangkun
	 */
	public class ConditionSignal implements IPrioritySignal
	{
		private var _signals:Dictionary

		public function ConditionSignal()
		{
			_signals = new Dictionary();
		}

		/**
		 * 添加条件监听
		 * @param callBack
		 * @param id
		 * @return
		 */
		public function addCondition(listener:Function, condition:Object = "all", priority:int = 0):ISlot
		{
			var signal:IPrioritySignal = _signals[condition];
			if (signal == null)
			{
				signal = new PrioritySignal();
				_signals[condition] = signal;
			}
			return signal.addWithPriority(listener, priority);
		}

		/**
		 * 添加条件监听
		 * @param callBack
		 * @param id
		 * @return
		 */
		public function addConditionOnce(listener:Function, condition:Object = "all", priority:int = 0):ISlot
		{
			var signal:IPrioritySignal = _signals[condition];
			if (signal == null)
			{
				signal = new PrioritySignal();
				_signals[condition] = signal;
			}
			return signal.addOnceWithPriority(listener, priority);
		}

		/**
		 * 移除条件监听
		 * @param listener
		 * @param id
		 */
		public function removeCondition(listener:Function, condition:Object = "all"):ISlot
		{
			var signal:IPrioritySignal = _signals[condition];
			if (signal)
			{
				signal.remove(listener);
				if (signal.numListeners < 1)
				{
					_signals[condition] = null;
					delete _signals[condition];
				}
			}
			return null;
		}

		/**
		 * 发送条件监听事件
		 * @param id
		 * @param target
		 */
		public function dispatchCondition(condition:Object, target:Object = null):void
		{
			var signal:IPrioritySignal = _signals["all"];
			if (signal)
			{
				signal.dispatch(condition, target);
			}
			signal = _signals[condition];
			if (signal)
			{
				signal.dispatch(condition, target);
				if (signal.numListeners < 1)
				{
					_signals[condition] = null;
					delete _signals[condition];
				}
			}
		}

		/**
		 * 移除所有监听
		 */
		public function removeAll():void
		{
			var signal:IPrioritySignal;
			for each (signal in _signals)
			{
				signal.removeAll();
			}
			_signals = new Dictionary();
		}

		public function addOnce(listener:Function):ISlot
		{
			return addCondition(listener);
		}

		public function dispatch(... valueObjects):void
		{
			dispatchCondition(valueObjects[0], valueObjects[1]);
		}

		public function get numListeners():uint
		{
			return 0;
		}

		public function remove(listener:Function):ISlot
		{
			return removeCondition(listener);
		}

		public function get valueClasses():Array
		{
			return null;
		}

		public function set valueClasses(value:Array):void
		{
		}

		public function add(listener:Function):ISlot
		{
			return addCondition(listener);
		}

		public function addOnceWithPriority(listener:Function, priority:int = 0):ISlot
		{
			return addConditionOnce(listener, "all", priority);
		}

		public function addWithPriority(listener:Function, priority:int = 0):ISlot
		{
			return addCondition(listener, "all", priority);
		}
	}
}
