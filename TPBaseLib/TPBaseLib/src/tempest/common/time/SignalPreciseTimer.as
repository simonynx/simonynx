package tempest.common.time
{
	
	public class SignalPreciseTimer extends PreciseTimer
	{
		private var _signals:PreciseTimerSignalSet;
		public function get signals():PreciseTimerSignalSet
		{
			return _signals ||= new PreciseTimerSignalSet(this);
		}
		public function SignalPreciseTimer(delay:Number = 1000,repeatCount:int = 0)
		{
			super(delay,repeatCount);
		}
	}
}