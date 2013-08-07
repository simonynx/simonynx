package tempest.common.time
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.natives.sets.EventDispatcherSignalSet;
	
	/**
	 * @author Jon Adams
	 */
	public class PreciseTimerSignalSet extends EventDispatcherSignalSet
	{
		public function PreciseTimerSignalSet(target:PreciseTimer)
		{
			super(target);
		}
		public function get timer():NativeSignal
		{
			return getNativeSignal(TimerEvent.TIMER,TimerEvent);
		}
		public function get timerComplete():NativeSignal
		{
			return getNativeSignal(TimerEvent.TIMER_COMPLETE,TimerEvent);
		}
	}
}