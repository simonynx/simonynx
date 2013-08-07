package org.osflash.signals.utilities
{
	import flash.utils.Dictionary;

	public class ConditionSignalSet
	{
		protected const _signals:Dictionary = new Dictionary();

		public function getSignal(name:String):ConditionSignal
		{
			if (null == name)
				throw new ArgumentError('name must not be null.');
			return _signals[name] ||= new ConditionSignal();
		}

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
