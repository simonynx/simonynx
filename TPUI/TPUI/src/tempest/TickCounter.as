package tempest
{
	import flash.utils.getTimer;

	public class TickCounter
	{
		private static var _lastTick:int = -1;
		private static var _totalTick:int = 0;
		private static var _count:int = 0;
		public static function begin(logStr:String):void
		{
			//			log.debug(logStr);
			if (logStr)
			{
				trace(logStr);
			}
			_lastTick = getTimer();
		}
		
		public static function printAndBegin(logStr:String):int
		{
			if (_lastTick == -1)
			{
				trace("begin Tick First");
				return -1;
			}
			var nowTick:int = getTimer();
			var span:int = nowTick - _lastTick;
			//			log.debug(logStr + ": " + span + "ms");
			if (logStr)
			{
				++_count;
				
				if(_count > 3)
				{
					_totalTick += span;
					trace(logStr + ": " + span + "ms | avg: " + (_totalTick / (_count - 3)) + "ms | count: " + (_count - 3));
				}
				else
				{
					trace(logStr + ": " + span + "ms");
				}
			}
			_lastTick = getTimer();
			return span;
		}
	}
}