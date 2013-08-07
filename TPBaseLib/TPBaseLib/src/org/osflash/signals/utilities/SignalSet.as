package org.osflash.signals.utilities
{
	import flash.utils.Dictionary;
	import org.osflash.signals.ISignal;
	import tempest.utils.ClassUtil;

	public class SignalSet
	{
		protected const _signals:Dictionary = new Dictionary();

		public function SignalSet()
		{
		}

		public function getSignal(name:String, signalClass:Class, ... parameters):ISignal
		{
			if (null == name)
				throw new ArgumentError('name must not be null.');
			if (null == signalClass)
				throw new ArgumentError('signalClass must not be null.');
			return _signals[name] ||= ClassUtil.getInstanceByClass(signalClass, parameters);
		}

		public function get numListeners():int
		{
			var count:int = 0;
			for each (var signal:ISignal in _signals)
			{
				count += signal.numListeners;
			}
			return count;
		}

		/**
		 * The signals in the SignalSet as an Array.
		 */
		public function get signals():Array
		{
			// TODO : This is horrid, it's very expensive to call this if there is a lot of signals.
			var result:Array = [];
			for each (var signal:ISignal in _signals)
			{
				result[result.length] = signal;
			}
			return result;
		}

		/**
		 * Unsubscribes all listeners from all signals in the set.
		 */
		public function removeAll():void
		{
			var name:String;
			for (name in _signals)
			{
				_signals[name].removeAll();
				delete _signals[name];
			}
		}
	}
}
